Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbZGLLEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbZGLLEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 07:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZGLLE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 07:04:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49548 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZGLLE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 07:04:28 -0400
Date: Sat, 11 Jul 2009 23:30:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Howells <dhowells@redhat.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, rgetz@blackfin.uclinux.org,
       lethal@linux-sh.org, gerg@uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when
	calculating the stack size
Message-ID: <20090711213018.GA1425@ucw.cz>
References: <20090709101930.GJ10937@elf.ucw.cz> <20090704024606.GE1345@ucw.cz> <20090701120814.30741.10146.stgit@warthog.procyon.org.uk> <24530.1247050900@redhat.com> <20090704033429.GA1799@ucw.cz> <8bd0f97a0907081148vc716eeepfdaf8178b1ecbce1@mail.gmail.com> <24280.1247137151@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24280.1247137151@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-09 11:59:11, David Howells wrote:
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > i really dont think this is realistic.  there is exactly one ldso that
> > > everyone uses under FDPIC ELF, and it needs a very minuscule stack.
> > 
> > Not very realistic; but that argues that the patch is NOP.
> >
> > And if it _is_ realistic, the patch adds a bug.
> 
> No, it doesn't.  The problem is that the loader, when it is linked, is given a
> sillyly large default stack size, and this causes the application to be given a
> much larger stack than is strictly necessary - a stack that is drawn from a
> limited pool of non-pageable RAM and that must be allocated as a contiguous
> lump.

Fix the loader to only request as big stack as it needs?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
