Return-Path: <linux-kernel-owner+w=401wt.eu-S933363AbYEBPMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363AbYEBPMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYEBPM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:12:27 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50386 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbYEBPM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:12:26 -0400
Date: Fri, 2 May 2008 18:11:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to reduce the number of open kernel bugs
Message-ID: <20080502151134.GC5838@cs181133002.pp.htv.fi>
References: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 10:42:21AM -0400, Parag Warudkar wrote:
> Adrian Bunk <bunk <at> kernel.org> writes:
> 
> > Maintainer:
> >
> > Yeah, in any case. I cannot fix it, since it's not a bug in the fobar
> > code. Please reopen a new bug and CC the architecture or PCI maintainer
> > or whatever person related to the bus, chipset or CPU, if you think the
> > foobar device still works. If the foobar hardware got corrupted, you
> > already know what to do...
> >
> > I am well aware that loud flames are often the only working way of
> > communication in Linux kernel development, but we mustn't communicate
> > this way with bug submitters.
> >
> 
> Actually this way of _communication_ is better because the maintainer has -

When immediately closing a new bug with a comment only consisting of 
"Your hardware is seriously broken." it's borderline whether you can 
call this "communication" - especially if the hardware works under 
Windows or with a different driver.

> a) at least seen the bug
> b) made it clear upfront that he/she is not in a position to fix it and
> c) not inflicted a huge amount of follow up work for the reporter
> while giving no hope that it will be fixed.

And gave the bug reporter (who might have spent some time on writing a 
proper bug report) the clear impression his bug reports are unwanted.

> There is not much you can do if the maintainer feels he/she can't do
> anything - apart from fixing it yourself which has its limits.
> So the best that can be done is to communicate it clearly - that
> happens in this case.
>...

He can ask for the output of "dmesg" and then reassign the bug to the 
correct people.

Different to immediately closing the bug with the comment
"Your hardware is seriously broken." this can result in the
bug actually being fixed.

> Parag

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

