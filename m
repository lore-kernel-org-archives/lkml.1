Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbXGDRcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbXGDRcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 13:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbXGDRcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 13:32:03 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50575 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755713AbXGDRcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 13:32:01 -0400
Date: Wed, 4 Jul 2007 19:32:29 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Darren <kernel@da4.org>
Cc: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070704173228.GK3492@stusta.de>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <468B3FBB.9050006@da4.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <468B3FBB.9050006@da4.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 02:35:39AM -0400, Darren wrote:
>
> I know this may sound kind of stupid, but how about not deprecating either, 
> and fully supporting both sound systems? Maybe we can get them to work 
> together, and the distro or user can choose whether they would like to use 
> alsa or oss for that particular card (or have the distro choose the sound 
> drivers that are best supported for that particular card). As it is now, 
> most apps already support oss and alsa.

It does not sound stupid and sounds good at first sight.

But there are problems we've already seen with similar situations in 
different parts of the kernel:

They would have different hardware support, features and bugs.

And then a user user whose sound card is only supported by sound system A
needs a feature only available in sound system B.

And the quality decreases since people will often not report bugs in 
sound system A if sound system B works for them.

OTOH, for a user it shouldn't matter whether there's OSS or ALSA, that's 
mostly a difference for application developers. And since (as you say) 
most applications already support both, there's no compelling reason for 
providing more than one of them.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

