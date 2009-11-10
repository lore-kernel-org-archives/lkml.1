Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbZKJB6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbZKJB6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 20:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZKJB6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 20:58:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1281 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbZKJB6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 20:58:45 -0500
Subject: [PATCH] pci-gart_64.c: Use correct length in strncmp
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 17:58:50 -0800
Message-ID: <1257818330.12852.72.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index a7f1b64..fcc0b5c 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -856,7 +856,7 @@ void __init gart_parse_options(char *p)
 #endif
 	if (isdigit(*p) && get_option(&p, &arg))
 		iommu_size = arg;
-	if (!strncmp(p, "fullflush", 8))
+	if (!strncmp(p, "fullflush", 9))
 		iommu_fullflush = 1;
 	if (!strncmp(p, "nofullflush", 11))
 		iommu_fullflush = 0;


