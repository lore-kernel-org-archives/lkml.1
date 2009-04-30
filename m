Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbZD3XnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbZD3XnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbZD3Xmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:42:47 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58674 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717AbZD3Xmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:42:46 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Tim Abbott <tabbott@MIT.EDU>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 2/3] avr32: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:42:38 -0400
Message-Id: <1241134959-7735-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241134959-7735-2-git-send-email-tabbott@mit.edu>
References: <1241134959-7735-1-git-send-email-tabbott@mit.edu>
 <1241134959-7735-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/kernel/vmlinux.lds.S |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
index 36d676f..21fb7b2 100644
--- a/arch/avr32/kernel/vmlinux.lds.S
+++ b/arch/avr32/kernel/vmlinux.lds.S
@@ -101,8 +101,7 @@ SECTIONS
 		PAGE_ALIGNED_DATA
 
 		/* Then, the cacheline aligned data */
-		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
+		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 
 		/* And the rest... */
 		*(.data.rel*)
-- 
1.6.2.1

