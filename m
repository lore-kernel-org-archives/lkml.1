Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675Ab0A2HpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0A2HpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132Ab0A2HpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:45:00 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:46008 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab0A2Ho7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:44:59 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] tree-wide: trivial typo fixes: s/lenght/length/g
Date: Fri, 29 Jan 2010 15:44:02 +0800
Message-Id: <1264751042-2657-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <7vy6jhk4of.fsf@alter.siamese.dyndns.org>
References: <7vy6jhk4of.fsf@alter.siamese.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some misspelled occurences of 'octet' and some comments were also fixed
as I was on it.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
---
 arch/arm/mach-at91/include/mach/at91_mci.h |    2 +-
 arch/s390/crypto/sha_common.c              |    2 +-
 drivers/crypto/hifn_795x.c                 |    2 +-
 drivers/isdn/mISDN/l1oip_core.c            |    2 +-
 drivers/net/ppp_generic.c                  |   15 +++++++--------
 drivers/net/r6040.c                        |    2 +-
 drivers/net/sb1000.c                       |    2 +-
 drivers/net/stmmac/common.h                |    2 +-
 drivers/net/stmmac/gmac.c                  |    4 ++--
 drivers/net/stmmac/mac100.c                |    2 +-
 drivers/net/stmmac/stmmac_ethtool.c        |    2 +-
 drivers/net/wimax/i2400m/i2400m-usb.h      |    2 +-
 drivers/net/wireless/p54/p54spi.c          |    2 +-
 drivers/net/wireless/wl12xx/wl1251_cmd.c   |    2 +-
 drivers/net/wireless/wl12xx/wl1251_rx.c    |    2 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |    2 +-
 drivers/usb/wusbcore/wusbhc.h              |    2 +-
 drivers/uwb/uwbd.c                         |    2 +-
 fs/cifs/asn1.c                             |    2 +-
 fs/ext4/mballoc.c                          |    2 +-
 fs/udf/inode.c                             |    2 +-
 kernel/trace/trace.h                       |    2 +-
 net/dccp/ackvec.h                          |    2 +-
 net/ipv6/ip6_output.c                      |    2 +-
 24 files changed, 31 insertions(+), 32 deletions(-)

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
index 2282e72..7944a7d 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -1436,17 +1436,16 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
 		}
 
 		/*
-		 *check	if we are on the last channel or
-		 *we exceded the lenght	of the data	to
-		 *fragment
+		 * check if we are on the last channel or we exceded the length
+		 * of the data to fragment
 		 */
 		if ((nfree <= 0) || (flen > len))
 			flen = len;
 		/*
-		 *it is not worth to tx on slow channels:
-		 *in that case from the resulting flen according to the
-		 *above formula will be equal or less than zero.
-		 *Skip the channel in this case
+		 * it is not worth to tx on slow channels:
+		 * in that case from the resulting flen according to the above
+		 * formula will be equal or less than zero.
+		 * skip the channel in this case.
 		 */
 		if (flen <=	0) {
 			pch->avail = 2;
@@ -1466,7 +1465,7 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
 			goto noskb;
 		q =	skb_put(frag, flen + hdrlen);
 
-		/* make	the	MP header */
+		/* make	the MP header */
 		q[0] = PPP_MP >> 8;
 		q[1] = PPP_MP;
 		if (ppp->flags & SC_MP_XSHORTSEQ) {
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
diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
index 9f83a11..dab3ac7 100644
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -65,7 +65,7 @@ static const int sb1000_debug = 1;
 
 static const int SB1000_IO_EXTENT = 8;
 /* SB1000 Maximum Receive Unit */
-static const int SB1000_MRU = 1500; /* octects */
+static const int SB1000_MRU = 1500; /* octets */
 
 #define NPIDS 4
 struct sb1000_private {
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
index 52586ee..620b204 100644
--- a/drivers/net/stmmac/gmac.c
+++ b/drivers/net/stmmac/gmac.c
@@ -257,7 +257,7 @@ static int gmac_coe_rdes0(int ipc_err, int type, int payload_err)
 
 	/* bits 5 7 0 | Frame status
 	 * ----------------------------------------------------------
-	 *      0 0 0 | IEEE 802.3 Type frame (lenght < 1536 octects)
+	 *      0 0 0 | IEEE 802.3 Type frame (length < 1536 octets)
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
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index eb6d097..cb4c91d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1206,7 +1206,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 	 * Let's try using as much space as possible.
 	 * Use MTU if total length of the message fits into the MTU.
 	 * Otherwise, we need to reserve fragment header and
-	 * fragment alignment (= 8-15 octects, in total).
+	 * fragment alignment (= 8-15 octets, in total).
 	 *
 	 * Note that we may need to "move" the data from the tail of
 	 * of the buffer to the new fragment when we split
-- 
1.6.3.3

