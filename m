Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYLSA6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYLSA6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYLSA6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:58:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:34778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbYLSA6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:58:21 -0500
Message-ID: <494AF190.6000801@kernel.org>
Date: Thu, 18 Dec 2008 16:57:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 18 (irq.h documentation)
References: <20081218230637.c879a046.sfr@canb.auug.org.au> <20081218155709.bf435d8c.randy.dunlap@oracle.com> <494AEBCA.70108@kernel.org>
In-Reply-To: <494AEBCA.70108@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check

[PATCH] sparseirq: add kernel-doc notation for new member in irq_desc -v2

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 1beb63a..5845bdc 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -135,6 +135,9 @@ struct irq_2_iommu;
 /**
  * struct irq_desc - interrupt descriptor
  * @irq:		interrupt number for this descriptor
+ * @timer_rand_state:	pointer to timer rand state struct
+ * @kstat_irqs:		irq stats per cpu
+ * @irq_2_iommu:	iommu with this irq
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
  * @chip:		low level interrupt hardware access
  * @msi_desc:		MSI descriptor

