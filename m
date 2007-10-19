Return-Path: <linux-kernel-owner+w=401wt.eu-S935257AbXJSH6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935257AbXJSH6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967097AbXJSH5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:57:48 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52814 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967079AbXJSH5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:57:43 -0400
Date: Fri, 19 Oct 2007 03:57:42 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 6/9] irq-remove: sound driver trivial
Message-ID: <20071019075742.GG6407@havoc.gtf.org>
References: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019075443.GA6407@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 6348eaa5c5320cc3c4fac5ca1d41b587388e74d9
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 00:48:10 2007 -0400

    [IRQ ARG REMOVAL] trivial sound driver updates

 sound/aoa/core/snd-aoa-gpio-feature.c   |    2 +-
 sound/aoa/soundbus/i2sbus/i2sbus-core.c |    2 +-
 sound/aoa/soundbus/i2sbus/i2sbus-pcm.c  |    4 ++--
 sound/aoa/soundbus/i2sbus/i2sbus.h      |    4 ++--
 sound/arm/aaci.c                        |    2 +-
 sound/arm/pxa2xx-ac97.c                 |    2 +-
 sound/drivers/mpu401/mpu401_uart.c      |    4 ++--
 sound/drivers/mtpav.c                   |    2 +-
 sound/drivers/serial-u16550.c           |    2 +-
 sound/drivers/vx/vx_core.c              |    2 +-
 sound/isa/ad1816a/ad1816a_lib.c         |    2 +-
 sound/isa/ad1848/ad1848_lib.c           |    2 +-
 sound/isa/cs423x/cs4231_lib.c           |    2 +-
 sound/isa/es1688/es1688_lib.c           |    2 +-
 sound/isa/es18xx.c                      |    4 ++--
 sound/isa/gus/gus_irq.c                 |    2 +-
 sound/isa/gus/gusmax.c                  |    6 +++---
 sound/isa/gus/interwave.c               |    6 +++---
 sound/isa/opl3sa2.c                     |    6 +++---
 sound/isa/opti9xx/opti92x-ad1848.c      |    2 +-
 sound/isa/sb/es968.c                    |    2 +-
 sound/isa/sb/sb16_main.c                |    4 ++--
 sound/isa/sb/sb8.c                      |    2 +-
 sound/isa/sgalaxy.c                     |    2 +-
 sound/isa/wavefront/wavefront.c         |    2 +-
 sound/mips/au1x00.c                     |    2 +-
 sound/oss/ad1848.c                      |    4 ++--
 sound/oss/btaudio.c                     |    2 +-
 sound/oss/dmasound/dmasound_atari.c     |    4 ++--
 sound/oss/dmasound/dmasound_paula.c     |    4 ++--
 sound/oss/dmasound/dmasound_q40.c       |    8 ++++----
 sound/oss/hal2.c                        |    2 +-
 sound/oss/i810_audio.c                  |    2 +-
 sound/oss/mpu401.c                      |    2 +-
 sound/oss/mpu401.h                      |    2 +-
 sound/oss/msnd_pinnacle.c               |    2 +-
 sound/oss/pas2_card.c                   |    2 +-
 sound/oss/sb_common.c                   |    4 ++--
 sound/oss/sh_dac_audio.c                |    2 +-
 sound/oss/swarm_cs4297a.c               |    2 +-
 sound/oss/trident.c                     |    2 +-
 sound/oss/uart401.c                     |    2 +-
 sound/oss/uart6850.c                    |    2 +-
 sound/oss/via82cxxx_audio.c             |    6 +++---
 sound/oss/vidc.h                        |    2 +-
 sound/oss/vwsnd.c                       |    2 +-
 sound/oss/waveartist.c                  |    4 ++--
 sound/parisc/harmony.c                  |    2 +-
 sound/pci/ad1889.c                      |    2 +-
 sound/pci/ali5451/ali5451.c             |    2 +-
 sound/pci/als300.c                      |    4 ++--
 sound/pci/als4000.c                     |    4 ++--
 sound/pci/atiixp.c                      |    2 +-
 sound/pci/atiixp_modem.c                |    2 +-
 sound/pci/au88x0/au88x0.h               |    2 +-
 sound/pci/au88x0/au88x0_core.c          |    5 ++---
 sound/pci/azt3328.c                     |    4 ++--
 sound/pci/bt87x.c                       |    2 +-
 sound/pci/ca0106/ca0106_main.c          |    2 +-
 sound/pci/cmipci.c                      |    4 ++--
 sound/pci/cs4281.c                      |    4 ++--
 sound/pci/cs46xx/cs46xx_lib.c           |    2 +-
 sound/pci/cs5535audio/cs5535audio.c     |    2 +-
 sound/pci/echoaudio/echoaudio.c         |    2 +-
 sound/pci/emu10k1/emu10k1x.c            |    2 +-
 sound/pci/emu10k1/irq.c                 |    2 +-
 sound/pci/ens1370.c                     |    4 ++--
 sound/pci/es1938.c                      |    6 +++---
 sound/pci/es1968.c                      |    9 ++++-----
 sound/pci/fm801.c                       |    4 ++--
 sound/pci/hda/hda_intel.c               |    2 +-
 sound/pci/ice1712/ice1712.c             |    6 +++---
 sound/pci/ice1712/ice1724.c             |    4 ++--
 sound/pci/intel8x0.c                    |    2 +-
 sound/pci/intel8x0m.c                   |    2 +-
 sound/pci/korg1212/korg1212.c           |    2 +-
 sound/pci/maestro3.c                    |    4 ++--
 sound/pci/mixart/mixart_core.c          |    2 +-
 sound/pci/mixart/mixart_core.h          |    2 +-
 sound/pci/nm256/nm256.c                 |    4 ++--
 sound/pci/pcxhr/pcxhr_core.c            |    2 +-
 sound/pci/pcxhr/pcxhr_core.h            |    2 +-
 sound/pci/riptide/riptide.c             |    5 ++---
 sound/pci/rme32.c                       |    2 +-
 sound/pci/rme96.c                       |    3 +--
 sound/pci/rme9652/hdsp.c                |    2 +-
 sound/pci/rme9652/hdspm.c               |    2 +-
 sound/pci/rme9652/rme9652.c             |    2 +-
 sound/pci/sonicvibes.c                  |    4 ++--
 sound/pci/trident/trident_main.c        |    6 +++---
 sound/pci/via82xx.c                     |    6 +++---
 sound/pci/via82xx_modem.c               |    2 +-
 sound/pci/ymfpci/ymfpci_main.c          |    4 ++--
 sound/pcmcia/pdaudiocf/pdaudiocf.h      |    2 +-
 sound/pcmcia/pdaudiocf/pdaudiocf_irq.c  |    2 +-
 sound/ppc/pmac.c                        |    6 +++---
 sound/ppc/tumbler.c                     |    2 +-
 sound/sparc/amd7930.c                   |    2 +-
 sound/sparc/cs4231.c                    |    2 +-
 sound/sparc/dbri.c                      |    2 +-
 100 files changed, 148 insertions(+), 152 deletions(-)

6348eaa5c5320cc3c4fac5ca1d41b587388e74d9
diff --git a/sound/aoa/core/snd-aoa-gpio-feature.c b/sound/aoa/core/snd-aoa-gpio-feature.c
index 805dcbf..1915d9b 100644
--- a/sound/aoa/core/snd-aoa-gpio-feature.c
+++ b/sound/aoa/core/snd-aoa-gpio-feature.c
@@ -281,7 +281,7 @@ static void ftr_gpio_exit(struct gpio_runtime *rt)
 	mutex_destroy(&rt->line_out_notify.mutex);
 }
 
-static irqreturn_t ftr_handle_notify_irq(int xx, void *data)
+static irqreturn_t ftr_handle_notify_irq(void *data)
 {
 	struct gpio_notification *notif = data;
 
diff --git a/sound/aoa/soundbus/i2sbus/i2sbus-core.c b/sound/aoa/soundbus/i2sbus/i2sbus-core.c
index efb9441..ee0a5ac 100644
--- a/sound/aoa/soundbus/i2sbus/i2sbus-core.c
+++ b/sound/aoa/soundbus/i2sbus/i2sbus-core.c
@@ -92,7 +92,7 @@ static void i2sbus_release_dev(struct device *dev)
 	kfree(i2sdev);
 }
 
-static irqreturn_t i2sbus_bus_intr(int irq, void *devid)
+static irqreturn_t i2sbus_bus_intr(void *devid)
 {
 	struct i2sbus_dev *dev = devid;
 	u32 intreg;
diff --git a/sound/aoa/soundbus/i2sbus/i2sbus-pcm.c b/sound/aoa/soundbus/i2sbus/i2sbus-pcm.c
index c6b42f9..e732f15 100644
--- a/sound/aoa/soundbus/i2sbus/i2sbus-pcm.c
+++ b/sound/aoa/soundbus/i2sbus/i2sbus-pcm.c
@@ -702,13 +702,13 @@ static inline void handle_interrupt(struct i2sbus_dev *i2sdev, int in)
 	spin_unlock(&i2sdev->low_lock);
 }
 
-irqreturn_t i2sbus_tx_intr(int irq, void *devid)
+irqreturn_t i2sbus_tx_intr(void *devid)
 {
 	handle_interrupt((struct i2sbus_dev *)devid, 0);
 	return IRQ_HANDLED;
 }
 
