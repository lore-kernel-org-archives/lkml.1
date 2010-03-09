Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0CIOrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 09:47:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39066 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab0CIOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 09:46:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CyxxMKEvZG39rcusk/+ltu9ADA6JaUjfjoSAK1eZee3n+3x6CmLLDupWNBitBUKvYC
         e+DSu4aHX48VKPsQ7PD6MZNHrtcMrku0EG7qpSpNE6dLb37WFWSX6glIGr6inINQWMgO
         VVc/Cxwbt4RaPlZfCS/TfZ7iNNwGZahkykpSQ=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] Staging: netwave: fixed trailing whitespace style issue in netwave_cs.c
Date: Tue,  9 Mar 2010 20:16:44 +0530
Message-Id: <1268146005-5305-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the netwave_cs.c file that fixes up all the
trailing whitespace errors found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/netwave/netwave_cs.c |  248 +++++++++++++++++-----------------
 1 files changed, 124 insertions(+), 124 deletions(-)

diff --git a/drivers/staging/netwave/netwave_cs.c b/drivers/staging/netwave/netwave_cs.c
index e936717..0c406fd 100644
--- a/drivers/staging/netwave/netwave_cs.c
+++ b/drivers/staging/netwave/netwave_cs.c
@@ -1,5 +1,5 @@
 /*********************************************************************
- *                
+ *
  * Filename:      netwave_cs.c
  * Version:       0.4.1
  * Description:   Netwave AirSurfer Wireless LAN PC Card driver
@@ -10,27 +10,27 @@
  * Created at:    A long time ago!
  * Modified at:   Mon Nov 10 11:54:37 1997
  * Modified by:   Dag Brattli <dagb@cs.uit.no>
- * 
+ *
  *     Copyright (c) 1997 University of Tromsø, Norway
  *
  * Revision History:
  *
  *   08-Nov-97 15:14:47   John Markus Bjørndalen <johnm@cs.uit.no>
- *    - Fixed some bugs in netwave_rx and cleaned it up a bit. 
+ *    - Fixed some bugs in netwave_rx and cleaned it up a bit.
  *      (One of the bugs would have destroyed packets when receiving
- *      multiple packets per interrupt). 
- *    - Cleaned up parts of newave_hw_xmit. 
- *    - A few general cleanups. 
+ *      multiple packets per interrupt).
+ *    - Cleaned up parts of newave_hw_xmit.
+ *    - A few general cleanups.
  *   24-Oct-97 13:17:36   Dag Brattli <dagb@cs.uit.no>
  *    - Fixed netwave_rx receive function (got updated docs)
  *   Others:
- *    - Changed name from xircnw to netwave, take a look at 
+ *    - Changed name from xircnw to netwave, take a look at
  *      http://www.netwave-wireless.com
  *    - Some reorganizing of the code
  *    - Removed possible race condition between interrupt handler and transmit
  *      function
  *    - Started to add wireless extensions, but still needs some coding
- *    - Added watchdog for better handling of transmission timeouts 
+ *    - Added watchdog for better handling of transmission timeouts
  *      (hopefully this works better)
  ********************************************************************/
 
@@ -102,7 +102,7 @@
 
 /*
  * Commands used in the extended command buffer
- * NETWAVE_EREG_CB (0x100-0x10F) 
+ * NETWAVE_EREG_CB (0x100-0x10F)
  */
 #define NETWAVE_CMD_NOP        0x00
 #define NETWAVE_CMD_SRC        0x01
@@ -134,7 +134,7 @@ static const unsigned int corConfIENA   = 0x01; /* Interrupt enable */
 static const unsigned int corConfLVLREQ = 0x40; /* Keep high */
 
 static const unsigned int rxConfRxEna  = 0x80; /* Receive Enable */
