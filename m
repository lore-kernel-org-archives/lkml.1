Return-Path: <linux-kernel-owner+w=401wt.eu-S1422656AbXBGS2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422656AbXBGS2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422652AbXBGS2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:28:51 -0500
Received: from web38505.mail.mud.yahoo.com ([209.191.125.51]:32270 "HELO
	web38505.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422656AbXBGS2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:28:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Eh2PeusQZtE3trdO6EEJMXXf9fgZicE3S8kBKiNoO9qKTrwuv/e7XlEw8SlvoJA4bfjRH1ias+awWPBapPrNL4Y1sAPeZlJNDU/QSKIkTSc8O1FQoevlsGaWZzwkIh55GGuQitRuWkniSWt5zUPSjWRYK/dWey8zepq60m22x+0=;
X-YMail-OSG: Kkp65lAVM1mCk1T4WgzLCOzb56nDDz1DMnjeu0a5C6ogLvdjPnoYUQ.sk36PKYldTTJFjjIzWyYbsXJltyOHdaT8JA0AOSkBEV9bupaWogLfZfLTT5ABIdhPGwITNrDf0Uwai3EiFwyz6q4-
Date: Wed, 7 Feb 2007 10:28:49 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: [PATCH] [NETDEV] [001] dmfe : trivial/spelling fixes
To: linux-kernel@vger.kernel.org
Cc: tori@unhappy.mine.nu, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <189584.77434.qm@web38505.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Levitsky <maximlevitsky@yahoo.com>
Subject: [PATCH] [NET] [001] dmfe : trivial/spelling fixes

Fix a typo, and wrap lines on 80-th column

Signed-off-by: Maxim Levitsky <maximlevitsky@yahoo.com>

---

--- linux-2.6.20-org/drivers/net/tulip/dmfe.c   2007-02-03 11:47:52.000000000 +0200
+++ linux-2.6.20-mod/drivers/net/tulip/dmfe.c   2007-02-07 14:41:29.000000000 +0200
@@ -143,9 +145,13 @@
 #define DMFE_TX_TIMEOUT ((3*HZ)/2)     /* tx packet time-out time 1.5 s" */
 #define DMFE_TX_KICK   (HZ/2)  /* tx packet Kick-out time 0.5 s" */
 
-#define DMFE_DBUG(dbug_now, msg, value) if (dmfe_debug || (dbug_now)) printk(KERN_ERR DRV_NAME ":
%s %lx\n", (msg), (long) (value))
+#define DMFE_DBUG(dbug_now, msg, value) if (dmfe_debug || (dbug_now)) \
+       printk(KERN_ERR DRV_NAME ": %s %lx\n", (msg), (long) (value))
 
-#define SHOW_MEDIA_TYPE(mode) printk(KERN_ERR DRV_NAME ": Change Speed to %sMhz %s duplex\n",mode
& 1 ?"100":"10", mode & 4 ? "full":"half");
+#define SHOW_MEDIA_TYPE(mode) \
+       printk(KERN_ERR DRV_NAME ": \
+       Change Speed to %sMhz %s duplex\n",mode & 1 ?"100":"10", \
+       mode & 4 ? "full":"half");
 
 
 /* CR9 definition: SROM/MII */
@@ -163,10 +169,17 @@
 
 #define SROM_V41_CODE   0x14
 
-#define SROM_CLK_WRITE(data, ioaddr)
outl(data|CR9_SROM_READ|CR9_SRCS,ioaddr);udelay(5);outl(data|CR9_SROM_READ|CR9_SRCS|CR9_SRCLK,ioaddr);udelay(5);outl(data|CR9_SROM_READ|CR9_SRCS,ioaddr);udelay(5);
+#define SROM_CLK_WRITE(data, ioaddr) \
+       outl(data|CR9_SROM_READ|CR9_SRCS,ioaddr);udelay(5);\
+       outl(data|CR9_SROM_READ|CR9_SRCS|CR9_SRCLK,ioaddr);udelay(5);\
+       outl(data|CR9_SROM_READ|CR9_SRCS,ioaddr);udelay(5);
+
+#define __CHK_IO_SIZE(pci_id, dev_rev) \
+       ( ((pci_id)==PCI_DM9132_ID) || ((dev_rev) >= 0x02000030) ) ? \
+       DM9102A_IO_SIZE: DM9102_IO_SIZE
 
-#define __CHK_IO_SIZE(pci_id, dev_rev) ( ((pci_id)==PCI_DM9132_ID) || ((dev_rev) >= 0x02000030) )
? DM9102A_IO_SIZE: DM9102_IO_SIZE
-#define CHK_IO_SIZE(pci_dev, dev_rev) __CHK_IO_SIZE(((pci_dev)->device << 16) |
(pci_dev)->vendor, dev_rev)
+#define CHK_IO_SIZE(pci_dev, dev_rev) \
+       __CHK_IO_SIZE(((pci_dev)->device << 16) | (pci_dev)->vendor, dev_rev)
 
 /* Sten Check */
 #define DEVICE net_device
