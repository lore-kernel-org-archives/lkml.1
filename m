Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbXCZKKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbXCZKKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbXCZKKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:10:52 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:15715 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbXCZKKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:10:51 -0400
X-IronPort-AV: i="4.14,329,1170651600"; 
   d="scan'208"; a="25489753:sNHT31938123"
Subject: [PATCH -mm] Blackfin arch: fix struct dmasg packing bug
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 26 Mar 2007 18:11:15 +0800
Message-Id: <1174903875.32691.63.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

This patch fix a bug about struct dmasg packed missing bug.
Using __attribute__ instead of pragma.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---

 include/asm-blackfin/dma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/asm-blackfin/dma.h
===================================================================
--- linux-2.6.orig/include/asm-blackfin/dma.h
+++ linux-2.6/include/asm-blackfin/dma.h
@@ -84,7 +84,7 @@
 	short x_modify;
 	unsigned short y_count;
 	short y_modify;
-};
+} __attribute__((packed));
 
 struct dma_register {
 	unsigned long next_desc_ptr;	/* DMA Next Descriptor Pointer register */
_

Thanks,
-Bryan Wu
