Return-Path: <linux-kernel-owner+w=401wt.eu-S933866AbXGYQy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866AbXGYQy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXGYQys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:54:48 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44135 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754721AbXGYQyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:54:47 -0400
Date: Wed, 25 Jul 2007 18:54:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: SL Baur <steve@xemacs.org>
Cc: jschopp <jschopp@austin.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Message-ID: <20070725165420.GD3572@stusta.de>
References: <46A534EA.6030008@intel.com> <46A5C12B.3080904@shadowen.org> <20070724021526.3d92286b.akpm@linux-foundation.org> <20070724172217.GA10725@linux-sh.org> <Pine.LNX.4.64.0707242000120.18990@fbirervta.pbzchgretzou.qr> <46A64587.2010704@shadowen.org> <20070724194901.GE6019@stusta.de> <46A661FB.7040504@austin.ibm.com> <20070725011346.GA3572@stusta.de> <ed10ee420707250839s60904507xb777b61c2d043bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ed10ee420707250839s60904507xb777b61c2d043bd@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 08:39:36AM -0700, SL Baur wrote:
> On 7/24/07, Adrian Bunk <bunk@stusta.de> wrote:
>
>> There are more important things than exploiting the corner cases of
>> codingstyle, e.g. could you teach checkpatch.pl to give exactly two
>> errors for the following code?
>>
>>
>>         while (a);
>>                 for (b = 0; b < 50; b++);
>>                         for (c = 0; c < sizeof(struct module); c++)
>>                                 d = e;
>
> There are three errors there.  The while (a) busy wait needs a cpu_relax()

OK, granted. But this is dummy code, and this is not what I'd expect 
checkpatch.pl to check for.

> or something, the first for is at the wrong level of indentation and the
> second for is at the wrong level of indentation relative to the first one.

If someone writes the code this way, the problem is usually not the 
indentation that is most likely correct, but the fact that the code does 
something completely different from what the author thought it would do.

We already had such bugs in the kernel, they are unlikely to be spotted 
at code review, but for a script that looks at the source code they 
should be easy to spot.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

