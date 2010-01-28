Return-Path: <linux-kernel-owner+w=401wt.eu-S932213Ab0A1HiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0A1HiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 02:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034Ab0A1HiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 02:38:25 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:58407 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab0A1HiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 02:38:23 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] tree-wide: trivial typo fixes: s/lenght/length/g
Date: Thu, 28 Jan 2010 15:37:11 +0800
Message-Id: <1264664231-28338-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
---
 arch/arm/mach-at91/include/mach/at91_mci.h  |    2 +-
 arch/s390/crypto/sha_common.c               |    2 +-
 drivers/crypto/hifn_795x.c                  |    2 +-
 drivers/isdn/mISDN/l1oip_core.c             |    2 +-
 drivers/net/ppp_generic.c                   |    2 +-
 drivers/net/r6040.c                         |    2 +-
 drivers/net/stmmac/common.h                 |    2 +-
 drivers/net/stmmac/gmac.c                   |    4 ++--
 drivers/net/stmmac/mac100.c                 |    2 +-
 drivers/net/stmmac/stmmac_ethtool.c         |    2 +-
 drivers/net/wimax/i2400m/i2400m-usb.h       |    2 +-
 drivers/net/wireless/p54/p54spi.c           |    2 +-
 drivers/net/wireless/wl12xx/wl1251_cmd.c    |    2 +-
 drivers/net/wireless/wl12xx/wl1251_rx.c     |    2 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c    |    2 +-
 drivers/staging/comedi/drivers/usbdux.c     |    2 +-
 drivers/staging/comedi/drivers/usbduxfast.c |    2 +-
 drivers/staging/dream/camera/msm_camera.c   |    2 +-
 drivers/staging/rt2860/common/cmm_sanity.c  |    4 ++--
 drivers/staging/rt2860/common/cmm_wpa.c     |    2 +-
 drivers/staging/rt2860/rt_linux.c           |    2 +-
 drivers/staging/rt2860/sta/rtmp_data.c      |    2 +-
 drivers/staging/rtl8187se/r8180_core.c      |    2 +-
 drivers/staging/wlags49_h2/hcf.c            |    2 +-
 drivers/staging/wlags49_h2/wl_util.c        |    4 ++--
 drivers/usb/wusbcore/wusbhc.h               |    2 +-
 drivers/uwb/uwbd.c                          |    2 +-
 fs/cifs/asn1.c                              |    2 +-
 fs/ext4/mballoc.c                           |    2 +-
 fs/udf/inode.c                              |    2 +-
 kernel/trace/trace.h                        |    2 +-
 net/dccp/ackvec.h                           |    2 +-
 32 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/at91_mci.h b/arch/arm/mach-at91/include/mach/at91_mci.h
index 550d503..57f8ee1 100644
--- a/arch/arm/mach-at91/include/mach/at91_mci.h
+++ b/arch/arm/mach-at91/include/mach/at91_mci.h
@@ -77,7 +77,7 @@
 
 #define AT91_MCI_BLKR		0x18		/* Block Register */
 #define		AT91_MCI_BLKR_BCNT(n)	((0xffff & (n)) << 0)	/* Block count */
-#define		AT91_MCI_BLKR_BLKLEN(n)	((0xffff & (n)) << 16)	/* Block lenght */
+#define		AT91_MCI_BLKR_BLKLEN(n)	((0xffff & (n)) << 16)	/* Block length */
 
 #define AT91_MCI_RSPR(n)	(0x20 + ((n) * 4))	/* Response Registers 0-3 */
 #define AT91_MCR_RDR		0x30		/* Receive Data Register */
diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
index 7903ec4..f42dbab 100644
--- a/arch/s390/crypto/sha_common.c
+++ b/arch/s390/crypto/sha_common.c
@@ -79,7 +79,7 @@ int s390_sha_final(struct shash_desc *desc, u8 *out)
 	memset(ctx->buf + index, 0x00, end - index - 8);
 
 	/*
-	 * Append message length. Well, SHA-512 wants a 128 bit lenght value,
+	 * Append message length. Well, SHA-512 wants a 128 bit length value,
 	 * nevertheless we use u64, should be enough for now...
 	 */
 	bits = ctx->count * 8;
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 09ad915..73e8b17 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -321,7 +321,7 @@ static atomic_t hifn_dev_number;
 #define	HIFN_PUBOPLEN_MOD_M	0x0000007f	/* modulus length mask */
 #define	HIFN_PUBOPLEN_MOD_S	0		/* modulus length shift */
 #define	HIFN_PUBOPLEN_EXP_M	0x0003ff80	/* exponent length mask */
-#define	HIFN_PUBOPLEN_EXP_S	7		/* exponent lenght shift */
+#define	HIFN_PUBOPLEN_EXP_S	7		/* exponent length shift */
 #define	HIFN_PUBOPLEN_RED_M	0x003c0000	/* reducend length mask */
 #define	HIFN_PUBOPLEN_RED_S	18		/* reducend length shift */
 
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index f1e8af5..2d319bf 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -477,7 +477,7 @@ l1oip_socket_parse(struct l1oip *hc, struct sockaddr_in *sin, u8 *buf, int len)
 		printk(KERN_DEBUG "%s: received frame, parsing... (%d)\n",
 			__func__, len);
 
