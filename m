Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab0BCDqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:46:40 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45813 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab0BCDqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:46:10 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH 11/11] tree-wide: Fix spelling of 'necessary'
Date: Wed,  3 Feb 2010 00:48:27 +0800
Message-Id: <1265129307-18201-11-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265129307-18201-10-git-send-email-daniel@caiaq.de>
References: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
 <1265129307-18201-2-git-send-email-daniel@caiaq.de>
 <1265129307-18201-3-git-send-email-daniel@caiaq.de>
 <1265129307-18201-4-git-send-email-daniel@caiaq.de>
 <1265129307-18201-5-git-send-email-daniel@caiaq.de>
 <1265129307-18201-6-git-send-email-daniel@caiaq.de>
 <1265129307-18201-7-git-send-email-daniel@caiaq.de>
 <1265129307-18201-8-git-send-email-daniel@caiaq.de>
 <1265129307-18201-9-git-send-email-daniel@caiaq.de>
 <1265129307-18201-10-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Junio C Hamano <gitster@pobox.com>
---
 Documentation/DocBook/v4l/common.xml        |    2 +-
 Documentation/DocBook/v4l/vidioc-g-parm.xml |    2 +-
 drivers/ata/libata-sff.c                    |    2 +-
 drivers/ata/pata_acpi.c                     |    2 +-
 drivers/ata/pata_hpt3x3.c                   |    2 +-
 drivers/ata/pata_pcmcia.c                   |    2 +-
 drivers/char/pty.c                          |    2 +-
 drivers/char/tty_io.c                       |    2 +-
 drivers/char/vt.c                           |    2 +-
 drivers/media/video/gspca/ov519.c           |    2 +-
 drivers/net/tehuti.c                        |    2 +-
 drivers/net/wimax/i2400m/fw.c               |    2 +-
 drivers/net/wimax/i2400m/sdio.c             |    4 ++--
 drivers/net/wimax/i2400m/usb.c              |    4 ++--
 drivers/scsi/a100u2w.c                      |    2 +-
 drivers/scsi/initio.c                       |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c            |    2 +-
 fs/cifs/cifs_dfs_ref.c                      |    2 +-
 fs/cifs/cifssmb.c                           |    2 +-
 include/linux/lru_cache.h                   |    2 +-
 sound/soc/codecs/wm8990.c                   |    2 +-
 21 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/Documentation/DocBook/v4l/common.xml b/Documentation/DocBook/v4l/common.xml
index c65f0ac..cea23e1 100644
--- a/Documentation/DocBook/v4l/common.xml
+++ b/Documentation/DocBook/v4l/common.xml
@@ -1170,7 +1170,7 @@ frames per second. If less than this number of frames is to be
 captured or output, applications can request frame skipping or
 duplicating on the driver side. This is especially useful when using
 the &func-read; or &func-write;, which are not augmented by timestamps
-or sequence counters, and to avoid unneccessary data copying.</para>
+or sequence counters, and to avoid unnecessary data copying.</para>
 
     <para>Finally these ioctls can be used to determine the number of
 buffers used internally by a driver in read/write mode. For
diff --git a/Documentation/DocBook/v4l/vidioc-g-parm.xml b/Documentation/DocBook/v4l/vidioc-g-parm.xml
index 78332d3..392aa9e 100644
--- a/Documentation/DocBook/v4l/vidioc-g-parm.xml
+++ b/Documentation/DocBook/v4l/vidioc-g-parm.xml
@@ -55,7 +55,7 @@ captured or output, applications can request frame skipping or
 duplicating on the driver side. This is especially useful when using
 the <function>read()</function> or <function>write()</function>, which
 are not augmented by timestamps or sequence counters, and to avoid
-unneccessary data copying.</para>
+unnecessary data copying.</para>
 
     <para>Further these ioctls can be used to determine the number of
 buffers used internally by a driver in read/write mode. For
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 741065c..7f2c94a 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2258,7 +2258,7 @@ EXPORT_SYMBOL_GPL(ata_sff_postreset);
  *	@qc: command
  *
  *	Drain the FIFO and device of any stuck data following a command
- *	failing to complete. In some cases this is neccessary before a
+ *	failing to complete. In some cases this is necessary before a
  *	reset will recover the device.
  *
  */
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index d8f35fe..9e33da9 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -161,7 +161,7 @@ static void pacpi_set_dmamode(struct ata_port *ap, struct ata_device *adev)
  *
  *	Called when the libata layer is about to issue a command. We wrap
  *	this interface so that we can load the correct ATA timings if
