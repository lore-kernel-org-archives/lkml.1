Return-Path: <linux-kernel-owner+w=401wt.eu-S1161450AbXBGWUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161450AbXBGWUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030660AbXBGWUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:20:38 -0500
Received: from hermes.domdv.de ([193.102.202.1]:2864 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030640AbXBGWUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:20:37 -0500
Message-ID: <45CA50B4.7050001@domdv.de>
Date: Wed, 07 Feb 2007 23:20:36 +0100
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Subject: [2.6.20] tifm_7xx1/mmc not working
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I do have a problem with tifm_7xx1 and 2.6.20. First of all, the device
is working with 2.6.18.2 and the out of tree tifm-0.6 release. In this
case except for the first card insertion after suspend/reboot I do get
the following messages:

tifm_7xx1: sd card detected in socket 3
mmcblk0: mmc0:7d7f SD01G 1006080KiB
 mmcblk0: p1

With 2.6.20, however, I always do get only the following which is the
same as for 2.6.18.2 on first card insert after reboot/suspend:

tifm_7xx1: sd card detected in socket 3

Am I doing something wrong here or is there a problem?

Relevant modules loaded with 2.6.20:

mmc_block               7944  0
tifm_sd                10824  0
tifm_7xx1               7296  0
sdhci                  17548  0
tifm_core               7960  2 tifm_sd,tifm_7xx1
mmc_core               24096  3 mmc_block,tifm_sd,sdhci

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