-	/* check lenght */
+	/* check length */
 	if (len < 1+1+2) {
 		printk(KERN_WARNING "%s: packet error - length %d below "
 			"4 bytes\n", __func__, len);
diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 2282e72..fba9145 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -1437,7 +1437,7 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
 
 		/*
 		 *check	if we are on the last channel or
-		 *we exceded the lenght	of the data	to
+		 *we exceded the length	of the data	to
 		 *fragment
 		 */
 		if ((nfree <= 0) || (flen > len))
diff --git a/drivers/net/r6040.c b/drivers/net/r6040.c
index f03e2e4..a3f9c3f 100644
--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -578,7 +578,7 @@ static int r6040_rx(struct net_device *dev, int limit)
 			/* RX dribble */
 			if (err & DSC_RX_ERR_DRI)
 				dev->stats.rx_frame_errors++;
-			/* Buffer lenght exceeded */
+			/* Buffer length exceeded */
 			if (err & DSC_RX_ERR_BUF)
 				dev->stats.rx_length_errors++;
 			/* Packet too long */
diff --git a/drivers/net/stmmac/common.h b/drivers/net/stmmac/common.h
index e49e518..81e5def 100644
--- a/drivers/net/stmmac/common.h
+++ b/drivers/net/stmmac/common.h
@@ -169,7 +169,7 @@ struct stmmac_extra_stats {
 	unsigned long rx_toolong;
 	unsigned long rx_collision;
 	unsigned long rx_crc;
-	unsigned long rx_lenght;
+	unsigned long rx_length;
 	unsigned long rx_mii;
 	unsigned long rx_multicast;
 	unsigned long rx_gmac_overflow;
diff --git a/drivers/net/stmmac/gmac.c b/drivers/net/stmmac/gmac.c
index 52586ee..467dc46 100644
--- a/drivers/net/stmmac/gmac.c
+++ b/drivers/net/stmmac/gmac.c
@@ -257,7 +257,7 @@ static int gmac_coe_rdes0(int ipc_err, int type, int payload_err)
 
 	/* bits 5 7 0 | Frame status
 	 * ----------------------------------------------------------
-	 *      0 0 0 | IEEE 802.3 Type frame (lenght < 1536 octects)
+	 *      0 0 0 | IEEE 802.3 Type frame (length < 1536 octects)
 	 *      1 0 0 | IPv4/6 No CSUM errorS.
 	 *      1 0 1 | IPv4/6 CSUM PAYLOAD error
 	 *      1 1 0 | IPv4/6 CSUM IP HR error
@@ -358,7 +358,7 @@ static int gmac_get_rx_frame_status(void *data, struct stmmac_extra_stats *x,
 	}
 	if (unlikely(p->des01.erx.length_error)) {
 		DBG(KERN_ERR "GMAC RX: length_error error\n");
-		x->rx_lenght++;
+		x->rx_length++;
 		ret = discard_frame;
 	}
 #ifdef STMMAC_VLAN_TAG_USED
diff --git a/drivers/net/stmmac/mac100.c b/drivers/net/stmmac/mac100.c
index 625171b..1f6b608 100644
--- a/drivers/net/stmmac/mac100.c
+++ b/drivers/net/stmmac/mac100.c
@@ -262,7 +262,7 @@ static int mac100_get_rx_frame_status(void *data, struct stmmac_extra_stats *x,
 		ret = discard_frame;
 
 	if (unlikely(p->des01.rx.length_error)) {
-		x->rx_lenght++;
+		x->rx_length++;
 		ret = discard_frame;
 	}
 	if (unlikely(p->des01.rx.mii_error)) {
diff --git a/drivers/net/stmmac/stmmac_ethtool.c b/drivers/net/stmmac/stmmac_ethtool.c
index 694ebe6..9edda5d 100644
--- a/drivers/net/stmmac/stmmac_ethtool.c
+++ b/drivers/net/stmmac/stmmac_ethtool.c
@@ -61,7 +61,7 @@ static const struct  stmmac_stats stmmac_gstrings_stats[] = {
 	STMMAC_STAT(rx_toolong),
 	STMMAC_STAT(rx_collision),
 	STMMAC_STAT(rx_crc),
-	STMMAC_STAT(rx_lenght),
+	STMMAC_STAT(rx_length),
 	STMMAC_STAT(rx_mii),
 	STMMAC_STAT(rx_multicast),
 	STMMAC_STAT(rx_gmac_overflow),
diff --git a/drivers/net/wimax/i2400m/i2400m-usb.h b/drivers/net/wimax/i2400m/i2400m-usb.h
index 2d7c96d..77e63d9 100644
--- a/drivers/net/wimax/i2400m/i2400m-usb.h
+++ b/drivers/net/wimax/i2400m/i2400m-usb.h
@@ -105,7 +105,7 @@ static inline void edc_init(struct edc *edc)
  *
  * @edc: pointer to error density counter.
  * @max_err: maximum number of errors we can accept over the timeframe
- * @timeframe: lenght of the timeframe (in jiffies).
+ * @timeframe: length of the timeframe (in jiffies).
  *
  * Returns: !0 1 if maximum acceptable errors per timeframe has been
  *     exceeded. 0 otherwise.
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index afd26bf..c4e4121 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -279,7 +279,7 @@ static void p54spi_power_on(struct p54s_priv *priv)
 	enable_irq(gpio_to_irq(p54spi_gpio_irq));
 
 	/*
-	 * need to wait a while before device can be accessed, the lenght
+	 * need to wait a while before device can be accessed, the length
 	 * is just a guess
 	 */
 	msleep(10);
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index 770f260..ff446a0 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -103,7 +103,7 @@ int wl1251_cmd_test(struct wl1251 *wl, void *buf, size_t buf_len, u8 answer)
  * @wl: wl struct
  * @id: acx id
  * @buf: buffer for the response, including all headers, must work with dma
- * @len: lenght of buf
+ * @len: length of buf
  */
 int wl1251_cmd_interrogate(struct wl1251 *wl, u16 id, void *buf, size_t len)
 {
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
index f84cc89..0a45528 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -135,7 +135,7 @@ static void wl1251_rx_body(struct wl1251 *wl,
 	rx_buffer = skb_put(skb, length);
 	wl1251_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
 
-	/* The actual lenght doesn't include the target's alignment */
+	/* The actual length doesn't include the target's alignment */
 	skb->len = desc->length  - PLCP_HEADER_LENGTH;
 
 	fc = (u16 *)skb->data;
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index c3385b3..1e3d4b0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -437,7 +437,7 @@ int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer)
  * @wl: wl struct
  * @id: acx id
  * @buf: buffer for the response, including all headers, must work with dma
- * @len: lenght of buf
+ * @len: length of buf
  */
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len)
 {
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 9a1b559..1f95c0c 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -122,7 +122,7 @@ sampling rate. If you sample two channels you get 4kHz and so on.
  */
 #define USBDUXSUB_MINOR 32
 
-/* max lenghth of the transfer-buffer for software upload */
+/* max length of the transfer-buffer for software upload */
 #define TB_LEN 0x2000
 
 /* Input endpoint number: ISO/IRQ */
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 2e675cc..6391a9f 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -73,7 +73,7 @@
 #define USBDUXFASTSUB_CPUCS	0xE600
 
 /*
- * max lenghth of the transfer-buffer for software upload
+ * max lengthh of the transfer-buffer for software upload
  */
 #define TB_LEN	0x2000
 
diff --git a/drivers/staging/dream/camera/msm_camera.c b/drivers/staging/dream/camera/msm_camera.c
index 7d93877..72b8ebd 100644
--- a/drivers/staging/dream/camera/msm_camera.c
+++ b/drivers/staging/dream/camera/msm_camera.c
@@ -7,7 +7,7 @@
 /* FIXME: msm_pmem_region_lookup return values */
 /* FIXME: way too many copy to/from user */
 /* FIXME: does region->active mean free */
-/* FIXME: check limits on command lenghts passed from userspace */
+/* FIXME: check limits on command lengths passed from userspace */
 /* FIXME: __msm_release: which queues should we flush when opencnt != 0 */
 
 #include <linux/kernel.h>
diff --git a/drivers/staging/rt2860/common/cmm_sanity.c b/drivers/staging/rt2860/common/cmm_sanity.c
index 6b003c9..3bfb4ad 100644
--- a/drivers/staging/rt2860/common/cmm_sanity.c
+++ b/drivers/staging/rt2860/common/cmm_sanity.c
@@ -67,7 +67,7 @@ BOOLEAN MlmeAddBAReqSanity(struct rt_rtmp_adapter *pAd,
 
 	if ((MsgLen != sizeof(struct rt_mlme_addba_req))) {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("MlmeAddBAReqSanity fail - message lenght not correct.\n"));
+			 ("MlmeAddBAReqSanity fail - message length not correct.\n"));
 		return FALSE;
 	}
 
@@ -104,7 +104,7 @@ BOOLEAN MlmeDelBAReqSanity(struct rt_rtmp_adapter *pAd, void * Msg, unsigned lon
 
 	if ((MsgLen != sizeof(struct rt_mlme_delba_req))) {
 		DBGPRINT(RT_DEBUG_ERROR,
-			 ("MlmeDelBAReqSanity fail - message lenght not correct.\n"));
+			 ("MlmeDelBAReqSanity fail - message length not correct.\n"));
 		return FALSE;
 	}
 
diff --git a/drivers/staging/rt2860/common/cmm_wpa.c b/drivers/staging/rt2860/common/cmm_wpa.c
index 94e119f..dfdc3e9 100644
--- a/drivers/staging/rt2860/common/cmm_wpa.c
+++ b/drivers/staging/rt2860/common/cmm_wpa.c
@@ -1267,7 +1267,7 @@ BOOLEAN WpaMsgTypeSubst(u8 EAPType, int * MsgType)
 		int		prefix_len	-	the length of the label
 		u8	*data		-	a specific data with variable length
 		int		data_len	-	the length of a specific data
-		int		len			-	the output lenght
+		int		len			-	the output length
 
 	Return Value:
 		u8	*output		-	the calculated result
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index 9357fb2..9bff82d 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -282,7 +282,7 @@ BOOLEAN OS_Need_Clone_Packet(void)
 	Arguments:
 		pAd 	Pointer to our adapter
 		pInsAMSDUHdr	EWC A-MSDU format has extra 14-bytes header. if TRUE, insert this 14-byte hdr in front of MSDU.
-		*pSrcTotalLen			return total packet length. This lenght is calculated with 802.3 format packet.
+		*pSrcTotalLen			return total packet length. This length is calculated with 802.3 format packet.
 
 	Return Value:
 		NDIS_STATUS_SUCCESS
diff --git a/drivers/staging/rt2860/sta/rtmp_data.c b/drivers/staging/rt2860/sta/rtmp_data.c
index 5d348e9..558ccd8 100644
--- a/drivers/staging/rt2860/sta/rtmp_data.c
+++ b/drivers/staging/rt2860/sta/rtmp_data.c
@@ -2291,7 +2291,7 @@ void STA_Fragment_Frame_Tx(struct rt_rtmp_adapter *pAd, struct rt_tx_blk *pTxBlk
 				      0);
 
 		/* NOTE: DON'T refer the skb->len directly after following copy. Becasue the length is not adjust */
-		/*                      to correct lenght, refer to pTxBlk->SrcBufLen for the packet length in following progress. */
+		/*                      to correct length, refer to pTxBlk->SrcBufLen for the packet length in following progress. */
 		NdisMoveMemory(pTxBlk->pSrcBufData + pTxBlk->SrcBufLen,
 			       &pAd->PrivateInfo.Tx.MIC[0], 8);
 		/*skb_put((RTPKT_TO_OSPKT(pTxBlk->pPacket))->tail, 8); */
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index e0f13ef..ee6b333 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -2221,7 +2221,7 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 		}
 		txbuf = txbuf + i;
 		*(tail+3)=*(tail+3) &~ 0xfff;
-		*(tail+3)=*(tail+3) | i; // buffer lenght
+		*(tail+3)=*(tail+3) | i; // buffer length
 		// Use short preamble or not
 		if (priv->ieee80211->current_network.capability&WLAN_CAPABILITY_SHORT_PREAMBLE)
 			if (priv->plcp_preamble_mode==1 && rate!=0)	//  short mode now, not long!
diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 6e39f50..77d3c08 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -1760,7 +1760,7 @@ DESC_STRCT *descp;	// pointer to start of FrameList
 *	- Copy DA/SA fields from the 2nd buffer
 *   - Calculate total length of the message (snap-header + type-field + the length of all buffer fragments
 *     associated with the 802.3 frame (i.e all descriptors except the first), but not the DestinationAddress,
-*     SourceAddress and lenght-field)
+*     SourceAddress and length-field)
 *     Assert the message length
 *	  Write length. Note that the message is in BE format, hence on LE platforms the length must be converted
 *	  ;? THIS IS NOT WHAT CURRENTLY IS IMPLEMENTED