- *	neccessary.
+ *	necessary.
  */
 
 static unsigned int pacpi_qc_issue(struct ata_queued_cmd *qc)
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index c86c716..727a81c 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -180,7 +180,7 @@ static void hpt3x3_init_chipset(struct pci_dev *dev)
  *	@id: Entry in match table
  *
  *	Perform basic initialisation. We set the device up so we access all
- *	ports via BAR4. This is neccessary to work around errata.
+ *	ports via BAR4. This is necessary to work around errata.
  */
 
 static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 1b392c9..416aebb 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -131,7 +131,7 @@ static unsigned int ata_data_xfer_8bit(struct ata_device *dev,
  *	@qc: command
  *
  *	Drain the FIFO and device of any stuck data following a command
- *	failing to complete. In some cases this is neccessary before a
+ *	failing to complete. In some cases this is necessary before a
  *	reset will recover the device.
  *
  */
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 385c44b..5ee4248 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -220,7 +220,7 @@ static void pty_set_termios(struct tty_struct *tty,
  *	@tty: tty being resized
  *	@ws: window size being set.
  *
- *	Update the termios variables and send the neccessary signals to
+ *	Update the termios variables and send the necessary signals to
  *	peform a terminal resize correctly
  */
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index c6f3b48..56b11c1 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2026,7 +2026,7 @@ static int tiocgwinsz(struct tty_struct *tty, struct winsize __user *arg)
  *	@rows: rows (character)
  *	@cols: cols (character)
  *
- *	Update the termios variables and send the neccessary signals to
+ *	Update the termios variables and send the necessary signals to
  *	peform a terminal resize correctly
  */
 
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 50faa1f..19e6673 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -821,7 +821,7 @@ static inline int resize_screen(struct vc_data *vc, int width, int height,
  *
  *	Resize a virtual console, clipping according to the actual constraints.
  *	If the caller passes a tty structure then update the termios winsize
- *	information and perform any neccessary signal handling.
+ *	information and perform any necessary signal handling.
  *
  *	Caller must hold the console semaphore. Takes the termios mutex and
  *	ctrl_lock of the tty IFF a tty is passed.
diff --git a/drivers/media/video/gspca/ov519.c b/drivers/media/video/gspca/ov519.c
index b4f9657..e5e4c44 100644
--- a/drivers/media/video/gspca/ov519.c
+++ b/drivers/media/video/gspca/ov519.c
@@ -503,7 +503,7 @@ static const struct v4l2_pix_format ovfx2_ov3610_mode[] = {
 /*
  * The FX2 chip does not give us a zero length read at end of frame.
  * It does, however, give a short read at the end of a frame, if
- * neccessary, rather than run two frames together.
+ * necessary, rather than run two frames together.
  *
  * By choosing the right bulk transfer size, we are guaranteed to always
  * get a short read for the last read of each frame.  Frame sizes are
diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 80b404f..ed4e9c4 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -1857,7 +1857,7 @@ static void bdx_tx_push_desc(struct bdx_priv *priv, void *data, int size)
  * @data - desc's data
  * @size - desc's size
  *
- * NOTE: this func does check for available space and, if neccessary, waits for
+ * NOTE: this func does check for available space and, if necessary, waits for
  *   NIC to read existing data before writing new one.
  */
 static void bdx_tx_push_desc_safe(struct bdx_priv *priv, void *data, int size)
diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index 64cdfeb..6c459f5 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -612,7 +612,7 @@ ssize_t i2400m_bm_cmd(struct i2400m *i2400m,
 		goto error_wait_for_ack;
 	}
 	rx_bytes = result;
-	/* verify the ack and read more if neccessary [result is the
+	/* verify the ack and read more if necessary [result is the
 	 * final amount of bytes we get in the ack]  */
 	result = __i2400m_bm_ack_verify(i2400m, opcode, ack, ack_size, flags);
 	if (result < 0)
diff --git a/drivers/net/wimax/i2400m/sdio.c b/drivers/net/wimax/i2400m/sdio.c
index 76a50ac..14f876b 100644
--- a/drivers/net/wimax/i2400m/sdio.c
+++ b/drivers/net/wimax/i2400m/sdio.c
@@ -304,7 +304,7 @@ error_kzalloc:
  *
  * The device will be fully reset internally, but won't be
  * disconnected from the bus (so no reenumeration will
- * happen). Firmware upload will be neccessary.
+ * happen). Firmware upload will be necessary.
  *
  * The device will send a reboot barker that will trigger the driver
  * to reinitialize the state via __i2400m_dev_reset_handle.
@@ -314,7 +314,7 @@ error_kzalloc:
  *
  * The device will be fully reset internally, disconnected from the
  * bus an a reenumeration will happen. Firmware upload will be
- * neccessary. Thus, we don't do any locking or struct
+ * necessary. Thus, we don't do any locking or struct
  * reinitialization, as we are going to be fully disconnected and
  * reenumerated.
  *
diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index 98f4f8c..99f04c4 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -246,7 +246,7 @@ error_kzalloc:
  *
  * The device will be fully reset internally, but won't be
  * disconnected from the USB bus (so no reenumeration will
- * happen). Firmware upload will be neccessary.
+ * happen). Firmware upload will be necessary.
  *
  * The device will send a reboot barker in the notification endpoint
  * that will trigger the driver to reinitialize the state
@@ -257,7 +257,7 @@ error_kzalloc:
  *
  * The device will be fully reset internally, disconnected from the
  * USB bus an a reenumeration will happen. Firmware upload will be
- * neccessary. Thus, we don't do any locking or struct
+ * necessary. Thus, we don't do any locking or struct
  * reinitialization, as we are going to be fully disconnected and
  * reenumerated.
  *
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 208d6df..ff5716d 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -492,7 +492,7 @@ static void init_alloc_map(struct orc_host * host)
  *	init_orchid		-	initialise the host adapter
  *	@host:host adapter to initialise
  *
- *	Initialise the controller and if neccessary load the firmware.
+ *	Initialise the controller and if necessary load the firmware.
  *
  *	Returns -1 if the initialisation fails.
  */
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 89a5948..a771416 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -531,7 +531,7 @@ static void initio_read_eeprom(unsigned long base)
  *	initio_stop_bm		-	stop bus master
  *	@host: InitIO we are stopping
  *
- *	Stop any pending DMA operation, aborting the DMA if neccessary
+ *	Stop any pending DMA operation, aborting the DMA if necessary
  */
 
 static void initio_stop_bm(struct initio_host * host)
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 7f9c83a..3b2c98f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -600,7 +600,7 @@ static void pm8001_free_dev(struct pm8001_device *pm8001_dev)
   * by the command "OPC_INB_REG_DEV", after that the HBA will assign a
   * device ID(according to device's sas address) and returned it to LLDD. From
   * now on, we communicate with HBA FW with the device ID which HBA assigned
-  * rather than sas address. it is the neccessary step for our HBA but it is
+  * rather than sas address. it is the necessary step for our HBA but it is
   * the optional for other HBA driver.
   */
 static int pm8001_dev_found_notify(struct domain_device *dev)
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index b44ce0a..b1d61d0 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -54,7 +54,7 @@ void cifs_dfs_release_automount_timer(void)
  * Extracts sharename form full UNC.
  * i.e. strips from UNC trailing path that is not part of share
  * name and fixup missing '\' in the begining of DFS node refferal
- * if neccessary.
+ * if necessary.
  * Returns pointer to share name on success or ERR_PTR on error.
  * Caller is responsible for freeing returned string.
  */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 941441d..0e22440 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3886,7 +3886,7 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 		goto parse_DFS_referrals_exit;
 	}
 
-	/* collect neccessary data from referrals */
+	/* collect necessary data from referrals */
 	for (i = 0; i < *num_of_nodes; i++) {
 		char *temp;
 		int max_len;
diff --git a/include/linux/lru_cache.h b/include/linux/lru_cache.h
index 3a2b2d9..de48d16 100644
--- a/include/linux/lru_cache.h
+++ b/include/linux/lru_cache.h
@@ -64,7 +64,7 @@ For crash recovery after replication node failure,
   usually the condition is softened to regions that _may_ have been target of
   in-flight WRITE IO, e.g. by only lazily clearing the on-disk write-intent
   bitmap, trading frequency of meta data transactions against amount of
-  (possibly unneccessary) resync traffic.
+  (possibly unnecessary) resync traffic.
 
   If we set a hard limit on the area that may be "hot" at any given time, we
   limit the amount of resync traffic needed for crash recovery.
diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 341481e..427614a 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -990,7 +990,7 @@ static int wm8990_set_dai_pll(struct snd_soc_dai *codec_dai, int pll_id,
 		reg = snd_soc_read(codec, WM8990_CLOCKING_2);
 		snd_soc_write(codec, WM8990_CLOCKING_2, reg | WM8990_SYSCLK_SRC);
 
-		/* set up N , fractional mode and pre-divisor if neccessary */
+		/* set up N , fractional mode and pre-divisor if necessary */
 		snd_soc_write(codec, WM8990_PLL1, pll_div.n | WM8990_SDM |
 			(pll_div.div2?WM8990_PRESCALE:0));
 		snd_soc_write(codec, WM8990_PLL2, (u8)(pll_div.k>>8));
-- 
1.6.3.3

