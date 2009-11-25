Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbZKYS53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbZKYS53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZKYS52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:57:28 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:54684 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbZKYS51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:57:27 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=v4X0nIsU9jQA:10 a=dnsDqYgvY1eI8xxSV9Tekg==:17
 a=pGb0pc2owl8CynuoNskA:9 a=EZeF9Z3pA5YMV570NtO7Q7X-B08A:4
From: graeme.smecher@mail.mcgill.ca
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       Graeme Smecher <graeme.smecher@mail.mcgill.ca>
Subject: [PATCH] microblaze: Add dev_archdata node accessors
Date: Wed, 25 Nov 2009 10:57:02 -0800
Message-Id: <1259175422-4628-1-git-send-email-graeme.smecher@mail.mcgill.ca>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Smecher <graeme.smecher@mail.mcgill.ca>

This syncs microblaze with powerpc and sparc architectures, which gained the
same accessors in Commit 3f3b1632022fcc8317fa3b3c1236471415b3a6b8.

Signed-off-by: Graeme Smecher <graeme.smecher@mail.mcgill.ca>
---
 arch/microblaze/include/asm/device.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/device.h b/arch/microblaze/include/asm/device.h
index 30286db..b8f654d 100644
--- a/arch/microblaze/include/asm/device.h
+++ b/arch/microblaze/include/asm/device.h
@@ -16,6 +16,18 @@ struct dev_archdata {
 	struct device_node	*of_node;
 };
 
+static inline void dev_archdata_set_node(struct dev_archdata *ad,
+					 struct device_node *np)
+{
+	ad->of_node = np;
+}
+
+static inline struct device_node *
+dev_archdata_get_node(const struct dev_archdata *ad)
+{
+	return ad->of_node;
+}
+
 struct pdev_archdata {
 };
 
-- 
1.6.5