-static const unsigned int rxConfMAC    = 0x20; /* MAC host receive mode*/ 
+static const unsigned int rxConfMAC    = 0x20; /* MAC host receive mode*/
 static const unsigned int rxConfPro    = 0x10; /* Promiscuous */
 static const unsigned int rxConfAMP    = 0x08; /* Accept Multicast Packets */
 static const unsigned int rxConfBcast  = 0x04; /* Accept Broadcast Packets */
@@ -153,15 +153,15 @@ static const unsigned int txConfLoop   = 0x01; /* Loopback mode */
 /* Choose the domain, default is 0x100 */
 static u_int  domain = 0x100;
 
-/* Scramble key, range from 0x0 to 0xffff.  
- * 0x0 is no scrambling. 
+/* Scramble key, range from 0x0 to 0xffff.
+ * 0x0 is no scrambling.
  */
 static u_int  scramble_key = 0x0;
 
-/* Shared memory speed, in ns. The documentation states that 
- * the card should not be read faster than every 400ns. 
- * This timing should be provided by the HBA. If it becomes a 
- * problem, try setting mem_speed to 400. 
+/* Shared memory speed, in ns. The documentation states that
+ * the card should not be read faster than every 400ns.
+ * This timing should be provided by the HBA. If it becomes a
+ * problem, try setting mem_speed to 400.
  */
 static int mem_speed;
 
@@ -230,7 +230,7 @@ struct site_survey {
     u_short length;
     u_char  struct_revision;
     u_char  roaming_state;
-	
+
     u_char  sp_existsFlag;
     u_char  sp_link_quality;
     u_char  sp_max_link_quality;
@@ -240,12 +240,12 @@ struct site_survey {
     u_char  sp_goodness;
     u_char  sp_hotheadcount;
     u_char  roaming_condition;
-	
+
     net_addr sp;
     u_char   numAPs;
     net_addr nearByAccessPoints[MAX_ESA];
-};	
-   
+};
+
 typedef struct netwave_private {
 	struct pcmcia_device	*p_dev;
     spinlock_t	spinlock;	/* Serialize access to the hardware (SMP) */
@@ -262,7 +262,7 @@ typedef struct netwave_private {
  * The Netwave card is little-endian, so won't work for big endian
  * systems.
  */
-static inline unsigned short get_uint16(u_char __iomem *staddr) 
+static inline unsigned short get_uint16(u_char __iomem *staddr)
 {
     return readw(staddr); /* Return only 16 bits */
 }
@@ -272,38 +272,38 @@ static inline short get_int16(u_char __iomem * staddr)
     return readw(staddr);
 }
 
-/* 
- * Wait until the WOC (Write Operation Complete) bit in the 
- * ASR (Adapter Status Register) is asserted. 
- * This should have aborted if it takes too long time. 
+/*
+ * Wait until the WOC (Write Operation Complete) bit in the
+ * ASR (Adapter Status Register) is asserted.
+ * This should have aborted if it takes too long time.
  */
 static inline void wait_WOC(unsigned int iobase)
 {
     /* Spin lock */
-    while ((inb(iobase + NETWAVE_REG_ASR) & 0x8) != 0x8) ; 
+    while ((inb(iobase + NETWAVE_REG_ASR) & 0x8) != 0x8) ;
 }
 
-static void netwave_snapshot(netwave_private *priv, u_char __iomem *ramBase, 
+static void netwave_snapshot(netwave_private *priv, u_char __iomem *ramBase,
 			     unsigned int iobase) {
     u_short resultBuffer;
 
-    /* if time since last snapshot is > 1 sec. (100 jiffies?)  then take 
-     * new snapshot, else return cached data. This is the recommended rate.  
+    /* if time since last snapshot is > 1 sec. (100 jiffies?)  then take
+     * new snapshot, else return cached data. This is the recommended rate.
      */
-    if ( jiffies - priv->lastExec > 100) { 
-	/* Take site survey  snapshot */ 
+    if ( jiffies - priv->lastExec > 100) {
+	/* Take site survey  snapshot */
 	/*printk( KERN_DEBUG "Taking new snapshot. %ld\n", jiffies -
 	  priv->lastExec); */
-	wait_WOC(iobase); 
-	writeb(NETWAVE_CMD_SSS, ramBase + NETWAVE_EREG_CB + 0); 
-	writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 1); 
-	wait_WOC(iobase); 
-
-	/* Get result and copy to cach */ 
-	resultBuffer = readw(ramBase + NETWAVE_EREG_CRBP); 
-	copy_from_pc( &priv->nss, ramBase+resultBuffer, 
-		      sizeof(struct site_survey)); 
-    } 
+	wait_WOC(iobase);
+	writeb(NETWAVE_CMD_SSS, ramBase + NETWAVE_EREG_CB + 0);
+	writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 1);
+	wait_WOC(iobase);
+
+	/* Get result and copy to cach */
+	resultBuffer = readw(ramBase + NETWAVE_EREG_CRBP);
+	copy_from_pc( &priv->nss, ramBase+resultBuffer,
+		      sizeof(struct site_survey));
+    }
 }
 
 /*
@@ -313,21 +313,21 @@ static void netwave_snapshot(netwave_private *priv, u_char __iomem *ramBase,
  *
  */
 static struct iw_statistics *netwave_get_wireless_stats(struct net_device *dev)