-irqreturn_t i2sbus_rx_intr(int irq, void *devid)
+irqreturn_t i2sbus_rx_intr(void *devid)
 {
 	handle_interrupt((struct i2sbus_dev *)devid, 1);
 	return IRQ_HANDLED;
diff --git a/sound/aoa/soundbus/i2sbus/i2sbus.h b/sound/aoa/soundbus/i2sbus/i2sbus.h
index ff29654..9d97f3b 100644
--- a/sound/aoa/soundbus/i2sbus/i2sbus.h
+++ b/sound/aoa/soundbus/i2sbus/i2sbus.h
@@ -100,9 +100,9 @@ i2sbus_attach_codec(struct soundbus_dev *dev, struct snd_card *card,
 extern void
 i2sbus_detach_codec(struct soundbus_dev *dev, void *data);
 extern irqreturn_t
-i2sbus_tx_intr(int irq, void *devid);
+i2sbus_tx_intr(void *devid);
 extern irqreturn_t
-i2sbus_rx_intr(int irq, void *devid);
+i2sbus_rx_intr(void *devid);
 
 extern void i2sbus_wait_for_stop_both(struct i2sbus_dev *i2sdev);
 extern void i2sbus_pcm_prepare_both(struct i2sbus_dev *i2sdev);
diff --git a/sound/arm/aaci.c b/sound/arm/aaci.c
index 3b73ba7..2c7b8bc 100644
--- a/sound/arm/aaci.c
+++ b/sound/arm/aaci.c
@@ -309,7 +309,7 @@ static void aaci_fifo_irq(struct aaci *aaci, int channel, u32 mask)
 	}
 }
 
-static irqreturn_t aaci_irq(int irq, void *devid)
+static irqreturn_t aaci_irq(void *devid)
 {
 	struct aaci *aaci = devid;
 	u32 mask;
diff --git a/sound/arm/pxa2xx-ac97.c b/sound/arm/pxa2xx-ac97.c
index 7bc2767..4110b80 100644
--- a/sound/arm/pxa2xx-ac97.c
+++ b/sound/arm/pxa2xx-ac97.c
@@ -152,7 +152,7 @@ static void pxa2xx_ac97_reset(struct snd_ac97 *ac97)
 	GCR |= GCR_SDONE_IE|GCR_CDONE_IE;
 }
 
