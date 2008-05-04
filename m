Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbYEDUlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbYEDUlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 16:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYEDUlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 16:41:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:34911 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYEDUlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 16:41:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:mime-version:content-disposition:message-id:cc:content-type:content-transfer-encoding:from;
        b=JZX0IIOC8GCo1DN7A9sCqgKtj/zg/JD93XIqCXAGnA6P6oyTuopqFQc+qoNOhZaQuLylzkGSxHRqjb1ACp5qm4iwPVehhrIWRkkKh2SfXbCB6RZYdHoR6oU0yAHOOiDFnLyZOMoe7yj0QQOGRlwH+IfeP1rL1A/XAOUshpLa7gk=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] x86: remove spew print out about bus to node mapping
Date: Sun, 4 May 2008 13:41:02 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805041341.02375.yhlu.kernel@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jeff Garzik pointed out that is not needed. looks like spam.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/pci/k8-bus_64.c b/arch/x86/pci/k8-bus_64.c
index ab6d4b1..5c2799c 100644
--- a/arch/x86/pci/k8-bus_64.c
+++ b/arch/x86/pci/k8-bus_64.c
@@ -504,14 +504,6 @@ static int __init early_fill_mp_bus_info(void)
 		}
 	}
 
-#ifdef CONFIG_NUMA
-	for (i = 0; i < BUS_NR; i++) {
-		node = mp_bus_to_node[i];
-		if (node >= 0)
-			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
-	}
-#endif
-
 	for (i = 0; i < pci_root_num; i++) {
 		int res_num;
 		int busnum;
