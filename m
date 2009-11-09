Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZKIIps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZKIIps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZKIIpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:45:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:39718 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbZKIIpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:45:46 -0500
Date: Mon, 9 Nov 2009 09:45:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: linux-next: manual merge of the trivial tree with the  tree
In-Reply-To: <20091109154305.49d3eb7c.sfr@canb.auug.org.au>
Message-ID: <alpine.LSU.2.00.0911090944200.15039@wotan.suse.de>
References: <20091109154305.49d3eb7c.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> drivers/net/wireless/rt2x00/rt2800usb.c between commit
> fcf5154118849cca3cdf424e83f863225d8173e7 ("rt2800: add rt2800lib (part
> three)") from the wireless tree and commit
> 305409a25f7df3c359ba67cbeb62763eeb7156e9 ("tree-wide: fix some typos and
> punctuation in comments") from the trivial tree.
> 
> The misspelling is moved to a new file
> (drivers/net/wireless/rt2x00/rt2800lib.c), but I didn't bother fixing it up.

Sure, thanks for letting me know.

John, I think it'd be best if you just take the appropriate hunks from 
that tree-wide patch into your tree, if you don't mind.

Please find the patch with extracted hunks below, and let me know if/when 
you have applied it, so that I can drop it. Thanks.



From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: rt2x00: fix some typos and punctuation in comments

fix some typos and punctuation in comments

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9fe770f..68b43e3 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1257,7 +1257,7 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 
 	/*
-	 * Wait untill BBP and RF are ready.
+	 * Wait until BBP and RF are ready.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2x00usb_register_read(rt2x00dev, MAC_CSR0, &reg);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b20e3ea..343e565 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -51,7 +51,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
  * These indirect registers work with busy bits,
  * and we will try maximal REGISTER_BUSY_COUNT times to access
  * the register while taking a REGISTER_BUSY_DELAY us delay
- * between each attampt. When the busy bit is still set at that time,
+ * between each attempt. When the busy bit is still set at that time,
  * the access attempt is considered to have failed,
  * and we will print an error.
  */
@@ -386,7 +386,7 @@ static int rt61pci_config_shared_key(struct rt2x00_dev *rt2x00dev,
 		 * The driver does not support the IV/EIV generation
 		 * in hardware. However it doesn't support the IV/EIV
 		 * inside the ieee80211 frame either, but requires it
-		 * to be provided seperately for the descriptor.
+		 * to be provided separately for the descriptor.
 		 * rt2x00lib will cut the IV/EIV data out of all frames
 		 * given to us by mac80211, but we must tell mac80211
 		 * to generate the IV/EIV data.
@@ -397,7 +397,7 @@ static int rt61pci_config_shared_key(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * SEC_CSR0 contains only single-bit fields to indicate
 	 * a particular key is valid. Because using the FIELD32()
-	 * defines directly will cause a lot of overhead we use
+	 * defines directly will cause a lot of overhead, we use
 	 * a calculation to determine the correct bit directly.
 	 */
 	mask = 1 << key->hw_key_idx;
@@ -425,11 +425,11 @@ static int rt61pci_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * rt2x00lib can't determine the correct free
 		 * key_idx for pairwise keys. We have 2 registers
-		 * with key valid bits. The goal is simple, read
-		 * the first register, if that is full move to
+		 * with key valid bits. The goal is simple: read
+		 * the first register. If that is full, move to
 		 * the next register.
-		 * When both registers are full, we drop the key,
-		 * otherwise we use the first invalid entry.
+		 * When both registers are full, we drop the key.
+		 * Otherwise, we use the first invalid entry.
 		 */
 		rt2x00pci_register_read(rt2x00dev, SEC_CSR2, &reg);
 		if (reg && reg == ~0) {
@@ -464,8 +464,8 @@ static int rt61pci_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 					      &addr_entry, sizeof(addr_entry));
 
 		/*
-		 * Enable pairwise lookup table for given BSS idx,
-		 * without this received frames will not be decrypted
+		 * Enable pairwise lookup table for given BSS idx.
+		 * Without this, received frames will not be decrypted
 		 * by the hardware.
 		 */
 		rt2x00pci_register_read(rt2x00dev, SEC_CSR4, &reg);
@@ -487,7 +487,7 @@ static int rt61pci_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * SEC_CSR2 and SEC_CSR3 contain only single-bit fields to indicate
 	 * a particular key is valid. Because using the FIELD32()
-	 * defines directly will cause a lot of overhead we use
+	 * defines directly will cause a lot of overhead, we use
 	 * a calculation to determine the correct bit directly.
 	 */
 	if (key->hw_key_idx < 32) {
@@ -556,7 +556,7 @@ static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
 	if (flags & CONFIG_UPDATE_TYPE) {
 		/*
 		 * Clear current synchronisation setup.
-		 * For the Beacon base registers we only need to clear
+		 * For the Beacon base registers, we only need to clear
 		 * the first byte since that byte contains the VALID and OWNER
 		 * bits which (when set to 0) will invalidate the entire beacon.
 		 */
@@ -1168,8 +1168,8 @@ static int rt61pci_check_firmware(struct rt2x00_dev *rt2x00dev,
 		return FW_BAD_LENGTH;
 
 	/*
-	 * The last 2 bytes in the firmware array are the crc checksum itself,
-	 * this means that we should never pass those 2 bytes to the crc
+	 * The last 2 bytes in the firmware array are the crc checksum itself.
+	 * This means that we should never pass those 2 bytes to the crc
 	 * algorithm.
 	 */
 	fw_crc = (data[len - 2] << 8 | data[len - 1]);
@@ -1986,7 +1986,7 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 
 		/*
 		 * Hardware has stripped IV/EIV data from 802.11 frame during
-		 * decryption. It has provided the data seperately but rt2x00lib
+		 * decryption. It has provided the data separately but rt2x00lib
 		 * should decide if it should be reinserted.
 		 */
 		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
@@ -2042,7 +2042,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 	 * During each loop we will compare the freshly read
 	 * STA_CSR4 register value with the value read from
 	 * the previous loop. If the 2 values are equal then
-	 * we should stop processing because the chance it
+	 * we should stop processing because the chance is
 	 * quite big that the device has been unplugged and
 	 * we risk going into an endless loop.
 	 */
@@ -2330,7 +2330,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags);
 
 	/*
-	 * Detect if this device has an hardware controlled radio.
+	 * Detect if this device has a hardware controlled radio.
 	 */
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
@@ -2355,7 +2355,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
 
 	/*
-	 * When working with a RF2529 chip without double antenna
+	 * When working with a RF2529 chip without double antenna,
 	 * the antenna settings should be gathered from the NIC
 	 * eeprom word.
 	 */
@@ -2668,7 +2668,7 @@ static int rt61pci_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 
 	/*
 	 * We only need to perform additional register initialization
-	 * for WMM queues/
+	 * for WMM queues.
 	 */
 	if (queue_idx >= 4)
 		return 0;

