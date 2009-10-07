Return-Path: <linux-kernel-owner+w=401wt.eu-S1759726AbZJGS0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726AbZJGS0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757973AbZJGS0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:26:45 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:56352 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757735AbZJGS0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:26:45 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [PATCH]Documentation: Use DMA_BIT_MASK(24) instead of 0x00ffffff
Date: Wed, 7 Oct 2009 21:23:33 +0300
User-Agent: KMail/1.11.4 (Linux/2.6.32-rc3; KDE/4.2.4; x86_64; ; )
Cc: "David S. Miller" <davem@redhat.com>, Richard Henderson <rth@cygnus.com>,
       Jakub Jelinek <jakub@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910072123.34048.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Use DMA_BIT_MASK(24) instead of 0x00ffffff in DMA-mapping.txt

The patch is against 2.6.32-rc3

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

======================================================
--- a/Documentation/DMA-mapping.txt	2009-10-05 17:43:52.000000000 +0300
+++ b/Documentation/DMA-mapping.txt	2009-10-05 17:44:45.000000000 +0300
@@ -214,7 +214,7 @@
 Here is pseudo-code showing how this might be done:
 
 	#define PLAYBACK_ADDRESS_BITS	DMA_BIT_MASK(32)
-	#define RECORD_ADDRESS_BITS	0x00ffffff
+	#define RECORD_ADDRESS_BITS	DMA_BIT_MASK(24)
 
 	struct my_sound_card *card;
 	struct pci_dev *pdev;
