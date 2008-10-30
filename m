Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYJ3TNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYJ3TNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYJ3TNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:13:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45527 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbYJ3TNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:13:21 -0400
Date: Thu, 30 Oct 2008 20:14:51 +0100
From: Pavel Machek <pavel@suse.cz>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081030191451.GE22185@elf.ucw.cz>
References: <20081026124643.GA1328@logfs.org> <20081030174300.GA1773@ucw.cz> <20081030175844.GC7157@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081030175844.GC7157@logfs.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 18:58:44, Jörn Engel wrote:
> On Thu, 30 October 2008 18:43:00 +0100, Pavel Machek wrote:
> > 
> > + * Disks have fulfilled the prerequite for a long time.  More recently DRAM
> > 
> > prerequisite?
> 
> In the paragraph above:

I don't thing "prerequite" is valid english word... is it?

> > +#define MAX(a, b) ((a) > (b) ? (a) : (b))
> > 
> > We already have that in the headers somewhere.
> 
> Except that min/max in include/linux/kernel.h have some type-safety
> added.  In this particular case that is actually a disadvantage:
>   CC      lib/btree.o
>   lib/btree.c:56: error: braced-group within expression allowed only inside a function
>   lib/btree.c:62: error: braced-group within expression allowed only inside a function
>   lib/btree.c:67: error: braced-group within expression allowed only inside a function
> 
> So I need something more stupid. :)

Aha, ok.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
