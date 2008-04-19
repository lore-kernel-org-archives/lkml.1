Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYDSNdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYDSNdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 09:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYDSNcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 09:32:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50691 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbYDSNct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:32:49 -0400
Date: Sat, 19 Apr 2008 15:33:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel.send@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: memtest bootparam
Message-ID: <20080419133333.GC23873@elf.ucw.cz>
References: <200804181717.m3IHHicT031344@hera.kernel.org> <20080418145202.c96460a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418145202.c96460a2.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c64df70793a9c344874eb4af19f85e0662d2d3ee
> > Commit:     c64df70793a9c344874eb4af19f85e0662d2d3ee
> > Parent:     9b967106da0357ef8b08847dce35584a04134f20
> > Author:     Yinghai Lu <yhlu.kernel.send@gmail.com>
> > AuthorDate: Fri Mar 21 18:56:19 2008 -0700
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Thu Apr 17 17:41:21 2008 +0200
> > 
> >     x86: memtest bootparam
> >     
> > ...
> >
> >  
> > +	memtest=	[KNL,X86_64] Enable memtest
> > +			Format: <integer>
> > +			range: 0,4 : pattern number
> > +			default : 0 <disable>
> 
> OK.  Did the new memtest feature get documented anywhere, btw?  I'm only
> vaguely aware of its existence.

Actually it would be nice if memtest was global, not x86-specific,
feature.

I had some fun with arm running with 256mb, when only 128mb was
present. It booted succesfully...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
