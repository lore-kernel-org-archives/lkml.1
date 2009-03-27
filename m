Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbZC0OoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbZC0OoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbZC0Onj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:43:39 -0400
Received: from smtp.nokia.com ([192.100.122.233]:63744 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287AbZC0Onh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:43:37 -0400
From: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Timo Kokkonen <timo.t.kokkonen@nokia.com>,
       Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
Subject: [PATCH 2/2] rx51_defconfig: add twl4030 to rx51 default configuration
Date: Fri, 27 Mar 2009 16:42:18 +0200
Message-Id: <359509a565280b2fb66c1ed94d61f9a04cdef356.1238163923.git.ext-atal.shargorodsky@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <b207c8283f0172e6b64c06fe6ac2e4bf9eedf875.1238163923.git.ext-atal.shargorodsky@nokia.com>
References: <>
 <1238164938-11932-1-git-send-email-ext-atal.shargorodsky@nokia.com>
 <b207c8283f0172e6b64c06fe6ac2e4bf9eedf875.1238163923.git.ext-atal.shargorodsky@nokia.com>
In-Reply-To: <b207c8283f0172e6b64c06fe6ac2e4bf9eedf875.1238163923.git.ext-atal.shargorodsky@nokia.com>
References: <b207c8283f0172e6b64c06fe6ac2e4bf9eedf875.1238163923.git.ext-atal.shargorodsky@nokia.com>
X-OriginalArrivalTime: 27 Mar 2009 14:43:02.0417 (UTC) FILETIME=[54BF4010:01C9AEEA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timo Kokkonen <timo.t.kokkonen@nokia.com>

From: Timo Kokkonen <timo.t.kokkonen@nokia.com>

twl4030 watchdog will be compiled as a module by default.

Signed-off-by: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
---
 arch/arm/configs/rx51_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/rx51_defconfig b/arch/arm/configs/rx51_defconfig
index 67fd8ec..8f01b81 100644
--- a/arch/arm/configs/rx51_defconfig
+++ b/arch/arm/configs/rx51_defconfig
@@ -1051,6 +1051,7 @@ CONFIG_WATCHDOG=y
 #
 # CONFIG_SOFT_WATCHDOG is not set
 CONFIG_OMAP_WATCHDOG=m
+CONFIG_TWL4030_WATCHDOG=m
 
 #
 # USB-based Watchdog Cards
-- 
1.5.4.3