-{	
+{
     unsigned long flags;
     unsigned int iobase = dev->base_addr;
     netwave_private *priv = netdev_priv(dev);
     u_char __iomem *ramBase = priv->ramBase;
     struct iw_statistics* wstats;
-	
+
     wstats = &priv->iw_stats;
 
     spin_lock_irqsave(&priv->spinlock, flags);
-	
+
     netwave_snapshot( priv, ramBase, iobase);
 
     wstats->status = priv->nss.roaming_state;
-    wstats->qual.qual = readb( ramBase + NETWAVE_EREG_SPCQ); 
+    wstats->qual.qual = readb( ramBase + NETWAVE_EREG_SPCQ);
     wstats->qual.level = readb( ramBase + NETWAVE_EREG_ISPLQ);
     wstats->qual.noise = readb( ramBase + NETWAVE_EREG_SPU) & 0x3f;
     wstats->discard.nwid = 0L;
@@ -335,7 +335,7 @@ static struct iw_statistics *netwave_get_wireless_stats(struct net_device *dev)
     wstats->discard.misc = 0L;
 
     spin_unlock_irqrestore(&priv->spinlock, flags);
-    
+
     return &priv->iw_stats;
 }
 
@@ -353,8 +353,8 @@ static const struct net_device_ops netwave_netdev_ops = {
 /*
  * Function netwave_attach (void)
  *
- *     Creates an "instance" of the driver, allocating local data 
- *     structures for one device.  The device is registered with Card 
+ *     Creates an "instance" of the driver, allocating local data
+ *     structures for one device.  The device is registered with Card
  *     Services.
  *
  *     The dev_link structure is initialized, but we don't actually
@@ -379,14 +379,14 @@ static int netwave_probe(struct pcmcia_device *link)
     /* The io structure describes IO port mapping */
     link->io.NumPorts1 = 16;
     link->io.Attributes1 = IO_DATA_PATH_WIDTH_16;
-    /* link->io.NumPorts2 = 16; 
+    /* link->io.NumPorts2 = 16;
        link->io.Attributes2 = IO_DATA_PATH_WIDTH_16; */
     link->io.IOAddrLines = 5;
-    
+
     /* Interrupt setup */
     link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
     link->irq.Handler = &netwave_interrupt;
-    
+
     /* General socket configuration */
     link->conf.Attributes = CONF_ENABLE_IRQ;
     link->conf.IntType = INT_MEMORY_AND_IO;
@@ -458,7 +458,7 @@ static int netwave_set_nwid(struct net_device *dev,
 
 	if(!wrqu->nwid.disabled) {
 	    domain = wrqu->nwid.value;
-	    printk( KERN_DEBUG "Setting domain to 0x%x%02x\n", 
+	    printk( KERN_DEBUG "Setting domain to 0x%x%02x\n",
 		    (domain >> 8) & 0x01, domain & 0xff);
 	    wait_WOC(iobase);
 	    writeb(NETWAVE_CMD_SMD, ramBase + NETWAVE_EREG_CB + 0);
@@ -469,7 +469,7 @@ static int netwave_set_nwid(struct net_device *dev,
 
 	/* ReEnable interrupts & restore flags */
 	spin_unlock_irqrestore(&priv->spinlock, flags);
-    
+
 	return 0;
 }
 
@@ -512,7 +512,7 @@ static int netwave_set_scramble(struct net_device *dev,
 
 	/* ReEnable interrupts & restore flags */
 	spin_unlock_irqrestore(&priv->spinlock, flags);
-    
+
 	return 0;
 }
 
@@ -567,19 +567,19 @@ static int netwave_get_range(struct net_device *dev,
 	/* Set the Wireless Extension versions */
 	range->we_version_compiled = WIRELESS_EXT;
 	range->we_version_source = 9;	/* Nothing for us in v10 and v11 */
-		   
+
 	/* Set information in the range struct */
 	range->throughput = 450 * 1000;	/* don't argue on this ! */
 	range->min_nwid = 0x0000;
 	range->max_nwid = 0x01FF;
 
 	range->num_channels = range->num_frequency = 0;
-		   
+
 	range->sensitivity = 0x3F;
 	range->max_qual.qual = 255;
 	range->max_qual.level = 255;
 	range->max_qual.noise = 0;
-		   
+
 	range->num_bitrates = 1;
 	range->bitrate[0] = 1000000;	/* 1 Mb/s */
 
@@ -615,7 +615,7 @@ static int netwave_get_snap(struct net_device *dev,
 
 	/* ReEnable interrupts & restore flags */
 	spin_unlock_irqrestore(&priv->spinlock, flags);
-    
+
 	return(0);
 }
 
@@ -626,8 +626,8 @@ static int netwave_get_snap(struct net_device *dev,
 
 static const struct iw_priv_args netwave_private_args[] = {
 /*{ cmd,         set_args,                            get_args, name } */
-  { SIOCGIPSNAP, 0, 
-    IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | sizeof(struct site_survey), 
+  { SIOCGIPSNAP, 0,
+    IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | sizeof(struct site_survey),
     "getsitesurvey" },
 };
 
@@ -699,9 +699,9 @@ static const struct iw_handler_def	netwave_handler_def =
 /*
  * Function netwave_pcmcia_config (link)
  *
- *     netwave_pcmcia_config() is scheduled to run after a CARD_INSERTION 
+ *     netwave_pcmcia_config() is scheduled to run after a CARD_INSERTION
  *     event is received, to configure the PCMCIA socket, and to make the
- *     device available to the system. 
+ *     device available to the system.
  *
  */
 
@@ -759,7 +759,7 @@ static int netwave_pcmcia_config(struct pcmcia_device *link) {
     ret = pcmcia_request_window(link, &req, &link->win);
     if (ret)
 	    goto failed;
-    mem.CardOffset = 0x20000; mem.Page = 0; 
+    mem.CardOffset = 0x20000; mem.Page = 0;
     ret = pcmcia_map_mem_page(link, link->win, &mem);
     if (ret)
 	    goto failed;
@@ -784,7 +784,7 @@ static int netwave_pcmcia_config(struct pcmcia_device *link) {
     netwave_doreset(dev->base_addr, ramBase);
 
     /* Read the ethernet address and fill in the Netwave registers. */
-    for (i = 0; i < 6; i++) 
+    for (i = 0; i < 6; i++)
 	dev->dev_addr[i] = readb(ramBase + NETWAVE_EREG_PA + i);
 
     printk(KERN_INFO "%s: Netwave: port %#3lx, irq %d, mem %lx, "
@@ -796,7 +796,7 @@ static int netwave_pcmcia_config(struct pcmcia_device *link) {
 	   dev->dev_addr);
 
     /* get revision words */
-    printk(KERN_DEBUG "Netwave_reset: revision %04x %04x\n", 
+    printk(KERN_DEBUG "Netwave_reset: revision %04x %04x\n",
 	   get_uint16(ramBase + NETWAVE_EREG_ARW),
 	   get_uint16(ramBase + NETWAVE_EREG_ARW+2));
     return 0;
@@ -865,7 +865,7 @@ static void netwave_doreset(unsigned int ioBase, u_char __iomem *ramBase)
 /*
  * Function netwave_reset (dev)
  *
- *    Reset and restore all of the netwave registers 
+ *    Reset and restore all of the netwave registers
  */
 static void netwave_reset(struct net_device *dev) {
     /* u_char state; */
@@ -880,24 +880,24 @@ static void netwave_reset(struct net_device *dev) {
     /* Reset card */
     netwave_doreset(iobase, ramBase);
     printk(KERN_DEBUG "netwave_reset: Done with hardware reset\n");
-	
+
     /* Write a NOP to check the card */
     wait_WOC(iobase);
     writeb(NETWAVE_CMD_NOP, ramBase + NETWAVE_EREG_CB + 0);
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 1);
-	
+
     /* Set receive conf */
     wait_WOC(iobase);
     writeb(NETWAVE_CMD_SRC, ramBase + NETWAVE_EREG_CB + 0);
     writeb(rxConfRxEna + rxConfBcast, ramBase + NETWAVE_EREG_CB + 1);
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 2);
-    
+
     /* Set transmit conf */
     wait_WOC(iobase);
     writeb(NETWAVE_CMD_STC, ramBase + NETWAVE_EREG_CB + 0);
     writeb(txConfTxEna, ramBase + NETWAVE_EREG_CB + 1);
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 2);
-    
+
     /* Now set the MU Domain */
     printk(KERN_DEBUG "Setting domain to 0x%x%02x\n", (domain >> 8) & 0x01, domain & 0xff);
     wait_WOC(iobase);
@@ -905,7 +905,7 @@ static void netwave_reset(struct net_device *dev) {
     writeb(domain & 0xff, ramBase + NETWAVE_EREG_CB + 1);
     writeb((domain>>8) & 0x01, ramBase + NETWAVE_EREG_CB + 2);
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 3);
-	
+
     /* Set scramble key */
     printk(KERN_DEBUG "Setting scramble key to 0x%x\n", scramble_key);
     wait_WOC(iobase);
@@ -915,8 +915,8 @@ static void netwave_reset(struct net_device *dev) {
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 3);
 
     /* Enable interrupts, bit 4 high to keep unused
-     * source from interrupting us, bit 2 high to 
-     * set interrupt enable, 567 to enable TxDN, 
+     * source from interrupting us, bit 2 high to
+     * set interrupt enable, 567 to enable TxDN,
      * RxErr and RxRdy
      */
     wait_WOC(iobase);
@@ -927,29 +927,29 @@ static void netwave_reset(struct net_device *dev) {
      * skriv 80 til d000:3688
      * sjekk om det ble 80
      */
-    
+
     /* Enable Receiver */
     wait_WOC(iobase);
     writeb(NETWAVE_CMD_ER, ramBase + NETWAVE_EREG_CB + 0);
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 1);
-	
+
     /* Set the IENA bit in COR */
     wait_WOC(iobase);
     outb(corConfIENA + corConfLVLREQ, iobase + NETWAVE_REG_COR);
 }
 
 /*
- * Function netwave_hw_xmit (data, len, dev)    
+ * Function netwave_hw_xmit (data, len, dev)
  */
 static int netwave_hw_xmit(unsigned char* data, int len,
 			   struct net_device* dev) {
     unsigned long flags;
     unsigned int TxFreeList,
 	         curBuff,
-	         MaxData, 
+	         MaxData,
                  DataOffset;
-    int tmpcount; 
-	
+    int tmpcount;
+
     netwave_private *priv = netdev_priv(dev);
     u_char __iomem * ramBase = priv->ramBase;
     unsigned int iobase = dev->base_addr;
@@ -980,23 +980,23 @@ static int netwave_hw_xmit(unsigned char* data, int len,
     TxFreeList = get_uint16(ramBase + NETWAVE_EREG_TDP);
     MaxData    = get_uint16(ramBase + NETWAVE_EREG_TDP+2);
     DataOffset = get_uint16(ramBase + NETWAVE_EREG_TDP+4);
-	
+
     pr_debug("TxFreeList %x, MaxData %x, DataOffset %x\n",
 	  TxFreeList, MaxData, DataOffset);
 
     /* Copy packet to the adapter fragment buffers */
-    curBuff = TxFreeList; 
-    tmpcount = 0; 
+    curBuff = TxFreeList;
+    tmpcount = 0;
     while (tmpcount < len) {
-	int tmplen = len - tmpcount; 
-	copy_to_pc(ramBase + curBuff + DataOffset, data + tmpcount, 
+	int tmplen = len - tmpcount;
+	copy_to_pc(ramBase + curBuff + DataOffset, data + tmpcount,
 		   (tmplen < MaxData) ? tmplen : MaxData);
 	tmpcount += MaxData;
-			
+
 	/* Advance to next buffer */
 	curBuff = get_uint16(ramBase + curBuff);
     }
-    
+
     /* Now issue transmit list */
     wait_WOC(iobase);
     writeb(NETWAVE_CMD_TL, ramBase + NETWAVE_EREG_CB + 0);
@@ -1021,7 +1021,7 @@ static netdev_tx_t netwave_start_xmit(struct sk_buff *skb,
     {
 	short length = ETH_ZLEN < skb->len ? skb->len : ETH_ZLEN;
 	unsigned char* buf = skb->data;
-	
+
 	if (netwave_hw_xmit( buf, length, dev) == 1) {
 	    /* Some error, let's make them call us another time? */
 	    netif_start_queue(dev);
@@ -1029,7 +1029,7 @@ static netdev_tx_t netwave_start_xmit(struct sk_buff *skb,
 	dev->trans_start = jiffies;
     }
     dev_kfree_skb(skb);
-    
+
     return NETDEV_TX_OK;
 } /* netwave_start_xmit */
 
@@ -1037,7 +1037,7 @@ static netdev_tx_t netwave_start_xmit(struct sk_buff *skb,
  * Function netwave_interrupt (irq, dev_id)
  *
  *    This function is the interrupt handler for the Netwave card. This
- *    routine will be called whenever: 
+ *    routine will be called whenever:
  *	  1. A packet is received.
  *	  2. A packet has successfully been transferred and the unit is
  *	     ready to transmit another packet.
@@ -1051,29 +1051,29 @@ static irqreturn_t netwave_interrupt(int irq, void* dev_id)
     struct netwave_private *priv = netdev_priv(dev);
     struct pcmcia_device *link = priv->p_dev;
     int i;
-    
+
     if (!netif_device_present(dev))
 	return IRQ_NONE;
-    
+
     iobase = dev->base_addr;
     ramBase = priv->ramBase;
-	
+
     /* Now find what caused the interrupt, check while interrupts ready */
     for (i = 0; i < 10; i++) {
 	u_char status;
-		
-	wait_WOC(iobase);	
+
+	wait_WOC(iobase);
 	if (!(inb(iobase+NETWAVE_REG_CCSR) & 0x02))
 	    break; /* None of the interrupt sources asserted (normal exit) */
-	
+
         status = inb(iobase + NETWAVE_REG_ASR);
-		
+
 	if (!pcmcia_dev_present(link)) {
 	    pr_debug("netwave_interrupt: Interrupt with status 0x%x "
 		  "from removed or suspended card!\n", status);
 	    break;
 	}
-		
+
 	/* RxRdy */
 	if (status & 0x80) {
 	    netwave_rx(dev);
@@ -1083,24 +1083,24 @@ static irqreturn_t netwave_interrupt(int irq, void* dev_id)
 	/* RxErr */
 	if (status & 0x40) {
 	    u_char rser;
-			
-	    rser = readb(ramBase + NETWAVE_EREG_RSER);			
-	    
+
+	    rser = readb(ramBase + NETWAVE_EREG_RSER);
+
 	    if (rser & 0x04) {
 		++dev->stats.rx_dropped;
 		++dev->stats.rx_crc_errors;
 	    }
 	    if (rser & 0x02)
 		++dev->stats.rx_frame_errors;
-			
+
 	    /* Clear the RxErr bit in RSER. RSER+4 is the
-	     * write part. Also clear the RxCRC (0x04) and 
+	     * write part. Also clear the RxCRC (0x04) and
 	     * RxBig (0x02) bits if present */
 	    wait_WOC(iobase);
 	    writeb(0x40 | (rser & 0x06), ramBase + NETWAVE_EREG_RSER + 4);
 
 	    /* Write bit 6 high to ASCC to clear RxErr in ASR,
-	     * WOC must be set first! 
+	     * WOC must be set first!
 	     */
 	    wait_WOC(iobase);
 	    writeb(0x40, ramBase + NETWAVE_EREG_ASCC);
@@ -1115,31 +1115,31 @@ static irqreturn_t netwave_interrupt(int irq, void* dev_id)
 	    txStatus = readb(ramBase + NETWAVE_EREG_TSER);
 	    pr_debug("Transmit done. TSER = %x id %x\n",
 		  txStatus, readb(ramBase + NETWAVE_EREG_TSER + 1));
-	    
+
 	    if (txStatus & 0x20) {
 		/* Transmitting was okay, clear bits */
 		wait_WOC(iobase);
 		writeb(0x2f, ramBase + NETWAVE_EREG_TSER + 4);
 		++dev->stats.tx_packets;
 	    }
-			
+
 	    if (txStatus & 0xd0) {
 		if (txStatus & 0x80) {
 		    ++dev->stats.collisions; /* Because of /proc/net/dev*/
 		    /* ++dev->stats.tx_aborted_errors; */
 		    /* printk("Collision. %ld\n", jiffies - dev->trans_start); */
 		}
-		if (txStatus & 0x40) 
+		if (txStatus & 0x40)
 		    ++dev->stats.tx_carrier_errors;
 		/* 0x80 TxGU Transmit giveup - nine times and no luck
 		 * 0x40 TxNOAP No access point. Discarded packet.
-		 * 0x10 TxErr Transmit error. Always set when 
+		 * 0x10 TxErr Transmit error. Always set when
 		 *      TxGU and TxNOAP is set. (Those are the only ones
 		 *      to set TxErr).
 		 */
 		pr_debug("netwave_interrupt: TxDN with error status %x\n",
 		      txStatus);
-		
+
 		/* Clear out TxGU, TxNOAP, TxErr and TxTrys */
 		wait_WOC(iobase);
 		writeb(0xdf & txStatus, ramBase+NETWAVE_EREG_TSER+4);
@@ -1191,31 +1191,31 @@ static int netwave_rx(struct net_device *dev)
     int dataCount, dataOffset;
     int i;
     u_char *ptr;
-	
+
     pr_debug("xinw_rx: Receiving ... \n");
 
     /* Receive max 10 packets for now. */
     for (i = 0; i < 10; i++) {
 	/* Any packets? */
 	wait_WOC(iobase);
-	rxStatus = readb(ramBase + NETWAVE_EREG_RSER);		
+	rxStatus = readb(ramBase + NETWAVE_EREG_RSER);
 	if ( !( rxStatus & 0x80)) /* No more packets */
 	    break;
-		
+
 	/* Check if multicast/broadcast or other */
 	/* multicast = (rxStatus & 0x20);  */
-		
+
 	/* The receive list pointer and length of the packet */
 	wait_WOC(iobase);
 	rcvLen  = get_int16( ramBase + NETWAVE_EREG_RDP);
 	rcvList = get_uint16( ramBase + NETWAVE_EREG_RDP + 2);
-		
+
 	if (rcvLen < 0) {
-	    printk(KERN_DEBUG "netwave_rx: Receive packet with len %d\n", 
+	    printk(KERN_DEBUG "netwave_rx: Receive packet with len %d\n",
 		   rcvLen);
 	    return 0;
 	}
-		
+
 	skb = dev_alloc_skb(rcvLen+5);
 	if (skb == NULL) {
 	    pr_debug("netwave_rx: Could not allocate an sk_buff of "
@@ -1234,21 +1234,21 @@ static int netwave_rx(struct net_device *dev)
 	/* Copy packet fragments to the skb data area */
 	ptr = (u_char*) skb->data;
 	curBuffer = rcvList;
-	tmpcount = 0; 
+	tmpcount = 0;
 	while ( tmpcount < rcvLen) {
 	    /* Get length and offset of current buffer */
 	    dataCount  = get_uint16( ramBase+curBuffer+2);
 	    dataOffset = get_uint16( ramBase+curBuffer+4);
-		
+
 	    copy_from_pc( ptr + tmpcount,
 			  ramBase+curBuffer+dataOffset, dataCount);
 
 	    tmpcount += dataCount;
-		
+
 	    /* Point to next buffer */
 	    curBuffer = get_uint16(ramBase + curBuffer);
 	}
-	
+
 	skb->protocol = eth_type_trans(skb,dev);
 	/* Queue packet for network layer */
 	netif_rx(skb);
@@ -1270,7 +1270,7 @@ static int netwave_open(struct net_device *dev) {
     struct pcmcia_device *link = priv->p_dev;
 
     dev_dbg(&link->dev, "netwave_open: starting.\n");
-    
+
     if (!pcmcia_dev_present(link))
 	return -ENODEV;
 
@@ -1278,7 +1278,7 @@ static int netwave_open(struct net_device *dev) {
 
     netif_start_queue(dev);
     netwave_reset(dev);
-	
+
     return 0;
 }
 
@@ -1337,7 +1337,7 @@ static void set_multicast_list(struct net_device *dev)
     netwave_private *priv = netdev_priv(dev);
     u_char __iomem * ramBase = priv->ramBase;
     u_char  rcvMode = 0;
-   
+
 #ifdef PCMCIA_DEBUG
     {
 	xstatic int old;
@@ -1348,7 +1348,7 @@ static void set_multicast_list(struct net_device *dev)
 	}
     }
 #endif
-	
+
     if (!netdev_mc_empty(dev) || (dev->flags & IFF_ALLMULTI)) {
 	/* Multicast Mode */
 	rcvMode = rxConfRxEna + rxConfAMP + rxConfBcast;
@@ -1359,7 +1359,7 @@ static void set_multicast_list(struct net_device *dev)
 	/* Normal mode */
 	rcvMode = rxConfRxEna + rxConfBcast;
     }
-	
+
     /* printk("netwave set_multicast_list: rcvMode to %x\n", rcvMode);*/
     /* Now set receive mode */
     wait_WOC(iobase);
-- 
1.6.0.4

