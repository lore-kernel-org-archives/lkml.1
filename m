Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZKPOTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZKPOTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZKPOQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:22 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:31523 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZKPOQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:19 -0500
X-SpamScore: 2
X-BigFish: VPS2(z5edIzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ3-01-9KL-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 15/21] edac, mce: update AMD F10h revD check
Date: Mon, 16 Nov 2009 15:16:42 +0100
Message-ID: <1258381008-18783-16-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0032 (UTC) FILETIME=[5A241680:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

F10h revD start with model number 8.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mce_amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 713ed7d..cc1c3c2 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -307,7 +307,7 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 	 * value encoding has changed so interpret those differently
 	 */
 	if ((boot_cpu_data.x86 == 0x10) &&
-	    (boot_cpu_data.x86_model > 8)) {
+	    (boot_cpu_data.x86_model > 7)) {
 		if (regs->nbsh & K8_NBSH_ERR_CPU_VAL)
 			pr_cont(", core: %u\n", (u8)(regs->nbsh & 0xf));
 	} else {
-- 
1.6.4.3


