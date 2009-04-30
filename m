Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZD3XoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZD3XoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758251AbZD3Xn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:43:57 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58826 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758262AbZD3Xn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:43:56 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Bryan Wu <cooloney@kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH] blackfin: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:43:35 -0400
Message-Id: <1241135015-7860-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135015-7860-1-git-send-email-tabbott@mit.edu>
References: <1241135015-7860-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
---
 arch/blackfin/kernel/vmlinux.lds.S |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 27952ae..0bfc59b 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -93,8 +93,7 @@ SECTIONS
 	{
 		__sdata = .;
 		/* This gets done first, so the glob doesn't suck it in */
-		. = ALIGN(32);
-		*(.data.cacheline_aligned)
+		CACHELINE_ALIGNED_DATA(32)
 
 #if !L1_DATA_A_LENGTH
 		. = ALIGN(32);
-- 
1.6.2.1

