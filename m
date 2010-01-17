Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682Ab0AQUqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab0AQUqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 15:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200Ab0AQUqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 15:46:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:52076 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754099Ab0AQUqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 15:46:24 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+yO5pyjLiy29ajiaO9eNVy9KPM0ajkX3ET9HF9nV
	nG7ksknQ5PLBIX
From: Peter Huewe <peterhuewe@gmx.de>
Cc: Peter Huewe <peterhuewe@gmx.de>, David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>,
       Saravana Kannan <skannan@quicinc.com>,
       Matt Wagantall <mattw@quicinc.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm: Fix build failure for msm_defconfig caused by wrong include path
Date: Sun, 17 Jan 2010 21:46:02 +0100
Message-Id: <1263761162-9447-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build failure [1] due to a wrong include path.

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2020066/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Patch against Linux-next of So 17. Jan 21:24:00 CET 2010
KernelVersion: next-20100114

Resending this patch as I got some errors from my mail-server, sorry for
the inconvenience
 arch/arm/mach-msm/devices.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/devices.c b/arch/arm/mach-msm/devices.c
index a64578f..737fd09 100644
--- a/arch/arm/mach-msm/devices.c
+++ b/arch/arm/mach-msm/devices.c
@@ -29,7 +29,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 
-#include <asm/mach/mmc.h>
+#include <mach/mmc.h>
 
 static struct resource resources_uart1[] = {
 	{
-- 
1.6.4.4

