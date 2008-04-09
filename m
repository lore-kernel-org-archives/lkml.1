Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbYDIUR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbYDIUR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYDIURq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:17:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:31548 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbYDIURp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:17:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,630,1199692800"; 
   d="scan'208";a="268115448"
From: Auke Kok <auke-jan.h.kok@intel.com>
Subject: [PATCH] e1000e: set CONFIG_E1000E=y in x86 defconfigs
To: torvalds@linux-foundation.org
Cc: jeff@garzik.org, andi@firstfloor.org, netdev@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       davem@davemloft.net, akpm@linux-foundation.org, mingo@elte.hu
Date: Wed, 09 Apr 2008 13:17:39 -0700
Message-ID: <20080409201739.14581.7454.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Apr 2008 20:17:43.0986 (UTC) FILETIME=[C4E38120:01C89A7E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds to the already default CONFIG_E1000=y in these files.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
---

 arch/x86/configs/i386_defconfig   |    1 +
 arch/x86/configs/x86_64_defconfig |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 3df340b..35f6308 100644
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
index eef98cb..2d078d7 100644
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

