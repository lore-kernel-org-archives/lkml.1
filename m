Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbXCZBsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbXCZBsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 21:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933291AbXCZBsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 21:48:22 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34452 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933290AbXCZBsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 21:48:16 -0400
Date: Mon, 26 Mar 2007 03:48:19 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] more scheduled OSS driver removal
Message-ID: <20070326014819.GS16477@stusta.de>
References: <20070324130602.GD752@stusta.de> <4607213B.9070005@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4607213B.9070005@student.ltu.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 03:26:19AM +0200, Richard Knutsson wrote:
> Adrian Bunk wrote:
> >This patch contains the scheduled removal of OSS drivers that:
> >- have ALSA drivers for the same hardware without known regressions and
> >- whose Kconfig options have been removed in 2.6.20.
> >  
> Sorry for this late respond
> 
> Is sound/oss/emu10k1/ really ready to be replaced? According to a friend 
> of mine, who got the hardware, the ALSA still lacks feature provided by 
> the OSS-driver. He mentioned some sort of programmable memory (forgot 
> the name for that) with whom you can run small programs to manipulate 
> the sounds (adding echo and such). Also, he got problems with getting 
> more accurate control of the volume (guess this is more a userland issue).
> He seems to have done his homework but only got to pages where other 
> peoples had the same problem.

Which bug numbers in the ALSA bugtracking system [1] are these?

If there are regressions in an ALSA driver compared to the corresponding 
OSS driver, the goal is to get the ALSA driver fixed.

Current number of regressions in the ALSA emu10k1 driver people gave me 
numbers of open ALSA bugs for:
  0

> If this is really implemented, please let me know so I can forward it to 
> him.
>...

You can monitor the bugs in the ALSA bugtracking system describing the 
problems your friend has.

> Thanks and good night
> Richard Knutsson

cu
Adrian

[1] http://bugtrack.alsa-project.org/alsa-bug/

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

