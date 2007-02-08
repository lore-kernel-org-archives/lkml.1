Return-Path: <linux-kernel-owner+w=401wt.eu-S1422763AbXBHF7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422763AbXBHF7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422898AbXBHF7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:59:12 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:45026 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422763AbXBHF7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:59:11 -0500
Message-ID: <45CABC2B.7070704@drzeus.cx>
Date: Thu, 08 Feb 2007 06:59:07 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Andreas Steinmetz <ast@domdv.de>
CC: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Subject: Re: [2.6.20] tifm_7xx1/mmc not working
References: <45CA50B4.7050001@domdv.de>
In-Reply-To: <45CA50B4.7050001@domdv.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov is the maintainer of tifm, not me.

Andreas Steinmetz wrote:
> Hi,
> I do have a problem with tifm_7xx1 and 2.6.20. First of all, the device
> is working with 2.6.18.2 and the out of tree tifm-0.6 release. In this
> case except for the first card insertion after suspend/reboot I do get
> the following messages:
> 
> tifm_7xx1: sd card detected in socket 3
> mmcblk0: mmc0:7d7f SD01G 1006080KiB
>  mmcblk0: p1
> 
> With 2.6.20, however, I always do get only the following which is the
> same as for 2.6.18.2 on first card insert after reboot/suspend:
> 
> tifm_7xx1: sd card detected in socket 3
> 
> Am I doing something wrong here or is there a problem?
> 
> Relevant modules loaded with 2.6.20:
> 
> mmc_block               7944  0
> tifm_sd                10824  0
> tifm_7xx1               7296  0
> sdhci                  17548  0
> tifm_core               7960  2 tifm_sd,tifm_7xx1
> mmc_core               24096  3 mmc_block,tifm_sd,sdhci
> 

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