@@ -329,7 +342,7 @@ static void dmfe_program_DM9802(struct d
 static void dmfe_HPNA_remote_cmd_chk(struct dmfe_board_info * );
 static void dmfe_set_phyxcer(struct dmfe_board_info *);
 
-/* DM910X network baord routine ---------------------------- */
+/* DM910X network board routine ---------------------------- */
 
 /*
  *     Search DM910X board ,allocate space and register it
@@ -402,8 +415,11 @@ static int __devinit dmfe_init_one (stru
        db->dev = dev;
 
        /* Allocate Tx/Rx descriptor memory */
-       db->desc_pool_ptr = pci_alloc_consistent(pdev, sizeof(struct tx_desc) * DESC_ALL_CNT +
0x20,
&db->desc_pool_dma_ptr);
-       db->buf_pool_ptr = pci_alloc_consistent(pdev, TX_BUF_ALLOC * TX_DESC_CNT + 4,
&db->buf_pool_dma_ptr);
+       db->desc_pool_ptr = pci_alloc_consistent(pdev, sizeof(struct tx_desc) 
+                       * DESC_ALL_CNT + 0x20, &db->desc_pool_dma_ptr);
+       
+       db->buf_pool_ptr = pci_alloc_consistent(pdev, TX_BUF_ALLOC 
+                       * TX_DESC_CNT + 4, &db->buf_pool_dma_ptr);
 
        db->first_tx_desc = (struct tx_desc *) db->desc_pool_ptr;
        db->first_tx_desc_dma = db->desc_pool_dma_ptr;
@@ -440,7 +457,8 @@ static int __devinit dmfe_init_one (stru
 
        /* read 64 word srom data */
        for (i = 0; i < 64; i++)
-               ((u16 *) db->srom)[i] = cpu_to_le16(read_srom_word(db->ioaddr, i));
+               ((u16 *) db->srom)[i] = 
+                       cpu_to_le16(read_srom_word(db->ioaddr, i));
 
        /* Set Node address */
        for (i = 0; i < 6; i++)
@@ -722,7 +742,8 @@ static int dmfe_stop(struct DEVICE *dev)
 
 #if 0
        /* show statistic counter */
-       printk(DRV_NAME ": FU:%lx EC:%lx LC:%lx NC:%lx LOC:%lx TXJT:%lx RESET:%lx RCR8:%lx FAL:%lx
TT:%lx\n",
+       printk(DRV_NAME ": FU:%lx EC:%lx LC:%lx NC:%lx LOC:%lx TXJT:%lx 
+               RESET:%lx RCR8:%lx FAL:%lx TT:%lx\n",
                db->tx_fifo_underrun, db->tx_excessive_collision,
                db->tx_late_collision, db->tx_no_carrier, db->tx_loss_carrier,
                db->tx_jabber_timeout, db->reset_count, db->reset_cr8,
@@ -919,7 +940,8 @@ static void dmfe_rx_packet(struct DEVICE
                db->rx_avail_cnt--;
                db->interval_rx_cnt++;
 
-               pci_unmap_single(db->pdev, le32_to_cpu(rxptr->rdes2), RX_ALLOC_SIZE,
PCI_DMA_FROMDEVICE);
+               pci_unmap_single(db->pdev, le32_to_cpu(rxptr->rdes2), 
+                                RX_ALLOC_SIZE, PCI_DMA_FROMDEVICE);
                if ( (rdes0 & 0x300) != 0x300) {
                        /* A packet without First/Last flag */
                        /* reuse this SKB */
@@ -1259,7 +1334,8 @@ static void dmfe_reuse_skb(struct dmfe_b
 
        if (!(rxptr->rdes0 & cpu_to_le32(0x80000000))) {
                rxptr->rx_skb_ptr = skb;
-               rxptr->rdes2 = cpu_to_le32( pci_map_single(db->pdev, skb->data, RX_ALLOC_SIZE,
PCI_DMA_FROMDEVICE) );
+               rxptr->rdes2 = cpu_to_le32( pci_map_single(db->pdev, skb->data, 
+                                           RX_ALLOC_SIZE, PCI_DMA_FROMDEVICE) );
                wmb();
                rxptr->rdes0 = cpu_to_le32(0x80000000);
                db->rx_avail_cnt++;
@@ -1470,7 +1546,8 @@ static void allocate_rx_buffer(struct dm
                if ( ( skb = dev_alloc_skb(RX_ALLOC_SIZE) ) == NULL )
                        break;
                rxptr->rx_skb_ptr = skb; /* FIXME (?) */
-               rxptr->rdes2 = cpu_to_le32( pci_map_single(db->pdev, skb->data, RX_ALLOC_SIZE,
PCI_DMA_FROMDEVICE) );
+               rxptr->rdes2 = cpu_to_le32( pci_map_single(db->pdev, skb->data, 
+                                           RX_ALLOC_SIZE, PCI_DMA_FROMDEVICE) );
                wmb();
                rxptr->rdes0 = cpu_to_le32(0x80000000);
                rxptr = rxptr->next_rx_desc;
@@ -1663,7 +1740,8 @@ static void dmfe_process_mode(struct dmf
  *     Write a word to Phy register
  */
 
-static void phy_write(unsigned long iobase, u8 phy_addr, u8 offset, u16 phy_data, u32 chip_id)
+static void phy_write(unsigned long iobase, u8 phy_addr, u8 offset, 
+                     u16 phy_data, u32 chip_id)
 {
        u16 i;
        unsigned long ioaddr;



 
____________________________________________________________________________________
Get your own web address.  
Have a HUGE year through Yahoo! Small Business.
http://smallbusiness.yahoo.com/domains/?p=BESTDEAL
