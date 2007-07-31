Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXGaRuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXGaRuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762305AbXGaRtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:49:53 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1040 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762440AbXGaRtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:49:52 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 28] drivers/net/wan/hdlc_fr.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:49:52 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Halasa <khc@pm.waw.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311949.52337.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/wan/hdlc_fr.c | 31260 -> 31223 (-37 bytes)
 drivers/net/wan/hdlc_fr.o | 144872 -> 144728 (-144 bytes)

 drivers/net/wan/hdlc_fr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/net/wan/hdlc_fr.c	2007-07-26 13:07:43.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/net/wan/hdlc_fr.c	2007-07-30 00:25:40.000000000 +0200
@@ -212,14 +212,13 @@ static pvc_device* add_pvc(struct net_de
 		pvc_p = &(*pvc_p)->next;
 	}

-	pvc = kmalloc(sizeof(pvc_device), GFP_ATOMIC);
+	pvc = kzalloc(sizeof(pvc_device), GFP_ATOMIC);
 #ifdef DEBUG_PVC
 	printk(KERN_DEBUG "add_pvc: allocated pvc %p, frad %p\n", pvc, dev);
 #endif
 	if (!pvc)
 		return NULL;

-	memset(pvc, 0, sizeof(pvc_device));
 	pvc->dlci = dlci;
 	pvc->frad = dev;
 	pvc->next = *pvc_p;	/* Put it in the chain */
