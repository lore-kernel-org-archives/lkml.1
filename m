Return-Path: <linux-kernel-owner+w=401wt.eu-S932770AbZEAARk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbZEAARk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765362AbZEAADV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:03:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61952 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763888AbZEAADU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:03:20 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/7] sh: Use macros for .data.page_aligned section.
Date: Thu, 30 Apr 2009 19:57:58 -0400
Message-Id: <1241135883-9766-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135883-9766-2-git-send-email-tabbott@mit.edu>
References: <1241135883-9766-1-git-send-email-tabbott@mit.edu>
 <1241135883-9766-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/kernel/vmlinux_32.lds.S |    3 +--
 arch/sh/kernel/vmlinux_64.lds.S |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/sh/kernel/vmlinux_32.lds.S b/arch/sh/kernel/vmlinux_32.lds.S
index 99a4124..325af0b 100644
--- a/arch/sh/kernel/vmlinux_32.lds.S
+++ b/arch/sh/kernel/vmlinux_32.lds.S
@@ -69,8 +69,7 @@ SECTIONS
 		. = ALIGN(L1_CACHE_BYTES);
 		*(.data.read_mostly)
 
-		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
+		PAGE_ALIGNED_DATA
 
 		__nosave_begin = .;
 		*(.data.nosave)
diff --git a/arch/sh/kernel/vmlinux_64.lds.S b/arch/sh/kernel/vmlinux_64.lds.S
index cb46577..b222700 100644
--- a/arch/sh/kernel/vmlinux_64.lds.S
+++ b/arch/sh/kernel/vmlinux_64.lds.S
@@ -78,8 +78,7 @@ SECTIONS
 		. = ALIGN(L1_CACHE_BYTES);
 		*(.data.read_mostly)
 
-		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
+		PAGE_ALIGNED_DATA
 
 		__nosave_begin = .;
 		*(.data.nosave)
-- 
1.6.2.1

