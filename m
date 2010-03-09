Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab0CIBud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:50:33 -0500
Received: from smtp105.plus.mail.re1.yahoo.com ([69.147.102.68]:34551 "HELO
	smtp105.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756511Ab0CIBub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:50:31 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 20:50:30 EST
X-Yahoo-SMTP: RdNnBxGswBA19fZwKxZZtNOsRPDoMFobEYheIR.LtQ--
X-YMail-OSG: 7hv_JB0VM1mJoTU.TQ65U46BGaT6zPWZYiTY_le3W8GnLVMj1XKApKzrPDGLbC1Jp0Z9eGE3qicN2l1IeUi58iVcC6ZMUJ.0nmvn3IwHu3G3ApCVOZsUVhrgsGxvIuf16hkwM6EoNBctU2hG7Q85vJxNBj1vZ5P2aECeLiigMDk6Df81iASWWmVvBNx65KLqBzx2VdKvttqgG2M3Yc8FIOPXxST5CESVgiPNQkHVmh13HLfJXZBPnn0RW.FUtfy9fGAohs3RHvD8QVRxOOEPo11oJpkeZYkhuf5K3QM39nAxAns4TWeTTRJjDmFdVywmrK7h7UfUPTJbXCBn7uRKXSt4TtoNaSJZ4J3v0H3q5aam2f.FQhrUCagP0wtGgHWdXSzj1VXDpWyHW1Jkll7HrRlr.EqcJAa1cO5D3Hlu
X-Yahoo-Newman-Property: ymail-3
From: John Church <j.church@ymail.com>
To: gregkh@suse.de, bzolnier@gmail.com, Larry.Finger@lwfinger.net,
       bernhard@schiffner-limbach.de, davem@davemloft.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       John Church <j.church@ymail.com>
Subject: [PATCH] Staging: rtl8187se: fix coding style issues in r8180_core.c
Date: Tue,  9 Mar 2010 01:43:47 +0000
Message-Id: <1268099027-29438-1-git-send-email-j.church@ymail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/rtl8187se/r8180_core.c |   98 ++++++++++++++++----------------
 1 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index b1757ac..34d464e 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -43,24 +43,24 @@
 #include "ieee80211/dot11d.h"
 
 static struct pci_device_id rtl8180_pci_id_tbl[] __devinitdata = {
-        {
-                .vendor = PCI_VENDOR_ID_REALTEK,
-                .device = 0x8199,
-                .subvendor = PCI_ANY_ID,
-                .subdevice = PCI_ANY_ID,
-                .driver_data = 0,
-        },
-        {
-                .vendor = 0,
-                .device = 0,
-                .subvendor = 0,
-                .subdevice = 0,
-                .driver_data = 0,
-        }
+	{
+		.vendor = PCI_VENDOR_ID_REALTEK,
+		.device = 0x8199,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.driver_data = 0,
+	},
+	{
+		.vendor = 0,
+		.device = 0,
+		.subvendor = 0,
+		.subdevice = 0,
+		.driver_data = 0,
+	}
 };
 
 
-static char* ifname = "wlan%d";
+static char *ifname = "wlan%d";
 static int hwseqnum = 0;
 static int hwwep = 0;
 static int channels = 0x3fff;
@@ -167,34 +167,34 @@ static struct pci_driver rtl8180_pci_driver = {
 
 u8 read_nic_byte(struct net_device *dev, int x)
 {
-        return 0xff&readb((u8*)dev->mem_start +x);
+	return 0xff&readb((u8)*dev->mem_start + x);
 }
 
 u32 read_nic_dword(struct net_device *dev, int x)
 {
-        return readl((u8*)dev->mem_start +x);
+	return readl((u8)*dev->mem_start + x);
 }
 
 u16 read_nic_word(struct net_device *dev, int x)
 {
-        return readw((u8*)dev->mem_start +x);
+	return readw((u8)*dev->mem_start + x);
 }
 
 void write_nic_byte(struct net_device *dev, int x,u8 y)
 {
-        writeb(y,(u8*)dev->mem_start +x);
+	writeb(y, (u8)*dev->mem_start + x);
 	udelay(20);
 }
 
 void write_nic_dword(struct net_device *dev, int x,u32 y)
 {
-        writel(y,(u8*)dev->mem_start +x);
+	writel(y, (u8)*dev->mem_start + x);
 	udelay(20);
 }
 
 void write_nic_word(struct net_device *dev, int x,u16 y)
 {
-        writew(y,(u8*)dev->mem_start +x);
+	writew(y, (u8)*dev->mem_start + x);
 	udelay(20);
 }
 
@@ -312,7 +312,7 @@ void rtl8180_proc_module_init(void)
 
 void rtl8180_proc_module_remove(void)
 {
-        remove_proc_entry(RTL8180_MODULE_NAME, init_net.proc_net);
+	remove_proc_entry(RTL8180_MODULE_NAME, init_net.proc_net);
 }
 
 void rtl8180_proc_remove_one(struct net_device *dev)
@@ -382,7 +382,7 @@ void rtl8180_proc_init_one(struct net_device *dev)
 short buffer_add(struct buffer **buffer, u32 *buf, dma_addr_t dma,
 		struct buffer **bufferhead)
 {
-        struct buffer *tmp;
+	struct buffer *tmp;
 
 	if(! *buffer){
 
@@ -1426,7 +1426,7 @@ void rtl8180_rx(struct net_device *dev)
 	u32 RXAGC = 0;
 	long RxAGC_dBm = 0;
 	u8	LNA=0, BB=0;
-	u8 	LNA_gain[4]={02, 17, 29, 39};
+	u8	LNA_gain[4] = {02, 17, 29, 39};
 	u8  Antenna = 0;
 	struct ieee80211_hdr_4addr *hdr;
 	u16 fc,type;
@@ -1528,7 +1528,7 @@ void rtl8180_rx(struct net_device *dev)
 		}else {
 			padding = 0;
 		}
-               padding = 0;
+		padding = 0;
 		priv->rx_prevlen+=len;
 
 		if(priv->rx_prevlen > MAX_FRAG_THRESHOLD + 100){
@@ -1621,7 +1621,7 @@ void rtl8180_rx(struct net_device *dev)
 		bICV = ((*(priv->rxringtail)) & (0x00001000)) >> 12;
 		hdr = (struct ieee80211_hdr_4addr *)priv->rxbuffer->buf;
 		    fc = le16_to_cpu(hdr->frame_ctl);
-	        type = WLAN_FC_GET_TYPE(fc);
+		type = WLAN_FC_GET_TYPE(fc);
 
 			if((IEEE80211_FTYPE_CTL != type) &&
 				(eqMacAddr(priv->ieee80211->current_network.bssid, (fc & IEEE80211_FCTL_TODS)? hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS )? hdr->addr2 : hdr->addr3))
@@ -1945,11 +1945,11 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 	u8			bUseShortPreamble = 0;
 	u8			bCTSEnable = 0;
 	u8			bRTSEnable = 0;
-	u16 			Duration = 0;
+	u16			Duration = 0;
 	u16			RtsDur = 0;
 	u16			ThisFrameTime = 0;
 	u16			TxDescDuration = 0;
-	u8 			ownbit_flag = false;
+	u8			ownbit_flag = false;
 
 	switch(priority) {
 	case MANAGE_PRIORITY:
@@ -1997,7 +1997,7 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 	default:
 		return -1;
 		break;
- 	}
+	}
 
 		memcpy(&dest, frag_hdr->addr1, ETH_ALEN);
 		if (is_multicast_ether_addr(dest) ||
@@ -2148,8 +2148,8 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 		if(morefrag) *tail = (*tail) | (1<<17); // more fragment
 		if(!remain) *tail = (*tail) | (1<<28); // last segment of frame
 
-               *(tail+5) = *(tail+5)|(2<<27);
-                *(tail+7) = *(tail+7)|(1<<4);
+		*(tail+5) = *(tail+5)|(2<<27);
+		*(tail+7) = *(tail+7)|(1<<4);
 
 		wmb();
 		if(ownbit_flag)
@@ -2286,13 +2286,13 @@ void rtl8180_hw_wakeup(struct net_device *dev)
 
 void rtl8180_hw_sleep_down(struct net_device *dev)
 {
-        unsigned long flags;
-        struct r8180_priv *priv = ieee80211_priv(dev);
+	unsigned long flags;
+	struct r8180_priv *priv = ieee80211_priv(dev);
 
-        spin_lock_irqsave(&priv->ps_lock,flags);
-        if(priv->rf_sleep)
-                priv->rf_sleep(dev);
-        spin_unlock_irqrestore(&priv->ps_lock,flags);
+	spin_lock_irqsave(&priv->ps_lock, flags);
+	if (priv->rf_sleep)
+		priv->rf_sleep(dev);
+	spin_unlock_irqrestore(&priv->ps_lock, flags);
 }
 
 void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
@@ -2783,7 +2783,7 @@ short rtl8180_init(struct net_device *dev)
 	priv->ieee80211->data_hard_stop = rtl8180_data_hard_stop;
 	priv->ieee80211->data_hard_resume = rtl8180_data_hard_resume;
 
-        priv->ieee80211->init_wmmparam_flag = 0;
+	priv->ieee80211->init_wmmparam_flag = 0;
 
 	priv->ieee80211->start_send_beacons = rtl8180_start_tx_beacon;
 	priv->ieee80211->stop_send_beacons = rtl8180_beacon_tx_disable;
@@ -2953,8 +2953,8 @@ short rtl8180_init(struct net_device *dev)
 		return -ENOMEM;
 
         if(request_irq(dev->irq, (void *)rtl8180_interrupt, IRQF_SHARED, dev->name, dev)){
-                DMESGE("Error allocating IRQ %d",dev->irq);
-                return -1;
+		DMESGE("Error allocating IRQ %d", dev->irq);
+		return -1;
 	}else{
 		priv->irq=dev->irq;
 		DMESG("IRQ %d",dev->irq);
@@ -3099,7 +3099,7 @@ void rtl8185_set_rate(struct net_device *dev)
 
 void rtl8180_adapter_start(struct net_device *dev)
 {
-        struct r8180_priv *priv = ieee80211_priv(dev);
+	struct r8180_priv *priv = ieee80211_priv(dev);
 
 	rtl8180_rtx_disable(dev);
 	rtl8180_reset(dev);
@@ -3193,7 +3193,7 @@ void rtl8180_start_tx_beacon(struct net_device *dev)
 
 	rtl8180_set_mode(dev, EPROM_CMD_NORMAL);
 
-        rtl8185b_irq_enable(dev);
+	rtl8185b_irq_enable(dev);
 }
 
 static struct net_device_stats *rtl8180_stats(struct net_device *dev)
@@ -3249,9 +3249,9 @@ void rtl8180_hw_sleep_wq (struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_sleep_wq);
-        struct net_device *dev = ieee->dev;
+	struct net_device *dev = ieee->dev;
 
-        rtl8180_hw_sleep_down(dev);
+	rtl8180_hw_sleep_down(dev);
 }
 
 static void MgntLinkKeepAlive(struct r8180_priv *priv )
@@ -3370,7 +3370,7 @@ int _rtl8180_up(struct net_device *dev)
 	}
        timer_rate_adaptive((unsigned long)dev);
 	watch_dog_adaptive((unsigned long)dev);
-        if(priv->bSwAntennaDiverity)
+	if (priv->bSwAntennaDiverity)
 			SwAntennaDiversityTimerCallback(dev);
 	ieee80211_softmac_start_protocol(priv->ieee80211);
 	return 0;
@@ -3611,10 +3611,10 @@ static int __devinit rtl8180_pci_probe(struct pci_dev *pdev,
 	dev->watchdog_timeo = HZ*3;
 
 	if (dev_alloc_name(dev, ifname) < 0){
-                DMESG("Oops: devname already taken! Trying wlan%%d...\n");
+		DMESG("Oops: devname already taken! Trying wlan%%d...\n");
 		ifname = "wlan%d";
 		dev_alloc_name(dev, ifname);
-        }
+	}
 
 	if(rtl8180_init(dev)!=0){
 		DMESG("Initialization failed");
@@ -4088,10 +4088,10 @@ void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 	u8 btPSR;
 	u8 btConfig0;
 	RT_RF_POWER_STATE	eRfPowerStateToSet;
-	bool 	bActuallySet=false;
+	bool bActuallySet = false;
 
 	char *argv[3];
-        static char *RadioPowerPath = "/etc/acpi/events/RadioPower.sh";
+	static char *RadioPowerPath = "/etc/acpi/events/RadioPower.sh";
         static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin", NULL};
 	static int readf_count = 0;
 
-- 
1.6.0.4


		
___________________________________________________________ 
To help you stay safe and secure online, we've developed the all new Yahoo! Security Centre. http://uk.security.yahoo.com
