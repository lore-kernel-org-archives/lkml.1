Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZGHLYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZGHLYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZGHLYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:24:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51710 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbZGHLYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:24:40 -0400
Date: Sat, 4 Jul 2009 05:34:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Howells <dhowells@redhat.com>
Cc: vapier.adi@gmail.com, rgetz@blackfin.uclinux.org, lethal@linux-sh.org,
       gerg@uclinux.org, uclinux-dist-devel@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when
	calculating the stack size
Message-ID: <20090704033429.GA1799@ucw.cz>
References: <20090704024606.GE1345@ucw.cz> <20090701120814.30741.10146.stgit@warthog.procyon.org.uk> <24530.1247050900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24530.1247050900@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-08 12:01:40, David Howells wrote:
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > The patch seems wrong to me; loader needs the stack, too, right?
> > 
> > What about making sure that the loader specifies reasonable stack
> > size, instead?
> 
> The loader doesn't need its own stack, unless it _is_ the executable.  It uses
> the executable's stack.  The problem is that the executable and the loader can
> both specify the stack size for NOMMU, but which one do we pick, or do we
> consider both.

Imageine loader needs 64K, while executable only needs 4K. You surely
want to execute it with 64K stack, because it will not fit into 4K?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
