Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbZCZNiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbZCZNiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZCZNik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:38:40 -0400
Received: from mx1.emlix.com ([193.175.82.87]:48859 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758199AbZCZNij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:38:39 -0400
From: Oskar Schirmer <os@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       Oskar Schirmer <os@emlix.com>
Subject: [patch 3/3] xtensa: update s6105_defconfig for ccount calibration
Date: Thu, 26 Mar 2009 14:39:45 +0100
Message-Id: <1238074785-24810-3-git-send-email-os@emlix.com>
In-Reply-To: <1238074785-24810-1-git-send-email-os@emlix.com>
References: <1238074785-24810-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch enabled ccount calibration for the s6000 variant.
This patch updates the defconfig for the s6105 platform to reflect this
change.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/configs/s6105_defconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 6ced233..8eec578 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -115,7 +115,7 @@ CONFIG_XTENSA_VARIANT_S6000=y
 CONFIG_PREEMPT=y
 # CONFIG_MATH_EMULATION is not set
 # CONFIG_HIGHMEM is not set
-# CONFIG_XTENSA_CALIBRATE_CCOUNT is not set
+CONFIG_XTENSA_CALIBRATE_CCOUNT=y
 CONFIG_SERIAL_CONSOLE=y
 # CONFIG_XTENSA_ISS_NETWORK is not set
 
@@ -131,7 +131,6 @@ CONFIG_SERIAL_CONSOLE=y
 # CONFIG_XTENSA_PLATFORM_ISS is not set
 # CONFIG_XTENSA_PLATFORM_XT2000 is not set
 CONFIG_XTENSA_PLATFORM_S6105=y
-CONFIG_XTENSA_CPU_CLOCK=300
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyS1,38400 debug bootmem_debug loglevel=7"
-- 
1.6.2.107.ge47ee

