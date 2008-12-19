Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbYLSAec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbYLSAec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYLSAeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:34:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:35387 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbYLSAeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:34:01 -0500
Message-ID: <494AEBCA.70108@kernel.org>
Date: Thu, 18 Dec 2008 16:33:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 18 (irq.h documentation)
References: <20081218230637.c879a046.sfr@canb.auug.org.au> <20081218155709.bf435d8c.randy.dunlap@oracle.com>
In-Reply-To: <20081218155709.bf435d8c.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Hi YH,
> 
> Whenever you update a struct in a header file that uses kernel-doc,
> like struct irq_desc in include/linux/irq.h, please also update the
> corresponding kernel-doc notation for the new struct members, so
> that kernel-doc warnings are not caused:
> 
> from linux-next-20081218:
> 
> Warning(linux-next-20081218//include/linux/irq.h:192): No description found for parameter 'timer_rand_state'
> Warning(linux-next-20081218//include/linux/irq.h:192): No description found for parameter 'kstat_irqs'
> Warning(linux-next-20081218//include/linux/irq.h:192): No description found for parameter 'irq_2_iommu'
> 
> 
please check

[PATCH] sparseirq: add kernel-doc notation for new member in irq_desc

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 1beb63a..4675682 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -135,6 +135,9 @@ struct irq_2_iommu;
 /**
  * struct irq_desc - interrupt descriptor
  * @irq:		interrupt number for this descriptor
+ * @timer_rand_state	pointer to timer rand state struct
+ * @kstat_irqs		irq stats per cpu
+ * @irq_2_iommu		iommu with this irq
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
  * @chip:		low level interrupt hardware access
  * @msi_desc:		MSI descriptor
