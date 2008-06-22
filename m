Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYFVWUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYFVWUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYFVWUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:20:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:25011 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbYFVWUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:20:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,686,1204531200"; 
   d="scan'208";a="1080723"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [RESEND PATCH 1/3] e1000e: set CONFIG_E1000E=y in x86 defconfigs
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
Date: Sun, 22 Jun 2008 15:20:15 -0700
Message-ID: <20080622221916.5907.79563.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2008 22:20:16.0211 (UTC) FILETIME=[25B98230:01C8D4B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Auke Kok <auke-jan.h.kok@intel.com>

This adds to the already default CONFIG_E1000=y in these files.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 arch/x86/configs/i386_defconfig   |    1 +
 arch/x86/configs/x86_64_defconfig |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index ad7ddaa..b738c78 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -814,6 +814,7 @@ CONFIG_NETDEV_1000=y
 CONFIG_E1000=y
 # CONFIG_E1000_NAPI is not set
 # CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
+CONFIG_E1000E=y
 # CONFIG_NS83820 is not set
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 2d6f5b2..0fb202e 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -740,6 +740,7 @@ CONFIG_NETDEV_1000=y
 CONFIG_E1000=y
 # CONFIG_E1000_NAPI is not set
 # CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
+CONFIG_E1000E=y
 # CONFIG_NS83820 is not set
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set

