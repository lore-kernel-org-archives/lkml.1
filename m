Return-Path: <linux-kernel-owner+w=401wt.eu-S1762316AbXGXT75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762316AbXGXT75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbXGXT7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:59:44 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43368 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756925AbXGXT7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:59:43 -0400
Date: Tue, 24 Jul 2007 21:59:08 +0200
From: Adrian Bunk <bunk@stusta.de>
To: jschopp <jschopp@austin.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Message-ID: <20070724195908.GF6019@stusta.de>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A534EA.6030008@intel.com> <46A5C12B.3080904@shadowen.org> <20070724021526.3d92286b.akpm@linux-foundation.org> <20070724172217.GA10725@linux-sh.org> <46A648C5.5050902@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46A648C5.5050902@austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 01:45:25PM -0500, jschopp wrote:
> <snip>
> > checkpatch has been quite useful
>> for catching obviously broken things, and now it seems like it's just
>> overreaching. Perhaps this functionality can be split in to a lite
>> checkpatch for catching show-stoppers for application and then something
>> more akin to a CodingStyle validator for the folks interested in
>> arbitrarily defining convention, which they can use freely while the rest
>> of us try to get something useful done.
>
> CodingStyle isn't about arbitrarily defining convention.  It is about 
> making the codebase consistent, which helps a ton in readability and 
> maintainability.
>
> Readability is important because it makes the job of the maintainers 
> easier.  If you or I have to spend 5 minutes to fix trivial CodingStyle 
> issues, but that 5 minutes saves Andrew or other maintainers 60 seconds in 
> reviewing your patch, we come out ahead.  Anything that shifts work from 
> maintainers to developers is a good thing because maintainers are 
> overworked as is.
>
> It could also argue that declaring multiple variables per line or putting 
> curly braces where they aren't needed doesn't make code unmaintainable.  
> I'd agree any one of these doesn't make code unmaintainable by itself.  But 
> if all these things are added together it is death by 1000 cuts.  The more 
> readable code is the fewer real bugs it will have because badness stands 
> out more in clean code.
>
> So, no we shouldn't separate out CodingStyle because
>
> Better CodingStyle == less bugs
>
> and
>
> Better CodingStyle == more throughput for maintainers

To some extent yes.

But extreme codingstyling won't gain you anything.

Except for long and fruitless discussions.

If a tool says anything would be wrong with the line of C code
	int i, j;
for two loop variables, then the tool is wrong because that's an idiom 
every C programmer knows and understands.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

