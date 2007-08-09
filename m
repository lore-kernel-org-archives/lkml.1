Return-Path: <linux-kernel-owner+w=401wt.eu-S940539AbXHIOQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940539AbXHIOQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbXHIOQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:16:36 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39371 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760191AbXHIOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:16:35 -0400
Date: Thu, 9 Aug 2007 16:16:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What does 'if EMBEDDED' mean?
Message-ID: <20070809141621.GO6997@stusta.de>
References: <4104961b0708090711j291974cbx933e1262ba1935f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4104961b0708090711j291974cbx933e1262ba1935f6@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:11:33PM +0800, jidong xiao wrote:
> For example,
> 
> config SYSFS
>         bool "sysfs file system support" if EMBEDDED
>         default y
> 
> What does 'if EMBEDDED' mean?Can I choose n here?

The "if EMBEDDED" means that you only see this question if 
CONFIG_EMBEDDED=y.

Otherwise, the default is used without the question being asked.

> I saw there is no corresponding option within `make menuconfig`, so I
> am wondering what can I do if I wanna to disable this option, directly
> change
> "default y" to "default n" in the Kconfig file?

Say "y" at
  General setup
    Configure standard kernel features (for small systems)

> Thanks
> Jason

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

