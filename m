Return-Path: <linux-kernel-owner+w=401wt.eu-S933380AbZKXPK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380AbZKXPK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933280AbZKXPKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:10:03 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45518 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933245AbZKXPHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:51 -0500
Message-Id: <20091124150757.311997000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:19 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 22/29] GRU - Remove stray local_irq_enable
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_remove_local_irq_enable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Remove a stray local_irq_enable() in the GRU TLB dropin code.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-11-20 10:45:10.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-11-20 10:45:59.000000000 -0600
@@ -253,7 +253,6 @@ static int atomic_pte_lookup(struct vm_a
 	return 0;
 
 err:
-	local_irq_enable();
 	return 1;
 }
 

