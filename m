Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbYK0JKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbYK0JKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 04:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYK0JJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 04:09:56 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:53127 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYK0JJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=A6RCpA/caKcw70JTNmCzoqG+4iu5/Il4zrFeHmXM/MEeHw3z4DIaekI7P5ukk+xnsO
         92AwP+So1Im56ciU7lJp3yJEXYB6xRySHwmr47oP411af07fQXZWxoJZaambHvHjitRs
         D/j13IqZXqsZkJSZKRGOxnWz3Be6qjDnHF+Ns=
From: Feng King <kinwin2008@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Feng King <kinwin2008@gmail.com>
Subject: [PATCH] cleanup some default configure
Date: Thu, 27 Nov 2008 17:09:45 +0800
Message-Id: <1227776985-2867-1-git-send-email-kinwin2008@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since CONFIG_R8169_NAPI has been removed,no need to include
it in defconfig now

Signed-off-by: Feng King <kinwin2008@gmail.com>
---
 arch/arm/configs/iop32x_defconfig  |    1 -
 arch/mips/configs/mtx1_defconfig   |    1 -
 arch/mips/configs/tb0219_defconfig |    1 -
 arch/mips/configs/tb0287_defconfig |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/arm/configs/iop32x_defconfig b/arch/arm/configs/iop32x_defconfig
index 8612f58..05be5e2 100644
--- a/arch/arm/configs/iop32x_defconfig
+++ b/arch/arm/configs/iop32x_defconfig
@@ -683,7 +683,6 @@ CONFIG_E1000_NAPI=y
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set
 CONFIG_R8169=y
-# CONFIG_R8169_NAPI is not set
 # CONFIG_SIS190 is not set
 # CONFIG_SKGE is not set
 # CONFIG_SKY2 is not set
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index db92726..ca00d65 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -1301,7 +1301,6 @@ CONFIG_NS83820=m
 CONFIG_HAMACHI=m
 CONFIG_YELLOWFIN=m
 CONFIG_R8169=m
-# CONFIG_R8169_NAPI is not set
 CONFIG_R8169_VLAN=y
 CONFIG_SIS190=m
 CONFIG_SKGE=m
diff --git a/arch/mips/configs/tb0219_defconfig b/arch/mips/configs/tb0219_defconfig
index b505988..0287223 100644
--- a/arch/mips/configs/tb0219_defconfig
+++ b/arch/mips/configs/tb0219_defconfig
@@ -484,7 +484,6 @@ CONFIG_NETDEV_1000=y
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set
 CONFIG_R8169=y
-# CONFIG_R8169_NAPI is not set
 # CONFIG_SIS190 is not set
 # CONFIG_SKGE is not set
 # CONFIG_SKY2 is not set
diff --git a/arch/mips/configs/tb0287_defconfig b/arch/mips/configs/tb0287_defconfig
index 46512cf..228dea0 100644
--- a/arch/mips/configs/tb0287_defconfig
+++ b/arch/mips/configs/tb0287_defconfig
@@ -600,7 +600,6 @@ CONFIG_NETDEV_1000=y
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set
 CONFIG_R8169=y
-# CONFIG_R8169_NAPI is not set
 # CONFIG_SIS190 is not set
 # CONFIG_SKGE is not set
 # CONFIG_SKY2 is not set
-- 
1.5.6.5

