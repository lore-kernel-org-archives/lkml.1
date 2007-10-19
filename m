Return-Path: <linux-kernel-owner+w=401wt.eu-S967032AbXJSH5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967032AbXJSH5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966814AbXJSH5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:57:32 -0400
Received: from havoc.gtf.org ([69.61.125.42]:34667 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967057AbXJSH5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:57:17 -0400
Date: Fri, 19 Oct 2007 03:57:15 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 5/9] irq-remove: net driver trivial
Message-ID: <20071019075715.GF6407@havoc.gtf.org>
References: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019075443.GA6407@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 93e93ce573545b3702477088cba8650b565fd60e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 00:47:56 2007 -0400

    [IRQ ARG REMOVAL] trivial net driver updates

 drivers/net/3c501.c                         |    3 +--
 drivers/net/3c501.h                         |    2 +-
 drivers/net/3c505.c                         |    2 +-
 drivers/net/3c507.c                         |    4 ++--
 drivers/net/3c509.c                         |    6 +++---
 drivers/net/3c515.c                         |    4 ++--
 drivers/net/3c523.c                         |    4 ++--
 drivers/net/3c527.c                         |    4 ++--
 drivers/net/3c59x.c                         |   14 +++++++-------
 drivers/net/7990.c                          |    4 ++--
 drivers/net/8139cp.c                        |    4 ++--
 drivers/net/8139too.c                       |    6 +++---
 drivers/net/82596.c                         |    6 +++---
 drivers/net/8390.c                          |    4 ++--
 drivers/net/8390.h                          |    2 +-
 drivers/net/a2065.c                         |    2 +-
 drivers/net/acenic.c                        |    2 +-
 drivers/net/acenic.h                        |    2 +-
 drivers/net/amd8111e.c                      |    4 ++--
 drivers/net/apne.c                          |    4 ++--
 drivers/net/appletalk/cops.c                |    4 ++--
 drivers/net/appletalk/ltpc.c                |    2 +-
 drivers/net/arcnet/arcnet.c                 |    2 +-
 drivers/net/ariadne.c                       |    4 ++--
 drivers/net/arm/am79c961a.c                 |    6 +++---
 drivers/net/arm/at91_ether.c                |    4 ++--
 drivers/net/arm/ep93xx_eth.c                |    2 +-
 drivers/net/arm/ether1.c                    |    4 ++--
 drivers/net/arm/ether3.c                    |    4 ++--
 drivers/net/at1700.c                        |    4 ++--
 drivers/net/atarilance.c                    |    4 ++--
 drivers/net/atl1/atl1_main.c                |    4 ++--
 drivers/net/atp.c                           |    4 ++--
 drivers/net/au1000_eth.c                    |    4 ++--
 drivers/net/b44.c                           |    4 ++--
 drivers/net/bmac.c                          |   12 ++++++------
 drivers/net/bnx2.c                          |    8 ++++----
 drivers/net/cassini.c                       |    8 ++++----
 drivers/net/chelsio/cxgb2.c                 |    2 +-
 drivers/net/chelsio/sge.c                   |    4 ++--
 drivers/net/chelsio/sge.h                   |    2 +-
 drivers/net/cris/eth_v10.c                  |    8 ++++----
 drivers/net/cs89x0.c                        |    6 +++---
 drivers/net/cxgb3/cxgb3_main.c              |    4 ++--
 drivers/net/cxgb3/sge.c                     |   14 +++++++-------
 drivers/net/de600.c                         |    2 +-
 drivers/net/de600.h                         |    2 +-
 drivers/net/de620.c                         |    4 ++--
 drivers/net/declance.c                      |    4 ++--
 drivers/net/defxx.c                         |    4 ++--
 drivers/net/depca.c                         |    4 ++--
 drivers/net/dl2k.c                          |    4 ++--
 drivers/net/dm9000.c                        |    6 +++---
 drivers/net/e100.c                          |    4 ++--
 drivers/net/e1000/e1000_ethtool.c           |    2 +-
 drivers/net/e1000/e1000_main.c              |   10 +++++-----
 drivers/net/e1000e/ethtool.c                |    2 +-
 drivers/net/eepro.c                         |    4 ++--
 drivers/net/eepro100.c                      |    6 +++---
 drivers/net/ehea/ehea_main.c                |    6 +++---
 drivers/net/epic100.c                       |    4 ++--
 drivers/net/eth16i.c                        |    4 ++--
 drivers/net/ewrk3.c                         |    4 ++--
 drivers/net/fealnx.c                        |    4 ++--
 drivers/net/fec.c                           |    8 ++++----
 drivers/net/fec_8xx/fec_main.c              |    4 ++--
 drivers/net/fs_enet/fs_enet-main.c          |    2 +-
 drivers/net/gianfar.c                       |   14 +++++++-------
 drivers/net/gianfar.h                       |    2 +-
 drivers/net/hamachi.c                       |    4 ++--
 drivers/net/hamradio/baycom_ser_fdx.c       |    2 +-
 drivers/net/hamradio/baycom_ser_hdx.c       |    2 +-
 drivers/net/hamradio/dmascc.c               |    4 ++--
 drivers/net/hamradio/yam.c                  |    2 +-
 drivers/net/hp100.c                         |    4 ++--
 drivers/net/ibm_emac/ibm_emac_core.c        |    4 ++--
 drivers/net/ibm_emac/ibm_emac_mal.c         |   10 +++++-----
 drivers/net/ibmlana.c                       |    2 +-
 drivers/net/ibmveth.c                       |    4 ++--
 drivers/net/ioc3-eth.c                      |    2 +-
 drivers/net/ipg.c                           |    2 +-
 drivers/net/irda/ali-ircc.c                 |    2 +-
 drivers/net/irda/donauboe.c                 |    4 ++--
 drivers/net/irda/irport.c                   |    4 ++--
 drivers/net/irda/irport.h                   |    2 +-
 drivers/net/irda/nsc-ircc.c                 |    2 +-
 drivers/net/irda/pxaficp_ir.c               |    4 ++--
 drivers/net/irda/sa1100_ir.c                |    2 +-
 drivers/net/irda/vlsi_ir.c                  |    2 +-
 drivers/net/irda/w83977af_ir.c              |    2 +-
 drivers/net/isa-skeleton.c                  |    4 ++--
 drivers/net/ixgb/ixgb_main.c                |    6 +++---
 drivers/net/ixgbe/ixgbe_main.c              |   12 ++++++------
 drivers/net/ixp2000/ixpdev.c                |    4 ++--
 drivers/net/lance.c                         |    4 ++--
 drivers/net/lguest_net.c                    |    2 +-
 drivers/net/lib8390.c                       |    4 ++--
 drivers/net/lp486e.c                        |    4 ++--
 drivers/net/mac89x0.c                       |    4 ++--
 drivers/net/mace.c                          |   12 ++++++------
 drivers/net/macmace.c                       |    8 ++++----
 drivers/net/meth.c                          |    4 ++--
 drivers/net/mipsnet.c                       |    2 +-
 drivers/net/mlx4/eq.c                       |    4 ++--
 drivers/net/mv643xx_eth.c                   |    4 ++--
 drivers/net/myri10ge/myri10ge.c             |    2 +-
 drivers/net/myri_sbus.c                     |    2 +-
 drivers/net/natsemi.c                       |    6 +++---
 drivers/net/netx-eth.c                      |    2 +-
 drivers/net/ni5010.c                        |    4 ++--
 drivers/net/ni52.c                          |    4 ++--
 drivers/net/ni65.c                          |    4 ++--
 drivers/net/niu.c                           |    2 +-
 drivers/net/ns83820.c                       |    2 +-
 drivers/net/pci-skeleton.c                  |    4 ++--
 drivers/net/pcmcia/3c574_cs.c               |    6 +++---
 drivers/net/pcmcia/3c589_cs.c               |    6 +++---
 drivers/net/pcmcia/axnet_cs.c               |   12 ++++++------
 drivers/net/pcmcia/nmclan_cs.c              |    4 ++--
 drivers/net/pcmcia/pcnet_cs.c               |    8 ++++----
 drivers/net/pcmcia/smc91c92_cs.c            |    6 +++---
 drivers/net/pcmcia/xirc2ps_cs.c             |    4 ++--
 drivers/net/pcnet32.c                       |    6 +++---
 drivers/net/qla3xxx.c                       |    2 +-
 drivers/net/r8169.c                         |    6 +++---
 drivers/net/rrunner.c                       |    2 +-
 drivers/net/rrunner.h                       |    2 +-
 drivers/net/s2io.c                          |    8 ++++----
 drivers/net/s2io.h                          |    6 +++---
 drivers/net/saa9730.c                       |    2 +-
 drivers/net/sb1000.c                        |    4 ++--
 drivers/net/sb1250-mac.c                    |    4 ++--
 drivers/net/sc92031.c                       |    4 ++--
 drivers/net/seeq8005.c                      |    4 ++--
 drivers/net/sgiseeq.c                       |    2 +-
 drivers/net/sis190.c                        |    4 ++--
 drivers/net/sis900.c                        |    6 +++---
 drivers/net/sk98lin/skge.c                  |   10 +++++-----
 drivers/net/skfp/skfddi.c                   |    4 ++--
 drivers/net/skge.c                          |    4 ++--
 drivers/net/sky2.c                          |    4 ++--
 drivers/net/smc-ultra.c                     |    2 +-
 drivers/net/smc911x.c                       |    4 ++--
 drivers/net/smc9194.c                       |    4 ++--
 drivers/net/smc91x.c                        |    4 ++--
 drivers/net/sonic.c                         |    2 +-
 drivers/net/sonic.h                         |    2 +-
 drivers/net/spider_net.c                    |    4 ++--
 drivers/net/starfire.c                      |    4 ++--
 drivers/net/sun3_82586.c                    |    4 ++--
 drivers/net/sun3lance.c                     |    4 ++--
 drivers/net/sunbmac.c                       |    2 +-
 drivers/net/sundance.c                      |    4 ++--
 drivers/net/sungem.c                        |    4 ++--
 drivers/net/sunhme.c                        |    2 +-
 drivers/net/sunlance.c                      |    2 +-
 drivers/net/sunqe.c                         |    2 +-
 drivers/net/tc35815.c                       |    4 ++--
 drivers/net/tehuti.c                        |    2 +-
 drivers/net/tg3.c                           |   14 ++++++--------
 drivers/net/tlan.c                          |    6 +++---
 drivers/net/tokenring/3c359.c               |    4 ++--
 drivers/net/tokenring/ibmtr.c               |    4 ++--
 drivers/net/tokenring/lanstreamer.c         |    4 ++--
 drivers/net/tokenring/madgemc.c             |    6 +++---
 drivers/net/tokenring/olympic.c             |    4 ++--
 drivers/net/tokenring/smctr.c               |    4 ++--
 drivers/net/tokenring/tms380tr.c            |    2 +-
 drivers/net/tokenring/tms380tr.h            |    2 +-
 drivers/net/tulip/de2104x.c                 |    2 +-
 drivers/net/tulip/de4x5.c                   |    4 ++--
 drivers/net/tulip/dmfe.c                    |    6 +++---
 drivers/net/tulip/interrupt.c               |    2 +-
 drivers/net/tulip/tulip.h                   |    2 +-
 drivers/net/tulip/tulip_core.c              |    2 +-
 drivers/net/tulip/uli526x.c                 |    4 ++--
 drivers/net/tulip/winbond-840.c             |    4 ++--
 drivers/net/tulip/xircom_cb.c               |    6 +++---
 drivers/net/tulip/xircom_tulip_cb.c         |    4 ++--
 drivers/net/typhoon.c                       |    2 +-
 drivers/net/via-rhine.c                     |    6 +++---
 drivers/net/via-velocity.c                  |    4 ++--
 drivers/net/wan/cosa.c                      |    4 ++--
 drivers/net/wan/cycx_main.c                 |    4 ++--
 drivers/net/wan/dscc4.c                     |    4 ++--
 drivers/net/wan/farsync.c                   |    2 +-
 drivers/net/wan/hd6457x.c                   |    2 +-
 drivers/net/wan/lmc/lmc_main.c              |    4 ++--
 drivers/net/wan/pc300_drv.c                 |    4 ++--
 drivers/net/wan/sbni.c                      |    4 ++--
 drivers/net/wan/wanxl.c                     |    2 +-
 drivers/net/wan/z85230.c                    |    2 +-
 drivers/net/wan/z85230.h                    |    2 +-
 drivers/net/wireless/adm8211.c              |    2 +-
 drivers/net/wireless/airo.c                 |    4 ++--
 drivers/net/wireless/arlan-main.c           |    4 ++--
 drivers/net/wireless/atmel.c                |    2 +-
 drivers/net/wireless/b43/main.c             |    2 +-
 drivers/net/wireless/b43legacy/main.c       |    2 +-
 drivers/net/wireless/bcm43xx/bcm43xx_main.c |    4 ++--
 drivers/net/wireless/hostap/hostap_hw.c     |    2 +-
 drivers/net/wireless/ipw2100.c              |    2 +-
 drivers/net/wireless/ipw2200.c              |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 drivers/net/wireless/libertas/if_cs.c       |    4 ++--
 drivers/net/wireless/netwave_cs.c           |    4 ++--
 drivers/net/wireless/orinoco.c              |    2 +-
 drivers/net/wireless/orinoco.h              |    2 +-
 drivers/net/wireless/p54pci.c               |    4 ++--
 drivers/net/wireless/prism54/islpci_dev.c   |    2 +-
 drivers/net/wireless/prism54/islpci_dev.h   |    2 +-
 drivers/net/wireless/ray_cs.c               |    4 ++--
 drivers/net/wireless/rt2x00/rt2400pci.c     |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c     |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c       |    2 +-
 drivers/net/wireless/wavelan.c              |    2 +-
 drivers/net/wireless/wavelan.p.h            |    3 +--
 drivers/net/wireless/wavelan_cs.c           |    3 +--
 drivers/net/wireless/wavelan_cs.p.h         |    3 +--
 drivers/net/wireless/wl3501_cs.c            |    3 +--
 drivers/net/xen-netfront.c                  |    2 +-
 drivers/net/yellowfin.c                     |    4 ++--
 drivers/net/znet.c                          |    4 ++--
 224 files changed, 444 insertions(+), 451 deletions(-)

93e93ce573545b3702477088cba8650b565fd60e
diff --git a/drivers/net/3c501.c b/drivers/net/3c501.c
index be71868..e4aeca5 100644
--- a/drivers/net/3c501.c
+++ b/drivers/net/3c501.c
@@ -491,7 +491,6 @@ static int el_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 /**
  * el_interrupt:
- * @irq: Interrupt number
  * @dev_id: The 3c501 that burped
  *
  * Handle the ether interface interrupts. The 3c501 needs a lot more
@@ -511,7 +510,7 @@ static int el_start_xmit(struct sk_buff *skb, struct net_device *dev)
  * TCP window.
  */
 
-static irqreturn_t el_interrupt(int irq, void *dev_id)
+static irqreturn_t el_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct net_local *lp;
diff --git a/drivers/net/3c501.h b/drivers/net/3c501.h
index cfec64e..a0e874a 100644
--- a/drivers/net/3c501.h
+++ b/drivers/net/3c501.h
@@ -7,7 +7,7 @@ static int  el1_probe1(struct net_device *dev, int ioaddr);
 static int  el_open(struct net_device *dev);
 static void el_timeout(struct net_device *dev);
 static int  el_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t el_interrupt(int irq, void *dev_id);
+static irqreturn_t el_interrupt(void *dev_id);
 static void el_receive(struct net_device *dev);
 static void el_reset(struct net_device *dev);
 static int  el1_close(struct net_device *dev);
diff --git a/drivers/net/3c505.c b/drivers/net/3c505.c
index 9c65734..d988da0 100644
--- a/drivers/net/3c505.c
+++ b/drivers/net/3c505.c
@@ -633,7 +633,7 @@ static void receive_packet(struct net_device *dev, int len)
  *
  ******************************************************/
 
-static irqreturn_t elp_interrupt(int irq, void *dev_id)
+static irqreturn_t elp_interrupt(void *dev_id)
 {
 	int len;
 	int dlen;
diff --git a/drivers/net/3c507.c b/drivers/net/3c507.c
index 964d31a..2a5579a 100644
--- a/drivers/net/3c507.c
+++ b/drivers/net/3c507.c
@@ -285,7 +285,7 @@ static unsigned short init_words[] = {
 static int	el16_probe1(struct net_device *dev, int ioaddr);
 static int	el16_open(struct net_device *dev);
 static int	el16_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t el16_interrupt(int irq, void *dev_id);
+static irqreturn_t el16_interrupt(void *dev_id);
 static void el16_rx(struct net_device *dev);
 static int	el16_close(struct net_device *dev);
 static void el16_tx_timeout (struct net_device *dev);
@@ -538,7 +538,7 @@ static int el16_send_packet (struct sk_buff *skb, struct net_device *dev)
 
 /*	The typical workload of the driver:
 	Handle the network interface interrupts. */
-static irqreturn_t el16_interrupt(int irq, void *dev_id)
+static irqreturn_t el16_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct net_local *lp;
diff --git a/drivers/net/3c509.c b/drivers/net/3c509.c
index edda6e1..259a594 100644
--- a/drivers/net/3c509.c
+++ b/drivers/net/3c509.c
@@ -189,7 +189,7 @@ static ushort id_read_eeprom(int index);
 static ushort read_eeprom(int ioaddr, int index);
 static int el3_open(struct net_device *dev);
 static int el3_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t el3_interrupt(int irq, void *dev_id);
+static irqreturn_t el3_interrupt(void *dev_id);
 static void update_stats(struct net_device *dev);
 static struct net_device_stats *el3_get_stats(struct net_device *dev);
 static int el3_rx(struct net_device *dev);
@@ -896,7 +896,7 @@ el3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 /* The EL3 interrupt handler. */
 static irqreturn_t
-el3_interrupt(int irq, void *dev_id)
+el3_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct el3_private *lp;
@@ -987,7 +987,7 @@ el3_interrupt(int irq, void *dev_id)
 static void el3_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	el3_interrupt(dev->irq, dev);
+	el3_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/3c515.c b/drivers/net/3c515.c
index 275e751..19c0232 100644
--- a/drivers/net/3c515.c
+++ b/drivers/net/3c515.c
@@ -373,7 +373,7 @@ static int corkscrew_start_xmit(struct sk_buff *skb,
 static int corkscrew_rx(struct net_device *dev);
 static void corkscrew_timeout(struct net_device *dev);
 static int boomerang_rx(struct net_device *dev);
-static irqreturn_t corkscrew_interrupt(int irq, void *dev_id);
+static irqreturn_t corkscrew_interrupt(void *dev_id);
 static int corkscrew_close(struct net_device *dev);
 static void update_stats(int addr, struct net_device *dev);
 static struct net_device_stats *corkscrew_get_stats(struct net_device *dev);
@@ -1113,7 +1113,7 @@ static int corkscrew_start_xmit(struct sk_buff *skb,
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
 
-static irqreturn_t corkscrew_interrupt(int irq, void *dev_id)
+static irqreturn_t corkscrew_interrupt(void *dev_id)
 {
 	/* Use the now-standard shared IRQ implementation. */
 	struct net_device *dev = dev_id;
diff --git a/drivers/net/3c523.c b/drivers/net/3c523.c
index 239fc42..80768bb 100644
--- a/drivers/net/3c523.c
+++ b/drivers/net/3c523.c
@@ -180,7 +180,7 @@ sizeof(nop_cmd) = 8;
       	dev->name,__LINE__); \
       elmc_id_reset586(); } } }
 
-static irqreturn_t elmc_interrupt(int irq, void *dev_id);
+static irqreturn_t elmc_interrupt(void *dev_id);
 static int elmc_open(struct net_device *dev);
 static int elmc_close(struct net_device *dev);
 static int elmc_send_packet(struct sk_buff *, struct net_device *);
@@ -895,7 +895,7 @@ static void *alloc_rfa(struct net_device *dev, void *ptr)
  */
 
 static irqreturn_t
-elmc_interrupt(int irq, void *dev_id)
+elmc_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	unsigned short stat;
diff --git a/drivers/net/3c527.c b/drivers/net/3c527.c
index b72b89d..22c57ac 100644
--- a/drivers/net/3c527.c
+++ b/drivers/net/3c527.c
@@ -217,7 +217,7 @@ static int      mc32_command(struct net_device *dev, u16 cmd, void *data, int le
 static int	mc32_open(struct net_device *dev);
 static void	mc32_timeout(struct net_device *dev);
 static int	mc32_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t mc32_interrupt(int irq, void *dev_id);
+static irqreturn_t mc32_interrupt(void *dev_id);
 static int	mc32_close(struct net_device *dev);
 static struct	net_device_stats *mc32_get_stats(struct net_device *dev);
 static void	mc32_set_multicast_list(struct net_device *dev);
@@ -1314,7 +1314,7 @@ static void mc32_tx_ring(struct net_device *dev)
  *
  */
 
-static irqreturn_t mc32_interrupt(int irq, void *dev_id)
+static irqreturn_t mc32_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct mc32_local *lp;
diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index 862f472..dd6ae9d 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -717,8 +717,8 @@ static int vortex_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int boomerang_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int vortex_rx(struct net_device *dev);
 static int boomerang_rx(struct net_device *dev);
-static irqreturn_t vortex_interrupt(int irq, void *dev_id);
-static irqreturn_t boomerang_interrupt(int irq, void *dev_id);
+static irqreturn_t vortex_interrupt(void *dev_id);
+static irqreturn_t boomerang_interrupt(void *dev_id);
 static int vortex_close(struct net_device *dev);
 static void dump_tx_ring(struct net_device *dev);
 static void update_stats(void __iomem *ioaddr, struct net_device *dev);
@@ -793,7 +793,7 @@ static void poll_vortex(struct net_device *dev)
 	struct vortex_private *vp = netdev_priv(dev);
 	unsigned long flags;
 	local_irq_save(flags);
-	(vp->full_bus_master_rx ? boomerang_interrupt:vortex_interrupt)(dev->irq,dev);
+	(vp->full_bus_master_rx ? boomerang_interrupt:vortex_interrupt)(dev);
 	local_irq_restore(flags);
 }
 #endif
@@ -1863,9 +1863,9 @@ static void vortex_tx_timeout(struct net_device *dev)
 			unsigned long flags;
 			local_irq_save(flags);
 			if (vp->full_bus_master_tx)
-				boomerang_interrupt(dev->irq, dev);
+				boomerang_interrupt(dev);
 			else
-				vortex_interrupt(dev->irq, dev);
+				vortex_interrupt(dev);
 			local_irq_restore(flags);
 		}
 	}
@@ -2163,7 +2163,7 @@ boomerang_start_xmit(struct sk_buff *skb, struct net_device *dev)
  */
 
 static irqreturn_t
-vortex_interrupt(int irq, void *dev_id)
+vortex_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct vortex_private *vp = netdev_priv(dev);
@@ -2268,7 +2268,7 @@ handler_exit:
  */
 
 static irqreturn_t
-boomerang_interrupt(int irq, void *dev_id)
+boomerang_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct vortex_private *vp = netdev_priv(dev);
diff --git a/drivers/net/7990.c b/drivers/net/7990.c
index 224e0bf..0940a0c 100644
--- a/drivers/net/7990.c
+++ b/drivers/net/7990.c
@@ -437,7 +437,7 @@ static int lance_tx (struct net_device *dev)
 }
 
 static irqreturn_t
-lance_interrupt (int irq, void *dev_id)
+lance_interrupt (void *dev_id)
 {
         struct net_device *dev = (struct net_device *)dev_id;
         struct lance_private *lp = netdev_priv(dev);
@@ -666,7 +666,7 @@ void lance_poll(struct net_device *dev)
 	WRITERAP(lp, LE_CSR0);
 	WRITERDP(lp, LE_C0_STRT);
 	spin_unlock (&lp->devlock);
-	lance_interrupt(dev->irq, dev);
+	lance_interrupt(dev);
 }
 #endif
 
diff --git a/drivers/net/8139cp.c b/drivers/net/8139cp.c
index a453eda..b8d3b1f 100644
--- a/drivers/net/8139cp.c
+++ b/drivers/net/8139cp.c
@@ -614,7 +614,7 @@ rx_next:
 	return rx;
 }
 