-static irqreturn_t pxa2xx_ac97_irq(int irq, void *dev_id)
+static irqreturn_t pxa2xx_ac97_irq(void *dev_id)
 {
 	long status;
 
diff --git a/sound/drivers/mpu401/mpu401_uart.c b/sound/drivers/mpu401/mpu401_uart.c
index 3306ecd..702c2dd 100644
--- a/sound/drivers/mpu401/mpu401_uart.c
+++ b/sound/drivers/mpu401/mpu401_uart.c
@@ -128,7 +128,7 @@ static void _snd_mpu401_uart_interrupt(struct snd_mpu401 *mpu)
  *
  * Processes the interrupt for MPU401-UART i/o.
  */
-irqreturn_t snd_mpu401_uart_interrupt(int irq, void *dev_id)
+irqreturn_t snd_mpu401_uart_interrupt(void *dev_id)
 {
 	struct snd_mpu401 *mpu = dev_id;
 	
@@ -147,7 +147,7 @@ EXPORT_SYMBOL(snd_mpu401_uart_interrupt);
  *
  * Processes the interrupt for MPU401-UART output.
  */
-irqreturn_t snd_mpu401_uart_interrupt_tx(int irq, void *dev_id)
+irqreturn_t snd_mpu401_uart_interrupt_tx(void *dev_id)
 {
 	struct snd_mpu401 *mpu = dev_id;
 	
diff --git a/sound/drivers/mtpav.c b/sound/drivers/mtpav.c
index 40eb026..ae65941 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -570,7 +570,7 @@ static void snd_mtpav_read_bytes(struct mtpav *mcrd)
 	} while (sbyt & SIGS_BYTE);
 }
 
-static irqreturn_t snd_mtpav_irqh(int irq, void *dev_id)
+static irqreturn_t snd_mtpav_irqh(void *dev_id)
 {
 	struct mtpav *mcard = dev_id;
 
diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
index 65de3a7..63c08a3 100644
--- a/sound/drivers/serial-u16550.c
+++ b/sound/drivers/serial-u16550.c
@@ -292,7 +292,7 @@ static void snd_uart16550_io_loop(struct snd_uart16550 * uart)
  * Note that some devices need OUT2 to be set before they will generate
  * interrupts at all. (Possibly tied to an internal pull-up on CTS?)
  */
-static irqreturn_t snd_uart16550_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_uart16550_interrupt(void *dev_id)
 {
 	struct snd_uart16550 *uart;
 
diff --git a/sound/drivers/vx/vx_core.c b/sound/drivers/vx/vx_core.c
index ed19bc1..d043118 100644
--- a/sound/drivers/vx/vx_core.c
+++ b/sound/drivers/vx/vx_core.c
@@ -537,7 +537,7 @@ static void vx_interrupt(unsigned long private_data)
 /**
  * snd_vx_irq_handler - interrupt handler
  */
-irqreturn_t snd_vx_irq_handler(int irq, void *dev)
+irqreturn_t snd_vx_irq_handler(void *dev)
 {
 	struct vx_core *chip = dev;
 
diff --git a/sound/isa/ad1816a/ad1816a_lib.c b/sound/isa/ad1816a/ad1816a_lib.c
index cf18fe4..376bd96 100644
--- a/sound/isa/ad1816a/ad1816a_lib.c
+++ b/sound/isa/ad1816a/ad1816a_lib.c
@@ -315,7 +315,7 @@ static snd_pcm_uframes_t snd_ad1816a_capture_pointer(struct snd_pcm_substream *s
 }
 
 
-static irqreturn_t snd_ad1816a_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_ad1816a_interrupt(void *dev_id)
 {
 	struct snd_ad1816a *chip = dev_id;
 	unsigned char status;
diff --git a/sound/isa/ad1848/ad1848_lib.c b/sound/isa/ad1848/ad1848_lib.c
index a901cd1..d3686db 100644
--- a/sound/isa/ad1848/ad1848_lib.c
+++ b/sound/isa/ad1848/ad1848_lib.c
@@ -564,7 +564,7 @@ static int snd_ad1848_capture_prepare(struct snd_pcm_substream *substream)
 	return 0;
 }
 
-static irqreturn_t snd_ad1848_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_ad1848_interrupt(void *dev_id)
 {
 	struct snd_ad1848 *chip = dev_id;
 
diff --git a/sound/isa/cs423x/cs4231_lib.c b/sound/isa/cs423x/cs4231_lib.c
index a5eb965..94b0961 100644
--- a/sound/isa/cs423x/cs4231_lib.c
+++ b/sound/isa/cs423x/cs4231_lib.c
@@ -909,7 +909,7 @@ static void snd_cs4231_overrange(struct snd_cs4231 *chip)
 		chip->capture_substream->runtime->overrange++;
 }
 
-irqreturn_t snd_cs4231_interrupt(int irq, void *dev_id)
+irqreturn_t snd_cs4231_interrupt(void *dev_id)
 {
 	struct snd_cs4231 *chip = dev_id;
 	unsigned char status;
diff --git a/sound/isa/es1688/es1688_lib.c b/sound/isa/es1688/es1688_lib.c
index 5c26d49..1f20e42 100644
--- a/sound/isa/es1688/es1688_lib.c
+++ b/sound/isa/es1688/es1688_lib.c
@@ -479,7 +479,7 @@ static int snd_es1688_capture_trigger(struct snd_pcm_substream *substream,
 	return snd_es1688_trigger(chip, cmd, 0x0f);
 }
 
-static irqreturn_t snd_es1688_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_es1688_interrupt(void *dev_id)
 {
 	struct snd_es1688 *chip = dev_id;
 
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 4a7367a..369a6f2 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -754,7 +754,7 @@ static int snd_es18xx_playback_trigger(struct snd_pcm_substream *substream,
 		return snd_es18xx_playback2_trigger(chip, substream, cmd);
 }
 
-static irqreturn_t snd_es18xx_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_es18xx_interrupt(void *dev_id)
 {
 	struct snd_es18xx *chip = dev_id;
 	unsigned char status;
@@ -799,7 +799,7 @@ static irqreturn_t snd_es18xx_interrupt(int irq, void *dev_id)
 
 	/* MPU */
 	if ((status & MPU_IRQ) && chip->rmidi)
-		snd_mpu401_uart_interrupt(irq, chip->rmidi->private_data);
+		snd_mpu401_uart_interrupt(chip->rmidi->private_data);
 
 	/* Hardware volume */
 	if (status & HWV_IRQ) {
diff --git a/sound/isa/gus/gus_irq.c b/sound/isa/gus/gus_irq.c
index cd9a6f1..ea27421 100644
--- a/sound/isa/gus/gus_irq.c
+++ b/sound/isa/gus/gus_irq.c
@@ -30,7 +30,7 @@
 #define STAT_ADD(x)	while (0) { ; }
 #endif
 
-irqreturn_t snd_gus_interrupt(int irq, void *dev_id)
+irqreturn_t snd_gus_interrupt(void *dev_id)
 {
 	struct snd_gus_card * gus = dev_id;
 	unsigned char status;
diff --git a/sound/isa/gus/gusmax.c b/sound/isa/gus/gusmax.c
index 4922f5d..31d4121 100644
--- a/sound/isa/gus/gusmax.c
+++ b/sound/isa/gus/gusmax.c
@@ -103,7 +103,7 @@ static int __devinit snd_gusmax_detect(struct snd_gus_card * gus)
 	return 0;
 }
 
-static irqreturn_t snd_gusmax_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_gusmax_interrupt(void *dev_id)
 {
 	struct snd_gusmax *maxcard = dev_id;
 	int loop, max = 5;
@@ -113,12 +113,12 @@ static irqreturn_t snd_gusmax_interrupt(int irq, void *dev_id)
 		loop = 0;
 		if (inb(maxcard->gus_status_reg)) {
 			handled = 1;
-			snd_gus_interrupt(irq, maxcard->gus);
+			snd_gus_interrupt(maxcard->gus);
 			loop++;
 		}
 		if (inb(maxcard->pcm_status_reg) & 0x01) { /* IRQ bit is set? */
 			handled = 1;
-			snd_cs4231_interrupt(irq, maxcard->cs4231);
+			snd_cs4231_interrupt(maxcard->cs4231);
 			loop++;
 		}
 	} while (loop && --max > 0);
diff --git a/sound/isa/gus/interwave.c b/sound/isa/gus/interwave.c
index 2091c50..6cd4770 100644
--- a/sound/isa/gus/interwave.c
+++ b/sound/isa/gus/interwave.c
@@ -298,7 +298,7 @@ static int __devinit snd_interwave_detect(struct snd_interwave *iwcard,
 	return -ENODEV;
 }
 
-static irqreturn_t snd_interwave_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_interwave_interrupt(void *dev_id)
 {
 	struct snd_interwave *iwcard = dev_id;
 	int loop, max = 5;
@@ -308,12 +308,12 @@ static irqreturn_t snd_interwave_interrupt(int irq, void *dev_id)
 		loop = 0;
 		if (inb(iwcard->gus_status_reg)) {
 			handled = 1;
-			snd_gus_interrupt(irq, iwcard->gus);
+			snd_gus_interrupt(iwcard->gus);
 			loop++;
 		}
 		if (inb(iwcard->pcm_status_reg) & 0x01) {	/* IRQ bit is set? */
 			handled = 1;
-			snd_cs4231_interrupt(irq, iwcard->cs4231);
+			snd_cs4231_interrupt(iwcard->cs4231);
 			loop++;
 		}
 	} while (loop && --max > 0);
diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
index 59af9ab..44ba899 100644
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -296,7 +296,7 @@ static int __devinit snd_opl3sa2_detect(struct snd_opl3sa2 *chip)
 	return 0;
 }
 
-static irqreturn_t snd_opl3sa2_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_opl3sa2_interrupt(void *dev_id)
 {
 	unsigned short status;
 	struct snd_opl3sa2 *chip = dev_id;
@@ -314,12 +314,12 @@ static irqreturn_t snd_opl3sa2_interrupt(int irq, void *dev_id)
 
 	if ((status & 0x10) && chip->rmidi != NULL) {
 		handled = 1;
-		snd_mpu401_uart_interrupt(irq, chip->rmidi->private_data);
+		snd_mpu401_uart_interrupt(chip->rmidi->private_data);
 	}
 
 	if (status & 0x07) {	/* TI,CI,PI */
 		handled = 1;
-		snd_cs4231_interrupt(irq, chip->cs4231);
+		snd_cs4231_interrupt(chip->cs4231);
 	}
 
 	if (status & 0x40) { /* hardware volume change */
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index ee1a824..4e04ee7 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -1098,7 +1098,7 @@ static void snd_opti93x_overrange(struct snd_opti93x *chip)
 	spin_unlock_irqrestore(&chip->lock, flags);
 }
 
-static irqreturn_t snd_opti93x_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_opti93x_interrupt(void *dev_id)
 {
 	struct snd_opti93x *codec = dev_id;
 	unsigned char status;
diff --git a/sound/isa/sb/es968.c b/sound/isa/sb/es968.c
index d4b2187..4eb3bbf 100644
--- a/sound/isa/sb/es968.c
+++ b/sound/isa/sb/es968.c
@@ -70,7 +70,7 @@ MODULE_DEVICE_TABLE(pnp_card, snd_es968_pnpids);
 
 #define	DRIVER_NAME	"snd-card-es968"
 
-static irqreturn_t snd_card_es968_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_card_es968_interrupt(void *dev_id)
 {
 	struct snd_sb *chip = dev_id;
 
diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index c06754f..eea5976 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -395,7 +395,7 @@ static int snd_sb16_capture_trigger(struct snd_pcm_substream *substream,
 	return result;
 }
 
-irqreturn_t snd_sb16dsp_interrupt(int irq, void *dev_id)
+irqreturn_t snd_sb16dsp_interrupt(void *dev_id)
 {
 	struct snd_sb *chip = dev_id;
 	unsigned char status;
@@ -405,7 +405,7 @@ irqreturn_t snd_sb16dsp_interrupt(int irq, void *dev_id)
 	status = snd_sbmixer_read(chip, SB_DSP4_IRQSTATUS);
 	spin_unlock(&chip->mixer_lock);
 	if ((status & SB_IRQTYPE_MPUIN) && chip->rmidi_callback)
-		chip->rmidi_callback(irq, chip->rmidi->private_data);
+		chip->rmidi_callback(chip->rmidi->private_data);
 	if (status & SB_IRQTYPE_8BIT) {
 		ok = 0;
 		if (chip->mode & SB_MODE_PLAYBACK_8) {
diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
index f933aef..8b3aa59 100644
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -61,7 +61,7 @@ struct snd_sb8 {
 	struct snd_sb *chip;
 };
 
-static irqreturn_t snd_sb8_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_sb8_interrupt(void *dev_id)
 {
 	struct snd_sb *chip = dev_id;
 
diff --git a/sound/isa/sgalaxy.c b/sound/isa/sgalaxy.c
index 922519d..3255bea 100644
--- a/sound/isa/sgalaxy.c
+++ b/sound/isa/sgalaxy.c
@@ -108,7 +108,7 @@ static int __devinit snd_sgalaxy_sbdsp_command(unsigned long port,
 	return 0;
 }
 
-static irqreturn_t snd_sgalaxy_dummy_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_sgalaxy_dummy_interrupt(void *dev_id)
 {
 	return IRQ_NONE;
 }
diff --git a/sound/isa/wavefront/wavefront.c b/sound/isa/wavefront/wavefront.c
index 83c2fc4..5cc35d4 100644
--- a/sound/isa/wavefront/wavefront.c
+++ b/sound/isa/wavefront/wavefront.c
@@ -264,7 +264,7 @@ snd_wavefront_pnp (int dev, snd_wavefront_card_t *acard, struct pnp_card_link *c
 
 #endif /* CONFIG_PNP */
 
-static irqreturn_t snd_wavefront_ics2115_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_wavefront_ics2115_interrupt(void *dev_id)
 {
 	snd_wavefront_card_t *acard;
 
diff --git a/sound/mips/au1x00.c b/sound/mips/au1x00.c
index 8a61a11..f4f7ae8 100644
--- a/sound/mips/au1x00.c
+++ b/sound/mips/au1x00.c
@@ -220,7 +220,7 @@ au1000_dma_start(struct audio_stream *stream)
 }
 
 static irqreturn_t
-au1000_dma_interrupt(int irq, void *dev_id)
+au1000_dma_interrupt(void *dev_id)
 {
 	struct audio_stream *stream = (struct audio_stream *) dev_id;
 	struct snd_pcm_substream *substream = stream->substream;
diff --git a/sound/oss/ad1848.c b/sound/oss/ad1848.c
index 7cf9913..0848881 100644
--- a/sound/oss/ad1848.c
+++ b/sound/oss/ad1848.c
@@ -195,7 +195,7 @@ static void     ad1848_halt(int dev);
 static void     ad1848_halt_input(int dev);
 static void     ad1848_halt_output(int dev);
 static void     ad1848_trigger(int dev, int bits);
-static irqreturn_t adintr(int irq, void *dev_id);
+static irqreturn_t adintr(void *dev_id);
 
 #ifndef EXCLUDE_TIMERS
 static int ad1848_tmr_install(int dev);
@@ -2196,7 +2196,7 @@ void ad1848_unload(int io_base, int irq, int dma_playback, int dma_capture, int
 		printk(KERN_ERR "ad1848: Can't find device to be unloaded. Base=%x\n", io_base);
 }
 
-static irqreturn_t adintr(int irq, void *dev_id)
+static irqreturn_t adintr(void *dev_id)
 {
 	unsigned char status;
 	ad1848_info *devc;
diff --git a/sound/oss/btaudio.c b/sound/oss/btaudio.c
index 4d5cf05..5583f35 100644
--- a/sound/oss/btaudio.c
+++ b/sound/oss/btaudio.c
@@ -824,7 +824,7 @@ static char *irq_name[] = { "", "", "", "OFLOW", "", "", "", "", "", "", "",
 			    "RISCI", "FBUS", "FTRGT", "FDSR", "PPERR",
 			    "RIPERR", "PABORT", "OCERR", "SCERR" };
 
-static irqreturn_t btaudio_irq(int irq, void *dev_id)
+static irqreturn_t btaudio_irq(void *dev_id)
 {
 	int count = 0;
 	u32 stat,astat;
diff --git a/sound/oss/dmasound/dmasound_atari.c b/sound/oss/dmasound/dmasound_atari.c
index 285239d..bf5db09 100644
--- a/sound/oss/dmasound/dmasound_atari.c
+++ b/sound/oss/dmasound/dmasound_atari.c
@@ -133,7 +133,7 @@ static int FalconSetFormat(int format);
 static int FalconSetVolume(int volume);
 static void AtaPlayNextFrame(int index);
 static void AtaPlay(void);
-static irqreturn_t AtaInterrupt(int irq, void *dummy);
+static irqreturn_t AtaInterrupt(void *dummy);
 
 /*** Mid level stuff *********************************************************/
 
@@ -1257,7 +1257,7 @@ static void AtaPlay(void)
 }
 
 
-static irqreturn_t AtaInterrupt(int irq, void *dummy)
+static irqreturn_t AtaInterrupt(void *dummy)
 {
 #if 0
 	/* ++TeSche: if you should want to test this... */
diff --git a/sound/oss/dmasound/dmasound_paula.c b/sound/oss/dmasound/dmasound_paula.c
index 90fc058..cc85922 100644
--- a/sound/oss/dmasound/dmasound_paula.c
+++ b/sound/oss/dmasound/dmasound_paula.c
@@ -82,7 +82,7 @@ static int AmiSetVolume(int volume);
 static int AmiSetTreble(int treble);
 static void AmiPlayNextFrame(int index);
 static void AmiPlay(void);
-static irqreturn_t AmiInterrupt(int irq, void *dummy);
+static irqreturn_t AmiInterrupt(void *dummy);
 
 #ifdef CONFIG_HEARTBEAT
 
@@ -556,7 +556,7 @@ static void AmiPlay(void)
 }
 
 
-static irqreturn_t AmiInterrupt(int irq, void *dummy)
+static irqreturn_t AmiInterrupt(void *dummy)
 {
 	int minframes = 1;
 
diff --git a/sound/oss/dmasound/dmasound_q40.c b/sound/oss/dmasound/dmasound_q40.c
index b3379dd..d706976 100644
--- a/sound/oss/dmasound/dmasound_q40.c
+++ b/sound/oss/dmasound/dmasound_q40.c
@@ -48,8 +48,8 @@ static int Q40SetFormat(int format);
 static int Q40SetVolume(int volume);
 static void Q40PlayNextFrame(int index);
 static void Q40Play(void);
-static irqreturn_t Q40StereoInterrupt(int irq, void *dummy);
-static irqreturn_t Q40MonoInterrupt(int irq, void *dummy);
+static irqreturn_t Q40StereoInterrupt(void *dummy);
+static irqreturn_t Q40MonoInterrupt(void *dummy);
 static void Q40Interrupt(void);
 
 
@@ -451,7 +451,7 @@ static void Q40Play(void)
 	spin_unlock_irqrestore(&dmasound.lock, flags);
 }
 
-static irqreturn_t Q40StereoInterrupt(int irq, void *dummy)
+static irqreturn_t Q40StereoInterrupt(void *dummy)
 {
 	spin_lock(&dmasound.lock);
         if (q40_sc>1){
@@ -463,7 +463,7 @@ static irqreturn_t Q40StereoInterrupt(int irq, void *dummy)
 	spin_unlock(&dmasound.lock);
 	return IRQ_HANDLED;
 }
-static irqreturn_t Q40MonoInterrupt(int irq, void *dummy)
+static irqreturn_t Q40MonoInterrupt(void *dummy)
 {
 	spin_lock(&dmasound.lock);
         if (q40_sc>0){
diff --git a/sound/oss/hal2.c b/sound/oss/hal2.c
index a94b9df..4d4f8fa 100644
--- a/sound/oss/hal2.c
+++ b/sound/oss/hal2.c
@@ -370,7 +370,7 @@ static void hal2_adc_interrupt(struct hal2_codec *adc)
 	wake_up(&adc->dma_wait);
 }
 
-static irqreturn_t hal2_interrupt(int irq, void *dev_id)
+static irqreturn_t hal2_interrupt(void *dev_id)
 {
 	struct hal2_card *hal2 = dev_id;
 	irqreturn_t ret = IRQ_NONE;
diff --git a/sound/oss/i810_audio.c b/sound/oss/i810_audio.c
index f5e31f1..d99fe07 100644
--- a/sound/oss/i810_audio.c
+++ b/sound/oss/i810_audio.c
@@ -1524,7 +1524,7 @@ static void i810_channel_interrupt(struct i810_card *card)
 #endif
 }
 
-static irqreturn_t i810_interrupt(int irq, void *dev_id)
+static irqreturn_t i810_interrupt(void *dev_id)
 {
 	struct i810_card *card = dev_id;
 	u32 status;
diff --git a/sound/oss/mpu401.c b/sound/oss/mpu401.c
index a690ca5..111fcd9 100644
--- a/sound/oss/mpu401.c
+++ b/sound/oss/mpu401.c
@@ -432,7 +432,7 @@ static void mpu401_input_loop(struct mpu_config *devc)
 	devc->m_busy = 0;
 }
 
-static irqreturn_t mpuintr(int irq, void *dev_id)
+static irqreturn_t mpuintr(void *dev_id)
 {
 	struct mpu_config *devc;
 	int dev = (int)(unsigned long) dev_id;
diff --git a/sound/oss/mpu401.h b/sound/oss/mpu401.h
index 0ad1e9e..fe21576 100644
--- a/sound/oss/mpu401.h
+++ b/sound/oss/mpu401.h
@@ -3,7 +3,7 @@
 int probe_uart401 (struct address_info *hw_config, struct module *owner);
 void unload_uart401 (struct address_info *hw_config);
 
-irqreturn_t uart401intr (int irq, void *dev_id);
+irqreturn_t uart401intr (void *dev_id);
 
 /*	From mpu401.c */
 int probe_mpu401(struct address_info *hw_config, struct resource *ports);
diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index f1f49eb..efd59c8 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -1087,7 +1087,7 @@ static __inline__ void eval_dsp_msg(register WORD wMessage)
 	}
 }
 
-static irqreturn_t intr(int irq, void *dev_id)
+static irqreturn_t intr(void *dev_id)
 {
 	/* Send ack to DSP */
 	msnd_inb(dev.io + HP_RXL);
diff --git a/sound/oss/pas2_card.c b/sound/oss/pas2_card.c
index 25f3a22..e9902fa 100644
--- a/sound/oss/pas2_card.c
+++ b/sound/oss/pas2_card.c
@@ -88,7 +88,7 @@ void pas_write(unsigned char data, int ioaddr)
 
 /******************* Begin of the Interrupt Handler ********************/
 
-static irqreturn_t pasintr(int irq, void *dev_id)
+static irqreturn_t pasintr(void *dev_id)
 {
 	int             status;
 
diff --git a/sound/oss/sb_common.c b/sound/oss/sb_common.c
index 07cbacf..1c65d0b 100644
--- a/sound/oss/sb_common.c
+++ b/sound/oss/sb_common.c
@@ -132,7 +132,7 @@ static void sb_intr (sb_devc *devc)
 
 		if (src & 4)						/* MPU401 interrupt */
 			if(devc->midi_irq_cookie)
-				uart401intr(devc->irq, devc->midi_irq_cookie);
+				uart401intr(devc->midi_irq_cookie);
 
 		if (!(src & 3))
 			return;	/* Not a DSP interrupt */
@@ -200,7 +200,7 @@ static void pci_intr(sb_devc *devc)
 		sb_intr(devc);
 }
 
-static irqreturn_t sbintr(int irq, void *dev_id)
+static irqreturn_t sbintr(void *dev_id)
 {
 	sb_devc *devc = dev_id;
 
diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
index b493660..2971832 100644
--- a/sound/oss/sh_dac_audio.c
+++ b/sound/oss/sh_dac_audio.c
@@ -263,7 +263,7 @@ const struct file_operations dac_audio_fops = {
       .release =	dac_audio_release,
 };
 
-static irqreturn_t timer1_interrupt(int irq, void *dev)
+static irqreturn_t timer1_interrupt(void *dev)
 {
 	unsigned long timer_status;
 
diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index a8057f2..e58fdd6 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -2503,7 +2503,7 @@ static /*const */ struct file_operations cs4297a_audio_fops = {
 	.release	= cs4297a_release,
 };
 
-static void cs4297a_interrupt(int irq, void *dev_id)
+static void cs4297a_interrupt(void *dev_id)
 {
 	struct cs4297a_state *s = (struct cs4297a_state *) dev_id;
         u32 status;
diff --git a/sound/oss/trident.c b/sound/oss/trident.c
index 96adc47..e702019 100644
--- a/sound/oss/trident.c
+++ b/sound/oss/trident.c
@@ -1811,7 +1811,7 @@ cyber_address_interrupt(struct trident_card *card)
 }
 
 static irqreturn_t
-trident_interrupt(int irq, void *dev_id)
+trident_interrupt(void *dev_id)
 {
 	struct trident_card *card = (struct trident_card *) dev_id;
 	u32 event;
diff --git a/sound/oss/uart401.c b/sound/oss/uart401.c
index a446b82..50922ef 100644
--- a/sound/oss/uart401.c
+++ b/sound/oss/uart401.c
@@ -96,7 +96,7 @@ static void uart401_input_loop(uart401_devc * devc)
 		printk(KERN_WARNING "Too much work in interrupt on uart401 (0x%X). UART jabbering ??\n", devc->base);
 }
 
-irqreturn_t uart401intr(int irq, void *dev_id)
+irqreturn_t uart401intr(void *dev_id)
 {
 	uart401_devc *devc = dev_id;
 
diff --git a/sound/oss/uart6850.c b/sound/oss/uart6850.c
index f3f914a..ccc3cf1 100644
--- a/sound/oss/uart6850.c
+++ b/sound/oss/uart6850.c
@@ -104,7 +104,7 @@ static void uart6850_input_loop(void)
 	}
 }
 
-static irqreturn_t m6850intr(int irq, void *dev_id)
+static irqreturn_t m6850intr(void *dev_id)
 {
 	if (input_avail())
 		uart6850_input_loop();
diff --git a/sound/oss/via82cxxx_audio.c b/sound/oss/via82cxxx_audio.c
index 5d3c037..a2b73ed 100644
--- a/sound/oss/via82cxxx_audio.c
+++ b/sound/oss/via82cxxx_audio.c
@@ -1911,7 +1911,7 @@ static void via_intr_channel (struct via_info *card, struct via_channel *chan)
 }
 
 
-static irqreturn_t  via_interrupt(int irq, void *dev_id)
+static irqreturn_t  via_interrupt(void *dev_id)
 {
 	struct via_info *card = dev_id;
 	u32 status32;
@@ -1926,7 +1926,7 @@ static irqreturn_t  via_interrupt(int irq, void *dev_id)
         {
 #ifdef CONFIG_MIDI_VIA82CXXX
 	    	 if (card->midi_devc)
-                    	uart401intr(irq, card->midi_devc);
+                    	uart401intr(card->midi_devc);
 #endif
 		return IRQ_HANDLED;
     	}
@@ -1949,7 +1949,7 @@ static irqreturn_t  via_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t via_new_interrupt(int irq, void *dev_id)
+static irqreturn_t via_new_interrupt(void *dev_id)
 {
 	struct via_info *card = dev_id;
 	u32 status32;
diff --git a/sound/oss/vidc.h b/sound/oss/vidc.h
index 0d14247..95da71a 100644
--- a/sound/oss/vidc.h
+++ b/sound/oss/vidc.h
@@ -33,7 +33,7 @@ extern unsigned long vidc_fill_2x16_s(unsigned long ibuf, unsigned long iend,
  * DMA Interrupt handler
  */
 
-extern irqreturn_t vidc_sound_dma_irq(int irqnr, void *ref);
+extern irqreturn_t vidc_sound_dma_irq(void *ref);
 
 /*
  * Filler routine pointer
diff --git a/sound/oss/vwsnd.c b/sound/oss/vwsnd.c
index d25249a..6cf7c74 100644
--- a/sound/oss/vwsnd.c
+++ b/sound/oss/vwsnd.c
@@ -2233,7 +2233,7 @@ static void vwsnd_audio_write_intr(vwsnd_dev_t *devc, unsigned int status)
 		pcm_output(devc, underflown, 0);
 }
 
-static irqreturn_t vwsnd_audio_intr(int irq, void *dev_id)
+static irqreturn_t vwsnd_audio_intr(void *dev_id)
 {
 	vwsnd_dev_t *devc = dev_id;
 	unsigned int status;
diff --git a/sound/oss/waveartist.c b/sound/oss/waveartist.c
index b48c729..4bdac2a 100644
--- a/sound/oss/waveartist.c
+++ b/sound/oss/waveartist.c
@@ -833,9 +833,9 @@ static struct audio_driver waveartist_audio_driver = {
 
 
 static irqreturn_t
-waveartist_intr(int irq, void *dev_id)
+waveartist_intr(void *dev_id)
 {
-	wavnc_info *devc = (wavnc_info *)dev_id;
+	wavnc_info *devc = dev_id;
 	int	   irqstatus, status;
 
 	spin_lock(&waveartist_lock);
diff --git a/sound/parisc/harmony.c b/sound/parisc/harmony.c
index ff705c6..141ae20 100644
--- a/sound/parisc/harmony.c
+++ b/sound/parisc/harmony.c
@@ -193,7 +193,7 @@ harmony_set_control(struct snd_harmony *h)
 }
 
 static irqreturn_t
-snd_harmony_interrupt(int irq, void *dev)
+snd_harmony_interrupt(void *dev)
 {
 	u32 dstatus;
 	struct snd_harmony *h = dev;
diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index 98970d4..5272038 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -596,7 +596,7 @@ static struct snd_pcm_ops snd_ad1889_capture_ops = {
 };
 
 static irqreturn_t
-snd_ad1889_interrupt(int irq, void *dev_id)
+snd_ad1889_interrupt(void *dev_id)
 {
 	unsigned long st;
 	struct snd_ad1889 *chip = dev_id;
diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 4c2bd7a..8c3ce64 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -968,7 +968,7 @@ static void snd_ali_update_ptr(struct snd_ali *codec, int channel)
 	pchregs->data.aint = old & (~mask);
 }
 
-static irqreturn_t snd_ali_card_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_ali_card_interrupt(void *dev_id)
 {
 	struct snd_ali 	*codec = dev_id;
 	int channel;
diff --git a/sound/pci/als300.c b/sound/pci/als300.c
index 48cc39b..1fdd075 100644
--- a/sound/pci/als300.c
+++ b/sound/pci/als300.c
@@ -204,7 +204,7 @@ static int snd_als300_dev_free(struct snd_device *device)
 	return snd_als300_free(chip);
 }
 
-static irqreturn_t snd_als300_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_als300_interrupt(void *dev_id)
 {
 	u8 status;
 	struct snd_als300 *chip = dev_id;
@@ -235,7 +235,7 @@ static irqreturn_t snd_als300_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t snd_als300plus_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_als300plus_interrupt(void *dev_id)
 {
 	u8 general, mpu, dram;
 	struct snd_als300 *chip = dev_id;
diff --git a/sound/pci/als4000.c b/sound/pci/als4000.c
index 1190ef3..6f08ea2 100644
--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -385,7 +385,7 @@ static snd_pcm_uframes_t snd_als4000_playback_pointer(struct snd_pcm_substream *
  * SB IRQ status.
  * And do we *really* need the lock here for *reading* SB_DSP4_IRQSTATUS??
  * */
-static irqreturn_t snd_als4000_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_als4000_interrupt(void *dev_id)
 {
 	struct snd_sb *chip = dev_id;
 	unsigned gcr_status;
@@ -399,7 +399,7 @@ static irqreturn_t snd_als4000_interrupt(int irq, void *dev_id)
 	if ((gcr_status & 0x40) && (chip->capture_substream)) /* capturing */
 		snd_pcm_period_elapsed(chip->capture_substream);
 	if ((gcr_status & 0x10) && (chip->rmidi)) /* MPU401 interrupt */
-		snd_mpu401_uart_interrupt(irq, chip->rmidi->private_data);
+		snd_mpu401_uart_interrupt(chip->rmidi->private_data);
 	/* release the gcr */
 	outb(gcr_status, chip->alt_port + 0xe);
 	
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 89184a4..8f91784 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1329,7 +1329,7 @@ static int __devinit snd_atiixp_pcm_new(struct atiixp *chip)
 /*
  * interrupt handler
  */
-static irqreturn_t snd_atiixp_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_atiixp_interrupt(void *dev_id)
 {
 	struct atiixp *chip = dev_id;
 	unsigned int status;
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index ce752f8..c592e6a 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1017,7 +1017,7 @@ static int __devinit snd_atiixp_pcm_new(struct atiixp_modem *chip)
 /*
  * interrupt handler
  */
-static irqreturn_t snd_atiixp_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_atiixp_interrupt(void *dev_id)
 {
 	struct atiixp_modem *chip = dev_id;
 	unsigned int status;
diff --git a/sound/pci/au88x0/au88x0.h b/sound/pci/au88x0/au88x0.h
index 5ccf0b1..06133a0 100644
--- a/sound/pci/au88x0/au88x0.h
+++ b/sound/pci/au88x0/au88x0.h
@@ -236,7 +236,7 @@ static void vortex_spdif_init(vortex_t * vortex, int spdif_sr, int spdif_mode);
 static int vortex_core_init(vortex_t * card);
 static int vortex_core_shutdown(vortex_t * card);
 static void vortex_enable_int(vortex_t * card);
-static irqreturn_t vortex_interrupt(int irq, void *dev_id);
+static irqreturn_t vortex_interrupt(void *dev_id);
 static int vortex_alsafmt_aspfmt(int alsafmt);
 
 /* Connection  stuff. */
diff --git a/sound/pci/au88x0/au88x0_core.c b/sound/pci/au88x0/au88x0_core.c
index 4a336ea..e385146 100644
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -2385,7 +2385,7 @@ static void vortex_disable_int(vortex_t * card)
 		hwread(card->mmio, VORTEX_CTRL) & ~CTRL_IRQ_ENABLE);
 }
 
-static irqreturn_t vortex_interrupt(int irq, void *dev_id)
+static irqreturn_t vortex_interrupt(void *dev_id)
 {
 	vortex_t *vortex = dev_id;
 	int i, handled;
@@ -2461,8 +2461,7 @@ static irqreturn_t vortex_interrupt(int irq, void *dev_id)
 		handled = 1;
 	}
 	if (source & IRQ_MIDI) {
-		snd_mpu401_uart_interrupt(vortex->irq,
-					  vortex->rmidi->private_data);
+		snd_mpu401_uart_interrupt(vortex->rmidi->private_data);
 		handled = 1;
 	}
 
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 36d3666..09cc9de 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -1198,7 +1198,7 @@ snd_azf3328_capture_pointer(struct snd_pcm_substream *substream)
 }
 
 static irqreturn_t
-snd_azf3328_interrupt(int irq, void *dev_id)
+snd_azf3328_interrupt(void *dev_id)
 {
 	struct snd_azf3328 *chip = dev_id;
 	u8 status, which;
@@ -1263,7 +1263,7 @@ snd_azf3328_interrupt(int irq, void *dev_id)
 	/* MPU401 has less critical IRQ requirements
 	 * than timer and playback/recording, right? */
 	if (status & IRQ_MPU401) {
-		snd_mpu401_uart_interrupt(irq, chip->rmidi->private_data);
+		snd_mpu401_uart_interrupt(chip->rmidi->private_data);
 
 		/* hmm, do we have to ack the IRQ here somehow?
 		 * If so, then I don't know how... */
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index 91f9e6a..b2c37f0 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -310,7 +310,7 @@ static void snd_bt87x_pci_error(struct snd_bt87x *chip, unsigned int status)
 	}
 }
 
-static irqreturn_t snd_bt87x_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_bt87x_interrupt(void *dev_id)
 {
 	struct snd_bt87x *chip = dev_id;
 	unsigned int status, irq_status;
diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index 31d8db9..c14ab27 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -1138,7 +1138,7 @@ static int snd_ca0106_dev_free(struct snd_device *device)
 	return snd_ca0106_free(chip);
 }
 
-static irqreturn_t snd_ca0106_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_ca0106_interrupt(void *dev_id)
 {
 	unsigned int status;
 
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 6832649..d51f834 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -1412,7 +1412,7 @@ static int snd_cmipci_capture_spdif_hw_free(struct snd_pcm_substream *subs)
 /*
  * interrupt handler
  */
-static irqreturn_t snd_cmipci_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_cmipci_interrupt(void *dev_id)
 {
 	struct cmipci *cm = dev_id;
 	unsigned int status, mask = 0;
@@ -1433,7 +1433,7 @@ static irqreturn_t snd_cmipci_interrupt(int irq, void *dev_id)
 	spin_unlock(&cm->reg_lock);
 
 	if (cm->rmidi && (status & CM_UARTINT))
-		snd_mpu401_uart_interrupt(irq, cm->rmidi->private_data);
+		snd_mpu401_uart_interrupt(cm->rmidi->private_data);
 
 	if (cm->pcm) {
 		if ((status & CM_CHINT0) && cm->channel[0].running)
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index 9a55f4a..ba3f91c 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -493,7 +493,7 @@ struct cs4281 {
 
 };
 
-static irqreturn_t snd_cs4281_interrupt(int irq, void *dev_id);
+static irqreturn_t snd_cs4281_interrupt(void *dev_id);
 
 static struct pci_device_id snd_cs4281_ids[] = {
 	{ 0x1013, 0x6005, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },	/* CS4281 */
@@ -1810,7 +1810,7 @@ static int __devinit snd_cs4281_midi(struct cs4281 * chip, int device,
  *  Interrupt handler
  */
 
-static irqreturn_t snd_cs4281_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_cs4281_interrupt(void *dev_id)
 {
 	struct cs4281 *chip = dev_id;
 	unsigned int status, dma, val;
diff --git a/sound/pci/cs46xx/cs46xx_lib.c b/sound/pci/cs46xx/cs46xx_lib.c
index 2c7bfc9..194d328 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -1149,7 +1149,7 @@ static int snd_cs46xx_capture_prepare(struct snd_pcm_substream *substream)
 	return 0;
 }
 
-static irqreturn_t snd_cs46xx_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_cs46xx_interrupt(void *dev_id)
 {
 	struct snd_cs46xx *chip = dev_id;
 	u32 status1;
diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index 2b35889..64c7cf0 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -203,7 +203,7 @@ static void process_bm1_irq(struct cs5535audio *cs5535au)
 	}
 }
 
-static irqreturn_t snd_cs5535audio_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_cs5535audio_interrupt(void *dev_id)
 {
 	u16 acc_irq_stat;
 	unsigned char count;
diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index 499ee1a..83e03f3 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -1805,7 +1805,7 @@ static struct snd_kcontrol_new snd_echo_channels_info __devinitdata = {
 	IRQ Handler
 ******************************************************************************/
 
-static irqreturn_t snd_echo_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_echo_interrupt(void *dev_id)
 {
 	struct echoaudio *chip = dev_id;
 	struct snd_pcm_substream *substream;
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index 1ec7eba..992a9b7 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -780,7 +780,7 @@ static int snd_emu10k1x_dev_free(struct snd_device *device)
 	return snd_emu10k1x_free(chip);
 }
 
-static irqreturn_t snd_emu10k1x_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_emu10k1x_interrupt(void *dev_id)
 {
 	unsigned int status;
 
diff --git a/sound/pci/emu10k1/irq.c b/sound/pci/emu10k1/irq.c
index 3c114b4..d5b7df9 100644
--- a/sound/pci/emu10k1/irq.c
+++ b/sound/pci/emu10k1/irq.c
@@ -30,7 +30,7 @@
 #include <sound/core.h>
 #include <sound/emu10k1.h>
 
-irqreturn_t snd_emu10k1_interrupt(int irq, void *dev_id)
+irqreturn_t snd_emu10k1_interrupt(void *dev_id)
 {
 	struct snd_emu10k1 *emu = dev_id;
 	unsigned int status, status2, orig_status, orig_status2;
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index b958f86..d6954d8 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -442,7 +442,7 @@ struct ensoniq {
 #endif
 };
 
-static irqreturn_t snd_audiopci_interrupt(int irq, void *dev_id);
+static irqreturn_t snd_audiopci_interrupt(void *dev_id);
 
 static struct pci_device_id snd_audiopci_ids[] = {
 #ifdef CHIP1370
@@ -2358,7 +2358,7 @@ static int __devinit snd_ensoniq_midi(struct ensoniq * ensoniq, int device,
  *  Interrupt handler
  */
 
-static irqreturn_t snd_audiopci_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_audiopci_interrupt(void *dev_id)
 {
 	struct ensoniq *ensoniq = dev_id;
 	unsigned int status, sctrl;
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index fb25abe..65e0fcc 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -241,7 +241,7 @@ struct es1938 {
 #endif
 };
 
-static irqreturn_t snd_es1938_interrupt(int irq, void *dev_id);
+static irqreturn_t snd_es1938_interrupt(void *dev_id);
 
 static struct pci_device_id snd_es1938_ids[] = {
         { 0x125d, 0x1969, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* Solo-1 */
@@ -1645,7 +1645,7 @@ static int __devinit snd_es1938_create(struct snd_card *card,
 /* --------------------------------------------------------------------
  * Interrupt handler
  * -------------------------------------------------------------------- */
-static irqreturn_t snd_es1938_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_es1938_interrupt(void *dev_id)
 {
 	struct es1938 *chip = dev_id;
 	unsigned char status, audiostatus;
@@ -1717,7 +1717,7 @@ static irqreturn_t snd_es1938_interrupt(int irq, void *dev_id)
 		// snd_es1938_mixer_bits(chip, ESSSB_IREG_MPU401CONTROL, 0x40, 0); /* ack? */
 		if (chip->rmidi) {
 			handled = 1;
-			snd_mpu401_uart_interrupt(irq, chip->rmidi->private_data);
+			snd_mpu401_uart_interrupt(chip->rmidi->private_data);
 		}
 	}
 	return IRQ_RETVAL(handled);
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index d69b11d..c15e89d 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -550,7 +550,7 @@ struct es1968 {
 #endif
 };
 
-static irqreturn_t snd_es1968_interrupt(int irq, void *dev_id);
+static irqreturn_t snd_es1968_interrupt(void *dev_id);
 
 static struct pci_device_id snd_es1968_ids[] = {
 	/* Maestro 1 */
@@ -1913,7 +1913,7 @@ static void es1968_update_hw_volume(unsigned long private_data)
 /*
  * interrupt handler
  */
-static irqreturn_t snd_es1968_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_es1968_interrupt(void *dev_id)
 {
 	struct es1968 *chip = dev_id;
 	u32 event;
@@ -1929,9 +1929,8 @@ static irqreturn_t snd_es1968_interrupt(int irq, void *dev_id)
 	/* else ack 'em all, i imagine */
 	outb(0xFF, chip->io_port + 0x1A);
 
-	if ((event & ESM_MPU401_IRQ) && chip->rmidi) {
-		snd_mpu401_uart_interrupt(irq, chip->rmidi->private_data);
-	}
+	if ((event & ESM_MPU401_IRQ) && chip->rmidi)
+		snd_mpu401_uart_interrupt(chip->rmidi->private_data);
 
 	if (event & ESM_SOUND_IRQ) {
 		struct esschan *es;
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 9939109..1037c1d 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -520,7 +520,7 @@ static snd_pcm_uframes_t snd_fm801_capture_pointer(struct snd_pcm_substream *sub
 	return bytes_to_frames(substream->runtime, ptr);
 }
 
-static irqreturn_t snd_fm801_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_fm801_interrupt(void *dev_id)
 {
 	struct fm801 *chip = dev_id;
 	unsigned short status;
@@ -561,7 +561,7 @@ static irqreturn_t snd_fm801_interrupt(int irq, void *dev_id)
 		snd_pcm_period_elapsed(chip->capture_substream);
 	}
 	if (chip->rmidi && (status & FM801_IRQ_MPU))
-		snd_mpu401_uart_interrupt(irq, chip->rmidi->private_data);
+		snd_mpu401_uart_interrupt(chip->rmidi->private_data);
 	if (status & FM801_IRQ_VOLUME)
 		;/* TODO */
 
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 3fa0f97..abb9229 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -878,7 +878,7 @@ static void azx_init_pci(struct azx *chip)
 /*
  * interrupt handler
  */
-static irqreturn_t azx_interrupt(int irq, void *dev_id)
+static irqreturn_t azx_interrupt(void *dev_id)
 {
 	struct azx *chip = dev_id;
 	struct azx_dev *azx_dev;
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 052fc3c..089f263 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -413,7 +413,7 @@ static void snd_ice1712_set_input_clock_source(struct snd_ice1712 *ice, int spdi
  *  Interrupt handler
  */
 
-static irqreturn_t snd_ice1712_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_ice1712_interrupt(void *dev_id)
 {
 	struct snd_ice1712 *ice = dev_id;
 	unsigned char status;
@@ -426,7 +426,7 @@ static irqreturn_t snd_ice1712_interrupt(int irq, void *dev_id)
 		handled = 1;
 		if (status & ICE1712_IRQ_MPU1) {
 			if (ice->rmidi[0])
-				snd_mpu401_uart_interrupt(irq, ice->rmidi[0]->private_data);
+				snd_mpu401_uart_interrupt(ice->rmidi[0]->private_data);
 			outb(ICE1712_IRQ_MPU1, ICEREG(ice, IRQSTAT));
 			status &= ~ICE1712_IRQ_MPU1;
 		}
@@ -434,7 +434,7 @@ static irqreturn_t snd_ice1712_interrupt(int irq, void *dev_id)
 			outb(ICE1712_IRQ_TIMER, ICEREG(ice, IRQSTAT));
 		if (status & ICE1712_IRQ_MPU2) {
 			if (ice->rmidi[1])
-				snd_mpu401_uart_interrupt(irq, ice->rmidi[1]->private_data);
+				snd_mpu401_uart_interrupt(ice->rmidi[1]->private_data);
 			outb(ICE1712_IRQ_MPU2, ICEREG(ice, IRQSTAT));
 			status &= ~ICE1712_IRQ_MPU2;
 		}
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 0b0bbb0..e61b1f1 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -219,7 +219,7 @@ static unsigned int snd_vt1724_get_gpio_data(struct snd_ice1712 *ice)
  *  Interrupt handler
  */
 
-static irqreturn_t snd_vt1724_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_vt1724_interrupt(void *dev_id)
 {
 	struct snd_ice1712 *ice = dev_id;
 	unsigned char status;
@@ -237,7 +237,7 @@ static irqreturn_t snd_vt1724_interrupt(int irq, void *dev_id)
 		 */
 		if ((status & VT1724_IRQ_MPU_RX)||(status & VT1724_IRQ_MPU_TX)) {
 			if (ice->rmidi[0])
-				snd_mpu401_uart_interrupt(irq, ice->rmidi[0]->private_data);
+				snd_mpu401_uart_interrupt(ice->rmidi[0]->private_data);
 			outb(status & (VT1724_IRQ_MPU_RX|VT1724_IRQ_MPU_TX), ICEREG1724(ice, IRQSTAT));
 			status &= ~(VT1724_IRQ_MPU_RX|VT1724_IRQ_MPU_TX);
 		}
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index b4a38a3..12a4f4d 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -777,7 +777,7 @@ static inline void snd_intel8x0_update(struct intel8x0 *chip, struct ichdev *ich
 		 status & (ICH_FIFOE | ICH_BCIS | ICH_LVBCI));
 }
 
-static irqreturn_t snd_intel8x0_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_intel8x0_interrupt(void *dev_id)
 {
 	struct intel8x0 *chip = dev_id;
 	struct ichdev *ichdev;
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index fad806e..97a88df 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -483,7 +483,7 @@ static inline void snd_intel8x0_update(struct intel8x0m *chip, struct ichdev *ic
 	iputbyte(chip, port + ichdev->roff_sr, ICH_FIFOE | ICH_BCIS | ICH_LVBCI);
 }
 
-static irqreturn_t snd_intel8x0_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_intel8x0_interrupt(void *dev_id)
 {
 	struct intel8x0m *chip = dev_id;
 	struct ichdev *ichdev;
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index c4af57f..d1fb714 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -1127,7 +1127,7 @@ static void snd_korg1212_OnDSPDownloadComplete(struct snd_korg1212 *korg1212)
 	snd_korg1212_setCardState(korg1212, K1212_STATE_DSP_COMPLETE);
 }
 
-static irqreturn_t snd_korg1212_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_korg1212_interrupt(void *dev_id)
 {
         u32 doorbellValue;
         struct snd_korg1212 *korg1212 = dev_id;
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 3224577..315c806 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -1658,7 +1658,7 @@ static void snd_m3_update_hw_volume(unsigned long private_data)
 	spin_unlock_irqrestore(&chip->ac97_lock, flags);
 }
 
-static irqreturn_t snd_m3_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_m3_interrupt(void *dev_id)
 {
 	struct snd_m3 *chip = dev_id;
 	u8 status;
@@ -1696,7 +1696,7 @@ static irqreturn_t snd_m3_interrupt(int irq, void *dev_id)
 
 #if 0 /* TODO: not supported yet */
 	if ((status & MPU401_INT_PENDING) && chip->rmidi)
-		snd_mpu401_uart_interrupt(irq, chip->rmidi->private_data, regs);
+		snd_mpu401_uart_interrupt(chip->rmidi->private_data);
 #endif
 
 	/* ack ints */
diff --git a/sound/pci/mixart/mixart_core.c b/sound/pci/mixart/mixart_core.c
index d544573..2bacb1b 100644
--- a/sound/pci/mixart/mixart_core.c
+++ b/sound/pci/mixart/mixart_core.c
@@ -408,7 +408,7 @@ void snd_mixart_msg_tasklet(unsigned long arg)
 }
 
 
-irqreturn_t snd_mixart_interrupt(int irq, void *dev_id)
+irqreturn_t snd_mixart_interrupt(void *dev_id)
 {
 	struct mixart_mgr *mgr = dev_id;
 	int err;
diff --git a/sound/pci/mixart/mixart_core.h b/sound/pci/mixart/mixart_core.h
index c919b73..dda03cd 100644
--- a/sound/pci/mixart/mixart_core.h
+++ b/sound/pci/mixart/mixart_core.h
@@ -563,7 +563,7 @@ int  snd_mixart_send_msg(struct mixart_mgr *mgr, struct mixart_msg *request, int
 int  snd_mixart_send_msg_wait_notif(struct mixart_mgr *mgr, struct mixart_msg *request, u32 notif_event);
 int  snd_mixart_send_msg_nonblock(struct mixart_mgr *mgr, struct mixart_msg *request);
 
-irqreturn_t snd_mixart_interrupt(int irq, void *dev_id);
+irqreturn_t snd_mixart_interrupt(void *dev_id);
 void snd_mixart_msg_tasklet(unsigned long arg);
 
 void snd_mixart_reset_board(struct mixart_mgr *mgr);
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index 276c576..69141e6 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -1003,7 +1003,7 @@ snd_nm256_intr_check(struct nm256 *chip)
  */
 
 static irqreturn_t
-snd_nm256_interrupt(int irq, void *dev_id)
+snd_nm256_interrupt(void *dev_id)
 {
 	struct nm256 *chip = dev_id;
 	u16 status;
@@ -1068,7 +1068,7 @@ snd_nm256_interrupt(int irq, void *dev_id)
  */
 
 static irqreturn_t
-snd_nm256_interrupt_zx(int irq, void *dev_id)
+snd_nm256_interrupt_zx(void *dev_id)
 {
 	struct nm256 *chip = dev_id;
 	u32 status;
diff --git a/sound/pci/pcxhr/pcxhr_core.c b/sound/pci/pcxhr/pcxhr_core.c
index 0ff8dc3..1871253 100644
--- a/sound/pci/pcxhr/pcxhr_core.c
+++ b/sound/pci/pcxhr/pcxhr_core.c
@@ -1131,7 +1131,7 @@ static void pcxhr_update_timer_pos(struct pcxhr_mgr *mgr,
 }
 
 
-irqreturn_t pcxhr_interrupt(int irq, void *dev_id)
+irqreturn_t pcxhr_interrupt(void *dev_id)
 {
 	struct pcxhr_mgr *mgr = dev_id;
 	unsigned int reg;
diff --git a/sound/pci/pcxhr/pcxhr_core.h b/sound/pci/pcxhr/pcxhr_core.h
index d9a4ab6..0a2c18f 100644
--- a/sound/pci/pcxhr/pcxhr_core.h
+++ b/sound/pci/pcxhr/pcxhr_core.h
@@ -194,7 +194,7 @@ int pcxhr_write_io_num_reg_cont(struct pcxhr_mgr *mgr, unsigned int mask,
 
 
 /* interrupt handling */
-irqreturn_t pcxhr_interrupt(int irq, void *dev_id);
+irqreturn_t pcxhr_interrupt(void *dev_id);
 void pcxhr_msg_tasklet(unsigned long arg);
 
 #endif /* __SOUND_PCXHR_CORE_H */
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 8e54104..72bb4b5 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -1742,7 +1742,7 @@ snd_riptide_pcm(struct snd_riptide *chip, int device, struct snd_pcm **rpcm)
 }
 
 static irqreturn_t
-snd_riptide_interrupt(int irq, void *dev_id)
+snd_riptide_interrupt(void *dev_id)
 {
 	struct snd_riptide *chip = dev_id;
 	struct cmdif *cif = chip->cif;
@@ -1756,8 +1756,7 @@ snd_riptide_interrupt(int irq, void *dev_id)
 		}
 		if (chip->rmidi && IS_MPUIRQ(cif->hwport)) {
 			chip->handled_irqs++;
-			snd_mpu401_uart_interrupt(irq,
-						  chip->rmidi->private_data);
+			snd_mpu401_uart_interrupt(chip->rmidi->private_data);
 		}
 		SET_AIACK(cif->hwport);
 	}
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index 1475912..9d52963 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -805,7 +805,7 @@ static void snd_rme32_pcm_stop(struct rme32 * rme32, int to_pause)
 		writel(0, rme32->iobase + RME32_IO_RESET_POS);
 }
 
-static irqreturn_t snd_rme32_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_rme32_interrupt(void *dev_id)
 {
 	struct rme32 *rme32 = (struct rme32 *) dev_id;
 
diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
index 0b3c532..7136784 100644
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -1102,8 +1102,7 @@ snd_rme96_capture_stop(struct rme96 *rme96)
 }
 
 static irqreturn_t
-snd_rme96_interrupt(int irq,
-		    void *dev_id)
+snd_rme96_interrupt(void *dev_id)
 {
 	struct rme96 *rme96 = (struct rme96 *)dev_id;
 
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index ff26a36..9814607 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -3673,7 +3673,7 @@ static void hdsp_midi_tasklet(unsigned long arg)
 		snd_hdsp_midi_input_read (&hdsp->midi[1]);
 } 
 
-static irqreturn_t snd_hdsp_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_hdsp_interrupt(void *dev_id)
 {
 	struct hdsp *hdsp = (struct hdsp *) dev_id;
 	unsigned int status;
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index f1bdda6..1acd8ee 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -3419,7 +3419,7 @@ static int snd_hdspm_set_defaults(struct hdspm * hdspm)
    interupt 
  ------------------------------------------------------------*/
 
-static irqreturn_t snd_hdspm_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_hdspm_interrupt(void *dev_id)
 {
 	struct hdspm *hdspm = (struct hdspm *) dev_id;
 	unsigned int status;
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index 34f96f1..78ba478 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -1861,7 +1861,7 @@ static void snd_rme9652_set_defaults(struct snd_rme9652 *rme9652)
 	rme9652_set_rate(rme9652, 48000);
 }
 
-static irqreturn_t snd_rme9652_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_rme9652_interrupt(void *dev_id)
 {
 	struct snd_rme9652 *rme9652 = (struct snd_rme9652 *) dev_id;
 
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index 44a7f5f..da5547e 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -580,7 +580,7 @@ static int snd_sonicvibes_trigger(struct sonicvibes * sonic, int what, int cmd)
 	return result;
 }
 
-static irqreturn_t snd_sonicvibes_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_sonicvibes_interrupt(void *dev_id)
 {
 	struct sonicvibes *sonic = dev_id;
 	unsigned char status;
@@ -601,7 +601,7 @@ static irqreturn_t snd_sonicvibes_interrupt(int irq, void *dev_id)
 	}
 	if (sonic->rmidi) {
 		if (status & SV_MIDI_IRQ)
-			snd_mpu401_uart_interrupt(irq, sonic->rmidi->private_data);
+			snd_mpu401_uart_interrupt(sonic->rmidi->private_data);
 	}
 	if (status & SV_UD_IRQ) {
 		unsigned char udreg;
diff --git a/sound/pci/trident/trident_main.c b/sound/pci/trident/trident_main.c
index a235e03..680d57a 100644
--- a/sound/pci/trident/trident_main.c
+++ b/sound/pci/trident/trident_main.c
@@ -52,7 +52,7 @@ static int snd_trident_pcm_mixer_build(struct snd_trident *trident,
 static int snd_trident_pcm_mixer_free(struct snd_trident *trident,
 				      struct snd_trident_voice * voice,
 				      struct snd_pcm_substream *substream);
-static irqreturn_t snd_trident_interrupt(int irq, void *dev_id);
+static irqreturn_t snd_trident_interrupt(void *dev_id);
 static int snd_trident_sis_reset(struct snd_trident *trident);
 
 static void snd_trident_clear_voices(struct snd_trident * trident,
@@ -3718,7 +3718,7 @@ static int snd_trident_free(struct snd_trident *trident)
   
   ---------------------------------------------------------------------------*/
 
-static irqreturn_t snd_trident_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_trident_interrupt(void *dev_id)
 {
 	struct snd_trident *trident = dev_id;
 	unsigned int audio_int, chn_int, stimer, channel, mask, tmp;
@@ -3806,7 +3806,7 @@ static irqreturn_t snd_trident_interrupt(int irq, void *dev_id)
 	}
 	if (audio_int & MPU401_IRQ) {
 		if (trident->rmidi) {
-			snd_mpu401_uart_interrupt(irq, trident->rmidi->private_data);
+			snd_mpu401_uart_interrupt(trident->rmidi->private_data);
 		} else {
 			inb(TRID_REG(trident, T4D_MPUR0));
 		}
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index cf62d2a..50c993b 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -613,7 +613,7 @@ static void snd_via82xx_channel_reset(struct via82xx *chip, struct viadev *viade
  *  Interrupt handler
  *  Used for 686 and 8233A
  */
-static irqreturn_t snd_via686_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_via686_interrupt(void *dev_id)
 {
 	struct via82xx *chip = dev_id;
 	unsigned int status;
@@ -623,7 +623,7 @@ static irqreturn_t snd_via686_interrupt(int irq, void *dev_id)
 	if (! (status & chip->intr_mask)) {
 		if (chip->rmidi)
 			/* check mpu401 interrupt */
-			return snd_mpu401_uart_interrupt(irq, chip->rmidi->private_data);
+			return snd_mpu401_uart_interrupt(chip->rmidi->private_data);
 		return IRQ_NONE;
 	}
 
@@ -659,7 +659,7 @@ static irqreturn_t snd_via686_interrupt(int irq, void *dev_id)
 /*
  *  Interrupt handler
  */
-static irqreturn_t snd_via8233_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_via8233_interrupt(void *dev_id)
 {
 	struct via82xx *chip = dev_id;
 	unsigned int status;
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index 57fb9ae..2bfc320 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -475,7 +475,7 @@ static void snd_via82xx_channel_reset(struct via82xx_modem *chip, struct viadev
  *  Interrupt handler
  */
 
-static irqreturn_t snd_via82xx_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_via82xx_interrupt(void *dev_id)
 {
 	struct via82xx_modem *chip = dev_id;
 	unsigned int status;
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index 1fe39ed..3e18d13 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -779,7 +779,7 @@ static void snd_ymfpci_irq_wait(struct snd_ymfpci *chip)
 	}
 }
 
-static irqreturn_t snd_ymfpci_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_ymfpci_interrupt(void *dev_id)
 {
 	struct snd_ymfpci *chip = dev_id;
 	u32 status, nvoice, mode;
@@ -825,7 +825,7 @@ static irqreturn_t snd_ymfpci_interrupt(int irq, void *dev_id)
 	snd_ymfpci_writew(chip, YDSXGR_INTFLAG, status);
 
 	if (chip->rawmidi)
-		snd_mpu401_uart_interrupt(irq, chip->rawmidi->private_data);
+		snd_mpu401_uart_interrupt(chip->rawmidi->private_data);
 	return IRQ_HANDLED;
 }
 
diff --git a/sound/pcmcia/pdaudiocf/pdaudiocf.h b/sound/pcmcia/pdaudiocf/pdaudiocf.h
index b060183..780c619 100644
--- a/sound/pcmcia/pdaudiocf/pdaudiocf.h
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf.h
@@ -138,7 +138,7 @@ int snd_pdacf_suspend(struct snd_pdacf *chip, pm_message_t state);
 int snd_pdacf_resume(struct snd_pdacf *chip);
 #endif
 int snd_pdacf_pcm_new(struct snd_pdacf *chip);
-irqreturn_t pdacf_interrupt(int irq, void *dev);
+irqreturn_t pdacf_interrupt(void *dev);
 void pdacf_tasklet(unsigned long private_data);
 void pdacf_reinit(struct snd_pdacf *chip, int resume);
 
diff --git a/sound/pcmcia/pdaudiocf/pdaudiocf_irq.c b/sound/pcmcia/pdaudiocf/pdaudiocf_irq.c
index 5454336..34b05ad 100644
--- a/sound/pcmcia/pdaudiocf/pdaudiocf_irq.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf_irq.c
@@ -27,7 +27,7 @@
 /*
  *
  */
-irqreturn_t pdacf_interrupt(int irq, void *dev)
+irqreturn_t pdacf_interrupt(void *dev)
 {
 	struct snd_pdacf *chip = dev;
 	unsigned short stat;
diff --git a/sound/ppc/pmac.c b/sound/ppc/pmac.c
index 4f9b19c..a888e3b 100644
--- a/sound/ppc/pmac.c
+++ b/sound/ppc/pmac.c
@@ -689,7 +689,7 @@ void snd_pmac_beep_dma_stop(struct snd_pmac *chip)
  * interrupt handlers
  */
 static irqreturn_t
-snd_pmac_tx_intr(int irq, void *devid)
+snd_pmac_tx_intr(void *devid)
 {
 	struct snd_pmac *chip = devid;
 	snd_pmac_pcm_update(chip, &chip->playback);
@@ -698,7 +698,7 @@ snd_pmac_tx_intr(int irq, void *devid)
 
 
 static irqreturn_t
-snd_pmac_rx_intr(int irq, void *devid)
+snd_pmac_rx_intr(void *devid)
 {
 	struct snd_pmac *chip = devid;
 	snd_pmac_pcm_update(chip, &chip->capture);
@@ -707,7 +707,7 @@ snd_pmac_rx_intr(int irq, void *devid)
 
 
 static irqreturn_t
-snd_pmac_ctrl_intr(int irq, void *devid)
+snd_pmac_ctrl_intr(void *devid)
 {
 	struct snd_pmac *chip = devid;
 	int ctrl = in_le32(&chip->awacs->control);
diff --git a/sound/ppc/tumbler.c b/sound/ppc/tumbler.c
index 5821cdd..96d9f74 100644
--- a/sound/ppc/tumbler.c
+++ b/sound/ppc/tumbler.c
@@ -1018,7 +1018,7 @@ static void tumbler_update_automute(struct snd_pmac *chip, int do_notify)
 
 
 /* interrupt - headphone plug changed */
-static irqreturn_t headphone_intr(int irq, void *devid)
+static irqreturn_t headphone_intr(void *devid)
 {
 	struct snd_pmac *chip = devid;
 	if (chip->update_automute && chip->initialized) {
diff --git a/sound/sparc/amd7930.c b/sound/sparc/amd7930.c
index 07962a3..0fb49b2 100644
--- a/sound/sparc/amd7930.c
+++ b/sound/sparc/amd7930.c
@@ -491,7 +491,7 @@ static void __amd7930_update_map(struct snd_amd7930 *amd)
 	__amd7930_write_map(amd);
 }
 
-static irqreturn_t snd_amd7930_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_amd7930_interrupt(void *dev_id)
 {
 	struct snd_amd7930 *amd = dev_id;
 	unsigned int elapsed;
diff --git a/sound/sparc/cs4231.c b/sound/sparc/cs4231.c
index 9785382..1efb7d4 100644
--- a/sound/sparc/cs4231.c
+++ b/sound/sparc/cs4231.c
@@ -1661,7 +1661,7 @@ out_err:
 
 #ifdef SBUS_SUPPORT
 
-static irqreturn_t snd_cs4231_sbus_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_cs4231_sbus_interrupt(void *dev_id)
 {
 	unsigned long flags;
 	unsigned char status;
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 376b986..ffc950b 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -1910,7 +1910,7 @@ static void dbri_process_interrupt_buffer(struct snd_dbri *dbri)
 	}
 }
 
-static irqreturn_t snd_dbri_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_dbri_interrupt(void *dev_id)
 {
 	struct snd_dbri *dbri = dev_id;
 	static int errcnt = 0;
