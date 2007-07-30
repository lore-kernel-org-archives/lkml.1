Return-Path: <linux-kernel-owner+w=401wt.eu-S1764921AbXG3KwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764921AbXG3KwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 06:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXG3KwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 06:52:11 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53152 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753863AbXG3KwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 06:52:09 -0400
Date: Mon, 30 Jul 2007 12:51:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mikael Starvik <mikael.starvik@axis.com>
Cc: dev-etrax <dev-etrax@axis.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cris port lacks a merge?
Message-ID: <20070730105145.GM16817@stusta.de>
References: <BFECAF9E178F144FAEF2BF4CE739C66804AE23FB@exmail1.se.axis.com> <BFECAF9E178F144FAEF2BF4CE739C668030B5C6F@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C668030B5C6F@exmail1.se.axis.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 09:44:19AM +0200, Mikael Starvik wrote:

> I will make another try soon.
> 
> The problem is that every time I try the following happens:
> 
> 1. I download the bleeding edge latest stuff that you can get
> 2. I prepare and submit patches
> 3. I get replies with comments on my patches
> 4. I fix the patches.
> 5. I get told that the patches are against a too old version
> 6. Repeat from 1.
> 
> But I will continue to start making attempts to send patches upstreams
> again.

Considering that your last merge was two years ago something goes wrong - 
and I suspect something goes wrong at 5.

If you download the latest -rc kernel at step 1 there should usually be 
no problem to let your patches Andrew add them to -mm and him forwarding 
them to Linus at the next merge window instead of running into point 5.

If there are conflicts with some bigger cross-architecture changes they 
should have been mentioned at 3.

I'll look at why it goes wrong when you submit your patches the
next time.

> Patches are also available at http://developer.axis.com
> 
> /Mikael
> 
> -----Original Message-----
> From: Adrian Bunk [mailto:bunk@stusta.de] 
> Sent: Sunday, July 15, 2007 2:04 PM
> To: Mikael Starvik
> Cc: dev-etrax; linux-kernel@vger.kernel.org
> Subject: cris port lacks a merge?
> 
> 
> Hi Mikael,
> 
> the last maintainer update to arch/cris/ was two years ago and it seems 
> code like e.g. the config variable ETRAX_ARCH_V32 is missing.
> 
> I assume there is there some external tree you use that contains updates?
> If yes, can you submit the changes for inclusion into the upstream kernel?
> 
> TIA
> Adrian

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

