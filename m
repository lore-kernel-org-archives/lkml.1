Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYAWWhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYAWWhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYAWWhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:37:42 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:37298 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbYAWWhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:37:41 -0500
Message-ID: <4797C1AD.3040307@tiscali.nl>
Date: Wed, 23 Jan 2008 23:37:33 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: jwboyer@linux.vnet.ibm.com, lkml <linux-kernel@vger.kernel.org>
CC: linuxppc-dev@ozlabs.org
Subject: [PATCH][ppc] logical/bitand typo in powerpc/boot/4xx.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

logical/bitand typo

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/powerpc/boot/4xx.c b/arch/powerpc/boot/4xx.c
index ebf9e21..dcfb459 100644
--- a/arch/powerpc/boot/4xx.c
+++ b/arch/powerpc/boot/4xx.c
@@ -104,7 +104,7 @@ void ibm4xx_denali_fixup_memsize(void)
 	val = DDR_GET_VAL(val, DDR_CS_MAP, DDR_CS_MAP_SHIFT);
 	cs = 0;
 	while (val) {
-		if (val && 0x1)
+		if (val & 0x1)
 			cs++;
 		val = val >> 1;
 	}