-static irqreturn_t cp_interrupt (int irq, void *dev_instance)
+static irqreturn_t cp_interrupt (void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct cp_private *cp;
@@ -678,7 +678,7 @@ static irqreturn_t cp_interrupt (int irq, void *dev_instance)
 static void cp_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	cp_interrupt(dev->irq, dev);
+	cp_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
index 973b684..26a2ba3 100644
--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -638,7 +638,7 @@ static int rtl8139_start_xmit (struct sk_buff *skb,
 static void rtl8139_poll_controller(struct net_device *dev);
 #endif
 static int rtl8139_poll(struct napi_struct *napi, int budget);
-static irqreturn_t rtl8139_interrupt (int irq, void *dev_instance);
+static irqreturn_t rtl8139_interrupt (void *dev_instance);
 static int rtl8139_close (struct net_device *dev);
 static int netdev_ioctl (struct net_device *dev, struct ifreq *rq, int cmd);
 static struct net_device_stats *rtl8139_get_stats (struct net_device *dev);
@@ -2128,7 +2128,7 @@ static int rtl8139_poll(struct napi_struct *napi, int budget)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-static irqreturn_t rtl8139_interrupt (int irq, void *dev_instance)
+static irqreturn_t rtl8139_interrupt (void *dev_instance)
 {
 	struct net_device *dev = (struct net_device *) dev_instance;
 	struct rtl8139_private *tp = netdev_priv(dev);
@@ -2200,7 +2200,7 @@ static irqreturn_t rtl8139_interrupt (int irq, void *dev_instance)
 static void rtl8139_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	rtl8139_interrupt(dev->irq, dev);
+	rtl8139_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/82596.c b/drivers/net/82596.c
index bb30d5b..61d2598 100644
--- a/drivers/net/82596.c
+++ b/drivers/net/82596.c
@@ -357,7 +357,7 @@ static char init_setup[] =
 
 static int i596_open(struct net_device *dev);
 static int i596_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t i596_interrupt(int irq, void *dev_id);
+static irqreturn_t i596_interrupt(void *dev_id);
 static int i596_close(struct net_device *dev);
 static void i596_add_cmd(struct net_device *dev, struct i596_cmd *cmd);
 static void i596_tx_timeout (struct net_device *dev);
@@ -500,7 +500,7 @@ static void i596_display_data(struct net_device *dev)
 
 
 #if defined(ENABLE_MVME16x_NET) || defined(ENABLE_BVME6000_NET)
-static irqreturn_t i596_error(int irq, void *dev_id)
+static irqreturn_t i596_error(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 #ifdef ENABLE_MVME16x_NET
@@ -1277,7 +1277,7 @@ out:
 	return ERR_PTR(err);
 }
 
-static irqreturn_t i596_interrupt(int irq, void *dev_id)
+static irqreturn_t i596_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct i596_private *lp;
diff --git a/drivers/net/8390.c b/drivers/net/8390.c
index a828076..f2e6405 100644
--- a/drivers/net/8390.c
+++ b/drivers/net/8390.c
@@ -15,9 +15,9 @@ int ei_close(struct net_device *dev)
 	return __ei_close(dev);
 }
 
-irqreturn_t ei_interrupt(int irq, void *dev_id)
+irqreturn_t ei_interrupt(void *dev_id)
 {
-	return __ei_interrupt(irq, dev_id);
+	return __ei_interrupt(dev_id);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/8390.h b/drivers/net/8390.h
index 04ddec0..afff8ad 100644
--- a/drivers/net/8390.h
+++ b/drivers/net/8390.h
@@ -35,7 +35,7 @@ extern void ei_poll(struct net_device *dev);
 extern void NS8390_init(struct net_device *dev, int startp);
 extern int ei_open(struct net_device *dev);
 extern int ei_close(struct net_device *dev);
-extern irqreturn_t ei_interrupt(int irq, void *dev_id);
+extern irqreturn_t ei_interrupt(void *dev_id);
 extern struct net_device *__alloc_ei_netdev(int size);
 static inline struct net_device *alloc_ei_netdev(void)
 {
diff --git a/drivers/net/a2065.c b/drivers/net/a2065.c
index 18f7f81..c4d04db 100644
--- a/drivers/net/a2065.c
+++ b/drivers/net/a2065.c
@@ -423,7 +423,7 @@ static int lance_tx (struct net_device *dev)
 	return 0;
 }
 
-static irqreturn_t lance_interrupt (int irq, void *dev_id)
+static irqreturn_t lance_interrupt (void *dev_id)
 {
 	struct net_device *dev;
 	struct lance_private *lp;
diff --git a/drivers/net/acenic.c b/drivers/net/acenic.c
index 6c19265..7ace7cd 100644
--- a/drivers/net/acenic.c
+++ b/drivers/net/acenic.c
@@ -2135,7 +2135,7 @@ static inline void ace_tx_int(struct net_device *dev,
 }
 
 
-static irqreturn_t ace_interrupt(int irq, void *dev_id)
+static irqreturn_t ace_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct ace_private *ap = netdev_priv(dev);
diff --git a/drivers/net/acenic.h b/drivers/net/acenic.h
index 60ed183..de6c5c3 100644
--- a/drivers/net/acenic.h
+++ b/drivers/net/acenic.h
@@ -769,7 +769,7 @@ static int ace_init(struct net_device *dev);
 static void ace_load_std_rx_ring(struct ace_private *ap, int nr_bufs);
 static void ace_load_mini_rx_ring(struct ace_private *ap, int nr_bufs);
 static void ace_load_jumbo_rx_ring(struct ace_private *ap, int nr_bufs);
-static irqreturn_t ace_interrupt(int irq, void *dev_id);
+static irqreturn_t ace_interrupt(void *dev_id);
 static int ace_load_firmware(struct net_device *dev);
 static int ace_open(struct net_device *dev);
 static int ace_start_xmit(struct sk_buff *skb, struct net_device *dev);
diff --git a/drivers/net/amd8111e.c b/drivers/net/amd8111e.c
index 1cc74ec..ca133d6 100644
--- a/drivers/net/amd8111e.c
+++ b/drivers/net/amd8111e.c
@@ -1248,7 +1248,7 @@ static int amd8111e_calc_coalesce(struct net_device *dev)
 /*
 This is device interrupt function. It handles transmit, receive,link change and hardware timer interrupts.
 */
-static irqreturn_t amd8111e_interrupt(int irq, void *dev_id)
+static irqreturn_t amd8111e_interrupt(void *dev_id)
 {
 
 	struct net_device * dev = (struct net_device *) dev_id;
@@ -1326,7 +1326,7 @@ static void amd8111e_poll(struct net_device *dev)
 {
 	unsigned long flags;
 	local_irq_save(flags);
-	amd8111e_interrupt(0, dev);
+	amd8111e_interrupt(dev);
 	local_irq_restore(flags);
 }
 #endif
diff --git a/drivers/net/apne.c b/drivers/net/apne.c
index c12cbdf..ad3a084 100644
--- a/drivers/net/apne.c
+++ b/drivers/net/apne.c
@@ -88,7 +88,7 @@ static void apne_block_input(struct net_device *dev, int count,
 								struct sk_buff *skb, int ring_offset);
 static void apne_block_output(struct net_device *dev, const int count,
 							const unsigned char *buf, const int start_page);
-static irqreturn_t apne_interrupt(int irq, void *dev_id);
+static irqreturn_t apne_interrupt(void *dev_id);
 
 static int init_pcmcia(void);
 
@@ -544,7 +544,7 @@ apne_block_output(struct net_device *dev, int count,
     return;
 }
 
-static irqreturn_t apne_interrupt(int irq, void *dev_id)
+static irqreturn_t apne_interrupt(void *dev_id)
 {
     unsigned char pcmcia_intreq;
 
diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index 92c3a4c..f7839cd 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -188,7 +188,7 @@ static void cops_reset (struct net_device *dev, int sleep);
 static void cops_load (struct net_device *dev);
 static int  cops_nodeid (struct net_device *dev, int nodeid);
 
-static irqreturn_t cops_interrupt (int irq, void *dev_id);
+static irqreturn_t cops_interrupt (void *dev_id);
 static void cops_poll (unsigned long ltdev);
 static void cops_timeout(struct net_device *dev);
 static void cops_rx (struct net_device *dev);
@@ -714,7 +714,7 @@ static void cops_poll(unsigned long ltdev)
  *      The typical workload of the driver:
  *      Handle the network interface interrupts.
  */
-static irqreturn_t cops_interrupt(int irq, void *dev_id)
+static irqreturn_t cops_interrupt(void *dev_id)
 {
         struct net_device *dev = dev_id;
         struct cops_local *lp;
diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index 6ab2c2d..f45ed88 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -790,7 +790,7 @@ static int sendup_buffer (struct net_device *dev)
 /* the handler for the board interrupt */
  
 static irqreturn_t
-ltpc_interrupt(int irq, void *dev_id)
+ltpc_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 
diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index c59c806..f6b35cc 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -761,7 +761,7 @@ static void arcnet_timeout(struct net_device *dev)
  * interrupts. Establish which device needs attention, and call the correct
  * chipset interrupt handler.
  */
-irqreturn_t arcnet_interrupt(int irq, void *dev_id)
+irqreturn_t arcnet_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct arcnet_local *lp;
diff --git a/drivers/net/ariadne.c b/drivers/net/ariadne.c
index 3fa3bcc..8cfacec 100644
--- a/drivers/net/ariadne.c
+++ b/drivers/net/ariadne.c
@@ -120,7 +120,7 @@ static int ariadne_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static void ariadne_tx_timeout(struct net_device *dev);
 static int ariadne_rx(struct net_device *dev);
 static void ariadne_reset(struct net_device *dev);
-static irqreturn_t ariadne_interrupt(int irq, void *data);
+static irqreturn_t ariadne_interrupt(void *data);
 static int ariadne_close(struct net_device *dev);
 static struct net_device_stats *ariadne_get_stats(struct net_device *dev);
 #ifdef HAVE_MULTICAST
@@ -415,7 +415,7 @@ static inline void ariadne_reset(struct net_device *dev)
 }
 
 
-static irqreturn_t ariadne_interrupt(int irq, void *data)
+static irqreturn_t ariadne_interrupt(void *data)
 {
     struct net_device *dev = (struct net_device *)data;
     volatile struct Am79C960 *lance = (struct Am79C960*)dev->base_addr;
diff --git a/drivers/net/arm/am79c961a.c b/drivers/net/arm/am79c961a.c
index ba6bd03..98522b7 100644
--- a/drivers/net/arm/am79c961a.c
+++ b/drivers/net/arm/am79c961a.c
@@ -38,7 +38,7 @@
 #include "am79c961a.h"
 
 static irqreturn_t
-am79c961_interrupt (int irq, void *dev_id);
+am79c961_interrupt (void *dev_id);
 
 static unsigned int net_debug = NET_DEBUG;
 
@@ -595,7 +595,7 @@ am79c961_tx(struct net_device *dev, struct dev_priv *priv)
 }
 
 static irqreturn_t
-am79c961_interrupt(int irq, void *dev_id)
+am79c961_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct dev_priv *priv = netdev_priv(dev);
@@ -634,7 +634,7 @@ static void am79c961_poll_controller(struct net_device *dev)
 {
 	unsigned long flags;
 	local_irq_save(flags);
-	am79c961_interrupt(dev->irq, dev);
+	am79c961_interrupt(dev);
 	local_irq_restore(flags);
 }
 #endif
diff --git a/drivers/net/arm/at91_ether.c b/drivers/net/arm/at91_ether.c
index 25b114a..15d06bf 100644
--- a/drivers/net/arm/at91_ether.c
+++ b/drivers/net/arm/at91_ether.c
@@ -193,7 +193,7 @@ static void update_linkspeed(struct net_device *dev, int silent)
 /*
  * Handle interrupts from the PHY
  */
-static irqreturn_t at91ether_phy_interrupt(int irq, void *dev_id)
+static irqreturn_t at91ether_phy_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct at91_private *lp = netdev_priv(dev);
@@ -918,7 +918,7 @@ static void at91ether_rx(struct net_device *dev)
 /*
  * MAC interrupt handler
  */
-static irqreturn_t at91ether_interrupt(int irq, void *dev_id)
+static irqreturn_t at91ether_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct at91_private *lp = netdev_priv(dev);
diff --git a/drivers/net/arm/ep93xx_eth.c b/drivers/net/arm/ep93xx_eth.c
index 7f016f3..997347e 100644
--- a/drivers/net/arm/ep93xx_eth.c
+++ b/drivers/net/arm/ep93xx_eth.c
@@ -405,7 +405,7 @@ static void ep93xx_tx_complete(struct net_device *dev)
 		netif_wake_queue(dev);
 }
 
-static irqreturn_t ep93xx_irq(int irq, void *dev_id)
+static irqreturn_t ep93xx_irq(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct ep93xx_priv *ep = netdev_priv(dev);
diff --git a/drivers/net/arm/ether1.c b/drivers/net/arm/ether1.c
index 3bb9e29..1f1fd1c 100644
--- a/drivers/net/arm/ether1.c
+++ b/drivers/net/arm/ether1.c
@@ -66,7 +66,7 @@ static unsigned int net_debug = NET_DEBUG;
 
 static int ether1_open(struct net_device *dev);
 static int ether1_sendpacket(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t ether1_interrupt(int irq, void *dev_id);
+static irqreturn_t ether1_interrupt(void *dev_id);
 static int ether1_close(struct net_device *dev);
 static struct net_device_stats *ether1_getstats(struct net_device *dev);
 static void ether1_setmulticastlist(struct net_device *dev);
@@ -905,7 +905,7 @@ ether1_recv_done (struct net_device *dev)
 }
 
 static irqreturn_t
-ether1_interrupt (int irq, void *dev_id)
+ether1_interrupt (void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	int status;
diff --git a/drivers/net/arm/ether3.c b/drivers/net/arm/ether3.c
index 67e96ae..7cd39e2 100644
--- a/drivers/net/arm/ether3.c
+++ b/drivers/net/arm/ether3.c
@@ -79,7 +79,7 @@ static int	ether3_rx(struct net_device *dev, unsigned int maxcnt);
 static void	ether3_tx(struct net_device *dev);
 static int	ether3_open (struct net_device *dev);
 static int	ether3_sendpacket (struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t ether3_interrupt (int irq, void *dev_id);
+static irqreturn_t ether3_interrupt (void *dev_id);
 static int	ether3_close (struct net_device *dev);
 static struct net_device_stats *ether3_getstats (struct net_device *dev);
 static void	ether3_setmulticastlist (struct net_device *dev);
@@ -566,7 +566,7 @@ ether3_sendpacket(struct sk_buff *skb, struct net_device *dev)
 }
 
 static irqreturn_t
-ether3_interrupt(int irq, void *dev_id)
+ether3_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	unsigned int status, handled = IRQ_NONE;
diff --git a/drivers/net/at1700.c b/drivers/net/at1700.c
index b032c1b..af41130 100644
--- a/drivers/net/at1700.c
+++ b/drivers/net/at1700.c
@@ -160,7 +160,7 @@ static int at1700_probe1(struct net_device *dev, int ioaddr);
 static int read_eeprom(long ioaddr, int location);
 static int net_open(struct net_device *dev);
 static int	net_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t net_interrupt(int irq, void *dev_id);
+static irqreturn_t net_interrupt(void *dev_id);
 static void net_rx(struct net_device *dev);
 static int net_close(struct net_device *dev);
 static void set_rx_mode(struct net_device *dev);
@@ -643,7 +643,7 @@ static int net_send_packet (struct sk_buff *skb, struct net_device *dev)
 
 /* The typical workload of the driver:
    Handle the network interface interrupts. */
-static irqreturn_t net_interrupt(int irq, void *dev_id)
+static irqreturn_t net_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct net_local *lp;
diff --git a/drivers/net/atarilance.c b/drivers/net/atarilance.c
index b74dbee..f02556a 100644
--- a/drivers/net/atarilance.c
+++ b/drivers/net/atarilance.c
@@ -343,7 +343,7 @@ static unsigned long lance_probe1( struct net_device *dev, struct lance_addr
 static int lance_open( struct net_device *dev );
 static void lance_init_ring( struct net_device *dev );
 static int lance_start_xmit( struct sk_buff *skb, struct net_device *dev );
-static irqreturn_t lance_interrupt( int irq, void *dev_id );
+static irqreturn_t lance_interrupt( void *dev_id );
 static int lance_rx( struct net_device *dev );
 static int lance_close( struct net_device *dev );
 static void set_multicast_list( struct net_device *dev );
@@ -853,7 +853,7 @@ static int lance_start_xmit( struct sk_buff *skb, struct net_device *dev )
 
 /* The LANCE interrupt handler. */
 
-static irqreturn_t lance_interrupt( int irq, void *dev_id )
+static irqreturn_t lance_interrupt( void *dev_id )
 {
 	struct net_device *dev = dev_id;
 	struct lance_private *lp;
diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index 35b0a7d..30c5366 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -1761,7 +1761,7 @@ static int atl1_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
  * @data: pointer to a network interface device structure
  * @pt_regs: CPU registers structure
  */
-static irqreturn_t atl1_intr(int irq, void *data)
+static irqreturn_t atl1_intr(void *data)
 {
 	struct atl1_adapter *adapter = netdev_priv(data);
 	u32 status;
@@ -2181,7 +2181,7 @@ static int atl1_resume(struct pci_dev *pdev)
 static void atl1_poll_controller(struct net_device *netdev)
 {
 	disable_irq(netdev->irq);
-	atl1_intr(netdev->irq, netdev);
+	atl1_intr(netdev);
 	enable_irq(netdev->irq);
 }
 #endif
diff --git a/drivers/net/atp.c b/drivers/net/atp.c
index 62f09e5..dcf5c4b 100644
--- a/drivers/net/atp.c
+++ b/drivers/net/atp.c
@@ -200,7 +200,7 @@ static void hardware_init(struct net_device *dev);
 static void write_packet(long ioaddr, int length, unsigned char *packet, int pad, int mode);
 static void trigger_send(long ioaddr, int length);
 static int	atp_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t atp_interrupt(int irq, void *dev_id);
+static irqreturn_t atp_interrupt(void *dev_id);
 static void net_rx(struct net_device *dev);
 static void read_block(long ioaddr, int length, unsigned char *buffer, int data_mode);
 static int net_close(struct net_device *dev);
@@ -589,7 +589,7 @@ static int atp_send_packet(struct sk_buff *skb, struct net_device *dev)
 
 /* The typical workload of the driver:
    Handle the network interface interrupts. */
-static irqreturn_t atp_interrupt(int irq, void *dev_instance)
+static irqreturn_t atp_interrupt(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct net_local *lp;
diff --git a/drivers/net/au1000_eth.c b/drivers/net/au1000_eth.c
index 185f98e..0c703cf 100644
--- a/drivers/net/au1000_eth.c
+++ b/drivers/net/au1000_eth.c
@@ -90,7 +90,7 @@ static int au1000_open(struct net_device *);
 static int au1000_close(struct net_device *);
 static int au1000_tx(struct sk_buff *, struct net_device *);
 static int au1000_rx(struct net_device *);
-static irqreturn_t au1000_interrupt(int, void *);
+static irqreturn_t au1000_interrupt(void *);
 static void au1000_tx_timeout(struct net_device *);
 static void set_rx_mode(struct net_device *);
 static int au1000_ioctl(struct net_device *, struct ifreq *, int);
@@ -1237,7 +1237,7 @@ static int au1000_rx(struct net_device *dev)
 /*
  * Au1000 interrupt service routine.
  */
-static irqreturn_t au1000_interrupt(int irq, void *dev_id)
+static irqreturn_t au1000_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 
diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index 3d247f3..e8fe653 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -881,7 +881,7 @@ static int b44_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static irqreturn_t b44_interrupt(int irq, void *dev_id)
+static irqreturn_t b44_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct b44 *bp = netdev_priv(dev);
@@ -1448,7 +1448,7 @@ out:
 static void b44_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	b44_interrupt(dev->irq, dev);
+	b44_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/bmac.c b/drivers/net/bmac.c
index a42bd19..908baf8 100644
--- a/drivers/net/bmac.c
+++ b/drivers/net/bmac.c
@@ -151,9 +151,9 @@ static void bmac_init_chip(struct net_device *dev);
 static void bmac_init_registers(struct net_device *dev);
 static void bmac_enable_and_reset_chip(struct net_device *dev);
 static int bmac_set_address(struct net_device *dev, void *addr);
-static irqreturn_t bmac_misc_intr(int irq, void *dev_id);
-static irqreturn_t bmac_txdma_intr(int irq, void *dev_id);
-static irqreturn_t bmac_rxdma_intr(int irq, void *dev_id);
+static irqreturn_t bmac_misc_intr(void *dev_id);
+static irqreturn_t bmac_txdma_intr(void *dev_id);
+static irqreturn_t bmac_rxdma_intr(void *dev_id);
 static void bmac_set_timeout(struct net_device *dev);
 static void bmac_tx_timeout(unsigned long data);
 static int bmac_output(struct sk_buff *skb, struct net_device *dev);
@@ -675,7 +675,7 @@ static int bmac_transmit_packet(struct sk_buff *skb, struct net_device *dev)
 
 static int rxintcount;
 
-static irqreturn_t bmac_rxdma_intr(int irq, void *dev_id)
+static irqreturn_t bmac_rxdma_intr(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct bmac_data *bp = netdev_priv(dev);
@@ -751,7 +751,7 @@ static irqreturn_t bmac_rxdma_intr(int irq, void *dev_id)
 
 static int txintcount;
 
-static irqreturn_t bmac_txdma_intr(int irq, void *dev_id)
+static irqreturn_t bmac_txdma_intr(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct bmac_data *bp = netdev_priv(dev);
@@ -1061,7 +1061,7 @@ static void bmac_set_multicast(struct net_device *dev)
 
 static int miscintcount;
 
-static irqreturn_t bmac_misc_intr(int irq, void *dev_id)
+static irqreturn_t bmac_misc_intr(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct bmac_data *bp = netdev_priv(dev);
diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index 96cee4b..3205cdd 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -2539,7 +2539,7 @@ next_rx:
  * is that the MSI interrupt is always serviced.
  */
 static irqreturn_t
-bnx2_msi(int irq, void *dev_instance)
+bnx2_msi(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct bnx2 *bp = netdev_priv(dev);
@@ -2559,7 +2559,7 @@ bnx2_msi(int irq, void *dev_instance)
 }
 
 static irqreturn_t
-bnx2_msi_1shot(int irq, void *dev_instance)
+bnx2_msi_1shot(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct bnx2 *bp = netdev_priv(dev);
@@ -2576,7 +2576,7 @@ bnx2_msi_1shot(int irq, void *dev_instance)
 }
 
 static irqreturn_t
-bnx2_interrupt(int irq, void *dev_instance)
+bnx2_interrupt(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct bnx2 *bp = netdev_priv(dev);
@@ -6325,7 +6325,7 @@ poll_bnx2(struct net_device *dev)
 	struct bnx2 *bp = netdev_priv(dev);
 
 	disable_irq(bp->pdev->irq);
-	bnx2_interrupt(bp->pdev->irq, dev);
+	bnx2_interrupt(dev);
 	enable_irq(bp->pdev->irq);
 }
 #endif
diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index 7df31b5..dd7c2a1 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -2468,7 +2468,7 @@ static inline void cas_handle_irqN(struct net_device *dev,
 		cas_post_rxcs_ringN(dev, cp, ring);
 }
 
-static irqreturn_t cas_interruptN(int irq, void *dev_id)
+static irqreturn_t cas_interruptN(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct cas *cp = netdev_priv(dev);
@@ -2521,7 +2521,7 @@ static inline void cas_handle_irq1(struct cas *cp, const u32 status)
 }
 
 /* ring 2 handles a few more events than 3 and 4 */
-static irqreturn_t cas_interrupt1(int irq, void *dev_id)
+static irqreturn_t cas_interrupt1(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct cas *cp = netdev_priv(dev);
@@ -2573,7 +2573,7 @@ static inline void cas_handle_irq(struct net_device *dev,
 		cas_post_rxcs_ringN(dev, cp, 0);
 }
 
-static irqreturn_t cas_interrupt(int irq, void *dev_id)
+static irqreturn_t cas_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct cas *cp = netdev_priv(dev);
@@ -2683,7 +2683,7 @@ static void cas_netpoll(struct net_device *dev)
 	struct cas *cp = netdev_priv(dev);
 
 	cas_disable_irq(cp, 0);
-	cas_interrupt(cp->pdev->irq, dev);
+	cas_interrupt(dev);
 	cas_enable_irq(cp, 0);
 
 #ifdef USE_PCI_INTB
diff --git a/drivers/net/chelsio/cxgb2.c b/drivers/net/chelsio/cxgb2.c
index 2dbf8dc..0384800 100644
--- a/drivers/net/chelsio/cxgb2.c
+++ b/drivers/net/chelsio/cxgb2.c
@@ -898,7 +898,7 @@ static void t1_netpoll(struct net_device *dev)
 	struct adapter *adapter = dev->priv;
 
 	local_irq_save(flags);
-	t1_interrupt(adapter->pdev->irq, adapter);
+	t1_interrupt(adapter);
 	local_irq_restore(flags);
 }
 #endif
diff --git a/drivers/net/chelsio/sge.c b/drivers/net/chelsio/sge.c
index ffa7e64..a3d147f 100644
--- a/drivers/net/chelsio/sge.c
+++ b/drivers/net/chelsio/sge.c
@@ -1639,7 +1639,7 @@ int t1_poll(struct napi_struct *napi, int budget)
 /*
  * NAPI version of the main interrupt handler.
  */
-irqreturn_t t1_interrupt(int irq, void *data)
+irqreturn_t t1_interrupt(void *data)
 {
 	struct adapter *adapter = data;
 	struct sge *sge = adapter->sge;
@@ -1688,7 +1688,7 @@ irqreturn_t t1_interrupt(int irq, void *data)
  * 5. If we took an interrupt, but no valid respQ descriptors was found we
  *      let the slow_intr_handler run and do error handling.
  */
-irqreturn_t t1_interrupt(int irq, void *cookie)
+irqreturn_t t1_interrupt(void *cookie)
 {
 	int work_done;
 	struct adapter *adapter = cookie;
diff --git a/drivers/net/chelsio/sge.h b/drivers/net/chelsio/sge.h
index 713d9c5..446de58 100644
--- a/drivers/net/chelsio/sge.h
+++ b/drivers/net/chelsio/sge.h
@@ -76,7 +76,7 @@ struct sge *t1_sge_create(struct adapter *, struct sge_params *);
 int t1_sge_configure(struct sge *, struct sge_params *);
 int t1_sge_set_coalesce_params(struct sge *, struct sge_params *);
 void t1_sge_destroy(struct sge *);
-irqreturn_t t1_interrupt(int irq, void *cookie);
+irqreturn_t t1_interrupt(void *cookie);
 int t1_poll(struct napi_struct *, int);
 
 int t1_start_xmit(struct sk_buff *skb, struct net_device *dev);
diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 314b2f6..0af45f9 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -402,8 +402,8 @@ static int etrax_ethernet_init(void);
 static int e100_open(struct net_device *dev);
 static int e100_set_mac_address(struct net_device *dev, void *addr);
 static int e100_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t e100rxtx_interrupt(int irq, void *dev_id);
-static irqreturn_t e100nw_interrupt(int irq, void *dev_id);
+static irqreturn_t e100rxtx_interrupt(void *dev_id);
+static irqreturn_t e100nw_interrupt(void *dev_id);
 static void e100_rx(struct net_device *dev);
 static int e100_close(struct net_device *dev);
 static int e100_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
@@ -1194,7 +1194,7 @@ e100_send_packet(struct sk_buff *skb, struct net_device *dev)
  */
 
 static irqreturn_t
-e100rxtx_interrupt(int irq, void *dev_id)
+e100rxtx_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct net_local *np = (struct net_local *)dev->priv;
@@ -1261,7 +1261,7 @@ e100rxtx_interrupt(int irq, void *dev_id)
 }
 
 static irqreturn_t
-e100nw_interrupt(int irq, void *dev_id)
+e100nw_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct net_local *np = (struct net_local *)dev->priv;
diff --git a/drivers/net/cs89x0.c b/drivers/net/cs89x0.c
index 5717509..5245a91 100644
--- a/drivers/net/cs89x0.c
+++ b/drivers/net/cs89x0.c
@@ -249,7 +249,7 @@ struct net_local {
 static int cs89x0_probe1(struct net_device *dev, int ioaddr, int modular);
 static int net_open(struct net_device *dev);
 static int net_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t net_interrupt(int irq, void *dev_id);
+static irqreturn_t net_interrupt(void *dev_id);
 static void set_multicast_list(struct net_device *dev);
 static void net_timeout(struct net_device *dev);
 static void net_rx(struct net_device *dev);
@@ -495,7 +495,7 @@ get_eeprom_cksum(int off, int len, int *buffer)
 static void net_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	net_interrupt(dev->irq, dev);
+	net_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
@@ -1568,7 +1568,7 @@ static int net_send_packet(struct sk_buff *skb, struct net_device *dev)
 /* The typical workload of the driver:
    Handle the network interface interrupts. */
 
-static irqreturn_t net_interrupt(int irq, void *dev_id)
+static irqreturn_t net_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct net_local *lp;
diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index 61ffc92..24e3ad8 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -252,7 +252,7 @@ static inline void cxgb_disable_msi(struct adapter *adapter)
 /*
  * Interrupt handler for asynchronous events used with MSI-X.
  */
-static irqreturn_t t3_async_intr_handler(int irq, void *cookie)
+static irqreturn_t t3_async_intr_handler(void *cookie)
 {
 	t3_slow_intr_handler(cookie);
 	return IRQ_HANDLED;
@@ -2150,7 +2150,7 @@ static void cxgb_netpoll(struct net_device *dev)
 		else
 			source = adapter;
 
-		t3_intr_handler(adapter, qs->rspq.polling) (0, source);
+		t3_intr_handler(adapter, qs->rspq.polling) (source);
 	}
 }
 #endif
diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index c15e43a..2c510d2 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -2196,7 +2196,7 @@ static inline int handle_responses(struct adapter *adap, struct sge_rspq *q)
  * The MSI-X interrupt handler for an SGE response queue for the non-NAPI case
  * (i.e., response queue serviced in hard interrupt).
  */
-irqreturn_t t3_sge_intr_msix(int irq, void *cookie)
+irqreturn_t t3_sge_intr_msix(void *cookie)
 {
 	struct sge_qset *qs = cookie;
 	struct adapter *adap = qs->adap;
@@ -2215,7 +2215,7 @@ irqreturn_t t3_sge_intr_msix(int irq, void *cookie)
  * The MSI-X interrupt handler for an SGE response queue for the NAPI case
  * (i.e., response queue serviced by NAPI polling).
  */
-static irqreturn_t t3_sge_intr_msix_napi(int irq, void *cookie)
+static irqreturn_t t3_sge_intr_msix_napi(void *cookie)
 {
 	struct sge_qset *qs = cookie;
 	struct sge_rspq *q = &qs->rspq;
@@ -2234,7 +2234,7 @@ static irqreturn_t t3_sge_intr_msix_napi(int irq, void *cookie)
  * the same MSI vector.  We use one SGE response queue per port in this mode
  * and protect all response queues with queue 0's lock.
  */
-static irqreturn_t t3_intr_msi(int irq, void *cookie)
+static irqreturn_t t3_intr_msi(void *cookie)
 {
 	int new_packets = 0;
 	struct adapter *adap = cookie;
@@ -2284,7 +2284,7 @@ static int rspq_check_napi(struct sge_qset *qs)
  * one SGE response queue per port in this mode and protect all response
  * queues with queue 0's lock.
  */
-static irqreturn_t t3_intr_msi_napi(int irq, void *cookie)
+static irqreturn_t t3_intr_msi_napi(void *cookie)
 {
 	int new_packets;
 	struct adapter *adap = cookie;
@@ -2322,7 +2322,7 @@ static inline int process_responses_gts(struct adapter *adap,
  * the same interrupt pin.  We use one SGE response queue per port in this mode
  * and protect all response queues with queue 0's lock.
  */
-static irqreturn_t t3_intr(int irq, void *cookie)
+static irqreturn_t t3_intr(void *cookie)
 {
 	int work_done, w0, w1;
 	struct adapter *adap = cookie;
@@ -2360,7 +2360,7 @@ static irqreturn_t t3_intr(int irq, void *cookie)
  * response queue per port in this mode and protect all response queues with
  * queue 0's lock.
  */
-static irqreturn_t t3b_intr(int irq, void *cookie)
+static irqreturn_t t3b_intr(void *cookie)
 {
 	u32 map;
 	struct adapter *adap = cookie;
@@ -2394,7 +2394,7 @@ static irqreturn_t t3b_intr(int irq, void *cookie)
  * response queue per port in this mode and protect all response queues with
  * queue 0's lock.
  */
-static irqreturn_t t3b_intr_napi(int irq, void *cookie)
+static irqreturn_t t3b_intr_napi(void *cookie)
 {
 	u32 map;
 	struct adapter *adap = cookie;
diff --git a/drivers/net/de600.c b/drivers/net/de600.c
index cb849b0..36eac9a 100644
--- a/drivers/net/de600.c
+++ b/drivers/net/de600.c
@@ -246,7 +246,7 @@ static int de600_start_xmit(struct sk_buff *skb, struct net_device *dev)
  * Handle the network interface interrupts.
  */
 
-static irqreturn_t de600_interrupt(int irq, void *dev_id)
+static irqreturn_t de600_interrupt(void *dev_id)
 {
 	struct net_device	*dev = dev_id;
 	u8		irq_status;
diff --git a/drivers/net/de600.h b/drivers/net/de600.h
index e80ecba..554ab64 100644
--- a/drivers/net/de600.h
+++ b/drivers/net/de600.h
@@ -124,7 +124,7 @@ static int	de600_close(struct net_device *dev);
 static int	de600_start_xmit(struct sk_buff *skb, struct net_device *dev);
 
 /* Dispatch from interrupts. */
-static irqreturn_t de600_interrupt(int irq, void *dev_id);
+static irqreturn_t de600_interrupt(void *dev_id);
 static int	de600_tx_intr(struct net_device *dev, int irq_status);
 static void	de600_rx_intr(struct net_device *dev);
 
diff --git a/drivers/net/de620.c b/drivers/net/de620.c
index 3f5190c..423599a 100644
--- a/drivers/net/de620.c
+++ b/drivers/net/de620.c
@@ -220,7 +220,7 @@ static void	de620_set_multicast_list(struct net_device *);
 static int	de620_start_xmit(struct sk_buff *, struct net_device *);
 
 /* Dispatch from interrupts. */
-static irqreturn_t de620_interrupt(int, void *);
+static irqreturn_t de620_interrupt(void *);
 static int	de620_rx_intr(struct net_device *);
 
 /* Initialization */
@@ -580,7 +580,7 @@ static int de620_start_xmit(struct sk_buff *skb, struct net_device *dev)
  *
  */
 static irqreturn_t
-de620_interrupt(int irq_in, void *dev_id)
+de620_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	byte irq_status;
diff --git a/drivers/net/declance.c b/drivers/net/declance.c
index 00e0194..d758e3e 100644
--- a/drivers/net/declance.c
+++ b/drivers/net/declance.c
@@ -719,7 +719,7 @@ out:
 	spin_unlock(&lp->lock);
 }
 
-static irqreturn_t lance_dma_merr_int(const int irq, void *dev_id)
+static irqreturn_t lance_dma_merr_int(const void *dev_id)
 {
 	struct net_device *dev = dev_id;
 
@@ -727,7 +727,7 @@ static irqreturn_t lance_dma_merr_int(const int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t lance_interrupt(const int irq, void *dev_id)
+static irqreturn_t lance_interrupt(const void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct lance_private *lp = netdev_priv(dev);
diff --git a/drivers/net/defxx.c b/drivers/net/defxx.c
index b07613e..cb4dc82 100644
--- a/drivers/net/defxx.c
+++ b/drivers/net/defxx.c
@@ -282,7 +282,7 @@ static int		dfx_close(struct net_device *dev);
 static void		dfx_int_pr_halt_id(DFX_board_t *bp);
 static void		dfx_int_type_0_process(DFX_board_t *bp);
 static void		dfx_int_common(struct net_device *dev);
-static irqreturn_t	dfx_interrupt(int irq, void *dev_id);
+static irqreturn_t	dfx_interrupt(void *dev_id);
 
 static struct		net_device_stats *dfx_ctl_get_stats(struct net_device *dev);
 static void		dfx_ctl_set_multicast_list(struct net_device *dev);
@@ -1874,7 +1874,7 @@ static void dfx_int_common(struct net_device *dev)
  *   Interrupts are disabled, then reenabled at the adapter.
  */
 
-static irqreturn_t dfx_interrupt(int irq, void *dev_id)
+static irqreturn_t dfx_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	DFX_board_t *bp = netdev_priv(dev);
diff --git a/drivers/net/depca.c b/drivers/net/depca.c
index ace39ec..ceb1948 100644
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -517,7 +517,7 @@ struct depca_private {
 */
 static int depca_open(struct net_device *dev);
 static int depca_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t depca_interrupt(int irq, void *dev_id);
+static irqreturn_t depca_interrupt(void *dev_id);
 static int depca_close(struct net_device *dev);
 static int depca_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static void depca_tx_timeout(struct net_device *dev);
@@ -960,7 +960,7 @@ static int depca_start_xmit(struct sk_buff *skb, struct net_device *dev)
 /*
 ** The DEPCA interrupt handler.
 */
-static irqreturn_t depca_interrupt(int irq, void *dev_id)
+static irqreturn_t depca_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct depca_private *lp;
diff --git a/drivers/net/dl2k.c b/drivers/net/dl2k.c
index 5066beb..682d9ba 100644
--- a/drivers/net/dl2k.c
+++ b/drivers/net/dl2k.c
@@ -60,7 +60,7 @@ static void rio_timer (unsigned long data);
 static void rio_tx_timeout (struct net_device *dev);
 static void alloc_list (struct net_device *dev);
 static int start_xmit (struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t rio_interrupt (int irq, void *dev_instance);
+static irqreturn_t rio_interrupt (void *dev_instance);
 static void rio_free_tx (struct net_device *dev, int irq);
 static void tx_error (struct net_device *dev, int tx_status);
 static int receive_packet (struct net_device *dev);
@@ -667,7 +667,7 @@ start_xmit (struct sk_buff *skb, struct net_device *dev)
 }
 
 static irqreturn_t
-rio_interrupt (int irq, void *dev_instance)
+rio_interrupt (void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct netdev_private *np;
diff --git a/drivers/net/dm9000.c b/drivers/net/dm9000.c
index 27ac010..7dd9c05 100644
--- a/drivers/net/dm9000.c
+++ b/drivers/net/dm9000.c
@@ -165,7 +165,7 @@ static int dm9000_stop(struct net_device *);
 static void dm9000_timer(unsigned long);
 static void dm9000_init_dm9000(struct net_device *);
 
-static irqreturn_t dm9000_interrupt(int, void *);
+static irqreturn_t dm9000_interrupt(void *);
 
 static int dm9000_phy_read(struct net_device *dev, int phyaddr_unsused, int reg);
 static void dm9000_phy_write(struct net_device *dev, int phyaddr_unused, int reg,
@@ -352,7 +352,7 @@ static void dm9000_timeout(struct net_device *dev)
 static void dm9000_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	dm9000_interrupt(dev->irq,dev);
+	dm9000_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
@@ -799,7 +799,7 @@ dm9000_tx_done(struct net_device *dev, board_info_t * db)
 }
 
 static irqreturn_t
-dm9000_interrupt(int irq, void *dev_id)
+dm9000_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	board_info_t *db;
diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index 64f35e2..e419ad9 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1959,7 +1959,7 @@ static int e100_rx_alloc_list(struct nic *nic)
 	return 0;
 }
 
-static irqreturn_t e100_intr(int irq, void *dev_id)
+static irqreturn_t e100_intr(void *dev_id)
 {
 	struct net_device *netdev = dev_id;
 	struct nic *nic = netdev_priv(netdev);
@@ -2011,7 +2011,7 @@ static void e100_netpoll(struct net_device *netdev)
 	struct nic *nic = netdev_priv(netdev);
 
 	e100_disable_irq(nic);
-	e100_intr(nic->pdev->irq, netdev);
+	e100_intr(netdev);
 	e100_tx_clean(nic);
 	e100_enable_irq(nic);
 }
diff --git a/drivers/net/e1000/e1000_ethtool.c b/drivers/net/e1000/e1000_ethtool.c
index 6c9a643..99df95c 100644
--- a/drivers/net/e1000/e1000_ethtool.c
+++ b/drivers/net/e1000/e1000_ethtool.c
@@ -885,7 +885,7 @@ e1000_eeprom_test(struct e1000_adapter *adapter, uint64_t *data)
 }
 
 static irqreturn_t
-e1000_test_intr(int irq, void *data)
+e1000_test_intr(void *data)
 {
 	struct net_device *netdev = (struct net_device *) data;
 	struct e1000_adapter *adapter = netdev_priv(netdev);
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 0472638..2f8450d 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -161,8 +161,8 @@ static int e1000_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
 static struct net_device_stats * e1000_get_stats(struct net_device *netdev);
 static int e1000_change_mtu(struct net_device *netdev, int new_mtu);
 static int e1000_set_mac(struct net_device *netdev, void *p);
-static irqreturn_t e1000_intr(int irq, void *data);
-static irqreturn_t e1000_intr_msi(int irq, void *data);
+static irqreturn_t e1000_intr(void *data);
+static irqreturn_t e1000_intr_msi(void *data);
 static boolean_t e1000_clean_tx_irq(struct e1000_adapter *adapter,
                                     struct e1000_tx_ring *tx_ring);
 #ifdef CONFIG_E1000_NAPI
@@ -3748,7 +3748,7 @@ e1000_update_stats(struct e1000_adapter *adapter)
  **/
 
 static irqreturn_t
-e1000_intr_msi(int irq, void *data)
+e1000_intr_msi(void *data)
 {
 	struct net_device *netdev = data;
 	struct e1000_adapter *adapter = netdev_priv(netdev);
@@ -3813,7 +3813,7 @@ e1000_intr_msi(int irq, void *data)
  **/
 
 static irqreturn_t
-e1000_intr(int irq, void *data)
+e1000_intr(void *data)
 {
 	struct net_device *netdev = data;
 	struct e1000_adapter *adapter = netdev_priv(netdev);
@@ -5236,7 +5236,7 @@ e1000_netpoll(struct net_device *netdev)
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
 	disable_irq(adapter->pdev->irq);
-	e1000_intr(adapter->pdev->irq, netdev);
+	e1000_intr(netdev);
 	e1000_clean_tx_irq(adapter, adapter->tx_ring);
 #ifndef CONFIG_E1000_NAPI
 	adapter->clean_rx(adapter, adapter->rx_ring);
diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
index 0666e62..d29b704 100644
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -837,7 +837,7 @@ static int e1000_eeprom_test(struct e1000_adapter *adapter, u64 *data)
 	return *data;
 }
 
-static irqreturn_t e1000_test_intr(int irq, void *data)
+static irqreturn_t e1000_test_intr(void *data)
 {
 	struct net_device *netdev = (struct net_device *) data;
 	struct e1000_adapter *adapter = netdev_priv(netdev);
diff --git a/drivers/net/eepro.c b/drivers/net/eepro.c
index 83bda6c..0873bf4 100644
--- a/drivers/net/eepro.c
+++ b/drivers/net/eepro.c
@@ -310,7 +310,7 @@ struct eepro_local {
 static int	eepro_probe1(struct net_device *dev, int autoprobe);
 static int	eepro_open(struct net_device *dev);
 static int	eepro_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t eepro_interrupt(int irq, void *dev_id);
+static irqreturn_t eepro_interrupt(void *dev_id);
 static void 	eepro_rx(struct net_device *dev);
 static void 	eepro_transmit_interrupt(struct net_device *dev);
 static int	eepro_close(struct net_device *dev);
@@ -1180,7 +1180,7 @@ static int eepro_send_packet(struct sk_buff *skb, struct net_device *dev)
 	Handle the network interface interrupts. */
 
 static irqreturn_t
-eepro_interrupt(int irq, void *dev_id)
+eepro_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct eepro_local *lp;
diff --git a/drivers/net/eepro100.c b/drivers/net/eepro100.c
index 1548a80..02a3952 100644
--- a/drivers/net/eepro100.c
+++ b/drivers/net/eepro100.c
@@ -488,7 +488,7 @@ static int speedo_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static void speedo_refill_rx_buffers(struct net_device *dev, int force);
 static int speedo_rx(struct net_device *dev);
 static void speedo_tx_buffer_gc(struct net_device *dev);
-static irqreturn_t speedo_interrupt(int irq, void *dev_instance);
+static irqreturn_t speedo_interrupt(void *dev_instance);
 static int speedo_close(struct net_device *dev);
 static struct net_device_stats *speedo_get_stats(struct net_device *dev);
 static int speedo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
@@ -606,7 +606,7 @@ static void poll_speedo (struct net_device *dev)
 	/* disable_irq is not very nice, but with the funny lockless design
 	   we have no other choice. */
 	disable_irq(dev->irq);
-	speedo_interrupt (dev->irq, dev);
+	speedo_interrupt (dev);
 	enable_irq(dev->irq);
 }
 #endif
@@ -1537,7 +1537,7 @@ static void speedo_tx_buffer_gc(struct net_device *dev)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-static irqreturn_t speedo_interrupt(int irq, void *dev_instance)
+static irqreturn_t speedo_interrupt(void *dev_instance)
 {
 	struct net_device *dev = (struct net_device *)dev_instance;
 	struct speedo_private *sp;
diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index 2809c99..2a2a3ff 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -686,7 +686,7 @@ static void ehea_netpoll(struct net_device *dev)
 }
 #endif
 
-static irqreturn_t ehea_recv_irq_handler(int irq, void *param)
+static irqreturn_t ehea_recv_irq_handler(void *param)
 {
 	struct ehea_port_res *pr = param;
 
@@ -695,7 +695,7 @@ static irqreturn_t ehea_recv_irq_handler(int irq, void *param)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t ehea_qp_aff_irq_handler(int irq, void *param)
+static irqreturn_t ehea_qp_aff_irq_handler(void *param)
 {
 	struct ehea_port *port = param;
 	struct ehea_eqe *eqe;
@@ -1010,7 +1010,7 @@ static void ehea_neq_tasklet(unsigned long data)
 			    adapter->neq->fw_handle, event_mask);
 }
 
-static irqreturn_t ehea_interrupt_neq(int irq, void *param)
+static irqreturn_t ehea_interrupt_neq(void *param)
 {
 	struct ehea_adapter *adapter = param;
 	tasklet_hi_schedule(&adapter->neq_tasklet);
diff --git a/drivers/net/epic100.c b/drivers/net/epic100.c
index ecdd3fc..d889ec6 100644
--- a/drivers/net/epic100.c
+++ b/drivers/net/epic100.c
@@ -296,7 +296,7 @@ static void epic_init_ring(struct net_device *dev);
 static int epic_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int epic_rx(struct net_device *dev, int budget);
 static int epic_poll(struct napi_struct *napi, int budget);
-static irqreturn_t epic_interrupt(int irq, void *dev_instance);
+static irqreturn_t epic_interrupt(void *dev_instance);
 static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static const struct ethtool_ops netdev_ethtool_ops;
 static int epic_close(struct net_device *dev);
@@ -1079,7 +1079,7 @@ static void epic_tx(struct net_device *dev, struct epic_private *ep)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-static irqreturn_t epic_interrupt(int irq, void *dev_instance)
+static irqreturn_t epic_interrupt(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct epic_private *ep = dev->priv;
diff --git a/drivers/net/eth16i.c b/drivers/net/eth16i.c
index 243fc6b..56a3ebb 100644
--- a/drivers/net/eth16i.c
+++ b/drivers/net/eth16i.c
@@ -409,7 +409,7 @@ static int     eth16i_close(struct net_device *dev);
 static int     eth16i_tx(struct sk_buff *skb, struct net_device *dev);
 static void    eth16i_rx(struct net_device *dev);
 static void    eth16i_timeout(struct net_device *dev);
-static irqreturn_t eth16i_interrupt(int irq, void *dev_id);
+static irqreturn_t eth16i_interrupt(void *dev_id);
 static void    eth16i_reset(struct net_device *dev);
 static void    eth16i_timeout(struct net_device *dev);
 static void    eth16i_skip_packet(struct net_device *dev);
@@ -1218,7 +1218,7 @@ static void eth16i_rx(struct net_device *dev)
 	} /* while */
 }
 
-static irqreturn_t eth16i_interrupt(int irq, void *dev_id)
+static irqreturn_t eth16i_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct eth16i_local *lp;
diff --git a/drivers/net/ewrk3.c b/drivers/net/ewrk3.c
index 593a120..68f1722 100644
--- a/drivers/net/ewrk3.c
+++ b/drivers/net/ewrk3.c
@@ -299,7 +299,7 @@ struct ewrk3_private {
  */
 static int ewrk3_open(struct net_device *dev);
 static int ewrk3_queue_pkt(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t ewrk3_interrupt(int irq, void *dev_id);
+static irqreturn_t ewrk3_interrupt(void *dev_id);
 static int ewrk3_close(struct net_device *dev);
 static void set_multicast_list(struct net_device *dev);
 static int ewrk3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
@@ -875,7 +875,7 @@ err_out:
 /*
    ** The EWRK3 interrupt handler.
  */
-static irqreturn_t ewrk3_interrupt(int irq, void *dev_id)
+static irqreturn_t ewrk3_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct ewrk3_private *lp;
diff --git a/drivers/net/fealnx.c b/drivers/net/fealnx.c
index 43f7647..22ef8fe 100644
--- a/drivers/net/fealnx.c
+++ b/drivers/net/fealnx.c
@@ -434,7 +434,7 @@ static void reset_timer(unsigned long data);
 static void tx_timeout(struct net_device *dev);
 static void init_ring(struct net_device *dev);
 static int start_tx(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t intr_handler(int irq, void *dev_instance);
+static irqreturn_t intr_handler(void *dev_instance);
 static int netdev_rx(struct net_device *dev);
 static void set_rx_mode(struct net_device *dev);
 static void __set_rx_mode(struct net_device *dev);
@@ -1451,7 +1451,7 @@ static void reset_rx_descriptors(struct net_device *dev)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-static irqreturn_t intr_handler(int irq, void *dev_instance)
+static irqreturn_t intr_handler(void *dev_instance)
 {
 	struct net_device *dev = (struct net_device *) dev_instance;
 	struct netdev_private *np = netdev_priv(dev);
diff --git a/drivers/net/fec.c b/drivers/net/fec.c
index 2b57820..d31fc10 100644
--- a/drivers/net/fec.c
+++ b/drivers/net/fec.c
@@ -229,7 +229,7 @@ struct fec_enet_private {
 static int fec_enet_open(struct net_device *dev);
 static int fec_enet_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static void fec_enet_mii(struct net_device *dev);
-static irqreturn_t fec_enet_interrupt(int irq, void * dev_id);
+static irqreturn_t fec_enet_interrupt(void * dev_id);
 static void fec_enet_tx(struct net_device *dev);
 static void fec_enet_rx(struct net_device *dev);
 static int fec_enet_close(struct net_device *dev);
@@ -449,7 +449,7 @@ fec_timeout(struct net_device *dev)
  * This is called from the MPC core interrupt.
  */
 static irqreturn_t
-fec_enet_interrupt(int irq, void * dev_id)
+fec_enet_interrupt(void * dev_id)
 {
 	struct	net_device *dev = dev_id;
 	volatile fec_t	*fecp;
@@ -1234,7 +1234,7 @@ static void
 mii_link_interrupt(void *dev_id);
 #else
 static irqreturn_t
-mii_link_interrupt(int irq, void * dev_id);
+mii_link_interrupt(void *dev_id);
 #endif
 #endif
 
@@ -2140,7 +2140,7 @@ static void
 mii_link_interrupt(void *dev_id)
 #else
 static irqreturn_t
-mii_link_interrupt(int irq, void * dev_id)
+mii_link_interrupt(void *dev_id)
 #endif
 {
 	struct	net_device *dev = dev_id;
diff --git a/drivers/net/fec_8xx/fec_main.c b/drivers/net/fec_8xx/fec_main.c
index 8d2904f..134da08 100644
--- a/drivers/net/fec_8xx/fec_main.c
+++ b/drivers/net/fec_8xx/fec_main.c
@@ -698,7 +698,7 @@ static void fec_enet_tx(struct net_device *dev)
  * This is called from the MPC core interrupt.
  */
 static irqreturn_t
-fec_enet_interrupt(int irq, void *dev_id)
+fec_enet_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct fec_enet_private *fep;
@@ -758,7 +758,7 @@ fec_enet_interrupt(int irq, void *dev_id)
 
 /* This interrupt occurs when the PHY detects a link change. */
 static irqreturn_t
-fec_mii_link_interrupt(int irq, void *dev_id)
+fec_mii_link_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct fec_enet_private *fep;
diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
index 04c6fae..0f6781f 100644
--- a/drivers/net/fs_enet/fs_enet-main.c
+++ b/drivers/net/fs_enet/fs_enet-main.c
@@ -450,7 +450,7 @@ static void fs_enet_tx(struct net_device *dev)
  * This is called from the MPC core interrupt.
  */
 static irqreturn_t
-fs_enet_interrupt(int irq, void *dev_id)
+fs_enet_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct fs_enet_private *fep;
diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index cc288d8..5de087b 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -118,9 +118,9 @@ static int gfar_close(struct net_device *dev);
 struct sk_buff *gfar_new_skb(struct net_device *dev, struct rxbd8 *bdp);
 static int gfar_set_mac_address(struct net_device *dev);
 static int gfar_change_mtu(struct net_device *dev, int new_mtu);
-static irqreturn_t gfar_error(int irq, void *dev_id);
-static irqreturn_t gfar_transmit(int irq, void *dev_id);
-static irqreturn_t gfar_interrupt(int irq, void *dev_id);
+static irqreturn_t gfar_error(void *dev_id);
+static irqreturn_t gfar_transmit(void *dev_id);
+static irqreturn_t gfar_interrupt(void *dev_id);
 static void adjust_link(struct net_device *dev);
 static void init_registers(struct net_device *dev);
 static int init_phy(struct net_device *dev);
@@ -1248,7 +1248,7 @@ static void gfar_timeout(struct net_device *dev)
 }
 
 /* Interrupt Handler for Transmit complete */
-static irqreturn_t gfar_transmit(int irq, void *dev_id)
+static irqreturn_t gfar_transmit(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct gfar_private *priv = netdev_priv(dev);
@@ -1380,7 +1380,7 @@ static inline void count_errors(unsigned short status, struct net_device *dev)
 	}
 }
 
-irqreturn_t gfar_receive(int irq, void *dev_id)
+irqreturn_t gfar_receive(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct gfar_private *priv = netdev_priv(dev);
@@ -1632,7 +1632,7 @@ static void gfar_netpoll(struct net_device *dev)
 #endif
 
 /* The interrupt handler for devices with one interrupt */
-static irqreturn_t gfar_interrupt(int irq, void *dev_id)
+static irqreturn_t gfar_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct gfar_private *priv = netdev_priv(dev);
@@ -1898,7 +1898,7 @@ static void gfar_set_mac_for_addr(struct net_device *dev, int num, u8 *addr)
 }
 
 /* GFAR error interrupt handler */
-static irqreturn_t gfar_error(int irq, void *dev_id)
+static irqreturn_t gfar_error(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct gfar_private *priv = netdev_priv(dev);
diff --git a/drivers/net/gianfar.h b/drivers/net/gianfar.h
index c16cc8b..9b174af 100644
--- a/drivers/net/gianfar.h
+++ b/drivers/net/gianfar.h
@@ -765,7 +765,7 @@ static inline void gfar_write(volatile unsigned __iomem *addr, u32 val)
 	out_be32(addr, val);
 }
 
-extern irqreturn_t gfar_receive(int irq, void *dev_id);
+extern irqreturn_t gfar_receive(void *dev_id);
 extern int startup_gfar(struct net_device *dev);
 extern void stop_gfar(struct net_device *dev);
 extern void gfar_halt(struct net_device *dev);
diff --git a/drivers/net/hamachi.c b/drivers/net/hamachi.c
index ed407c8..fda9678 100644
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -556,7 +556,7 @@ static void hamachi_timer(unsigned long data);
 static void hamachi_tx_timeout(struct net_device *dev);
 static void hamachi_init_ring(struct net_device *dev);
 static int hamachi_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t hamachi_interrupt(int irq, void *dev_instance);
+static irqreturn_t hamachi_interrupt(void *dev_instance);
 static int hamachi_rx(struct net_device *dev);
 static inline int hamachi_tx(struct net_device *dev);
 static void hamachi_error(struct net_device *dev, int intr_status);
@@ -1372,7 +1372,7 @@ static int hamachi_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-static irqreturn_t hamachi_interrupt(int irq, void *dev_instance)
+static irqreturn_t hamachi_interrupt(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct hamachi_private *hmp = netdev_priv(dev);
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index 17ac697..a132079 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -281,7 +281,7 @@ static __inline__ void ser12_rx(struct net_device *dev, struct baycom_state *bc,
 
 /* --------------------------------------------------------------------- */
 
-static irqreturn_t ser12_interrupt(int irq, void *dev_id)
+static irqreturn_t ser12_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct baycom_state *bc = netdev_priv(dev);
diff --git a/drivers/net/hamradio/baycom_ser_hdx.c b/drivers/net/hamradio/baycom_ser_hdx.c
index 3bcc57a..ca2e54e 100644
--- a/drivers/net/hamradio/baycom_ser_hdx.c
+++ b/drivers/net/hamradio/baycom_ser_hdx.c
@@ -373,7 +373,7 @@ static inline void ser12_rx(struct net_device *dev, struct baycom_state *bc)
 
 /* --------------------------------------------------------------------- */
 
-static irqreturn_t ser12_interrupt(int irq, void *dev_id)
+static irqreturn_t ser12_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct baycom_state *bc = netdev_priv(dev);
diff --git a/drivers/net/hamradio/dmascc.c b/drivers/net/hamradio/dmascc.c
index bc02e46..7ca27ec 100644
--- a/drivers/net/hamradio/dmascc.c
+++ b/drivers/net/hamradio/dmascc.c
@@ -249,7 +249,7 @@ static void start_timer(struct scc_priv *priv, int t, int r15);
 static inline unsigned char random(void);
 
 static inline void z8530_isr(struct scc_info *info);
-static irqreturn_t scc_isr(int irq, void *dev_id);
+static irqreturn_t scc_isr(void *dev_id);
 static void rx_isr(struct scc_priv *priv);
 static void special_condition(struct scc_priv *priv, int rc);
 static void rx_bh(struct work_struct *);
@@ -1133,7 +1133,7 @@ static inline void z8530_isr(struct scc_info *info)
 }
 
 
-static irqreturn_t scc_isr(int irq, void *dev_id)
+static irqreturn_t scc_isr(void *dev_id)
 {
 	struct scc_info *info = dev_id;
 
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 1c94286..f2bc152 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -693,7 +693,7 @@ static void yam_tx_byte(struct net_device *dev, struct yam_port *yp)
 * ISR routine
 ************************************************************************************/
 
-static irqreturn_t yam_interrupt(int irq, void *dev_id)
+static irqreturn_t yam_interrupt(void *dev_id)
 {
 	struct net_device *dev;
 	struct yam_port *yp;
diff --git a/drivers/net/hp100.c b/drivers/net/hp100.c
index 49421d1..db116e5 100644
--- a/drivers/net/hp100.c
+++ b/drivers/net/hp100.c
@@ -249,7 +249,7 @@ static void hp100_misc_interrupt(struct net_device *dev);
 static void hp100_update_stats(struct net_device *dev);
 static void hp100_clear_stats(struct hp100_private *lp, int ioaddr);
 static void hp100_set_multicast_list(struct net_device *dev);
-static irqreturn_t hp100_interrupt(int irq, void *dev_id);
+static irqreturn_t hp100_interrupt(void *dev_id);
 static void hp100_start_interface(struct net_device *dev);
 static void hp100_stop_interface(struct net_device *dev);
 static void hp100_load_eeprom(struct net_device *dev, u_short ioaddr);
@@ -2184,7 +2184,7 @@ static void hp100_set_multicast_list(struct net_device *dev)
  *  hardware interrupt handling
  */
 
-static irqreturn_t hp100_interrupt(int irq, void *dev_id)
+static irqreturn_t hp100_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct hp100_private *lp = netdev_priv(dev);
diff --git a/drivers/net/ibm_emac/ibm_emac_core.c b/drivers/net/ibm_emac/ibm_emac_core.c
index 73664f2..c11e169 100644
--- a/drivers/net/ibm_emac/ibm_emac_core.c
+++ b/drivers/net/ibm_emac/ibm_emac_core.c
@@ -182,7 +182,7 @@ static const char emac_stats_keys[EMAC_ETHTOOL_STATS_COUNT][ETH_GSTRING_LEN] = {
 	"tx_errors"
 };
 
-static irqreturn_t emac_irq(int irq, void *dev_instance);
+static irqreturn_t emac_irq(void *dev_instance);
 static void emac_clean_tx_ring(struct ocp_enet_private *dev);
 
 static inline int emac_phy_supports_gige(int phy_mode)
@@ -1511,7 +1511,7 @@ static void emac_rxde(void *param)
 }
 
 /* Hard IRQ */
-static irqreturn_t emac_irq(int irq, void *dev_instance)
+static irqreturn_t emac_irq(void *dev_instance)
 {
 	struct ocp_enet_private *dev = dev_instance;
 	struct emac_regs __iomem *p = dev->emacp;
diff --git a/drivers/net/ibm_emac/ibm_emac_mal.c b/drivers/net/ibm_emac/ibm_emac_mal.c
index dcd8826..fb4d149 100644
--- a/drivers/net/ibm_emac/ibm_emac_mal.c
+++ b/drivers/net/ibm_emac/ibm_emac_mal.c
@@ -167,7 +167,7 @@ static inline void mal_disable_eob_irq(struct ibm_ocp_mal *mal)
 	MAL_DBG2("%d: disable_irq" NL, mal->def->index);
 }
 
-static irqreturn_t mal_serr(int irq, void *dev_instance)
+static irqreturn_t mal_serr(void *dev_instance)
 {
 	struct ibm_ocp_mal *mal = dev_instance;
 	u32 esr = get_mal_dcrn(mal, MAL_ESR);
@@ -215,7 +215,7 @@ static inline void mal_schedule_poll(struct ibm_ocp_mal *mal)
 		MAL_DBG2("%d: already in poll" NL, mal->def->index);
 }
 
-static irqreturn_t mal_txeob(int irq, void *dev_instance)
+static irqreturn_t mal_txeob(void *dev_instance)
 {
 	struct ibm_ocp_mal *mal = dev_instance;
 	u32 r = get_mal_dcrn(mal, MAL_TXEOBISR);
@@ -225,7 +225,7 @@ static irqreturn_t mal_txeob(int irq, void *dev_instance)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t mal_rxeob(int irq, void *dev_instance)
+static irqreturn_t mal_rxeob(void *dev_instance)
 {
 	struct ibm_ocp_mal *mal = dev_instance;
 	u32 r = get_mal_dcrn(mal, MAL_RXEOBISR);
@@ -235,7 +235,7 @@ static irqreturn_t mal_rxeob(int irq, void *dev_instance)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t mal_txde(int irq, void *dev_instance)
+static irqreturn_t mal_txde(void *dev_instance)
 {
 	struct ibm_ocp_mal *mal = dev_instance;
 	u32 deir = get_mal_dcrn(mal, MAL_TXDEIR);
@@ -251,7 +251,7 @@ static irqreturn_t mal_txde(int irq, void *dev_instance)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t mal_rxde(int irq, void *dev_instance)
+static irqreturn_t mal_rxde(void *dev_instance)
 {
 	struct ibm_ocp_mal *mal = dev_instance;
 	struct list_head *l;
diff --git a/drivers/net/ibmlana.c b/drivers/net/ibmlana.c
index 91d83ac..3b90c3e 100644
--- a/drivers/net/ibmlana.c
+++ b/drivers/net/ibmlana.c
@@ -704,7 +704,7 @@ static void irqtxerr_handler(struct net_device *dev)
 
 /* general interrupt entry */
 
-static irqreturn_t irq_handler(int irq, void *device)
+static irqreturn_t irq_handler(void *device)
 {
 	struct net_device *dev = (struct net_device *) device;
 	u16 ival;
diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index 7d7758f..f698d2d 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -93,7 +93,7 @@ static void ibmveth_proc_register_driver(void);
 static void ibmveth_proc_unregister_driver(void);
 static void ibmveth_proc_register_adapter(struct ibmveth_adapter *adapter);
 static void ibmveth_proc_unregister_adapter(struct ibmveth_adapter *adapter);
-static irqreturn_t ibmveth_interrupt(int irq, void *dev_instance);
+static irqreturn_t ibmveth_interrupt(void *dev_instance);
 static void ibmveth_rxq_harvest_buffer(struct ibmveth_adapter *adapter);
 static struct kobj_type ktype_veth_pool;
 
@@ -988,7 +988,7 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
 	return frames_processed;
 }
 
-static irqreturn_t ibmveth_interrupt(int irq, void *dev_instance)
+static irqreturn_t ibmveth_interrupt(void *dev_instance)
 {
 	struct net_device *netdev = dev_instance;
 	struct ibmveth_adapter *adapter = netdev->priv;
diff --git a/drivers/net/ioc3-eth.c b/drivers/net/ioc3-eth.c
index 373f72c..d2e5271 100644
--- a/drivers/net/ioc3-eth.c
+++ b/drivers/net/ioc3-eth.c
@@ -736,7 +736,7 @@ static void ioc3_error(struct ioc3_private *ip, u32 eisr)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread.  */
-static irqreturn_t ioc3_interrupt(int irq, void *_dev)
+static irqreturn_t ioc3_interrupt(void *_dev)
 {
 	struct net_device *dev = (struct net_device *)_dev;
 	struct ioc3_private *ip = netdev_priv(dev);
diff --git a/drivers/net/ipg.c b/drivers/net/ipg.c
index 6888723..ccd3c76 100644
--- a/drivers/net/ipg.c
+++ b/drivers/net/ipg.c
@@ -1597,7 +1597,7 @@ static void ipg_reset_after_host_error(struct work_struct *work)
 	}
 }
 
-static irqreturn_t ipg_interrupt_handler(int irq, void *dev_inst)
+static irqreturn_t ipg_interrupt_handler(void *dev_inst)
 {
 	struct net_device *dev = dev_inst;
 	struct ipg_nic_private *sp = netdev_priv(dev);
diff --git a/drivers/net/irda/ali-ircc.c b/drivers/net/irda/ali-ircc.c
index 9f58452..cad76ce 100644
--- a/drivers/net/irda/ali-ircc.c
+++ b/drivers/net/irda/ali-ircc.c
@@ -656,7 +656,7 @@ static int ali_ircc_read_dongle_id (int i, chipio_t *info)
  *    An interrupt from the chip has arrived. Time to do some work
  *
  */
-static irqreturn_t ali_ircc_interrupt(int irq, void *dev_id)
+static irqreturn_t ali_ircc_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct ali_ircc_cb *self;
diff --git a/drivers/net/irda/donauboe.c b/drivers/net/irda/donauboe.c
index a82d8f9..9fef892 100644
--- a/drivers/net/irda/donauboe.c
+++ b/drivers/net/irda/donauboe.c
@@ -703,7 +703,7 @@ stuff_byte (__u8 byte, __u8 * buf)
 }
 
 static irqreturn_t
-toshoboe_probeinterrupt (int irq, void *dev_id)
+toshoboe_probeinterrupt (void *dev_id)
 {
   struct toshoboe_cb *self = dev_id;
   __u8 irqstat;
@@ -1152,7 +1152,7 @@ dumpbufs(skb->data,skb->len,'>');
 
 /*interrupt handler */
 static irqreturn_t
-toshoboe_interrupt (int irq, void *dev_id)
+toshoboe_interrupt (void *dev_id)
 {
   struct toshoboe_cb *self = dev_id;
   __u8 irqstat;
diff --git a/drivers/net/irda/irport.c b/drivers/net/irda/irport.c
index c79caa5..fa87524 100644
--- a/drivers/net/irda/irport.c
+++ b/drivers/net/irda/irport.c
@@ -87,7 +87,7 @@ static struct net_device_stats *irport_net_get_stats(struct net_device *dev);
 static int irport_change_speed_complete(struct irda_task *task);
 static void irport_timeout(struct net_device *dev);
 
-static irqreturn_t irport_interrupt(int irq, void *dev_id);
+static irqreturn_t irport_interrupt(void *dev_id);
 static int irport_hard_xmit(struct sk_buff *skb, struct net_device *dev);
 static void irport_change_speed(void *priv, __u32 speed);
 static int irport_net_open(struct net_device *dev);
@@ -761,7 +761,7 @@ static inline void irport_receive(struct irport_cb *self)
  *
  *    Interrupt handler
  */
-static irqreturn_t irport_interrupt(int irq, void *dev_id) 
+static irqreturn_t irport_interrupt(void *dev_id) 
 {
 	struct net_device *dev = dev_id;
 	struct irport_cb *self;
diff --git a/drivers/net/irda/irport.h b/drivers/net/irda/irport.h
index 3f46b84..5da7a35 100644
--- a/drivers/net/irda/irport.h
+++ b/drivers/net/irda/irport.h
@@ -74,7 +74,7 @@ struct irport_cb {
 	/* For piggyback drivers */
 	void *priv;                
 	void (*change_speed)(void *priv, __u32 speed);
-	irqreturn_t (*interrupt)(int irq, void *dev_id);
+	irqreturn_t (*interrupt)(void *dev_id);
 };
 
 #endif /* IRPORT_H */
diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
index 12b9378..4f9ea92 100644
--- a/drivers/net/irda/nsc-ircc.c
+++ b/drivers/net/irda/nsc-ircc.c
@@ -2068,7 +2068,7 @@ static void nsc_ircc_fir_interrupt(struct nsc_ircc_cb *self, int iobase,
  *    An interrupt from the chip has arrived. Time to do some work
  *
  */
-static irqreturn_t nsc_ircc_interrupt(int irq, void *dev_id)
+static irqreturn_t nsc_ircc_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct nsc_ircc_cb *self;
diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
index 8c09344..26f5ff6 100644
--- a/drivers/net/irda/pxaficp_ir.c
+++ b/drivers/net/irda/pxaficp_ir.c
@@ -222,7 +222,7 @@ static int pxa_irda_set_speed(struct pxa_irda *si, int speed)
 }
 
 /* SIR interrupt service routine. */
-static irqreturn_t pxa_irda_sir_irq(int irq, void *dev_id)
+static irqreturn_t pxa_irda_sir_irq(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct pxa_irda *si = netdev_priv(dev);
@@ -426,7 +426,7 @@ static void pxa_irda_fir_irq_eif(struct pxa_irda *si, struct net_device *dev, in
 }
 
 /* FIR interrupt handler */
-static irqreturn_t pxa_irda_fir_irq(int irq, void *dev_id)
+static irqreturn_t pxa_irda_fir_irq(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct pxa_irda *si = netdev_priv(dev);
diff --git a/drivers/net/irda/sa1100_ir.c b/drivers/net/irda/sa1100_ir.c
index 056639f..3b79304 100644
--- a/drivers/net/irda/sa1100_ir.c
+++ b/drivers/net/irda/sa1100_ir.c
@@ -579,7 +579,7 @@ static void sa1100_irda_fir_irq(struct net_device *dev)
 	sa1100_irda_rx_dma_start(si);
 }
 
-static irqreturn_t sa1100_irda_irq(int irq, void *dev_id)
+static irqreturn_t sa1100_irda_irq(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	if (IS_FIR(((struct sa1100_irda *)dev->priv)))
diff --git a/drivers/net/irda/vlsi_ir.c b/drivers/net/irda/vlsi_ir.c
index acd082a..7e88666 100644
--- a/drivers/net/irda/vlsi_ir.c
+++ b/drivers/net/irda/vlsi_ir.c
@@ -1455,7 +1455,7 @@ static int vlsi_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 
 /********************************************************/
 
-static irqreturn_t vlsi_interrupt(int irq, void *dev_instance)
+static irqreturn_t vlsi_interrupt(void *dev_instance)
 {
 	struct net_device *ndev = dev_instance;
 	vlsi_irda_dev_t *idev = ndev->priv;
diff --git a/drivers/net/irda/w83977af_ir.c b/drivers/net/irda/w83977af_ir.c
index 9fd2451..0ca43a3 100644
--- a/drivers/net/irda/w83977af_ir.c
+++ b/drivers/net/irda/w83977af_ir.c
@@ -1112,7 +1112,7 @@ static __u8 w83977af_fir_interrupt(struct w83977af_ir *self, int isr)
  *    An interrupt from the chip has arrived. Time to do some work
  *
  */
-static irqreturn_t w83977af_interrupt(int irq, void *dev_id)
+static irqreturn_t w83977af_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct w83977af_ir *self;
diff --git a/drivers/net/isa-skeleton.c b/drivers/net/isa-skeleton.c
index d6ff26a..e3c6a11 100644
--- a/drivers/net/isa-skeleton.c
+++ b/drivers/net/isa-skeleton.c
@@ -107,7 +107,7 @@ struct net_local {
 static int	netcard_probe1(struct net_device *dev, int ioaddr);
 static int	net_open(struct net_device *dev);
 static int	net_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t net_interrupt(int irq, void *dev_id);
+static irqreturn_t net_interrupt(void *dev_id);
 static void	net_rx(struct net_device *dev);
 static int	net_close(struct net_device *dev);
 static struct	net_device_stats *net_get_stats(struct net_device *dev);
@@ -505,7 +505,7 @@ void net_tx(struct net_device *dev)
  * The typical workload of the driver:
  * Handle the network interface interrupts.
  */
-static irqreturn_t net_interrupt(int irq, void *dev_id)
+static irqreturn_t net_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct net_local *np;
diff --git a/drivers/net/ixgb/ixgb_main.c b/drivers/net/ixgb/ixgb_main.c
index d444de5..b8c0cf7 100644
--- a/drivers/net/ixgb/ixgb_main.c
+++ b/drivers/net/ixgb/ixgb_main.c
@@ -93,7 +93,7 @@ static int ixgb_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
 static struct net_device_stats *ixgb_get_stats(struct net_device *netdev);
 static int ixgb_change_mtu(struct net_device *netdev, int new_mtu);
 static int ixgb_set_mac(struct net_device *netdev, void *p);
-static irqreturn_t ixgb_intr(int irq, void *data);
+static irqreturn_t ixgb_intr(void *data);
 static boolean_t ixgb_clean_tx_irq(struct ixgb_adapter *adapter);
 
 #ifdef CONFIG_IXGB_NAPI
@@ -1726,7 +1726,7 @@ ixgb_update_stats(struct ixgb_adapter *adapter)
  **/
 
 static irqreturn_t
-ixgb_intr(int irq, void *data)
+ixgb_intr(void *data)
 {
 	struct net_device *netdev = data;
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
@@ -2246,7 +2246,7 @@ static void ixgb_netpoll(struct net_device *dev)
 	struct ixgb_adapter *adapter = netdev_priv(dev);
 
 	disable_irq(adapter->pdev->irq);
-	ixgb_intr(adapter->pdev->irq, dev);
+	ixgb_intr(dev);
 	enable_irq(adapter->pdev->irq);
 }
 #endif
diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index b75f1c6..a53bcb0 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -524,7 +524,7 @@ static void ixgbe_configure_msix(struct ixgbe_adapter *adapter)
 	IXGBE_WRITE_REG(&adapter->hw, IXGBE_EITR(vector), 1950);
 }
 
-static irqreturn_t ixgbe_msix_lsc(int irq, void *data)
+static irqreturn_t ixgbe_msix_lsc(void *data)
 {
 	struct net_device *netdev = data;
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
@@ -541,7 +541,7 @@ static irqreturn_t ixgbe_msix_lsc(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t ixgbe_msix_clean_tx(int irq, void *data)
+static irqreturn_t ixgbe_msix_clean_tx(void *data)
 {
 	struct ixgbe_ring *txr = data;
 	struct ixgbe_adapter *adapter = txr->adapter;
@@ -551,7 +551,7 @@ static irqreturn_t ixgbe_msix_clean_tx(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t ixgbe_msix_clean_rx(int irq, void *data)
+static irqreturn_t ixgbe_msix_clean_rx(void *data)
 {
 	struct ixgbe_ring *rxr = data;
 	struct ixgbe_adapter *adapter = rxr->adapter;
@@ -694,7 +694,7 @@ out:
  * @data: pointer to a network interface device structure
  * @pt_regs: CPU registers structure
  **/
-static irqreturn_t ixgbe_intr(int irq, void *data)
+static irqreturn_t ixgbe_intr(void *data)
 {
 	struct net_device *netdev = data;
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
@@ -733,7 +733,7 @@ static int ixgbe_request_irq(struct ixgbe_adapter *adapter, u32 *num_rx_queues)
 {
 	struct net_device *netdev = adapter->netdev;
 	int flags, err;
-	irqreturn_t(*handler) (int, void *) = &ixgbe_intr;
+	irqreturn_t(*handler) (void *) = &ixgbe_intr;
 
 	flags = IRQF_SHARED;
 
@@ -2484,7 +2484,7 @@ static void ixgbe_netpoll(struct net_device *netdev)
 
 	disable_irq(adapter->pdev->irq);
 	adapter->flags |= IXGBE_FLAG_IN_NETPOLL;
-	ixgbe_intr(adapter->pdev->irq, netdev);
+	ixgbe_intr(netdev);
 	adapter->flags &= ~IXGBE_FLAG_IN_NETPOLL;
 	enable_irq(adapter->pdev->irq);
 }
diff --git a/drivers/net/ixp2000/ixpdev.c b/drivers/net/ixp2000/ixpdev.c
index 6c0dd49..e48f8a5 100644
--- a/drivers/net/ixp2000/ixpdev.c
+++ b/drivers/net/ixp2000/ixpdev.c
@@ -192,7 +192,7 @@ static void ixpdev_tx_complete(void)
 	}
 }
 
-static irqreturn_t ixpdev_interrupt(int irq, void *dev_id)
+static irqreturn_t ixpdev_interrupt(void *dev_id)
 {
 	u32 status;
 
@@ -230,7 +230,7 @@ static irqreturn_t ixpdev_interrupt(int irq, void *dev_id)
 static void ixpdev_poll_controller(struct net_device *dev)
 {
 	disable_irq(IRQ_IXP2000_THDA0);
-	ixpdev_interrupt(IRQ_IXP2000_THDA0, dev);
+	ixpdev_interrupt(dev);
 	enable_irq(IRQ_IXP2000_THDA0);
 }
 #endif
diff --git a/drivers/net/lance.c b/drivers/net/lance.c
index 977ed34..bce199e 100644
--- a/drivers/net/lance.c
+++ b/drivers/net/lance.c
@@ -302,7 +302,7 @@ static int lance_open(struct net_device *dev);
 static void lance_init_ring(struct net_device *dev, gfp_t mode);
 static int lance_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int lance_rx(struct net_device *dev);
-static irqreturn_t lance_interrupt(int irq, void *dev_id);
+static irqreturn_t lance_interrupt(void *dev_id);
 static int lance_close(struct net_device *dev);
 static struct net_device_stats *lance_get_stats(struct net_device *dev);
 static void set_multicast_list(struct net_device *dev);
@@ -1013,7 +1013,7 @@ out:
 }
 
 /* The LANCE interrupt handler. */
-static irqreturn_t lance_interrupt(int irq, void *dev_id)
+static irqreturn_t lance_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct lance_private *lp;
diff --git a/drivers/net/lguest_net.c b/drivers/net/lguest_net.c
index abce2ee..08a196c 100644
--- a/drivers/net/lguest_net.c
+++ b/drivers/net/lguest_net.c
@@ -315,7 +315,7 @@ static int fill_slot(struct net_device *dev, unsigned int slot)
 
 /* This is the actual receive routine.  When we receive an interrupt from the
  * Host to tell us a packet has been delivered, we arrive here: */
-static irqreturn_t lguestnet_rcv(int irq, void *dev_id)
+static irqreturn_t lguestnet_rcv(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct lguestnet_info *info = netdev_priv(dev);
diff --git a/drivers/net/lib8390.c b/drivers/net/lib8390.c
index c429a50..eaf1701 100644
--- a/drivers/net/lib8390.c
+++ b/drivers/net/lib8390.c
@@ -434,7 +434,7 @@ static int ei_start_xmit(struct sk_buff *skb, struct net_device *dev)
  * needed.
  */
 
-static irqreturn_t __ei_interrupt(int irq, void *dev_id)
+static irqreturn_t __ei_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	unsigned long e8390_base = dev->base_addr;
@@ -531,7 +531,7 @@ static irqreturn_t __ei_interrupt(int irq, void *dev_id)
 static void __ei_poll(struct net_device *dev)
 {
 	disable_irq_lockdep(dev->irq);
-	__ei_interrupt(dev->irq, dev);
+	__ei_interrupt(dev);
 	enable_irq_lockdep(dev->irq);
 }
 #endif
diff --git a/drivers/net/lp486e.c b/drivers/net/lp486e.c
index c5095ec..d72d781 100644
--- a/drivers/net/lp486e.c
+++ b/drivers/net/lp486e.c
@@ -378,7 +378,7 @@ static char init_setup[14] = {
 
 static int i596_open(struct net_device *dev);
 static int i596_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t i596_interrupt(int irq, void *dev_id);
+static irqreturn_t i596_interrupt(void *dev_id);
 static int i596_close(struct net_device *dev);
 static void i596_add_cmd(struct net_device *dev, struct i596_cmd *cmd);
 static void print_eth(char *);
@@ -1144,7 +1144,7 @@ i596_handle_CU_completion(struct net_device *dev,
 }
 
 static irqreturn_t
-i596_interrupt (int irq, void *dev_instance) {
+i596_interrupt (void *dev_instance) {
 	struct net_device *dev = (struct net_device *) dev_instance;
 	struct i596_private *lp;
 	unsigned short status, ack_cmd = 0;
diff --git a/drivers/net/mac89x0.c b/drivers/net/mac89x0.c
index 30854f0..7ed6cbc 100644
--- a/drivers/net/mac89x0.c
+++ b/drivers/net/mac89x0.c
@@ -129,7 +129,7 @@ extern void reset_chip(struct net_device *dev);
 #endif
 static int net_open(struct net_device *dev);
 static int net_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t net_interrupt(int irq, void *dev_id);
+static irqreturn_t net_interrupt(void *dev_id);
 static void set_multicast_list(struct net_device *dev);
 static void net_rx(struct net_device *dev);
 static int net_close(struct net_device *dev);
@@ -411,7 +411,7 @@ net_send_packet(struct sk_buff *skb, struct net_device *dev)
 
 /* The typical workload of the driver:
    Handle the network interface interrupts. */
-static irqreturn_t net_interrupt(int irq, void *dev_id)
+static irqreturn_t net_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct net_local *lp;
diff --git a/drivers/net/mace.c b/drivers/net/mace.c
index 95ebe72..a24c43c 100644
--- a/drivers/net/mace.c
+++ b/drivers/net/mace.c
@@ -80,9 +80,9 @@ static int mace_xmit_start(struct sk_buff *skb, struct net_device *dev);
 static void mace_set_multicast(struct net_device *dev);
 static void mace_reset(struct net_device *dev);
 static int mace_set_address(struct net_device *dev, void *addr);
-static irqreturn_t mace_interrupt(int irq, void *dev_id);
-static irqreturn_t mace_txdma_intr(int irq, void *dev_id);
-static irqreturn_t mace_rxdma_intr(int irq, void *dev_id);
+static irqreturn_t mace_interrupt(void *dev_id);
+static irqreturn_t mace_txdma_intr(void *dev_id);
+static irqreturn_t mace_rxdma_intr(void *dev_id);
 static void mace_set_timeout(struct net_device *dev);
 static void mace_tx_timeout(unsigned long data);
 static inline void dbdma_reset(volatile struct dbdma_regs __iomem *dma);
@@ -653,7 +653,7 @@ static void mace_handle_misc_intrs(struct mace_data *mp, int intr, struct net_de
 	    printk(KERN_DEBUG "mace: jabbering transceiver\n");
 }
 
-static irqreturn_t mace_interrupt(int irq, void *dev_id)
+static irqreturn_t mace_interrupt(void *dev_id)
 {
     struct net_device *dev = (struct net_device *) dev_id;
     struct mace_data *mp = (struct mace_data *) dev->priv;
@@ -865,12 +865,12 @@ out:
     spin_unlock_irqrestore(&mp->lock, flags);
 }
 
-static irqreturn_t mace_txdma_intr(int irq, void *dev_id)
+static irqreturn_t mace_txdma_intr(void *dev_id)
 {
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t mace_rxdma_intr(int irq, void *dev_id)
+static irqreturn_t mace_rxdma_intr(void *dev_id)
 {
     struct net_device *dev = (struct net_device *) dev_id;
     struct mace_data *mp = (struct mace_data *) dev->priv;
diff --git a/drivers/net/macmace.c b/drivers/net/macmace.c
index 1877052..f50c344 100644
--- a/drivers/net/macmace.c
+++ b/drivers/net/macmace.c
@@ -94,8 +94,8 @@ static int mace_xmit_start(struct sk_buff *skb, struct net_device *dev);
 static void mace_set_multicast(struct net_device *dev);
 static int mace_set_address(struct net_device *dev, void *addr);
 static void mace_reset(struct net_device *dev);
-static irqreturn_t mace_interrupt(int irq, void *dev_id);
-static irqreturn_t mace_dma_intr(int irq, void *dev_id);
+static irqreturn_t mace_interrupt(void *dev_id);
+static irqreturn_t mace_dma_intr(void *dev_id);
 static void mace_tx_timeout(struct net_device *dev);
 static void __mace_set_address(struct net_device *dev, void *addr);
 
@@ -560,7 +560,7 @@ static void mace_handle_misc_intrs(struct net_device *dev, int intr)
 			printk(KERN_DEBUG "macmace: jabbering transceiver\n");
 }
 
-static irqreturn_t mace_interrupt(int irq, void *dev_id)
+static irqreturn_t mace_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct mace_data *mp = netdev_priv(dev);
@@ -684,7 +684,7 @@ static void mace_dma_rx_frame(struct net_device *dev, struct mace_frame *mf)
  * The PSC has passed us a DMA interrupt event.
  */
 
-static irqreturn_t mace_dma_intr(int irq, void *dev_id)
+static irqreturn_t mace_dma_intr(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct mace_data *mp = netdev_priv(dev);
diff --git a/drivers/net/meth.c b/drivers/net/meth.c
index e25dbab..48d11fa 100644
--- a/drivers/net/meth.c
+++ b/drivers/net/meth.c
@@ -87,7 +87,7 @@ struct meth_private {
 };
 
 static void meth_tx_timeout(struct net_device *dev);
-static irqreturn_t meth_interrupt(int irq, void *dev_id);
+static irqreturn_t meth_interrupt(void *dev_id);
 
 /* global, initialized in ip32-setup.c */
 char o2meth_eaddr[8]={0,0,0,0,0,0,0,0};
@@ -563,7 +563,7 @@ static void meth_error(struct net_device* dev, unsigned status)
 /*
  * The typical interrupt entry point
  */
-static irqreturn_t meth_interrupt(int irq, void *dev_id)
+static irqreturn_t meth_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct meth_private *priv = netdev_priv(dev);
diff --git a/drivers/net/mipsnet.c b/drivers/net/mipsnet.c
index 37707a0..7bb8f6f 100644
--- a/drivers/net/mipsnet.c
+++ b/drivers/net/mipsnet.c
@@ -104,7 +104,7 @@ static inline ssize_t mipsnet_get_fromdev(struct net_device *dev, size_t count)
 	return count;
 }
 
-static irqreturn_t mipsnet_interrupt(int irq, void *dev_id)
+static irqreturn_t mipsnet_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 
diff --git a/drivers/net/mlx4/eq.c b/drivers/net/mlx4/eq.c
index 9c36c20..41cd70e 100644
--- a/drivers/net/mlx4/eq.c
+++ b/drivers/net/mlx4/eq.c
@@ -253,7 +253,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 	return eqes_found;
 }
 
-static irqreturn_t mlx4_interrupt(int irq, void *dev_ptr)
+static irqreturn_t mlx4_interrupt(void *dev_ptr)
 {
 	struct mlx4_dev *dev = dev_ptr;
 	struct mlx4_priv *priv = mlx4_priv(dev);
@@ -268,7 +268,7 @@ static irqreturn_t mlx4_interrupt(int irq, void *dev_ptr)
 	return IRQ_RETVAL(work);
 }
 
-static irqreturn_t mlx4_msi_x_interrupt(int irq, void *eq_ptr)
+static irqreturn_t mlx4_msi_x_interrupt(void *eq_ptr)
 {
 	struct mlx4_eq  *eq  = eq_ptr;
 	struct mlx4_dev *dev = eq->dev;
diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index 84f2d63..88d1ac2 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -514,7 +514,7 @@ static void mv643xx_eth_update_pscr(struct net_device *dev,
  * Output :	N/A
  */
 
-static irqreturn_t mv643xx_eth_int_handler(int irq, void *dev_id)
+static irqreturn_t mv643xx_eth_int_handler(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct mv643xx_private *mp = netdev_priv(dev);
@@ -1237,7 +1237,7 @@ static void mv643xx_netpoll(struct net_device *netdev)
 	/* wait for previous write to complete */
 	mv_read(MV643XX_ETH_INTERRUPT_MASK_REG(port_num));
 
-	mv643xx_eth_int_handler(netdev->irq, netdev);
+	mv643xx_eth_int_handler(netdev);
 
 	mv_write(MV643XX_ETH_INTERRUPT_MASK_REG(port_num), ETH_INT_UNMASK_ALL);
 }
diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index 366e62a..8bd4bbe 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -1246,7 +1246,7 @@ static int myri10ge_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static irqreturn_t myri10ge_intr(int irq, void *arg)
+static irqreturn_t myri10ge_intr(void *arg)
 {
 	struct myri10ge_priv *mgp = arg;
 	struct mcp_irq_data *stats = mgp->fw_stats;
diff --git a/drivers/net/myri_sbus.c b/drivers/net/myri_sbus.c
index 8d29319..7e5b6aa 100644
--- a/drivers/net/myri_sbus.c
+++ b/drivers/net/myri_sbus.c
@@ -529,7 +529,7 @@ static void myri_rx(struct myri_eth *mp, struct net_device *dev)
 	}
 }
 
-static irqreturn_t myri_interrupt(int irq, void *dev_id)
+static irqreturn_t myri_interrupt(void *dev_id)
 {
 	struct net_device *dev		= (struct net_device *) dev_id;
 	struct myri_eth *mp		= (struct myri_eth *) dev->priv;
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 50e1ec6..5ebcdac 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -636,7 +636,7 @@ static void free_ring(struct net_device *dev);
 static void reinit_ring(struct net_device *dev);
 static void init_registers(struct net_device *dev);
 static int start_tx(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t intr_handler(int irq, void *dev_instance);
+static irqreturn_t intr_handler(void *dev_instance);
 static void netdev_error(struct net_device *dev, int intr_status);
 static int natsemi_poll(struct napi_struct *napi, int budget);
 static void netdev_rx(struct net_device *dev, int *work_done, int work_to_do);
@@ -2180,7 +2180,7 @@ static void netdev_tx_done(struct net_device *dev)
 
 /* The interrupt handler doesn't actually handle interrupts itself, it
  * schedules a NAPI poll if there is anything to do. */
-static irqreturn_t intr_handler(int irq, void *dev_instance)
+static irqreturn_t intr_handler(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct netdev_private *np = netdev_priv(dev);
@@ -2480,7 +2480,7 @@ static struct net_device_stats *get_stats(struct net_device *dev)
 static void natsemi_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	intr_handler(dev->irq, dev);
+	intr_handler(dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/netx-eth.c b/drivers/net/netx-eth.c
index eb0aff7..8475ce7 100644
--- a/drivers/net/netx-eth.c
+++ b/drivers/net/netx-eth.c
@@ -174,7 +174,7 @@ static void netx_eth_receive(struct net_device *ndev)
 }
 
 static irqreturn_t
-netx_eth_interrupt(int irq, void *dev_id)
+netx_eth_interrupt(void *dev_id)
 {
 	struct net_device *ndev = dev_id;
 	struct netx_eth_priv *priv = netdev_priv(ndev);
diff --git a/drivers/net/ni5010.c b/drivers/net/ni5010.c
index 14a768f..c673b59 100644
--- a/drivers/net/ni5010.c
+++ b/drivers/net/ni5010.c
@@ -98,7 +98,7 @@ struct ni5010_local {
 static int	ni5010_probe1(struct net_device *dev, int ioaddr);
 static int	ni5010_open(struct net_device *dev);
 static int	ni5010_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t ni5010_interrupt(int irq, void *dev_id);
+static irqreturn_t ni5010_interrupt(void *dev_id);
 static void	ni5010_rx(struct net_device *dev);
 static void	ni5010_timeout(struct net_device *dev);
 static int	ni5010_close(struct net_device *dev);
@@ -465,7 +465,7 @@ static int ni5010_send_packet(struct sk_buff *skb, struct net_device *dev)
  * The typical workload of the driver:
  * Handle the network interface interrupts.
  */
-static irqreturn_t ni5010_interrupt(int irq, void *dev_id)
+static irqreturn_t ni5010_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct ni5010_local *lp;
diff --git a/drivers/net/ni52.c b/drivers/net/ni52.c
index 6b3384a..2f4dae5 100644
--- a/drivers/net/ni52.c
+++ b/drivers/net/ni52.c
@@ -193,7 +193,7 @@ sizeof(nop_cmd) = 8;
 #define NI52_ADDR2 0x01
 
 static int     ni52_probe1(struct net_device *dev,int ioaddr);
-static irqreturn_t ni52_interrupt(int irq,void *dev_id);
+static irqreturn_t ni52_interrupt(void *dev_id);
 static int     ni52_open(struct net_device *dev);
 static int     ni52_close(struct net_device *dev);
 static int     ni52_send_packet(struct sk_buff *,struct net_device *);
@@ -833,7 +833,7 @@ static void *alloc_rfa(struct net_device *dev,void *ptr)
  * Interrupt Handler ...
  */
 
-static irqreturn_t ni52_interrupt(int irq,void *dev_id)
+static irqreturn_t ni52_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	unsigned short stat;
diff --git a/drivers/net/ni65.c b/drivers/net/ni65.c
index 3edc971..12d2b1c 100644
--- a/drivers/net/ni65.c
+++ b/drivers/net/ni65.c
@@ -248,7 +248,7 @@ struct priv
 };
 
 static int  ni65_probe1(struct net_device *dev,int);
-static irqreturn_t ni65_interrupt(int irq, void * dev_id);
+static irqreturn_t ni65_interrupt(void *dev_id);
 static void ni65_recv_intr(struct net_device *dev,int);
 static void ni65_xmit_intr(struct net_device *dev,int);
 static int  ni65_open(struct net_device *dev);
@@ -869,7 +869,7 @@ static int ni65_lance_reinit(struct net_device *dev)
 /*
  * interrupt handler
  */
-static irqreturn_t ni65_interrupt(int irq, void * dev_id)
+static irqreturn_t ni65_interrupt(void *dev_id)
 {
 	int csr0 = 0;
 	struct net_device *dev = dev_id;
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index ed1f9bb..bb57df2 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -2870,7 +2870,7 @@ static void niu_schedule_napi(struct niu *np, struct niu_ldg *lp,
 	}
 }
 
-static irqreturn_t niu_interrupt(int irq, void *dev_id)
+static irqreturn_t niu_interrupt(void *dev_id)
 {
 	struct niu_ldg *lp = dev_id;
 	struct niu *np = lp->np;
diff --git a/drivers/net/ns83820.c b/drivers/net/ns83820.c
index ea71f6d..dc7bd56 100644
--- a/drivers/net/ns83820.c
+++ b/drivers/net/ns83820.c
@@ -1422,7 +1422,7 @@ static void ns83820_mib_isr(struct ns83820 *dev)
 }
 
 static void ns83820_do_isr(struct net_device *ndev, u32 isr);
-static irqreturn_t ns83820_irq(int foo, void *data)
+static irqreturn_t ns83820_irq(void *data)
 {
 	struct net_device *ndev = data;
 	struct ns83820 *dev = PRIV(ndev);
diff --git a/drivers/net/pci-skeleton.c b/drivers/net/pci-skeleton.c
index ed402e0..829a56d 100644
--- a/drivers/net/pci-skeleton.c
+++ b/drivers/net/pci-skeleton.c
@@ -501,7 +501,7 @@ static void netdrv_tx_timeout (struct net_device *dev);
 static void netdrv_init_ring (struct net_device *dev);
 static int netdrv_start_xmit (struct sk_buff *skb,
 			       struct net_device *dev);
-static irqreturn_t netdrv_interrupt (int irq, void *dev_instance);
+static irqreturn_t netdrv_interrupt (void *dev_instance);
 static int netdrv_close (struct net_device *dev);
 static int netdrv_ioctl (struct net_device *dev, struct ifreq *rq, int cmd);
 static void netdrv_set_rx_mode (struct net_device *dev);
@@ -1645,7 +1645,7 @@ static void netdrv_weird_interrupt (struct net_device *dev,
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-static irqreturn_t netdrv_interrupt (int irq, void *dev_instance)
+static irqreturn_t netdrv_interrupt (void *dev_instance)
 {
 	struct net_device *dev = (struct net_device *) dev_instance;
 	struct netdrv_private *tp = dev->priv;
diff --git a/drivers/net/pcmcia/3c574_cs.c b/drivers/net/pcmcia/3c574_cs.c
index 73dcbb7..48439de 100644
--- a/drivers/net/pcmcia/3c574_cs.c
+++ b/drivers/net/pcmcia/3c574_cs.c
@@ -238,7 +238,7 @@ static void tc574_reset(struct net_device *dev);
 static void media_check(unsigned long arg);
 static int el3_open(struct net_device *dev);
 static int el3_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t el3_interrupt(int irq, void *dev_id);
+static irqreturn_t el3_interrupt(void *dev_id);
 static void update_stats(struct net_device *dev);
 static struct net_device_stats *el3_get_stats(struct net_device *dev);
 static int el3_rx(struct net_device *dev, int worklimit);
@@ -806,7 +806,7 @@ static int el3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 }
 
 /* The EL3 interrupt handler. */
-static irqreturn_t el3_interrupt(int irq, void *dev_id)
+static irqreturn_t el3_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct el3_private *lp = netdev_priv(dev);
@@ -916,7 +916,7 @@ static void media_check(unsigned long arg)
 	if ((inw(ioaddr + EL3_STATUS) & IntLatch) && (inb(ioaddr + Timer) == 0xff)) {
 		if (!lp->fast_poll)
 			printk(KERN_INFO "%s: interrupt(s) dropped!\n", dev->name);
-		el3_interrupt(dev->irq, dev);
+		el3_interrupt(dev);
 		lp->fast_poll = HZ;
 	}
 	if (lp->fast_poll) {
diff --git a/drivers/net/pcmcia/3c589_cs.c b/drivers/net/pcmcia/3c589_cs.c
index 32076ca..e88da00 100644
--- a/drivers/net/pcmcia/3c589_cs.c
+++ b/drivers/net/pcmcia/3c589_cs.c
@@ -151,7 +151,7 @@ static void media_check(unsigned long arg);
 static int el3_config(struct net_device *dev, struct ifmap *map);
 static int el3_open(struct net_device *dev);
 static int el3_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t el3_interrupt(int irq, void *dev_id);
+static irqreturn_t el3_interrupt(void *dev_id);
 static void update_stats(struct net_device *dev);
 static struct net_device_stats *el3_get_stats(struct net_device *dev);
 static int el3_rx(struct net_device *dev);
@@ -636,7 +636,7 @@ static int el3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 }
 
 /* The EL3 interrupt handler. */
-static irqreturn_t el3_interrupt(int irq, void *dev_id)
+static irqreturn_t el3_interrupt(void *dev_id)
 {
     struct net_device *dev = (struct net_device *) dev_id;
     struct el3_private *lp = netdev_priv(dev);
@@ -738,7 +738,7 @@ static void media_check(unsigned long arg)
 	(inb(ioaddr + EL3_TIMER) == 0xff)) {
 	if (!lp->fast_poll)
 	    printk(KERN_WARNING "%s: interrupt(s) dropped!\n", dev->name);
-	el3_interrupt(dev->irq, dev);
+	el3_interrupt(dev);
 	lp->fast_poll = HZ;
     }
     if (lp->fast_poll) {
diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index a95a2ca..4bb96a5 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -92,7 +92,7 @@ static int axnet_open(struct net_device *dev);
 static int axnet_close(struct net_device *dev);
 static int axnet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static const struct ethtool_ops netdev_ethtool_ops;
-static irqreturn_t ei_irq_wrapper(int irq, void *dev_id);
+static irqreturn_t ei_irq_wrapper(void *dev_id);
 static void ei_watchdog(u_long arg);
 static void axnet_reset_8390(struct net_device *dev);
 
@@ -112,7 +112,7 @@ static void axdev_setup(struct net_device *dev);
 static void AX88190_init(struct net_device *dev, int startp);
 static int ax_open(struct net_device *dev);
 static int ax_close(struct net_device *dev);
-static irqreturn_t ax_interrupt(int irq, void *dev_id);
+static irqreturn_t ax_interrupt(void *dev_id);
 
 /*====================================================================*/
 
@@ -599,11 +599,11 @@ static void axnet_reset_8390(struct net_device *dev)
 
 /*====================================================================*/
 
-static irqreturn_t ei_irq_wrapper(int irq, void *dev_id)
+static irqreturn_t ei_irq_wrapper(void *dev_id)
 {
     struct net_device *dev = dev_id;
     PRIV(dev)->stale = 0;
-    return ax_interrupt(irq, dev_id);
+    return ax_interrupt(dev_id);
 }
 
 static void ei_watchdog(u_long arg)
@@ -621,7 +621,7 @@ static void ei_watchdog(u_long arg)
     if (info->stale++ && (inb_p(nic_base + EN0_ISR) & ENISR_ALL)) {
 	if (!info->fast_poll)
 	    printk(KERN_INFO "%s: interrupt(s) dropped!\n", dev->name);
-	ei_irq_wrapper(dev->irq, dev);
+	ei_irq_wrapper(dev);
 	info->fast_poll = HZ;
     }
     if (info->fast_poll) {
@@ -1194,7 +1194,7 @@ static int ei_start_xmit(struct sk_buff *skb, struct net_device *dev)
  * needed.
  */
 
-static irqreturn_t ax_interrupt(int irq, void *dev_id)
+static irqreturn_t ax_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	long e8390_base;
diff --git a/drivers/net/pcmcia/nmclan_cs.c b/drivers/net/pcmcia/nmclan_cs.c
index a355a93..193f3b4 100644
--- a/drivers/net/pcmcia/nmclan_cs.c
+++ b/drivers/net/pcmcia/nmclan_cs.c
@@ -426,7 +426,7 @@ static int mace_open(struct net_device *dev);
 static int mace_close(struct net_device *dev);
 static int mace_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static void mace_tx_timeout(struct net_device *dev);
-static irqreturn_t mace_interrupt(int irq, void *dev_id);
+static irqreturn_t mace_interrupt(void *dev_id);
 static struct net_device_stats *mace_get_stats(struct net_device *dev);
 static int mace_rx(struct net_device *dev, unsigned char RxCnt);
 static void restore_multicast_list(struct net_device *dev);
@@ -992,7 +992,7 @@ static int mace_start_xmit(struct sk_buff *skb, struct net_device *dev)
 mace_interrupt
 	The interrupt handler.
 ---------------------------------------------------------------------------- */
-static irqreturn_t mace_interrupt(int irq, void *dev_id)
+static irqreturn_t mace_interrupt(void *dev_id)
 {
   struct net_device *dev = (struct net_device *) dev_id;
   mace_private *lp = netdev_priv(dev);
diff --git a/drivers/net/pcmcia/pcnet_cs.c b/drivers/net/pcmcia/pcnet_cs.c
index 9d45e96..8bdf95a 100644
--- a/drivers/net/pcmcia/pcnet_cs.c
+++ b/drivers/net/pcmcia/pcnet_cs.c
@@ -109,7 +109,7 @@ static int pcnet_open(struct net_device *dev);
 static int pcnet_close(struct net_device *dev);
 static int ei_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static const struct ethtool_ops netdev_ethtool_ops;
-static irqreturn_t ei_irq_wrapper(int irq, void *dev_id);
+static irqreturn_t ei_irq_wrapper(void *dev_id);
 static void ei_watchdog(u_long arg);
 static void pcnet_reset_8390(struct net_device *dev);
 static int set_config(struct net_device *dev, struct ifmap *map);
@@ -1056,11 +1056,11 @@ static int set_config(struct net_device *dev, struct ifmap *map)
 
 /*====================================================================*/
 
-static irqreturn_t ei_irq_wrapper(int irq, void *dev_id)
+static irqreturn_t ei_irq_wrapper(void *dev_id)
 {
     struct net_device *dev = dev_id;
     pcnet_dev_t *info;
-    irqreturn_t ret = ei_interrupt(irq, dev_id);
+    irqreturn_t ret = ei_interrupt(dev_id);
 
     if (ret == IRQ_HANDLED) {
 	    info = PRIV(dev);
@@ -1084,7 +1084,7 @@ static void ei_watchdog(u_long arg)
     if (info->stale++ && (inb_p(nic_base + EN0_ISR) & ENISR_ALL)) {
 	if (!info->fast_poll)
 	    printk(KERN_INFO "%s: interrupt(s) dropped!\n", dev->name);
-	ei_irq_wrapper(dev->irq, dev);
+	ei_irq_wrapper(dev);
 	info->fast_poll = HZ;
     }
     if (info->fast_poll) {
diff --git a/drivers/net/pcmcia/smc91c92_cs.c b/drivers/net/pcmcia/smc91c92_cs.c
index 58d716f..0fa3b8a 100644
--- a/drivers/net/pcmcia/smc91c92_cs.c
+++ b/drivers/net/pcmcia/smc91c92_cs.c
@@ -287,7 +287,7 @@ static int smc_close(struct net_device *dev);
 static int smc_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static void smc_tx_timeout(struct net_device *dev);
 static int smc_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t smc_interrupt(int irq, void *dev_id);
+static irqreturn_t smc_interrupt(void *dev_id);
 static void smc_rx(struct net_device *dev);
 static struct net_device_stats *smc_get_stats(struct net_device *dev);
 static void set_rx_mode(struct net_device *dev);
@@ -1509,7 +1509,7 @@ static void smc_eph_irq(struct net_device *dev)
 
 /*====================================================================*/
 
-static irqreturn_t smc_interrupt(int irq, void *dev_id)
+static irqreturn_t smc_interrupt(void *dev_id)
 {
     struct net_device *dev = dev_id;
     struct smc_private *smc = netdev_priv(dev);
@@ -1934,7 +1934,7 @@ static void media_check(u_long arg)
     if (smc->watchdog++ && ((i>>8) & i)) {
 	if (!smc->fast_poll)
 	    printk(KERN_INFO "%s: interrupt(s) dropped!\n", dev->name);
-	smc_interrupt(dev->irq, dev);
+	smc_interrupt(dev);
 	smc->fast_poll = HZ;
     }
     if (smc->fast_poll) {
diff --git a/drivers/net/pcmcia/xirc2ps_cs.c b/drivers/net/pcmcia/xirc2ps_cs.c
index c3b6960..a8e2448 100644
--- a/drivers/net/pcmcia/xirc2ps_cs.c
+++ b/drivers/net/pcmcia/xirc2ps_cs.c
@@ -308,7 +308,7 @@ static void xirc2ps_detach(struct pcmcia_device *p_dev);
  * less on other parts of the kernel.
  */
 
-static irqreturn_t xirc2ps_interrupt(int irq, void *dev_id);
+static irqreturn_t xirc2ps_interrupt(void *dev_id);
 
 /****************
  * A linked list of "instances" of the device.  Each actual
@@ -1100,7 +1100,7 @@ static int xirc2ps_resume(struct pcmcia_device *link)
  * This is the Interrupt service route.
  */
 static irqreturn_t
-xirc2ps_interrupt(int irq, void *dev_id)
+xirc2ps_interrupt(void *dev_id)
 {
     struct net_device *dev = (struct net_device *)dev_id;
     local_info_t *lp = netdev_priv(dev);
diff --git a/drivers/net/pcnet32.c b/drivers/net/pcnet32.c
index 5f994b5..b58adc2 100644
--- a/drivers/net/pcnet32.c
+++ b/drivers/net/pcnet32.c
@@ -306,7 +306,7 @@ static int pcnet32_open(struct net_device *);
 static int pcnet32_init_ring(struct net_device *);
 static int pcnet32_start_xmit(struct sk_buff *, struct net_device *);
 static void pcnet32_tx_timeout(struct net_device *dev);
-static irqreturn_t pcnet32_interrupt(int, void *);
+static irqreturn_t pcnet32_interrupt(void *);
 static int pcnet32_close(struct net_device *);
 static struct net_device_stats *pcnet32_get_stats(struct net_device *);
 static void pcnet32_load_multicast(struct net_device *dev);
@@ -682,7 +682,7 @@ static void pcnet32_purge_rx_ring(struct net_device *dev)
 static void pcnet32_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	pcnet32_interrupt(0, dev);
+	pcnet32_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
@@ -2558,7 +2558,7 @@ static int pcnet32_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 /* The PCNET32 interrupt handler. */
 static irqreturn_t
-pcnet32_interrupt(int irq, void *dev_id)
+pcnet32_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct pcnet32_private *lp;
diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index 30adf72..1b08646 100644
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -2336,7 +2336,7 @@ quit_polling:
 	return tx_cleaned + rx_cleaned;
 }
 
-static irqreturn_t ql3xxx_isr(int irq, void *dev_id)
+static irqreturn_t ql3xxx_isr(void *dev_id)
 {
 
 	struct net_device *ndev = dev_id;
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 419c00c..dc5e003 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -436,7 +436,7 @@ MODULE_VERSION(RTL8169_VERSION);
 
 static int rtl8169_open(struct net_device *dev);
 static int rtl8169_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance);
+static irqreturn_t rtl8169_interrupt(void *dev_instance);
 static int rtl8169_init_ring(struct net_device *dev);
 static void rtl_hw_start(struct net_device *dev);
 static int rtl8169_close(struct net_device *dev);
@@ -1328,7 +1328,7 @@ static void rtl8169_netpoll(struct net_device *dev)
 	struct pci_dev *pdev = tp->pci_dev;
 
 	disable_irq(pdev->irq);
-	rtl8169_interrupt(pdev->irq, dev);
+	rtl8169_interrupt(dev);
 	enable_irq(pdev->irq);
 }
 #endif
@@ -2752,7 +2752,7 @@ static int rtl8169_rx_interrupt(struct net_device *dev,
 	return count;
 }
 
-static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
+static irqreturn_t rtl8169_interrupt(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct rtl8169_private *tp = netdev_priv(dev);
diff --git a/drivers/net/rrunner.c b/drivers/net/rrunner.c
index 19152f5..0f60e9f 100644
--- a/drivers/net/rrunner.c
+++ b/drivers/net/rrunner.c
@@ -1046,7 +1046,7 @@ static void rx_int(struct net_device *dev, u32 rxlimit, u32 index)
 }
 
 
-static irqreturn_t rr_interrupt(int irq, void *dev_id)
+static irqreturn_t rr_interrupt(void *dev_id)
 {
 	struct rr_private *rrpriv;
 	struct rr_regs __iomem *regs;
diff --git a/drivers/net/rrunner.h b/drivers/net/rrunner.h
index 6a79825..c3daaa2 100644
--- a/drivers/net/rrunner.h
+++ b/drivers/net/rrunner.h
@@ -828,7 +828,7 @@ struct rr_private
  */
 static int rr_init(struct net_device *dev);
 static int rr_init1(struct net_device *dev);
-static irqreturn_t rr_interrupt(int irq, void *dev_id);
+static irqreturn_t rr_interrupt(void *dev_id);
 
 static int rr_open(struct net_device *dev);
 static int rr_start_xmit(struct sk_buff *skb, struct net_device *dev);
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 22e4054..abc24ba 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -3723,7 +3723,7 @@ static int s2io_enable_msi_x(struct s2io_nic *nic)
 }
 
 /* Handle software interrupt used during MSI(X) test */
-static irqreturn_t __devinit s2io_test_intr(int irq, void *dev_id)
+static irqreturn_t __devinit s2io_test_intr(void *dev_id)
 {
 	struct s2io_nic *sp = dev_id;
 
@@ -4134,7 +4134,7 @@ static int s2io_chk_rx_buffers(struct s2io_nic *sp, int rng_n)
 	return 0;
 }
 
-static irqreturn_t s2io_msix_ring_handle(int irq, void *dev_id)
+static irqreturn_t s2io_msix_ring_handle(void *dev_id)
 {
 	struct ring_info *ring = (struct ring_info *)dev_id;
 	struct s2io_nic *sp = ring->nic;
@@ -4148,7 +4148,7 @@ static irqreturn_t s2io_msix_ring_handle(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t s2io_msix_fifo_handle(int irq, void *dev_id)
+static irqreturn_t s2io_msix_fifo_handle(void *dev_id)
 {
 	struct fifo_info *fifo = (struct fifo_info *)dev_id;
 	struct s2io_nic *sp = fifo->nic;
@@ -4519,7 +4519,7 @@ reset:
  *   IRQ_HANDLED: will be returned if IRQ was handled by this routine
  *   IRQ_NONE: will be returned if interrupt is not from our device
  */
-static irqreturn_t s2io_isr(int irq, void *dev_id)
+static irqreturn_t s2io_isr(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct s2io_nic *sp = dev->priv;
diff --git a/drivers/net/s2io.h b/drivers/net/s2io.h
index f6b4556..f11b3de 100644
--- a/drivers/net/s2io.h
+++ b/drivers/net/s2io.h
@@ -1050,10 +1050,10 @@ static void s2io_init_pci(struct s2io_nic * sp);
 static int do_s2io_prog_unicast(struct net_device *dev, u8 *addr);
 static void s2io_alarm_handle(unsigned long data);
 static irqreturn_t
-s2io_msix_ring_handle(int irq, void *dev_id);
+s2io_msix_ring_handle(void *dev_id);
 static irqreturn_t
-s2io_msix_fifo_handle(int irq, void *dev_id);
-static irqreturn_t s2io_isr(int irq, void *dev_id);
+s2io_msix_fifo_handle(void *dev_id);
+static irqreturn_t s2io_isr(void *dev_id);
 static int verify_xena_quiescence(struct s2io_nic *sp);
 static const struct ethtool_ops netdev_ethtool_ops;
 static void s2io_set_link(struct work_struct *work);
diff --git a/drivers/net/saa9730.c b/drivers/net/saa9730.c
index c65199d..8b359c9 100644
--- a/drivers/net/saa9730.c
+++ b/drivers/net/saa9730.c
@@ -748,7 +748,7 @@ static int lan_saa9730_rx(struct net_device *dev)
 	return 0;
 }
 
-static irqreturn_t lan_saa9730_interrupt(const int irq, void *dev_id)
+static irqreturn_t lan_saa9730_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct lan_saa9730_private *lp = netdev_priv(dev);
diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
index 487f9d2..02de56f 100644
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -83,7 +83,7 @@ extern int sb1000_probe(struct net_device *dev);
 static int sb1000_open(struct net_device *dev);
 static int sb1000_dev_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd);
 static int sb1000_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t sb1000_interrupt(int irq, void *dev_id);
+static irqreturn_t sb1000_interrupt(void *dev_id);
 static int sb1000_close(struct net_device *dev);
 
 
@@ -1075,7 +1075,7 @@ sb1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 }
 
 /* SB1000 interrupt handler. */
-static irqreturn_t sb1000_interrupt(int irq, void *dev_id)
+static irqreturn_t sb1000_interrupt(void *dev_id)
 {
 	char *name;
 	unsigned char st;
diff --git a/drivers/net/sb1250-mac.c b/drivers/net/sb1250-mac.c
index 7b53d65..2b5a7c0 100644
--- a/drivers/net/sb1250-mac.c
+++ b/drivers/net/sb1250-mac.c
@@ -320,7 +320,7 @@ static enum sbmac_state sbmac_set_channel_state(struct sbmac_softc *,
 						enum sbmac_state);
 static void sbmac_promiscuous_mode(struct sbmac_softc *sc, int onoff);
 static uint64_t sbmac_addr2reg(unsigned char *ptr);
-static irqreturn_t sbmac_intr(int irq, void *dev_instance);
+static irqreturn_t sbmac_intr(void *dev_instance);
 static int sbmac_start_tx(struct sk_buff *skb, struct net_device *dev);
 static void sbmac_setmulti(struct sbmac_softc *sc);
 static int sbmac_init(struct platform_device *pldev, long long base);
@@ -2011,7 +2011,7 @@ static int sbmac_set_duplex(struct sbmac_softc *s, enum sbmac_duplex duplex,
  *  Return value:
  *  	   nothing
  ********************************************************************* */
-static irqreturn_t sbmac_intr(int irq,void *dev_instance)
+static irqreturn_t sbmac_intr(void *dev_instance)
 {
 	struct net_device *dev = (struct net_device *) dev_instance;
 	struct sbmac_softc *sc = netdev_priv(dev);
diff --git a/drivers/net/sc92031.c b/drivers/net/sc92031.c
index 37b4239..2074e14 100644
--- a/drivers/net/sc92031.c
+++ b/drivers/net/sc92031.c
@@ -886,7 +886,7 @@ out:
 	spin_unlock(&priv->lock);
 }
 
-static irqreturn_t sc92031_interrupt(int irq, void *dev_id)
+static irqreturn_t sc92031_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct sc92031_priv *priv = netdev_priv(dev);
@@ -1133,7 +1133,7 @@ static void sc92031_tx_timeout(struct net_device *dev)
 static void sc92031_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	if (sc92031_interrupt(dev->irq, dev) != IRQ_NONE)
+	if (sc92031_interrupt(dev) != IRQ_NONE)
 		sc92031_tasklet((unsigned long)dev);
 	enable_irq(dev->irq);
 }
diff --git a/drivers/net/seeq8005.c b/drivers/net/seeq8005.c
index 48c64fb..66e242a 100644
--- a/drivers/net/seeq8005.c
+++ b/drivers/net/seeq8005.c
@@ -82,7 +82,7 @@ static int seeq8005_probe1(struct net_device *dev, int ioaddr);
 static int seeq8005_open(struct net_device *dev);
 static void seeq8005_timeout(struct net_device *dev);
 static int seeq8005_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t seeq8005_interrupt(int irq, void *dev_id);
+static irqreturn_t seeq8005_interrupt(void *dev_id);
 static void seeq8005_rx(struct net_device *dev);
 static int seeq8005_close(struct net_device *dev);
 static void set_multicast_list(struct net_device *dev);
@@ -435,7 +435,7 @@ inline void wait_for_buffer(struct net_device * dev)
 
 /* The typical workload of the driver:
    Handle the network interface interrupts. */
-static irqreturn_t seeq8005_interrupt(int irq, void *dev_id)
+static irqreturn_t seeq8005_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct net_local *lp;
diff --git a/drivers/net/sgiseeq.c b/drivers/net/sgiseeq.c
index ff40563..f61953c 100644
--- a/drivers/net/sgiseeq.c
+++ b/drivers/net/sgiseeq.c
@@ -416,7 +416,7 @@ static inline void sgiseeq_tx(struct net_device *dev, struct sgiseeq_private *sp
 	}
 }
 
-static irqreturn_t sgiseeq_interrupt(int irq, void *dev_id)
+static irqreturn_t sgiseeq_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct sgiseeq_private *sp = netdev_priv(dev);
diff --git a/drivers/net/sis190.c b/drivers/net/sis190.c
index 7200883..8d2cefc 100644
--- a/drivers/net/sis190.c
+++ b/drivers/net/sis190.c
@@ -702,7 +702,7 @@ static void sis190_tx_interrupt(struct net_device *dev,
  * The interrupt handler does all of the Rx thread work and cleans up after
  * the Tx thread.
  */
-static irqreturn_t sis190_interrupt(int irq, void *__dev)
+static irqreturn_t sis190_interrupt(void *__dev)
 {
 	struct net_device *dev = __dev;
 	struct sis190_private *tp = netdev_priv(dev);
@@ -747,7 +747,7 @@ static void sis190_netpoll(struct net_device *dev)
 	struct pci_dev *pdev = tp->pci_dev;
 
 	disable_irq(pdev->irq);
-	sis190_interrupt(pdev->irq, dev);
+	sis190_interrupt(dev);
 	enable_irq(pdev->irq);
 }
 #endif
diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index 0857d2c..6f0bf9f 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -217,7 +217,7 @@ static void sis900_init_rx_ring(struct net_device *net_dev);
 static int sis900_start_xmit(struct sk_buff *skb, struct net_device *net_dev);
 static int sis900_rx(struct net_device *net_dev);
 static void sis900_finish_xmit (struct net_device *net_dev);
-static irqreturn_t sis900_interrupt(int irq, void *dev_instance);
+static irqreturn_t sis900_interrupt(void *dev_instance);
 static int sis900_close(struct net_device *net_dev);
 static int mii_ioctl(struct net_device *net_dev, struct ifreq *rq, int cmd);
 static u16 sis900_mcast_bitnr(u8 *addr, u8 revision);
@@ -983,7 +983,7 @@ static u16 sis900_reset_phy(struct net_device *net_dev, int phy_addr)
 static void sis900_poll(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	sis900_interrupt(dev->irq, dev);
+	sis900_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
@@ -1636,7 +1636,7 @@ sis900_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
  *	and cleans up after the Tx thread
  */
 
-static irqreturn_t sis900_interrupt(int irq, void *dev_instance)
+static irqreturn_t sis900_interrupt(void *dev_instance)
 {
 	struct net_device *net_dev = dev_instance;
 	struct sis900_private *sis_priv = net_dev->priv;
diff --git a/drivers/net/sk98lin/skge.c b/drivers/net/sk98lin/skge.c
index 20890e4..748168d 100644
--- a/drivers/net/sk98lin/skge.c
+++ b/drivers/net/sk98lin/skge.c
@@ -198,8 +198,8 @@ static SK_BOOL	BoardAllocMem(SK_AC *pAC);
 static void	BoardFreeMem(SK_AC *pAC);
 static void	BoardInitMem(SK_AC *pAC);
 static void	SetupRing(SK_AC*, void*, uintptr_t, RXD**, RXD**, RXD**, int*, SK_BOOL);
-static SkIsrRetVar	SkGeIsr(int irq, void *dev_id);
-static SkIsrRetVar	SkGeIsrOnePort(int irq, void *dev_id);
+static SkIsrRetVar	SkGeIsr(void *dev_id);
+static SkIsrRetVar	SkGeIsrOnePort(void *dev_id);
 static int	SkGeOpen(struct SK_NET_DEVICE *dev);
 static int	SkGeClose(struct SK_NET_DEVICE *dev);
 static int	SkGeXmit(struct sk_buff *skb, struct SK_NET_DEVICE *dev);
@@ -882,7 +882,7 @@ int	PortIndex)	/* index of the port for which to re-init */
  * Returns: N/A
  *
  */
-static SkIsrRetVar SkGeIsr(int irq, void *dev_id)
+static SkIsrRetVar SkGeIsr(void *dev_id)
 {
 struct SK_NET_DEVICE *dev = (struct SK_NET_DEVICE *)dev_id;
 DEV_NET		*pNet;
@@ -1031,7 +1031,7 @@ SK_U32		IntSrc;		/* interrupts source register contents */
  * Returns: N/A
  *
  */
-static SkIsrRetVar SkGeIsrOnePort(int irq, void *dev_id)
+static SkIsrRetVar SkGeIsrOnePort(void *dev_id)
 {
 struct SK_NET_DEVICE *dev = (struct SK_NET_DEVICE *)dev_id;
 DEV_NET		*pNet;
@@ -1142,7 +1142,7 @@ SK_U32		IntSrc;		/* interrupts source register contents */
 static void SkGePollController(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	SkGeIsr(dev->irq, dev);
+	SkGeIsr(dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/skfp/skfddi.c b/drivers/net/skfp/skfddi.c
index 7cf9b9f..55323f5 100644
--- a/drivers/net/skfp/skfddi.c
+++ b/drivers/net/skfp/skfddi.c
@@ -101,7 +101,7 @@ static const char * const boot_msg =
 static int skfp_driver_init(struct net_device *dev);
 static int skfp_open(struct net_device *dev);
 static int skfp_close(struct net_device *dev);
-static irqreturn_t skfp_interrupt(int irq, void *dev_id);
+static irqreturn_t skfp_interrupt(void *dev_id);
 static struct net_device_stats *skfp_ctl_get_stats(struct net_device *dev);
 static void skfp_ctl_set_multicast_list(struct net_device *dev);
 static void skfp_ctl_set_multicast_list_wo_lock(struct net_device *dev);
@@ -612,7 +612,7 @@ static int skfp_close(struct net_device *dev)
  *   Interrupts are disabled, then reenabled at the adapter.
  */
 
-irqreturn_t skfp_interrupt(int irq, void *dev_id)
+irqreturn_t skfp_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct s_smc *smc;	/* private board structure pointer */
diff --git a/drivers/net/skge.c b/drivers/net/skge.c
index b9961dc..8ee1e36 100644
--- a/drivers/net/skge.c
+++ b/drivers/net/skge.c
@@ -3373,7 +3373,7 @@ static void skge_extirq(unsigned long arg)
 	spin_unlock_irq(&hw->hw_lock);
 }
 
-static irqreturn_t skge_intr(int irq, void *dev_id)
+static irqreturn_t skge_intr(void *dev_id)
 {
 	struct skge_hw *hw = dev_id;
 	u32 status;
@@ -3447,7 +3447,7 @@ static void skge_netpoll(struct net_device *dev)
 	struct skge_port *skge = netdev_priv(dev);
 
 	disable_irq(dev->irq);
-	skge_intr(dev->irq, skge->hw);
+	skge_intr(skge->hw);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 70d7e47..a79b1e7 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -2636,7 +2636,7 @@ done:
 	return work_done;
 }
 
-static irqreturn_t sky2_intr(int irq, void *dev_id)
+static irqreturn_t sky2_intr(void *dev_id)
 {
 	struct sky2_hw *hw = dev_id;
 	u32 status;
@@ -4035,7 +4035,7 @@ static void __devinit sky2_show_addr(struct net_device *dev)
 }
 
 /* Handle software interrupt used during MSI test */
-static irqreturn_t __devinit sky2_test_intr(int irq, void *dev_id)
+static irqreturn_t __devinit sky2_test_intr(void *dev_id)
 {
 	struct sky2_hw *hw = dev_id;
 	u32 status = sky2_read32(hw, B0_Y2_SP_ISRC2);
diff --git a/drivers/net/smc-ultra.c b/drivers/net/smc-ultra.c
index 00d6cf1..191280b 100644
--- a/drivers/net/smc-ultra.c
+++ b/drivers/net/smc-ultra.c
@@ -127,7 +127,7 @@ MODULE_DEVICE_TABLE(isapnp, ultra_device_ids);
 static void ultra_poll(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	ei_interrupt(dev->irq, dev);
+	ei_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/smc911x.c b/drivers/net/smc911x.c
index 7c60df4..374e0a7 100644
--- a/drivers/net/smc911x.c
+++ b/drivers/net/smc911x.c
@@ -1069,7 +1069,7 @@ static void smc911x_phy_interrupt(struct net_device *dev)
  * This is the main routine of the driver, to handle the device when
  * it needs some attention.
  */
-static irqreturn_t smc911x_interrupt(int irq, void *dev_id)
+static irqreturn_t smc911x_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	unsigned long ioaddr = dev->base_addr;
@@ -1325,7 +1325,7 @@ smc911x_rx_dma_irq(int dma, void *data)
 static void smc911x_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	smc911x_interrupt(dev->irq, dev);
+	smc911x_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/smc9194.c b/drivers/net/smc9194.c
index cb2698d..a5716b1 100644
--- a/drivers/net/smc9194.c
+++ b/drivers/net/smc9194.c
@@ -257,7 +257,7 @@ static void smc_set_multicast_list(struct net_device *dev);
 /*
  . Handles the actual interrupt
 */
-static irqreturn_t smc_interrupt(int irq, void *);
+static irqreturn_t smc_interrupt(void *);
 /*
  . This is a separate procedure to handle the receipt of a packet, to
  . leave the interrupt code looking slightly cleaner
@@ -1372,7 +1372,7 @@ static void smc_tx( struct net_device * dev )
  .
  ---------------------------------------------------------------------*/
 
-static irqreturn_t smc_interrupt(int irq, void * dev_id)
+static irqreturn_t smc_interrupt(void *dev_id)
 {
 	struct net_device *dev 	= dev_id;
 	int ioaddr 		= dev->base_addr;
diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
index 7da7589..cbd77b1 100644
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -1235,7 +1235,7 @@ static void smc_eph_interrupt(struct net_device *dev)
  * This is the main routine of the driver, to handle the device when
  * it needs some attention.
  */
-static irqreturn_t smc_interrupt(int irq, void *dev_id)
+static irqreturn_t smc_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct smc_local *lp = netdev_priv(dev);
@@ -1351,7 +1351,7 @@ static irqreturn_t smc_interrupt(int irq, void *dev_id)
 static void smc_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	smc_interrupt(dev->irq, dev);
+	smc_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/sonic.c b/drivers/net/sonic.c
index 8069f3e..ee2f87b 100644
--- a/drivers/net/sonic.c
+++ b/drivers/net/sonic.c
@@ -272,7 +272,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
  * The typical workload of the driver:
  * Handle the network interface interrupts.
  */
-static irqreturn_t sonic_interrupt(int irq, void *dev_id)
+static irqreturn_t sonic_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct sonic_local *lp = netdev_priv(dev);
diff --git a/drivers/net/sonic.h b/drivers/net/sonic.h
index 7db13e4..562ff7e 100644
--- a/drivers/net/sonic.h
+++ b/drivers/net/sonic.h
@@ -328,7 +328,7 @@ struct sonic_local {
 
 static int sonic_open(struct net_device *dev);
 static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t sonic_interrupt(int irq, void *dev_id);
+static irqreturn_t sonic_interrupt(void *dev_id);
 static void sonic_rx(struct net_device *dev);
 static int sonic_close(struct net_device *dev);
 static struct net_device_stats *sonic_get_stats(struct net_device *dev);
diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index fab055f..0eb3cc3 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -1650,7 +1650,7 @@ spider_net_handle_error_irq(struct spider_net_card *card, u32 status_reg)
  * interrupts for this device and makes the stack poll the driver
  */
 static irqreturn_t
-spider_net_interrupt(int irq, void *ptr)
+spider_net_interrupt(void *ptr)
 {
 	struct net_device *netdev = ptr;
 	struct spider_net_card *card = netdev_priv(netdev);
@@ -1693,7 +1693,7 @@ static void
 spider_net_poll_controller(struct net_device *netdev)
 {
 	disable_irq(netdev->irq);
-	spider_net_interrupt(netdev->irq, netdev);
+	spider_net_interrupt(netdev);
 	enable_irq(netdev->irq);
 }
 #endif /* CONFIG_NET_POLL_CONTROLLER */
diff --git a/drivers/net/starfire.c b/drivers/net/starfire.c
index bcc430b..c91d8db 100644
--- a/drivers/net/starfire.c
+++ b/drivers/net/starfire.c
@@ -632,7 +632,7 @@ static void	check_duplex(struct net_device *dev);
 static void	tx_timeout(struct net_device *dev);
 static void	init_ring(struct net_device *dev);
 static int	start_tx(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t intr_handler(int irq, void *dev_instance);
+static irqreturn_t intr_handler(void *dev_instance);
 static void	netdev_error(struct net_device *dev, int intr_status);
 static int	__netdev_rx(struct net_device *dev, int *quota);
 static void	refill_rx_ring(struct net_device *dev);
@@ -1308,7 +1308,7 @@ static int start_tx(struct sk_buff *skb, struct net_device *dev)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-static irqreturn_t intr_handler(int irq, void *dev_instance)
+static irqreturn_t intr_handler(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct netdev_private *np = netdev_priv(dev);
diff --git a/drivers/net/sun3_82586.c b/drivers/net/sun3_82586.c
index 9b2a7f7..12c721d 100644
--- a/drivers/net/sun3_82586.c
+++ b/drivers/net/sun3_82586.c
@@ -120,7 +120,7 @@ sizeof(nop_cmd) = 8;
      DELAY_16(); DELAY_16(); } }
 
 static int     sun3_82586_probe1(struct net_device *dev,int ioaddr);
-static irqreturn_t sun3_82586_interrupt(int irq,void *dev_id);
+static irqreturn_t sun3_82586_interrupt(void *dev_id);
 static int     sun3_82586_open(struct net_device *dev);
 static int     sun3_82586_close(struct net_device *dev);
 static int     sun3_82586_send_packet(struct sk_buff *,struct net_device *);
@@ -675,7 +675,7 @@ static void *alloc_rfa(struct net_device *dev,void *ptr)
  * Interrupt Handler ...
  */
 
-static irqreturn_t sun3_82586_interrupt(int irq,void *dev_id)
+static irqreturn_t sun3_82586_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	unsigned short stat;
diff --git a/drivers/net/sun3lance.c b/drivers/net/sun3lance.c
index f8d4613..d6d4eb9 100644
--- a/drivers/net/sun3lance.c
+++ b/drivers/net/sun3lance.c
@@ -237,7 +237,7 @@ static int lance_probe( struct net_device *dev);
 static int lance_open( struct net_device *dev );
 static void lance_init_ring( struct net_device *dev );
 static int lance_start_xmit( struct sk_buff *skb, struct net_device *dev );
-static irqreturn_t lance_interrupt( int irq, void *dev_id);
+static irqreturn_t lance_interrupt(void *dev_id);
 static int lance_rx( struct net_device *dev );
 static int lance_close( struct net_device *dev );
 static void set_multicast_list( struct net_device *dev );
@@ -646,7 +646,7 @@ static int lance_start_xmit( struct sk_buff *skb, struct net_device *dev )
 
 /* The LANCE interrupt handler. */
 
-static irqreturn_t lance_interrupt( int irq, void *dev_id)
+static irqreturn_t lance_interrupt( void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct lance_private *lp = netdev_priv(dev);
diff --git a/drivers/net/sunbmac.c b/drivers/net/sunbmac.c
index fe3ac6f..b5283a6 100644
--- a/drivers/net/sunbmac.c
+++ b/drivers/net/sunbmac.c
@@ -887,7 +887,7 @@ static void bigmac_rx(struct bigmac *bp)
 		printk(KERN_NOTICE "%s: Memory squeeze, deferring packet.\n", bp->dev->name);
 }
 
-static irqreturn_t bigmac_interrupt(int irq, void *dev_id)
+static irqreturn_t bigmac_interrupt(void *dev_id)
 {
 	struct bigmac *bp = (struct bigmac *) dev_id;
 	u32 qec_status, bmac_status;
diff --git a/drivers/net/sundance.c b/drivers/net/sundance.c
index ff98f5d..d35627f 100644
--- a/drivers/net/sundance.c
+++ b/drivers/net/sundance.c
@@ -416,7 +416,7 @@ static void tx_timeout(struct net_device *dev);
 static void init_ring(struct net_device *dev);
 static int  start_tx(struct sk_buff *skb, struct net_device *dev);
 static int reset_tx (struct net_device *dev);
-static irqreturn_t intr_handler(int irq, void *dev_instance);
+static irqreturn_t intr_handler(void *dev_instance);
 static void rx_poll(unsigned long data);
 static void tx_poll(unsigned long data);
 static void refill_rx (struct net_device *dev);
@@ -1112,7 +1112,7 @@ reset_tx (struct net_device *dev)
 
 /* The interrupt handler cleans up after the Tx thread,
    and schedule a Rx thread work */
-static irqreturn_t intr_handler(int irq, void *dev_instance)
+static irqreturn_t intr_handler(void *dev_instance)
 {
 	struct net_device *dev = (struct net_device *)dev_instance;
 	struct netdev_private *np = netdev_priv(dev);
diff --git a/drivers/net/sungem.c b/drivers/net/sungem.c
index 53b8344..cf4039a 100644
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -928,7 +928,7 @@ static int gem_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static irqreturn_t gem_interrupt(int irq, void *dev_id)
+static irqreturn_t gem_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct gem *gp = dev->priv;
@@ -971,7 +971,7 @@ static void gem_poll_controller(struct net_device *dev)
 	/* gem_interrupt is safe to reentrance so no need
 	 * to disable_irq here.
 	 */
-	gem_interrupt(dev->irq, dev);
+	gem_interrupt(dev);
 }
 #endif
 
diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index 120c8af..99cc094 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -2090,7 +2090,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 	RXD((">"));
 }
 
-static irqreturn_t happy_meal_interrupt(int irq, void *dev_id)
+static irqreturn_t happy_meal_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct happy_meal *hp  = netdev_priv(dev);
diff --git a/drivers/net/sunlance.c b/drivers/net/sunlance.c
index 26ade68..daa8910 100644
--- a/drivers/net/sunlance.c
+++ b/drivers/net/sunlance.c
@@ -816,7 +816,7 @@ out:
 	spin_unlock(&lp->lock);
 }
 
-static irqreturn_t lance_interrupt(int irq, void *dev_id)
+static irqreturn_t lance_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct lance_private *lp = netdev_priv(dev);
diff --git a/drivers/net/sunqe.c b/drivers/net/sunqe.c
index ff23c64..66ab859 100644
--- a/drivers/net/sunqe.c
+++ b/drivers/net/sunqe.c
@@ -466,7 +466,7 @@ static void qe_tx_reclaim(struct sunqe *qep);
  * so we just run through each qe and check to see who is signaling
  * and thus needs to be serviced.
  */
-static irqreturn_t qec_interrupt(int irq, void *dev_id)
+static irqreturn_t qec_interrupt(void *dev_id)
 {
 	struct sunqec *qecp = dev_id;
 	u32 qec_status;
diff --git a/drivers/net/tc35815.c b/drivers/net/tc35815.c
index 8038f28..a9edd2b 100644
--- a/drivers/net/tc35815.c
+++ b/drivers/net/tc35815.c
@@ -566,7 +566,7 @@ static void free_rxbuf_skb(struct pci_dev *hwdev, struct sk_buff *skb, dma_addr_
 
 static int	tc35815_open(struct net_device *dev);
 static int	tc35815_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t	tc35815_interrupt(int irq, void *dev_id);
+static irqreturn_t	tc35815_interrupt(void *dev_id);
 #ifdef TC35815_NAPI
 static int	tc35815_rx(struct net_device *dev, int limit);
 static int	tc35815_poll(struct napi_struct *napi, int budget);
@@ -1437,7 +1437,7 @@ static int tc35815_do_interrupt(struct net_device *dev, u32 status)
  * The typical workload of the driver:
  * Handle the network interface interrupts.
  */
-static irqreturn_t tc35815_interrupt(int irq, void *dev_id)
+static irqreturn_t tc35815_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct tc35815_local *lp = netdev_priv(dev);
diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 4e1b84e..08d0b17 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -248,7 +248,7 @@ static void bdx_isr_extra(struct bdx_priv *priv, u32 isr)
  *    TX_FREE - packet was transmited and RXF fifo holds its descriptor
  */
 
-static irqreturn_t bdx_isr_napi(int irq, void *dev)
+static irqreturn_t bdx_isr_napi(void *dev)
 {
 	struct net_device *ndev = dev;
 	struct bdx_priv *priv = ndev->priv;
diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 014dc2c..5363f6a 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -3665,7 +3665,7 @@ static inline void tg3_full_unlock(struct tg3 *tp)
 /* One-shot MSI handler - Chip automatically disables interrupt
  * after sending MSI so driver doesn't have to do it.
  */
-static irqreturn_t tg3_msi_1shot(int irq, void *dev_id)
+static irqreturn_t tg3_msi_1shot(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct tg3 *tp = netdev_priv(dev);
@@ -3683,7 +3683,7 @@ static irqreturn_t tg3_msi_1shot(int irq, void *dev_id)
  * flush status block and interrupt mailbox. PCI ordering rules
  * guarantee that MSI will arrive after the status block.
  */
-static irqreturn_t tg3_msi(int irq, void *dev_id)
+static irqreturn_t tg3_msi(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct tg3 *tp = netdev_priv(dev);
@@ -3704,7 +3704,7 @@ static irqreturn_t tg3_msi(int irq, void *dev_id)
 	return IRQ_RETVAL(1);
 }
 
-static irqreturn_t tg3_interrupt(int irq, void *dev_id)
+static irqreturn_t tg3_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct tg3 *tp = netdev_priv(dev);
@@ -3753,7 +3753,7 @@ out:
 	return IRQ_RETVAL(handled);
 }
 
-static irqreturn_t tg3_interrupt_tagged(int irq, void *dev_id)
+static irqreturn_t tg3_interrupt_tagged(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct tg3 *tp = netdev_priv(dev);
@@ -3802,7 +3802,7 @@ out:
 }
 
 /* ISR for interrupt test */
-static irqreturn_t tg3_test_isr(int irq, void *dev_id)
+static irqreturn_t tg3_test_isr(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct tg3 *tp = netdev_priv(dev);
@@ -3844,9 +3844,7 @@ static int tg3_restart_hw(struct tg3 *tp, int reset_phy)
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void tg3_poll_controller(struct net_device *dev)
 {
-	struct tg3 *tp = netdev_priv(dev);
-
-	tg3_interrupt(tp->pdev->irq, dev);
+	tg3_interrupt(dev);
 }
 #endif
 
diff --git a/drivers/net/tlan.c b/drivers/net/tlan.c
index c99ce74..6b451e2 100644
--- a/drivers/net/tlan.c
+++ b/drivers/net/tlan.c
@@ -289,7 +289,7 @@ static void	TLan_Eisa_Cleanup( void );
 static int      TLan_Init( struct net_device * );
 static int	TLan_Open( struct net_device *dev );
 static int	TLan_StartTx( struct sk_buff *, struct net_device *);
-static irqreturn_t TLan_HandleInterrupt( int, void *);
+static irqreturn_t TLan_HandleInterrupt(void *);
 static int	TLan_Close( struct net_device *);
 static struct	net_device_stats *TLan_GetStats( struct net_device *);
 static void	TLan_SetMulticastList( struct net_device *);
@@ -822,7 +822,7 @@ static void  __init TLan_EisaProbe (void)
 static void TLan_Poll(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	TLan_HandleInterrupt(dev->irq, dev);
+	TLan_HandleInterrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
@@ -1178,7 +1178,7 @@ static int TLan_StartTx( struct sk_buff *skb, struct net_device *dev )
 	 *
 	 **************************************************************/
 
-static irqreturn_t TLan_HandleInterrupt(int irq, void *dev_id)
+static irqreturn_t TLan_HandleInterrupt(void *dev_id)
 {
 	u32		ack;
 	struct net_device	*dev;
diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index 5d31519..0412c15 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -130,7 +130,7 @@ static int xl_xmit(struct sk_buff *skb, struct net_device *dev);
 static void xl_dn_comp(struct net_device *dev); 
 static int xl_close(struct net_device *dev);
 static void xl_set_rx_mode(struct net_device *dev);
-static irqreturn_t xl_interrupt(int irq, void *dev_id);
+static irqreturn_t xl_interrupt(void *dev_id);
 static struct net_device_stats * xl_get_stats(struct net_device *dev);
 static int xl_set_mac_address(struct net_device *dev, void *addr) ; 
 static void xl_arb_cmd(struct net_device *dev);
@@ -1038,7 +1038,7 @@ static void xl_freemem(struct net_device *dev)
 	return  ; 
 }
 
-static irqreturn_t xl_interrupt(int irq, void *dev_id) 
+static irqreturn_t xl_interrupt(void *dev_id) 
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct xl_private *xl_priv =netdev_priv(dev);
diff --git a/drivers/net/tokenring/ibmtr.c b/drivers/net/tokenring/ibmtr.c
index e494c63..fa57dee 100644
--- a/drivers/net/tokenring/ibmtr.c
+++ b/drivers/net/tokenring/ibmtr.c
@@ -193,7 +193,7 @@ static void 	open_sap(unsigned char type, struct net_device *dev);
 static void 	tok_set_multicast_list(struct net_device *dev);
 static int 	tok_send_packet(struct sk_buff *skb, struct net_device *dev);
 static int 	tok_close(struct net_device *dev);
-static irqreturn_t tok_interrupt(int irq, void *dev_id);
+static irqreturn_t tok_interrupt(void *dev_id);
 static void 	initial_tok_int(struct net_device *dev);
 static void 	tr_tx(struct net_device *dev);
 static void 	tr_rx(struct net_device *dev);
@@ -1162,7 +1162,7 @@ static void dir_open_adapter (struct net_device *dev)
 
 /******************************************************************************/
 
-static irqreturn_t tok_interrupt(int irq, void *dev_id)
+static irqreturn_t tok_interrupt(void *dev_id)
 {
 	unsigned char status;
 	/*  unsigned char status_even ; */
diff --git a/drivers/net/tokenring/lanstreamer.c b/drivers/net/tokenring/lanstreamer.c
index 47d84cd..f1c243e 100644
--- a/drivers/net/tokenring/lanstreamer.c
+++ b/drivers/net/tokenring/lanstreamer.c
@@ -207,7 +207,7 @@ static int streamer_open(struct net_device *dev);
 static int streamer_xmit(struct sk_buff *skb, struct net_device *dev);
 static int streamer_close(struct net_device *dev);
 static void streamer_set_rx_mode(struct net_device *dev);
-static irqreturn_t streamer_interrupt(int irq, void *dev_id);
+static irqreturn_t streamer_interrupt(void *dev_id);
 static struct net_device_stats *streamer_get_stats(struct net_device *dev);
 static int streamer_set_mac_address(struct net_device *dev, void *addr);
 static void streamer_arb_cmd(struct net_device *dev);
@@ -1025,7 +1025,7 @@ static void streamer_rx(struct net_device *dev)
 	}			/* end for all completed rx descriptors */
 }
 
-static irqreturn_t streamer_interrupt(int irq, void *dev_id)
+static irqreturn_t streamer_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct streamer_private *streamer_priv =
diff --git a/drivers/net/tokenring/madgemc.c b/drivers/net/tokenring/madgemc.c
index 5a41513..cbacfeb 100644
--- a/drivers/net/tokenring/madgemc.c
+++ b/drivers/net/tokenring/madgemc.c
@@ -69,7 +69,7 @@ static void madgemc_setregpage(struct net_device *dev, int page);
 static void madgemc_setsifsel(struct net_device *dev, int val);
 static void madgemc_setint(struct net_device *dev, int val);
 
-static irqreturn_t madgemc_interrupt(int irq, void *dev_id);
+static irqreturn_t madgemc_interrupt(void *dev_id);
 
 /*
  * These work around paging, however they don't guarentee you're on the
@@ -413,7 +413,7 @@ getout:
  * exhausted all contiguous interrupts.
  *
  */
-static irqreturn_t madgemc_interrupt(int irq, void *dev_id)
+static irqreturn_t madgemc_interrupt(void *dev_id)
 {
 	int pending,reg1;
 	struct net_device *dev;
@@ -447,7 +447,7 @@ static irqreturn_t madgemc_interrupt(int irq, void *dev_id)
 			outb(reg1, dev->base_addr + MC_CONTROL_REG1);
 
 			/* Continue handling as normal */
-			tms380tr_interrupt(irq, dev_id);
+			tms380tr_interrupt(dev_id);
 
 			pending = SIFREADW(SIFSTS); /* restart - the SIF way */
 
diff --git a/drivers/net/tokenring/olympic.c b/drivers/net/tokenring/olympic.c
index 74c1f0f..12637e0 100644
--- a/drivers/net/tokenring/olympic.c
+++ b/drivers/net/tokenring/olympic.c
@@ -186,7 +186,7 @@ static int olympic_xmit(struct sk_buff *skb, struct net_device *dev);
 static int olympic_close(struct net_device *dev);
 static void olympic_set_rx_mode(struct net_device *dev);
 static void olympic_freemem(struct net_device *dev) ;  
-static irqreturn_t olympic_interrupt(int irq, void *dev_id);
+static irqreturn_t olympic_interrupt(void *dev_id);
 static struct net_device_stats * olympic_get_stats(struct net_device *dev);
 static int olympic_set_mac_address(struct net_device *dev, void *addr) ; 
 static void olympic_arb_cmd(struct net_device *dev);
@@ -919,7 +919,7 @@ static void olympic_freemem(struct net_device *dev)
 	return ; 
 }
  
-static irqreturn_t olympic_interrupt(int irq, void *dev_id) 
+static irqreturn_t olympic_interrupt(void *dev_id) 
 {
 	struct net_device *dev= (struct net_device *)dev_id;
 	struct olympic_private *olympic_priv=netdev_priv(dev);
diff --git a/drivers/net/tokenring/smctr.c b/drivers/net/tokenring/smctr.c
index 93da3a3..e496442 100644
--- a/drivers/net/tokenring/smctr.c
+++ b/drivers/net/tokenring/smctr.c
@@ -140,7 +140,7 @@ static int smctr_init_shared_memory(struct net_device *dev);
 static int smctr_init_tx_bdbs(struct net_device *dev);
 static int smctr_init_tx_fcbs(struct net_device *dev);
 static int smctr_internal_self_test(struct net_device *dev);
-static irqreturn_t smctr_interrupt(int irq, void *dev_id);
+static irqreturn_t smctr_interrupt(void *dev_id);
 static int smctr_issue_enable_int_cmd(struct net_device *dev,
         __u16 interrupt_enable_mask);
 static int smctr_issue_int_ack(struct net_device *dev, __u16 iack_code,
@@ -1979,7 +1979,7 @@ static int smctr_internal_self_test(struct net_device *dev)
 /*
  * The typical workload of the driver: Handle the network interface interrupts.
  */
-static irqreturn_t smctr_interrupt(int irq, void *dev_id)
+static irqreturn_t smctr_interrupt(void *dev_id)
 {
         struct net_device *dev = dev_id;
         struct net_local *tp;
diff --git a/drivers/net/tokenring/tms380tr.c b/drivers/net/tokenring/tms380tr.c
index d5fa36d..672cc06 100644
--- a/drivers/net/tokenring/tms380tr.c
+++ b/drivers/net/tokenring/tms380tr.c
@@ -744,7 +744,7 @@ static void tms380tr_timer_chk(unsigned long data)
 /*
  * The typical workload of the driver: Handle the network interface interrupts.
  */
-irqreturn_t tms380tr_interrupt(int irq, void *dev_id)
+irqreturn_t tms380tr_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct net_local *tp;
diff --git a/drivers/net/tokenring/tms380tr.h b/drivers/net/tokenring/tms380tr.h
index 7daf74e..ca10671 100644
--- a/drivers/net/tokenring/tms380tr.h
+++ b/drivers/net/tokenring/tms380tr.h
@@ -16,7 +16,7 @@
 /* module prototypes */
 int tms380tr_open(struct net_device *dev);
 int tms380tr_close(struct net_device *dev);
-irqreturn_t tms380tr_interrupt(int irq, void *dev_id);
+irqreturn_t tms380tr_interrupt(void *dev_id);
 int tmsdev_init(struct net_device *dev, struct device *pdev);
 void tmsdev_term(struct net_device *dev);
 void tms380tr_wait(unsigned long time);
diff --git a/drivers/net/tulip/de2104x.c b/drivers/net/tulip/de2104x.c
index 77d9dd7..8dcf8b5 100644
--- a/drivers/net/tulip/de2104x.c
+++ b/drivers/net/tulip/de2104x.c
@@ -483,7 +483,7 @@ rx_next:
 	de->rx_tail = rx_tail;
 }
 
-static irqreturn_t de_interrupt (int irq, void *dev_instance)
+static irqreturn_t de_interrupt (void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct de_private *de = dev->priv;
diff --git a/drivers/net/tulip/de4x5.c b/drivers/net/tulip/de4x5.c
index 41f34bb..02d5e6c 100644
--- a/drivers/net/tulip/de4x5.c
+++ b/drivers/net/tulip/de4x5.c
@@ -896,7 +896,7 @@ static struct {
 */
 static int     de4x5_open(struct net_device *dev);
 static int     de4x5_queue_pkt(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t de4x5_interrupt(int irq, void *dev_id);
+static irqreturn_t de4x5_interrupt(void *dev_id);
 static int     de4x5_close(struct net_device *dev);
 static struct  net_device_stats *de4x5_get_stats(struct net_device *dev);
 static void    de4x5_local_stats(struct net_device *dev, char *buf, int pkt_len);
@@ -1530,7 +1530,7 @@ de4x5_queue_pkt(struct sk_buff *skb, struct net_device *dev)
 ** interrupt is asserted and this routine entered.
 */
 static irqreturn_t
-de4x5_interrupt(int irq, void *dev_id)
+de4x5_interrupt(void *dev_id)
 {
     struct net_device *dev = dev_id;
     struct de4x5_private *lp;
diff --git a/drivers/net/tulip/dmfe.c b/drivers/net/tulip/dmfe.c
index ca90566..90c2bd1 100644
--- a/drivers/net/tulip/dmfe.c
+++ b/drivers/net/tulip/dmfe.c
@@ -320,7 +320,7 @@ static struct net_device_stats * dmfe_get_stats(struct DEVICE *);
 static void dmfe_set_filter_mode(struct DEVICE *);
 static const struct ethtool_ops netdev_ethtool_ops;
 static u16 read_srom_word(long ,int);
-static irqreturn_t dmfe_interrupt(int , void *);
+static irqreturn_t dmfe_interrupt(void *);
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void poll_dmfe (struct net_device *dev);
 #endif
@@ -764,7 +764,7 @@ static int dmfe_stop(struct DEVICE *dev)
  *	receive the packet to upper layer, free the transmitted packet
  */
 
-static irqreturn_t dmfe_interrupt(int irq, void *dev_id)
+static irqreturn_t dmfe_interrupt(void *dev_id)
 {
 	struct DEVICE *dev = dev_id;
 	struct dmfe_board_info *db = netdev_priv(dev);
@@ -835,7 +835,7 @@ static void poll_dmfe (struct net_device *dev)
 	/* disable_irq here is not very nice, but with the lockless
 	   interrupt handler we have no other choice. */
 	disable_irq(dev->irq);
-	dmfe_interrupt (dev->irq, dev);
+	dmfe_interrupt (dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/tulip/interrupt.c b/drivers/net/tulip/interrupt.c
index 3653314..2c1582b 100644
--- a/drivers/net/tulip/interrupt.c
+++ b/drivers/net/tulip/interrupt.c
@@ -486,7 +486,7 @@ static inline unsigned int phy_interrupt (struct net_device *dev)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-irqreturn_t tulip_interrupt(int irq, void *dev_instance)
+irqreturn_t tulip_interrupt(void *dev_instance)
 {
 	struct net_device *dev = (struct net_device *)dev_instance;
 	struct tulip_private *tp = netdev_priv(dev);
diff --git a/drivers/net/tulip/tulip.h b/drivers/net/tulip/tulip.h
index 3f69f53..35a07b2 100644
--- a/drivers/net/tulip/tulip.h
+++ b/drivers/net/tulip/tulip.h
@@ -427,7 +427,7 @@ int tulip_read_eeprom(struct net_device *dev, int location, int addr_len);
 /* interrupt.c */
 extern unsigned int tulip_max_interrupt_work;
 extern int tulip_rx_copybreak;
-irqreturn_t tulip_interrupt(int irq, void *dev_instance);
+irqreturn_t tulip_interrupt(void *dev_instance);
 int tulip_refill_rx(struct net_device *dev);
 #ifdef CONFIG_TULIP_NAPI
 int tulip_poll(struct napi_struct *napi, int budget);
diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
index e5e2c9c..d81e576 100644
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -1813,7 +1813,7 @@ static void poll_tulip (struct net_device *dev)
 	/* disable_irq here is not very nice, but with the lockless
 	   interrupt handler we have no other choice. */
 	disable_irq(dev->irq);
-	tulip_interrupt (dev->irq, dev);
+	tulip_interrupt (dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/tulip/uli526x.c b/drivers/net/tulip/uli526x.c
index 76e5561..fd03199 100644
--- a/drivers/net/tulip/uli526x.c
+++ b/drivers/net/tulip/uli526x.c
@@ -224,7 +224,7 @@ static struct net_device_stats * uli526x_get_stats(struct net_device *);
 static void uli526x_set_filter_mode(struct net_device *);
 static const struct ethtool_ops netdev_ethtool_ops;
 static u16 read_srom_word(long, int);
-static irqreturn_t uli526x_interrupt(int, void *);
+static irqreturn_t uli526x_interrupt(void *);
 static void uli526x_descriptor_init(struct uli526x_board_info *, unsigned long);
 static void allocate_rx_buffer(struct uli526x_board_info *);
 static void update_cr6(u32, unsigned long);
@@ -657,7 +657,7 @@ static int uli526x_stop(struct net_device *dev)
  *	receive the packet to upper layer, free the transmitted packet
  */
 
-static irqreturn_t uli526x_interrupt(int irq, void *dev_id)
+static irqreturn_t uli526x_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct uli526x_board_info *db = netdev_priv(dev);
diff --git a/drivers/net/tulip/winbond-840.c b/drivers/net/tulip/winbond-840.c
index 3c8e3b6..58639d0 100644
--- a/drivers/net/tulip/winbond-840.c
+++ b/drivers/net/tulip/winbond-840.c
@@ -332,7 +332,7 @@ static void tx_timeout(struct net_device *dev);
 static int alloc_ringdesc(struct net_device *dev);
 static void free_ringdesc(struct netdev_private *np);
 static int  start_tx(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t intr_handler(int irq, void *dev_instance);
+static irqreturn_t intr_handler(void *dev_instance);
 static void netdev_error(struct net_device *dev, int intr_status);
 static int  netdev_rx(struct net_device *dev);
 static u32 __set_rx_mode(struct net_device *dev);
@@ -1107,7 +1107,7 @@ static void netdev_tx_done(struct net_device *dev)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-static irqreturn_t intr_handler(int irq, void *dev_instance)
+static irqreturn_t intr_handler(void *dev_instance)
 {
 	struct net_device *dev = (struct net_device *)dev_instance;
 	struct netdev_private *np = netdev_priv(dev);
diff --git a/drivers/net/tulip/xircom_cb.c b/drivers/net/tulip/xircom_cb.c
index 70befe3..da4855a 100644
--- a/drivers/net/tulip/xircom_cb.c
+++ b/drivers/net/tulip/xircom_cb.c
@@ -114,7 +114,7 @@ struct xircom_private {
 /* Function prototypes */
 static int xircom_probe(struct pci_dev *pdev, const struct pci_device_id *id);
 static void xircom_remove(struct pci_dev *pdev);
-static irqreturn_t xircom_interrupt(int irq, void *dev_instance);
+static irqreturn_t xircom_interrupt(void *dev_instance);
 static int xircom_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int xircom_open(struct net_device *dev);
 static int xircom_close(struct net_device *dev);
@@ -329,7 +329,7 @@ static void __devexit xircom_remove(struct pci_dev *pdev)
 	leave("xircom_remove");
 }
 
-static irqreturn_t xircom_interrupt(int irq, void *dev_instance)
+static irqreturn_t xircom_interrupt(void *dev_instance)
 {
 	struct net_device *dev = (struct net_device *) dev_instance;
 	struct xircom_private *card = netdev_priv(dev);
@@ -508,7 +508,7 @@ static struct net_device_stats *xircom_get_stats(struct net_device *dev)
 static void xircom_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	xircom_interrupt(dev->irq, dev);
+	xircom_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
diff --git a/drivers/net/tulip/xircom_tulip_cb.c b/drivers/net/tulip/xircom_tulip_cb.c
index c3f8e30..6787e61 100644
--- a/drivers/net/tulip/xircom_tulip_cb.c
+++ b/drivers/net/tulip/xircom_tulip_cb.c
@@ -328,7 +328,7 @@ static void xircom_init_ring(struct net_device *dev);
 static int xircom_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int xircom_rx(struct net_device *dev);
 static void xircom_media_change(struct net_device *dev);
-static irqreturn_t xircom_interrupt(int irq, void *dev_instance);
+static irqreturn_t xircom_interrupt(void *dev_instance);
 static int xircom_close(struct net_device *dev);
 static struct net_device_stats *xircom_get_stats(struct net_device *dev);
 static int xircom_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
@@ -1043,7 +1043,7 @@ static void check_duplex(struct net_device *dev)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-static irqreturn_t xircom_interrupt(int irq, void *dev_instance)
+static irqreturn_t xircom_interrupt(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct xircom_private *tp = netdev_priv(dev);
diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
index 94ac586..34d5c6c 100644
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -1799,7 +1799,7 @@ typhoon_poll(struct napi_struct *napi, int budget)
 }
 
 static irqreturn_t
-typhoon_interrupt(int irq, void *dev_instance)
+typhoon_interrupt(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct typhoon *tp = dev->priv;
diff --git a/drivers/net/via-rhine.c b/drivers/net/via-rhine.c
index 07263cd..f2a2ffd 100644
--- a/drivers/net/via-rhine.c
+++ b/drivers/net/via-rhine.c
@@ -413,7 +413,7 @@ static void mdio_write(struct net_device *dev, int phy_id, int location, int val
 static int  rhine_open(struct net_device *dev);
 static void rhine_tx_timeout(struct net_device *dev);
 static int  rhine_start_tx(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t rhine_interrupt(int irq, void *dev_instance);
+static irqreturn_t rhine_interrupt(void *dev_instance);
 static void rhine_tx(struct net_device *dev);
 static int rhine_rx(struct net_device *dev, int limit);
 static void rhine_error(struct net_device *dev, int intr_status);
@@ -578,7 +578,7 @@ static void __devinit rhine_reload_eeprom(long pioaddr, struct net_device *dev)
 static void rhine_poll(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	rhine_interrupt(dev->irq, (void *)dev);
+	rhine_interrupt(dev);
 	enable_irq(dev->irq);
 }
 #endif
@@ -1295,7 +1295,7 @@ static int rhine_start_tx(struct sk_buff *skb, struct net_device *dev)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-static irqreturn_t rhine_interrupt(int irq, void *dev_instance)
+static irqreturn_t rhine_interrupt(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct rhine_private *rp = netdev_priv(dev);
diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index 4ae0579..c36fbe5 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -378,7 +378,7 @@ static void velocity_print_info(struct velocity_info *vptr);
 static int velocity_open(struct net_device *dev);
 static int velocity_change_mtu(struct net_device *dev, int mtu);
 static int velocity_xmit(struct sk_buff *skb, struct net_device *dev);
-static int velocity_intr(int irq, void *dev_instance);
+static int velocity_intr(void *dev_instance);
 static void velocity_set_multi(struct net_device *dev);
 static struct net_device_stats *velocity_get_stats(struct net_device *dev);
 static int velocity_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
@@ -2212,7 +2212,7 @@ static int velocity_xmit(struct sk_buff *skb, struct net_device *dev)
  *	efficiently as possible.
  */
 
-static int velocity_intr(int irq, void *dev_instance)
+static int velocity_intr(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct velocity_info *vptr = netdev_priv(dev);
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index ff37bf4..cf84139 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -343,7 +343,7 @@ static void put_driver_status(struct cosa_data *cosa);
 static void put_driver_status_nolock(struct cosa_data *cosa);
 
 /* Interrupt handling */
-static irqreturn_t cosa_interrupt(int irq, void *cosa);
+static irqreturn_t cosa_interrupt(void *cosa);
 
 /* I/O ops debugging */
 #ifdef DEBUG_IO
@@ -1968,7 +1968,7 @@ out:
 	spin_unlock_irqrestore(&cosa->lock, flags);
 }
 
-static irqreturn_t cosa_interrupt(int irq, void *cosa_)
+static irqreturn_t cosa_interrupt(void *cosa_)
 {
 	unsigned status;
 	int count = 0;
diff --git a/drivers/net/wan/cycx_main.c b/drivers/net/wan/cycx_main.c
index a0e8611..f32e3d6 100644
--- a/drivers/net/wan/cycx_main.c
+++ b/drivers/net/wan/cycx_main.c
@@ -74,7 +74,7 @@ static int cycx_wan_setup(struct wan_device *wandev, wandev_conf_t *conf);
 static int cycx_wan_shutdown(struct wan_device *wandev);
 
 /* Miscellaneous functions */
-static irqreturn_t cycx_isr(int irq, void *dev_id);
+static irqreturn_t cycx_isr(void *dev_id);
 
 /* Global Data
  * Note: All data must be explicitly initialized!!!
@@ -299,7 +299,7 @@ out:	return ret;
  * o acknowledge Cyclom 2X hardware interrupt.
  * o call protocol-specific interrupt service routine, if any.
  */
-static irqreturn_t cycx_isr(int irq, void *dev_id)
+static irqreturn_t cycx_isr(void *dev_id)
 {
 	struct cycx_device *card = dev_id;
 
diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c
index 33dc713..9f07e5b 100644
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -365,7 +365,7 @@ static int dscc4_init_ring(struct net_device *);
 static void dscc4_release_ring(struct dscc4_dev_priv *);
 static void dscc4_timer(unsigned long);
 static void dscc4_tx_timeout(struct net_device *);
-static irqreturn_t dscc4_irq(int irq, void *dev_id);
+static irqreturn_t dscc4_irq(void *dev_id);
 static int dscc4_hdlc_attach(struct net_device *, unsigned short, unsigned short);
 static int dscc4_set_iface(struct dscc4_dev_priv *, struct net_device *);
 #ifdef DSCC4_POLLING
@@ -1473,7 +1473,7 @@ static int dscc4_set_iface(struct dscc4_dev_priv *dpriv, struct net_device *dev)
 	return ret;
 }
 
-static irqreturn_t dscc4_irq(int irq, void *token)
+static irqreturn_t dscc4_irq(void *token)
 {
 	struct dscc4_dev_priv *root = token;
 	struct dscc4_pci_priv *priv;
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 12dae8e..3825708 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -1498,7 +1498,7 @@ do_bottom_half_rx(struct fst_card_info *card)
  *      Dev_id is our fst_card_info pointer
  */
 static irqreturn_t
-fst_intr(int irq, void *dev_id)
+fst_intr(void *dev_id)
 {
 	struct fst_card_info *card;
 	struct fst_port_info *port;
diff --git a/drivers/net/wan/hd6457x.c b/drivers/net/wan/hd6457x.c
index 8d0a1f2..95fafe6 100644
--- a/drivers/net/wan/hd6457x.c
+++ b/drivers/net/wan/hd6457x.c
@@ -424,7 +424,7 @@ static inline void sca_tx_intr(port_t *port)
 
 
 
-static irqreturn_t sca_intr(int irq, void* dev_id)
+static irqreturn_t sca_intr(void* dev_id)
 {
 	card_t *card = dev_id;
 	int i;
diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 5ea8772..b12f2d9 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -100,7 +100,7 @@ static int lmc_rx (struct net_device *dev);
 static int lmc_open(struct net_device *dev);
 static int lmc_close(struct net_device *dev);
 static struct net_device_stats *lmc_get_stats(struct net_device *dev);
-static irqreturn_t lmc_interrupt(int irq, void *dev_instance);
+static irqreturn_t lmc_interrupt(void *dev_instance);
 static void lmc_initcsrs(lmc_softc_t * const sc, lmc_csrptr_t csr_base, size_t csr_size);
 static void lmc_softreset(lmc_softc_t * const);
 static void lmc_running_reset(struct net_device *dev);
@@ -1272,7 +1272,7 @@ static int lmc_ifdown (struct net_device *dev) /*fold00*/
 /* Interrupt handling routine.  This will take an incoming packet, or clean
  * up after a trasmit.
  */
-static irqreturn_t lmc_interrupt (int irq, void *dev_instance) /*fold00*/
+static irqreturn_t lmc_interrupt (void *dev_instance) /*fold00*/
 {
     struct net_device *dev = (struct net_device *) dev_instance;
     lmc_softc_t *sc;
diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
index 99fee2f..f0e531f 100644
--- a/drivers/net/wan/pc300_drv.c
+++ b/drivers/net/wan/pc300_drv.c
@@ -284,7 +284,7 @@ static void rx_dma_buf_pt_init(pc300_t *, int);
 static void rx_dma_buf_init(pc300_t *, int);
 static void tx_dma_buf_check(pc300_t *, int);
 static void rx_dma_buf_check(pc300_t *, int);
-static irqreturn_t cpc_intr(int, void *);
+static irqreturn_t cpc_intr(void *);
 static struct net_device_stats *cpc_get_stats(struct net_device *);
 static int clock_rate_calc(uclong, uclong, int *);
 static uclong detect_ram(pc300_t *);
@@ -2363,7 +2363,7 @@ static void falc_intr(pc300_t * card)
 	}
 }
 
-static irqreturn_t cpc_intr(int irq, void *dev_id)
+static irqreturn_t cpc_intr(void *dev_id)
 {
 	pc300_t *card;
 	volatile ucchar plx_status;
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 2e8b5c2..859e75e 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -120,7 +120,7 @@ static int  sbni_ioctl( struct net_device *, struct ifreq *, int );
 static struct net_device_stats  *sbni_get_stats( struct net_device * );
 static void  set_multicast_list( struct net_device * );
 
-static irqreturn_t sbni_interrupt( int, void * );
+static irqreturn_t sbni_interrupt( void * );
 static void  handle_channel( struct net_device * );
 static int   recv_frame( struct net_device * );
 static void  send_frame( struct net_device * );
@@ -500,7 +500,7 @@ sbni_start_xmit( struct sk_buff  *skb,  struct net_device  *dev )
  */ 
 
 static irqreturn_t
-sbni_interrupt( int  irq,  void  *dev_id )
+sbni_interrupt( void  *dev_id )
 {
 	struct net_device	  *dev = dev_id;
 	struct net_local  *nl  = dev->priv;
diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index 8e320b7..a84aa4c 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -244,7 +244,7 @@ static inline void wanxl_rx_intr(card_t *card)
 
 
 
-static irqreturn_t wanxl_intr(int irq, void* dev_id)
+static irqreturn_t wanxl_intr(void *dev_id)
 {
         card_t *card = dev_id;
         int i;
diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 98ef400..7732d99 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -716,7 +716,7 @@ EXPORT_SYMBOL(z8530_nop);
  *	channel). c->lock for both channels points to dev->lock
  */
 
-irqreturn_t z8530_interrupt(int irq, void *dev_id)
+irqreturn_t z8530_interrupt(void *dev_id)
 {
 	struct z8530_dev *dev=dev_id;
 	u8 intr;
diff --git a/drivers/net/wan/z85230.h b/drivers/net/wan/z85230.h
index 158aea7..7ce32b5 100644
--- a/drivers/net/wan/z85230.h
+++ b/drivers/net/wan/z85230.h
@@ -396,7 +396,7 @@ struct z8530_dev
 extern u8 z8530_dead_port[];
 extern u8 z8530_hdlc_kilostream_85230[];
 extern u8 z8530_hdlc_kilostream[];
-extern irqreturn_t z8530_interrupt(int, void *);
+extern irqreturn_t z8530_interrupt(void *);
 extern void z8530_describe(struct z8530_dev *, char *mapping, unsigned long io);
 extern int z8530_init(struct z8530_dev *);
 extern int z8530_shutdown(struct z8530_dev *);
diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 5bf7913..4e6de7d 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -442,7 +442,7 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 }
 
 
-static irqreturn_t adm8211_interrupt(int irq, void *dev_id)
+static irqreturn_t adm8211_interrupt(void *dev_id)
 {
 #define ADM8211_INT(x)							   \
 do {									   \
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 074055e..8526cd4 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1122,7 +1122,7 @@ static void mpi_receive_802_3(struct airo_info *ai);
 static void mpi_receive_802_11(struct airo_info *ai);
 static int waitbusy (struct airo_info *ai);
 
-static irqreturn_t airo_interrupt( int irq, void* dev_id);
+static irqreturn_t airo_interrupt(void *dev_id);
 static int airo_thread(void *data);
 static void timer_func( struct net_device *dev );
 static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
@@ -3177,7 +3177,7 @@ static int airo_thread(void *data) {
 	return 0;
 }
 
-static irqreturn_t airo_interrupt ( int irq, void* dev_id) {
+static irqreturn_t airo_interrupt ( void *dev_id) {
 	struct net_device *dev = (struct net_device *)dev_id;
 	u16 status;
 	u16 fid;
diff --git a/drivers/net/wireless/arlan-main.c b/drivers/net/wireless/arlan-main.c
index dbdfc9e..567514f 100644
--- a/drivers/net/wireless/arlan-main.c
+++ b/drivers/net/wireless/arlan-main.c
@@ -78,7 +78,7 @@ static int arlans_found;
 
 static  int 	arlan_open(struct net_device *dev);
 static  int 	arlan_tx(struct sk_buff *skb, struct net_device *dev);
-static  irqreturn_t arlan_interrupt(int irq, void *dev_id);
+static  irqreturn_t arlan_interrupt(void *dev_id);
 static  int 	arlan_close(struct net_device *dev);
 static  struct net_device_stats *
 		arlan_statistics		(struct net_device *dev);
@@ -1651,7 +1651,7 @@ end_int_process:
 	return;
 }
 
-static irqreturn_t arlan_interrupt(int irq, void *dev_id)
+static irqreturn_t arlan_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct arlan_private *priv = netdev_priv(dev);
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 059ce3f..2d06fac 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -1142,7 +1142,7 @@ next:
 	}
 }
 
-static irqreturn_t service_interrupt(int irq, void *dev_id)
+static irqreturn_t service_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct atmel_private *priv = netdev_priv(dev);
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c141a26..e88e161 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1505,7 +1505,7 @@ static void b43_interrupt_ack(struct b43_wldev *dev, u32 reason)
 }
 
 /* Interrupt handler top-half */
-static irqreturn_t b43_interrupt_handler(int irq, void *dev_id)
+static irqreturn_t b43_interrupt_handler(void *dev_id)
 {
 	irqreturn_t ret = IRQ_NONE;
 	struct b43_wldev *dev = dev_id;
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index f074951..141ca8c 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -1350,7 +1350,7 @@ static void b43legacy_interrupt_ack(struct b43legacy_wldev *dev, u32 reason)
 }
 
 /* Interrupt handler top-half */
-static irqreturn_t b43legacy_interrupt_handler(int irq, void *dev_id)
+static irqreturn_t b43legacy_interrupt_handler(void *dev_id)
 {
 	irqreturn_t ret = IRQ_NONE;
 	struct b43legacy_wldev *dev = dev_id;
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
index 4568343..4a6693a 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -1814,7 +1814,7 @@ static void bcm43xx_interrupt_ack(struct bcm43xx_private *bcm, u32 reason)
 }
 
 /* Interrupt handler top-half */
-static irqreturn_t bcm43xx_interrupt_handler(int irq, void *dev_id)
+static irqreturn_t bcm43xx_interrupt_handler(void *dev_id)
 {
 	irqreturn_t ret = IRQ_HANDLED;
 	struct bcm43xx_private *bcm = dev_id;
@@ -4007,7 +4007,7 @@ static void bcm43xx_net_poll_controller(struct net_device *net_dev)
 
 	local_irq_save(flags);
 	if (bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED)
-		bcm43xx_interrupt_handler(bcm->irq, bcm);
+		bcm43xx_interrupt_handler(bcm);
 	local_irq_restore(flags);
 }
 #endif /* CONFIG_NET_POLL_CONTROLLER */
diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index c592641..6a90173 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -2622,7 +2622,7 @@ static void prism2_check_magic(local_info_t *local)
 
 
 /* Called only from hardware IRQ */
-static irqreturn_t prism2_interrupt(int irq, void *dev_id)
+static irqreturn_t prism2_interrupt(void *dev_id)
 {
 	struct net_device *dev = (struct net_device *) dev_id;
 	struct hostap_interface *iface;
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index 2d46a16..a52b3ab 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -3263,7 +3263,7 @@ static void ipw2100_irq_tasklet(struct ipw2100_priv *priv)
 	IPW_DEBUG_ISR("exit\n");
 }
 
-static irqreturn_t ipw2100_interrupt(int irq, void *data)
+static irqreturn_t ipw2100_interrupt(void *data)
 {
 	struct ipw2100_priv *priv = data;
 	u32 inta, inta_mask;
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index feb8fcb..944c60e 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -10595,7 +10595,7 @@ static const struct ethtool_ops ipw_ethtool_ops = {
 	.set_eeprom = ipw_ethtool_set_eeprom,
 };
 
-static irqreturn_t ipw_isr(int irq, void *data)
+static irqreturn_t ipw_isr(void *data)
 {
 	struct ipw_priv *priv = data;
 	u32 inta, inta_mask;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 75e3b5c..67286e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4810,7 +4810,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static irqreturn_t iwl_isr(int irq, void *data)
+static irqreturn_t iwl_isr(void *data)
 {
 	struct iwl_priv *priv = data;
 	u32 inta, inta_mask;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index b1a6e39..e67b1a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5118,7 +5118,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static irqreturn_t iwl_isr(int irq, void *data)
+static irqreturn_t iwl_isr(void *data)
 {
 	struct iwl_priv *priv = data;
 	u32 inta, inta_mask;
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 0360cad..3a5b60f 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -240,9 +240,9 @@ static inline void if_cs_disable_ints(struct if_cs_card *card)
 	if_cs_write16(card, IF_CS_H_INT_MASK, IF_CS_H_IM_MASK);
 }
 
-static irqreturn_t if_cs_interrupt(int irq, void *data)
+static irqreturn_t if_cs_interrupt(void *data)
 {
-	struct if_cs_card *card = (struct if_cs_card *)data;
+	struct if_cs_card *card = data;
 	u16 int_cause;
 
 	lbs_deb_enter(LBS_DEB_CS);
diff --git a/drivers/net/wireless/netwave_cs.c b/drivers/net/wireless/netwave_cs.c
index c2d71af..576373a 100644
--- a/drivers/net/wireless/netwave_cs.c
+++ b/drivers/net/wireless/netwave_cs.c
@@ -207,7 +207,7 @@ static int netwave_start_xmit( struct sk_buff *skb, struct net_device *dev);
 static int netwave_rx( struct net_device *dev);
 
 /* Interrupt routines */
-static irqreturn_t netwave_interrupt(int irq, void *dev_id);
+static irqreturn_t netwave_interrupt(void *dev_id);
 static void netwave_watchdog(struct net_device *);
 
 /* Statistics */
@@ -1063,7 +1063,7 @@ static int netwave_start_xmit(struct sk_buff *skb, struct net_device *dev) {
  *	     ready to transmit another packet.
  *	  3. A command has completed execution.
  */
-static irqreturn_t netwave_interrupt(int irq, void* dev_id)
+static irqreturn_t netwave_interrupt(void *dev_id)
 {
     kio_addr_t iobase;
     u_char __iomem *ramBase;
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index ca6c2da..ee774f0 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -1957,7 +1957,7 @@ static void __orinoco_ev_wterr(struct net_device *dev, hermes_t *hw)
 	       dev->name);
 }
 
-irqreturn_t orinoco_interrupt(int irq, void *dev_id)
+irqreturn_t orinoco_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct orinoco_private *priv = netdev_priv(dev);
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index 4720fb2..b6a7df9 100644
--- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -128,7 +128,7 @@ extern void free_orinocodev(struct net_device *dev);
 extern int __orinoco_up(struct net_device *dev);
 extern int __orinoco_down(struct net_device *dev);
 extern int orinoco_reinit_firmware(struct net_device *dev);
-extern irqreturn_t orinoco_interrupt(int irq, void * dev_id);
+extern irqreturn_t orinoco_interrupt(void *dev_id);
 
 /********************************************************************/
 /* Locking and synchronization functions                            */
diff --git a/drivers/net/wireless/p54pci.c b/drivers/net/wireless/p54pci.c
index 410b543..5e1cd30 100644
--- a/drivers/net/wireless/p54pci.c
+++ b/drivers/net/wireless/p54pci.c
@@ -124,7 +124,7 @@ static int p54p_upload_firmware(struct ieee80211_hw *dev)
 	return 0;
 }
 
-static irqreturn_t p54p_simple_interrupt(int irq, void *dev_id)
+static irqreturn_t p54p_simple_interrupt(void *dev_id)
 {
 	struct p54p_priv *priv = (struct p54p_priv *) dev_id;
 	__le32 reg;
@@ -277,7 +277,7 @@ static void p54p_refill_rx_ring(struct ieee80211_hw *dev)
 	priv->ring_control->host_idx[0] = cpu_to_le32(host_idx);
 }
 
-static irqreturn_t p54p_interrupt(int irq, void *dev_id)
+static irqreturn_t p54p_interrupt(void *dev_id)
 {
 	struct ieee80211_hw *dev = dev_id;
 	struct p54p_priv *priv = dev->priv;
diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 219dd65..6e250a3 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -182,7 +182,7 @@ isl_upload_firmware(islpci_private *priv)
 ******************************************************************************/
 
 irqreturn_t
-islpci_interrupt(int irq, void *config)
+islpci_interrupt(void *config)
 {
 	u32 reg;
 	islpci_private *priv = config;
diff --git a/drivers/net/wireless/prism54/islpci_dev.h b/drivers/net/wireless/prism54/islpci_dev.h
index 736666d..2c8161f 100644
--- a/drivers/net/wireless/prism54/islpci_dev.h
+++ b/drivers/net/wireless/prism54/islpci_dev.h
@@ -197,7 +197,7 @@ islpci_state_t islpci_set_state(islpci_private *priv, islpci_state_t new_state);
 
 #define ISLPCI_TX_TIMEOUT               (2*HZ)
 
-irqreturn_t islpci_interrupt(int, void *);
+irqreturn_t islpci_interrupt(void *);
 
 int prism54_post_setup(islpci_private *, int);
 int islpci_reset(islpci_private *, int);
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index f87fe10..db014eb 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -130,7 +130,7 @@ static void ray_update_parm(struct net_device *dev, UCHAR objid, UCHAR *value, i
 static void verify_dl_startup(u_long);
 
 /* Prototypes for interrpt time functions **********************************/
-static irqreturn_t ray_interrupt (int reg, void *dev_id);
+static irqreturn_t ray_interrupt (void *dev_id);
 static void clear_interrupt(ray_dev_t *local);
 static void rx_deauthenticate(ray_dev_t *local, struct rcs __iomem *prcs, 
                        unsigned int pkt_addr, int rx_len);
@@ -1916,7 +1916,7 @@ static void set_multicast_list(struct net_device *dev)
 /*=============================================================================
  * All routines below here are run at interrupt time.
 =============================================================================*/
-static irqreturn_t ray_interrupt(int irq, void *dev_id)
+static irqreturn_t ray_interrupt(void *dev_id)
 {
     struct net_device *dev = (struct net_device *)dev_id;
     struct pcmcia_device *link;
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 31c1dd2..9e742ca 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1186,7 +1186,7 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev, const int queue)
 				     entry->tx_status.control.queue);
 }
 
-static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
+static irqreturn_t rt2400pci_interrupt(void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
 	u32 reg;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index ff2d632..3d91337 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1323,7 +1323,7 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev, const int queue)
 				     entry->tx_status.control.queue);
 }
 
-static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
+static irqreturn_t rt2500pci_interrupt(void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
 	u32 reg;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 01dbef1..f64105c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1818,7 +1818,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
+static irqreturn_t rt61pci_interrupt(void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
 	u32 reg_mcu;
diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wavelan.c
index a1f8a16..cb93a2b 100644
--- a/drivers/net/wireless/wavelan.c
+++ b/drivers/net/wireless/wavelan.c
@@ -3760,7 +3760,7 @@ static int wv_check_ioaddr(unsigned long ioaddr, u8 * mac)
  * This function is the interrupt handler for the WaveLAN card. This
  * routine will be called whenever: 
  */
-static irqreturn_t wavelan_interrupt(int irq, void *dev_id)
+static irqreturn_t wavelan_interrupt(void *dev_id)
 {
 	struct net_device *dev;
 	unsigned long ioaddr;
diff --git a/drivers/net/wireless/wavelan.p.h b/drivers/net/wireless/wavelan.p.h
index fe24281..e000b89 100644
--- a/drivers/net/wireless/wavelan.p.h
+++ b/drivers/net/wireless/wavelan.p.h
@@ -638,8 +638,7 @@ static int
 			u_char *);	/* mac address (read) */
 /* ---------------------- INTERRUPT HANDLING ---------------------- */
 static irqreturn_t
-	wavelan_interrupt(int,		/* interrupt handler */
-			  void *);
+	wavelan_interrupt(void *);	/* interrupt handler */
 static void
 	wavelan_watchdog(struct net_device *);	/* transmission watchdog */
 /* ------------------- CONFIGURATION CALLBACKS ------------------- */
diff --git a/drivers/net/wireless/wavelan_cs.c b/drivers/net/wireless/wavelan_cs.c
index 577c647..ea336b1 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -4067,8 +4067,7 @@ wv_pcmcia_release(struct pcmcia_device *link)
  *	3. A command has completed execution.
  */
 static irqreturn_t
-wavelan_interrupt(int		irq,
-		  void *	dev_id)
+wavelan_interrupt(void *	dev_id)
 {
   struct net_device *	dev = dev_id;
   net_local *	lp;
diff --git a/drivers/net/wireless/wavelan_cs.p.h b/drivers/net/wireless/wavelan_cs.p.h
index 4b9de00..e7b5e22 100644
--- a/drivers/net/wireless/wavelan_cs.p.h
+++ b/drivers/net/wireless/wavelan_cs.p.h
@@ -737,8 +737,7 @@ static void
 	wv_pcmcia_release(struct pcmcia_device *);/* Remove a device */
 /* ---------------------- INTERRUPT HANDLING ---------------------- */
 static irqreturn_t
-	wavelan_interrupt(int,	/* Interrupt handler */
-			  void *);
+	wavelan_interrupt(void *);	/* Interrupt handler */
 static void
 	wavelan_watchdog(struct net_device *);	/* Transmission watchdog */
 /* ------------------- CONFIGURATION CALLBACKS ------------------- */
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 42a36b3..21f4024 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1141,7 +1141,6 @@ static inline void wl3501_ack_interrupt(struct wl3501_card *this)
 
 /**
  * wl3501_interrupt - Hardware interrupt from card.
- * @irq - Interrupt number
  * @dev_id - net_device
  *
  * We must acknowledge the interrupt as soon as possible, and block the
@@ -1151,7 +1150,7 @@ static inline void wl3501_ack_interrupt(struct wl3501_card *this)
  * On the other hand, to prevent SUTRO from malfunctioning, we must
  * unlock the SUTRO as soon as possible.
  */
-static irqreturn_t wl3501_interrupt(int irq, void *dev_id)
+static irqreturn_t wl3501_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct wl3501_card *this;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 2a8fc43..7a94b52 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1292,7 +1292,7 @@ static int xen_net_read_mac(struct xenbus_device *dev, u8 mac[])
 	return 0;
 }
 
-static irqreturn_t xennet_interrupt(int irq, void *dev_id)
+static irqreturn_t xennet_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct netfront_info *np = netdev_priv(dev);
diff --git a/drivers/net/yellowfin.c b/drivers/net/yellowfin.c
index 87f002a..a02874e 100644
--- a/drivers/net/yellowfin.c
+++ b/drivers/net/yellowfin.c
@@ -348,7 +348,7 @@ static void yellowfin_timer(unsigned long data);
 static void yellowfin_tx_timeout(struct net_device *dev);
 static void yellowfin_init_ring(struct net_device *dev);
 static int yellowfin_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t yellowfin_interrupt(int irq, void *dev_instance);
+static irqreturn_t yellowfin_interrupt(void *dev_instance);
 static int yellowfin_rx(struct net_device *dev);
 static void yellowfin_error(struct net_device *dev, int intr_status);
 static int yellowfin_close(struct net_device *dev);
@@ -882,7 +882,7 @@ static int yellowfin_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread. */
-static irqreturn_t yellowfin_interrupt(int irq, void *dev_instance)
+static irqreturn_t yellowfin_interrupt(void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct yellowfin_private *yp;
diff --git a/drivers/net/znet.c b/drivers/net/znet.c
index a86c022..73b1c87 100644
--- a/drivers/net/znet.c
+++ b/drivers/net/znet.c
@@ -157,7 +157,7 @@ struct netidblk {
 
 static int	znet_open(struct net_device *dev);
 static int	znet_send_packet(struct sk_buff *skb, struct net_device *dev);
-static irqreturn_t znet_interrupt(int irq, void *dev_id);
+static irqreturn_t znet_interrupt(void *dev_id);
 static void	znet_rx(struct net_device *dev);
 static int	znet_close(struct net_device *dev);
 static void hardware_init(struct net_device *dev);
@@ -598,7 +598,7 @@ static int znet_send_packet(struct sk_buff *skb, struct net_device *dev)
 }
 
 /* The ZNET interrupt handler. */
-static irqreturn_t znet_interrupt(int irq, void *dev_id)
+static irqreturn_t znet_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct znet_private *znet = dev->priv;