diff --git a/drivers/staging/wlags49_h2/wl_util.c b/drivers/staging/wlags49_h2/wl_util.c
index ac1e7f3..f99a92c 100644
--- a/drivers/staging/wlags49_h2/wl_util.c
+++ b/drivers/staging/wlags49_h2/wl_util.c
@@ -1568,8 +1568,8 @@ int i = strlen( string );
 		if ( value > UINT_MAX / base ) {	//test for overrun
 			DBG_FUNC( "wl_atoi" );	//don't overload the log file with good messages
 			DBG_ENTER( DbgInfo );
-			DBG_ERROR( DbgInfo, "string \"%s\", lenght exceeds expectations\n", string );
-			printk( "<1>string \"%s\", lenght exceeds expectations\n", string );
+			DBG_ERROR( DbgInfo, "string \"%s\", length exceeds expectations\n", string );
+			printk( "<1>string \"%s\", length exceeds expectations\n", string );
 			DBG_LEAVE( DbgInfo );
 			break;
 		}
diff --git a/drivers/usb/wusbcore/wusbhc.h b/drivers/usb/wusbcore/wusbhc.h
index fd2fd4e..759cda5 100644
--- a/drivers/usb/wusbcore/wusbhc.h
+++ b/drivers/usb/wusbcore/wusbhc.h
@@ -198,7 +198,7 @@ struct wusb_port {
  *                 ports) this HC will take. Read-only.
  *
  * @port      	   Array of port status for each fake root port. Guaranteed to
