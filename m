Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbZDNJlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbZDNJlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZDNJjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:39:46 -0400
Received: from mx1.emlix.com ([193.175.82.87]:46537 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbZDNJjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:39:42 -0400
From: Johannes Weiner <jw@emlix.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
       Oskar Schirmer <os@emlix.com>
Subject: [patch 05/12] xtensa: update s6105_defconfig for ccount calibration
Date: Tue, 14 Apr 2009 11:41:13 +0200
Message-Id: <1239702080-14355-6-git-send-email-jw@emlix.com>
In-Reply-To: <1239702080-14355-1-git-send-email-jw@emlix.com>
References: <1239702080-14355-1-git-send-email-jw@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oskar Schirmer <os@emlix.com>

The previous patch enabled ccount calibration for the s6000 variant.
This patch updates the defconfig for the s6105 platform to reflect this
change.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/configs/s6105_defconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 6e1deff..768bee0 100644
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

