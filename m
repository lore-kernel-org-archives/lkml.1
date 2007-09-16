Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbXIPVNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbXIPVNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 17:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXIPVNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 17:13:41 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:48971 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752976AbXIPVNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 17:13:40 -0400
Date: Sun, 16 Sep 2007 23:13:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070916211351.GB18232@stusta.de>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070916203926.GA17863@schlund.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 10:39:26PM +0200, Hannah Schroeter wrote:
> Hi!
> 
> On Sun, Sep 16, 2007 at 09:59:09PM +0200, Adrian Bunk wrote:
> >On Sun, Sep 16, 2007 at 11:48:47AM -0700, Can E. Acar wrote:
> >>...
> >> First, these developers got questionable advice from senior Linux kernel
> >> developers, and SLFC (which is closely related to FSF) in the process.
> 
> >The most questionable legal advice in this thread was by Theo de Raadt 
> >who claimed choosing one licence for _dual-licenced_ code was illegal...
> 
> JFTR, I do *not* think that that assessment was questionable. Unless the
> dual-licensing *explicitly* allows relicensing, relicensing is forbidden
> by copyright law. The dual-licensing allows relicensing only if that's
> *explicitly* stated, either in the statement offering the alternative, or
> in one of the licenses.


Dual licenced code by definition explicitely states that you can choose 
the licence - otherwise it wouldn't be called dual-licenced.


> Neither GPL nor BSD/ISC allow relicensing in their well-known wordings.


Noone said otherwise.


> If you think that's questionable, you should at least provide arguments
> (and be ready to have your interpretation of the law and the licenses
> tested before court).


The licence in question was:

<--  snip  -->

/*-
 * Copyright (c) 2002-2004 Sam Leffler, Errno Consulting
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer,
 *    without modification.
 * 2. Redistributions in binary form must reproduce at minimum a disclaimer
 *    similar to the "NO WARRANTY" disclaimer below ("Disclaimer") and any
 *    redistribution must be conditioned upon including a substantially
 *    similar Disclaimer requirement for further binary redistribution.
 * 3. Neither the names of the above-listed copyright holders nor the names
 *    of any contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * Alternatively, this software may be distributed under the terms of the
 * GNU General Public License ("GPL") version 2 as published by the Free
 * Software Foundation.
 *
 * NO WARRANTY
 * ...

<--  snip  -->


Theo claimed it would "break the law" [1] to choose the GPL for
_this_ code. [2]


> >[...]
> 
> >Regarding ethics - if you use the BSD licence for your code you state in 
> >the licence text that it's OK that I take your code and never give 
> >anything back.
> 
> But the BSDl does not allow you to relicense the original code, even
> while it allows you to license copyrightable additions/modifications
> under different terms with few restrictions.
> 
> However, you say "regarding ethics" and just go back to the legal level.
> Is it really ethical, if you consider both Linux and OpenBSD part of one
> OSS "community", to share things only in one direction? To take the
> reverse engineered HAL but to not allow OpenBSD to take some
> modifications back?


Is it really ethical to use a licence that does not require to give 
back, but then demand that something has to be given back?

Why don't you use a licence that expresses your intentions in a legally 
binding way?


> >[...]
> 
> >Some people have the funny position of opposing the GPL which enforces 
> >that you have to give back, but whining that people took their BSD 
> >licenced code and don't give back.
> 
> A difference is, GPL requires it under every circumstance. BSD does not,
> indeed. But how should one expect it from *OSS* people that even *they*
> don't give back? Do you really want to put yourself on the same level as
> closed-source companies?


You could also see it from a different perspective:

If you like that the GPL enforces that everyone has to give back, do you 
also want to see your code BSD licenced without this protection?


But the truth is a bit less harsh:

In reality most Linux kernel developers might not mind to give back - 
and e.g. much of the ACPI code is BSD/GPL dual-licenced, and there 
doesn't seem to be any problem with this.

But Theo's wrong accusations regarding dual licenced code might not be
the best way for starting a fruitful collaboration...


> >[...]
> 
> Kind regards,
> 
> Hannah.

cu
Adrian

[1] http://lkml.org/lkml/2007/9/1/102
[2] The fact that Alan didn't notice that part of Jiri's patch touched
    non-dual-licenced code is the mistake I already mentioned - but
    this mistake is not what Theo is ranting about.

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