- *                 always be the same lenght during device existence
+ *                 always be the same length during device existence
  *                 [this allows for some unlocked but referenced reading].
  *
  * @mmcies_max	   Max number of Information Elements this HC can send
diff --git a/drivers/uwb/uwbd.c b/drivers/uwb/uwbd.c
index 5a777d8..6210fe1 100644
--- a/drivers/uwb/uwbd.c
+++ b/drivers/uwb/uwbd.c
@@ -43,7 +43,7 @@
  *
  * EVENTS
  *
- * Events have a type, a subtype, a lenght, some other stuff and the
+ * Events have a type, a subtype, a length, some other stuff and the
  * data blob, which depends on the event. The header is 'struct
  * uwb_event'; for payloads, see 'struct uwbd_evt_*'.
  *
diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index 20692fb..a20bea5 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -136,7 +136,7 @@ asn1_enum_decode(struct asn1_ctx *ctx, __le32 *val)
 		return 0;
 	}
 
-	ch = *(ctx->pointer)++; /* ch has 0xa, ptr points to lenght octet */
+	ch = *(ctx->pointer)++; /* ch has 0xa, ptr points to length octet */
 	if ((ch) == ASN1_ENUM)  /* if ch value is ENUM, 0xa */
 		*val = *(++(ctx->pointer)); /* value has enum value */
 	else
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d34afad..b794dd8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -69,7 +69,7 @@
  *
  * pa_lstart -> the logical start block for this prealloc space
  * pa_pstart -> the physical start block for this prealloc space
