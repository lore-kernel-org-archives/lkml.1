Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbXIXWU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbXIXWU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbXIXWUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:20:51 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:55812 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbXIXWUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:20:50 -0400
Message-ID: <46F83825.7060905@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2007 03:50:21 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The drivers/net/pasemi_mac seems to be broken and build fails with

CC [M] drivers/net/pasemi_mac.o
drivers/net/pasemi_mac.c: In function ‘pasemi_mac_probe’:
drivers/net/pasemi_mac.c:1153: error: conflicting types for ‘mac’
drivers/net/pasemi_mac.c:1151: error: previous declaration of ‘mac’ was here
drivers/net/pasemi_mac.c:1170: error: incompatible types in assignment
drivers/net/pasemi_mac.c:1172: error: request for member ‘pdev’ in
something not a structure or union
drivers/net/pasemi_mac.c:1173: error: request for member ‘netdev’ in
something not a structure or union
drivers/net/pasemi_mac.c:1175: error: request for member ‘napi’ in
something not a structure or union
drivers/net/pasemi_mac.c:1180: error: request for member ‘dma_txch’ in
something not a structure or union
drivers/net/pasemi_mac.c:1181: error: request for member ‘dma_rxch’ in
something not a structure or union
drivers/net/pasemi_mac.c:1187: error: request for member ‘dma_if’ in
something not a structure or union
drivers/net/pasemi_mac.c:1189: error: request for member ‘dma_if’ in
something not a structure or union
drivers/net/pasemi_mac.c:1194: error: request for member ‘type’ in
something not a structure or union
drivers/net/pasemi_mac.c:1197: error: request for member ‘type’ in
something not a structure or union
drivers/net/pasemi_mac.c:1205: warning: passing argument 1 of
‘pasemi_get_mac_addr’ from incompatible pointer type
drivers/net/pasemi_mac.c:1205: error: request for member ‘mac_addr’ in
something not a structure or union
drivers/net/pasemi_mac.c:1209: error: request for member ‘mac_addr’ in
something not a structure or union
drivers/net/pasemi_mac.c:1209: error: request for member ‘mac_addr’ in
something not a structure or union
drivers/net/pasemi_mac.c:1216: warning: passing argument 1 of
‘pasemi_mac_map_regs’ from incompatible pointer type
drivers/net/pasemi_mac.c:1220: error: request for member ‘rx_status’ in
something not a structure or union
drivers/net/pasemi_mac.c:1220: error: request for member ‘dma_rxch’ in
something not a structure or union
drivers/net/pasemi_mac.c:1221: error: request for member ‘tx_status’ in
something not a structure or union
drivers/net/pasemi_mac.c:1221: error: request for member ‘dma_txch’ in
something not a structure or union
drivers/net/pasemi_mac.c:1223: error: request for member ‘msg_enable’ in
something not a structure or union
drivers/net/pasemi_mac.c:1226: error: request for member ‘msg_enable’ in
something not a structure or union
drivers/net/pasemi_mac.c:1231: error: request for member ‘pdev’ in
something not a structure or union
drivers/net/pasemi_mac.c:1231: error: request for member ‘pdev’ in
something not a structure or union
drivers/net/pasemi_mac.c:1237: error: request for member ‘type’ in
something not a structure or union
drivers/net/pasemi_mac.c:1238: error: request for member ‘dma_if’ in
something not a structure or union
drivers/net/pasemi_mac.c:1238: error: request for member ‘dma_txch’ in
something not a structure or union
drivers/net/pasemi_mac.c:1238: error: request for member ‘dma_rxch’ in
something not a structure or union
drivers/net/pasemi_mac.c:1244: error: request for member ‘iob_pdev’ in
something not a structure or union
drivers/net/pasemi_mac.c:1245: error: request for member ‘iob_pdev’ in
something not a structure or union
drivers/net/pasemi_mac.c:1246: error: request for member ‘dma_pdev’ in
something not a structure or union
drivers/net/pasemi_mac.c:1247: error: request for member ‘dma_pdev’ in
something not a structure or union
drivers/net/pasemi_mac.c:1248: error: request for member ‘dma_regs’ in
something not a structure or union
drivers/net/pasemi_mac.c:1249: error: request for member ‘dma_regs’ in
something not a structure or union
drivers/net/pasemi_mac.c:1250: error: request for member ‘iob_regs’ in
something not a structure or union
drivers/net/pasemi_mac.c:1251: error: request for member ‘iob_regs’ in
something not a structure or union
drivers/net/pasemi_mac.c:1252: error: request for member ‘regs’ in
something not a structure or union
drivers/net/pasemi_mac.c:1253: error: request for member ‘regs’ in
something not a structure or union
make[2]: *** [drivers/net/pasemi_mac.o] Error 1
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

In the function
static int __devinit
pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
{
<snip>
struct pasemi_mac *mac;
int err;
DECLARE_MAC_BUF(mac);

introduction of mac as var [18] triggers the build failure, so in the
below patch
renaming mac as mac_buf is done, because it is used to print the mac
address using
the newly introduced print_mac function.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---

--- linux-2.6.23-rc7/drivers/net/pasemi_mac.c   2007-09-25 03:27:45.000000000 +0530
+++ linux-2.6.23-rc7/drivers/net/~pasemi_mac.c  2007-09-25 03:27:27.000000000 +0530
@@ -1150,7 +1150,7 @@ pasemi_mac_probe(struct pci_dev *pdev, c
        struct net_device *dev;
        struct pasemi_mac *mac;
        int err;
-       DECLARE_MAC_BUF(mac);
+       DECLARE_MAC_BUF(mac_buf); 

        err = pci_enable_device(pdev);
        if (err)
@@ -1236,7 +1236,7 @@ pasemi_mac_probe(struct pci_dev *pdev, c
                       "hw addr %s\n",
                       dev->name, mac->type == MAC_TYPE_GMAC ? "GMAC" : "XAUI",
                       mac->dma_if, mac->dma_txch, mac->dma_rxch,
-                      print_mac(mac, dev->dev_addr));
+                      print_mac(mac_buf, dev->dev_addr)); 

        return err; 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

