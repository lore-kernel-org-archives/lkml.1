Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbXE1IiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbXE1IiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760717AbXE1Igh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:37 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:4651 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571AbXE1Igc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:32 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="31069463:sNHT20011278"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Robin Getz <robin.getz@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 05/20] Blackfin arch: all symbols were offset by 4k, since we didn't have the __text label.
Date: Mon, 28 May 2007 16:37:40 +0800
Message-Id: <1180341477212-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Bug tracker: http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3231

Singed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/vmlinux.lds.S |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 86fe679..19b853a 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -52,6 +52,7 @@ SECTIONS
 
 	.text :
 	{
+		 __text = .;
 		 _text = .;
 		 __stext = .;
 		TEXT_TEXT
-- 
1.5.2