- * pa_len    -> lenght for this prealloc space
+ * pa_len    -> length for this prealloc space
  * pa_free   ->  free space available in this prealloc space
  *
  * The inode preallocation space is used looking at the _logical_ start
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index f90231e..772a4fa 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -102,7 +102,7 @@ void udf_clear_inode(struct inode *inode)
 	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
 	    inode->i_size != iinfo->i_lenExtents) {
 		printk(KERN_WARNING "UDF-fs (%s): Inode %lu (mode %o) has "
-			"inode size %llu different from extent lenght %llu. "
+			"inode size %llu different from extent length %llu. "
 			"Filesystem need not be standards compliant.\n",
 			inode->i_sb->s_id, inode->i_ino, inode->i_mode,
 			(unsigned long long)inode->i_size,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4df6a77..e4b32c8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -549,7 +549,7 @@ static inline int ftrace_trace_task(struct task_struct *task)
  * struct trace_parser - servers for reading the user input separated by spaces
  * @cont: set if the input is not complete - no final space char was found
  * @buffer: holds the parsed user input
- * @idx: user input lenght
+ * @idx: user input length
  * @size: buffer size
  */
 struct trace_parser {
diff --git a/net/dccp/ackvec.h b/net/dccp/ackvec.h
index 7ea557b..fd278d8 100644
--- a/net/dccp/ackvec.h
+++ b/net/dccp/ackvec.h
@@ -73,7 +73,7 @@ struct dccp_ackvec {
  * @avr_ack_ackno - sequence number being acknowledged
  * @avr_ack_ptr - pointer into av_buf where this record starts
  * @avr_ack_nonce - av_ack_nonce at the time this record was sent
- * @avr_sent_len - lenght of the record in av_buf
+ * @avr_sent_len - length of the record in av_buf
  */
 struct dccp_ackvec_record {
 	struct list_head avr_node;
-- 
1.6.3.3

