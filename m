Return-Path: <linux-kernel-owner+w=401wt.eu-S936869AbXLQUEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936869AbXLQUEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934010AbXLQTmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:42:00 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3246 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934069AbXLQTli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:38 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jaroslav Kysela <perex@perex.cz>, Nils Faerber <nils@kernelconcepts.de>
Subject: [PATCH] sound/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:38 -0800
Message-Id: <1197920439-5455-32-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918894.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/drivers/serial-u16550.c    |    6 ++--
 sound/isa/es18xx.c               |    2 +-
 sound/pci/au88x0/au88x0_core.c   |    2 +-
 sound/pci/cs46xx/cs46xx_lib.c    |    2 +-
 sound/pci/hda/hda_codec.h        |    2 +-
 sound/pci/rme9652/hdsp.c         |    2 +-
 sound/pci/rme9652/hdspm.c        |    4 +-
 sound/pci/rme9652/rme9652.c      |    4 +-
 sound/pci/trident/trident_main.c |   44 +++++++++++++++++++-------------------
 9 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
index 65de3a7..3958dbd 100644
--- a/sound/drivers/serial-u16550.c
+++ b/sound/drivers/serial-u16550.c
@@ -455,7 +455,7 @@ static void snd_uart16550_do_open(struct snd_uart16550 * uart)
 		    | UART_IER_THRI	/* Enable Transmitter holding register empty interrupt */
 		    ;
 	}
-	outb(byte, uart->base + UART_IER);	/* Interupt enable Register */
+	outb(byte, uart->base + UART_IER);	/* Interrupt enable Register */
 
 	inb(uart->base + UART_LSR);	/* Clear any pre-existing overrun indication */
 	inb(uart->base + UART_IIR);	/* Clear any pre-existing transmit interrupt */
@@ -473,7 +473,7 @@ static void snd_uart16550_do_close(struct snd_uart16550 * uart)
 
 	outb((0 & UART_IER_RDI)		/* Disable Receiver data interrupt */
 	     |(0 & UART_IER_THRI)	/* Disable Transmitter holding register empty interrupt */
-	     ,uart->base + UART_IER);	/* Interupt enable Register */
+	     ,uart->base + UART_IER);	/* Interrupt enable Register */
 
 	switch (uart->adaptor) {
 	default:
@@ -653,7 +653,7 @@ static void snd_uart16550_output_write(struct snd_rawmidi_substream *substream)
 	char first;
 	static unsigned long lasttime = 0;
 	
-	/* Interupts are disabled during the updating of the tx_buff,
+	/* Interrupts are disabled during the updating of the tx_buff,
 	 * since it is 'bad' to have two processes updating the same
 	 * variables (ie buff_in & buff_out)
 	 */
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index c1af28f..5f927ad 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -163,7 +163,7 @@ struct snd_audiodrive {
 #define ES18XX_DUPLEX_SAME 0x0010	/* Playback and record must share the same rate */
 #define ES18XX_NEW_RATE	0x0020	/* More precise rate setting */
 #define ES18XX_AUXB	0x0040	/* AuxB mixer control */
-#define ES18XX_HWV	0x0080	/* Has seperate hardware volume mixer controls*/
+#define ES18XX_HWV	0x0080	/* Has separate hardware volume mixer controls*/
 #define ES18XX_MONO	0x0100	/* Mono_in mixer control */
 #define ES18XX_I2S	0x0200	/* I2S mixer control */
 #define ES18XX_MUTEREC	0x0400	/* Record source can be muted */
diff --git a/sound/pci/au88x0/au88x0_core.c b/sound/pci/au88x0/au88x0_core.c
index 4a336ea..333c62d 100644
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -2395,7 +2395,7 @@ static irqreturn_t vortex_interrupt(int irq, void *dev_id)
 	if (!(hwread(vortex->mmio, VORTEX_STAT) & 0x1))
 		return IRQ_NONE;
 
-	// This is the Interrrupt Enable flag we set before (consistency check).
+	// This is the Interrupt Enable flag we set before (consistency check).
 	if (!(hwread(vortex->mmio, VORTEX_CTRL) & CTRL_IRQ_ENABLE))
 		return IRQ_NONE;
 
diff --git a/sound/pci/cs46xx/cs46xx_lib.c b/sound/pci/cs46xx/cs46xx_lib.c
index 2c7bfc9..c004fa8 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -8,7 +8,7 @@
  *    - Sometimes the SPDIF input DSP tasks get's unsynchronized
  *      and the SPDIF get somewhat "distorcionated", or/and left right channel
  *      are swapped. To get around this problem when it happens, mute and unmute 
- *      the SPDIF input mixer controll.
+ *      the SPDIF input mixer control.
  *    - On the Hercules Game Theater XP the amplifier are sometimes turned
  *      off on inadecuate moments which causes distorcions on sound.
  *
diff --git a/sound/pci/hda/hda_codec.h b/sound/pci/hda/hda_codec.h
index 2bce925..5bd44ac 100644
--- a/sound/pci/hda/hda_codec.h
+++ b/sound/pci/hda/hda_codec.h
@@ -417,7 +417,7 @@ struct hda_bus_ops {
 	/* free the private data */
 	void (*private_free)(struct hda_bus *);
 #ifdef CONFIG_SND_HDA_POWER_SAVE
-	/* notify power-up/down from codec to contoller */
+	/* notify power-up/down from codec to controller */
 	void (*pm_notify)(struct hda_codec *codec);
 #endif
 };
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index ff26a36..263cd16 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -3606,7 +3606,7 @@ static int snd_hdsp_set_defaults(struct hdsp *hdsp)
 
 	/* ASSUMPTION: hdsp->lock is either held, or
 	   there is no need to hold it (e.g. during module
-	   initalization).
+	   initialization).
 	 */
 
 	/* set defaults:
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index f1bdda6..6b1d529 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -3348,7 +3348,7 @@ static int snd_hdspm_set_defaults(struct hdspm * hdspm)
 	unsigned int i;
 
 	/* ASSUMPTION: hdspm->lock is either held, or there is no need to
-	   hold it (e.g. during module initalization).
+	   hold it (e.g. during module initialization).
 	 */
 
 	/* set defaults:       */
@@ -3416,7 +3416,7 @@ static int snd_hdspm_set_defaults(struct hdspm * hdspm)
 
 
 /*------------------------------------------------------------
-   interupt 
+   interrupt 
  ------------------------------------------------------------*/
 
 static irqreturn_t snd_hdspm_interrupt(int irq, void *dev_id)
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index 34f96f1..1d73be6 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -148,7 +148,7 @@ MODULE_SUPPORTED_DEVICE("{{RME,Hammerfall},"
 #define RME9652_start_bit	   (1<<0)	/* start record/play */
                                                 /* bits 1-3 encode buffersize/latency */
 #define RME9652_Master		   (1<<4)	/* Clock Mode Master=1,Slave/Auto=0 */
-#define RME9652_IE		   (1<<5)	/* Interupt Enable */
+#define RME9652_IE		   (1<<5)	/* Interrupt Enable */
 #define RME9652_freq		   (1<<6)       /* samplerate 0=44.1/88.2, 1=48/96 kHz */
 #define RME9652_freq1		   (1<<7)       /* if 0, 32kHz, else always 1 */
 #define RME9652_DS                 (1<<8)	/* Doule Speed 0=44.1/48, 1=88.2/96 Khz */
@@ -1826,7 +1826,7 @@ static void snd_rme9652_set_defaults(struct snd_rme9652 *rme9652)
 
 	/* ASSUMPTION: rme9652->lock is either held, or
 	   there is no need to hold it (e.g. during module
-	   initalization).
+	   initialization).
 	 */
 
 	/* set defaults:
diff --git a/sound/pci/trident/trident_main.c b/sound/pci/trident/trident_main.c
index a235e03..a1c6177 100644
--- a/sound/pci/trident/trident_main.c
+++ b/sound/pci/trident/trident_main.c
@@ -436,7 +436,7 @@ static void snd_trident_free_synth_channel(struct snd_trident *trident, int chan
    Description: This routine will complete and write the 5 hardware channel
                 registers to hardware.
   
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
                 voice - synthesizer voice structure
                 Each register field.
   
@@ -514,7 +514,7 @@ EXPORT_SYMBOL(snd_trident_write_voice_regs);
    Description: This routine will write the new CSO offset
                 register to hardware.
   
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
                 voice - synthesizer voice structure
                 CSO - new CSO value
   
@@ -540,7 +540,7 @@ static void snd_trident_write_cso_reg(struct snd_trident * trident,
    Description: This routine will write the new ESO offset
                 register to hardware.
   
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
                 voice - synthesizer voice structure
                 ESO - new ESO value
   
@@ -566,7 +566,7 @@ static void snd_trident_write_eso_reg(struct snd_trident * trident,
    Description: This routine will write the new voice volume
                 register to hardware.
   
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
                 voice - synthesizer voice structure
                 Vol - new voice volume
   
@@ -597,7 +597,7 @@ static void snd_trident_write_vol_reg(struct snd_trident * trident,
    Description: This routine will write the new voice pan
                 register to hardware.
   
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
                 voice - synthesizer voice structure
                 Pan - new pan value
   
@@ -619,7 +619,7 @@ static void snd_trident_write_pan_reg(struct snd_trident * trident,
    Description: This routine will write the new reverb volume
                 register to hardware.
   
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
                 voice - synthesizer voice structure
                 RVol - new reverb volume
   
@@ -643,7 +643,7 @@ static void snd_trident_write_rvol_reg(struct snd_trident * trident,
    Description: This routine will write the new chorus volume
                 register to hardware.
   
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
                 voice - synthesizer voice structure
                 CVol - new chorus volume
   
@@ -666,7 +666,7 @@ static void snd_trident_write_cvol_reg(struct snd_trident * trident,
 
    Description: This routine converts rate in HZ to hardware delta value.
   
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
                 rate - Real or Virtual channel number.
   
    Returns:     Delta value.
@@ -696,7 +696,7 @@ static unsigned int snd_trident_convert_rate(unsigned int rate)
 
    Description: This routine converts rate in HZ to hardware delta value.
   
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
                 rate - Real or Virtual channel number.
   
    Returns:     Delta value.
@@ -726,7 +726,7 @@ static unsigned int snd_trident_convert_adc_rate(unsigned int rate)
 
    Description: This routine converts rate in HZ to spurious threshold.
   
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
                 rate - Real or Virtual channel number.
   
    Returns:     Delta value.
@@ -748,7 +748,7 @@ static unsigned int snd_trident_spurious_threshold(unsigned int rate,
 
    Description: This routine returns a control mode for a PCM channel.
   
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
                 substream  - PCM substream
   
    Returns:     Control value.
@@ -781,7 +781,7 @@ static unsigned int snd_trident_control_mode(struct snd_pcm_substream *substream
   
    Description: Device I/O control handler for playback/capture parameters.
   
-   Paramters:   substream  - PCM substream class
+   Parameters:   substream  - PCM substream class
                 cmd     - what ioctl message to process
                 arg     - additional message infoarg     
   
@@ -1664,7 +1664,7 @@ static snd_pcm_uframes_t snd_trident_playback_pointer(struct snd_pcm_substream *
   
    Description: This routine return the capture position
                 
-   Paramters:   pcm1    - PCM device class
+   Parameters:   pcm1    - PCM device class
 
    Returns:     position of buffer
   
@@ -2157,7 +2157,7 @@ static struct snd_pcm_ops snd_trident_spdif_7018_ops = {
   
    Description: This routine registers the 4DWave device for PCM support.
                 
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
 
    Returns:     None
   
@@ -2215,7 +2215,7 @@ int __devinit snd_trident_pcm(struct snd_trident * trident,
   
    Description: This routine registers the 4DWave device for foldback PCM support.
                 
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
 
    Returns:     None
   
@@ -2272,7 +2272,7 @@ int __devinit snd_trident_foldback_pcm(struct snd_trident * trident,
   
    Description: This routine registers the 4DWave-NX device for SPDIF support.
                 
-   Paramters:   trident - pointer to target device class for 4DWave-NX.
+   Parameters:  trident - pointer to target device class for 4DWave-NX.
 
    Returns:     None
   
@@ -2956,7 +2956,7 @@ static int snd_trident_pcm_mixer_free(struct snd_trident *trident, struct snd_tr
   
    Description: This routine registers the 4DWave device for mixer support.
                 
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
 
    Returns:     None
   
@@ -3344,7 +3344,7 @@ static int snd_trident_dev_free(struct snd_device *device)
    Description: Allocate and set up the TLB page table on 4D NX.
 		Each entry has 4 bytes (physical PCI address).
                 
-   Paramters:   trident - pointer to target device class for 4DWave.
+   Parameters:  trident - pointer to target device class for 4DWave.
 
    Returns:     0 or negative error code
   
@@ -3521,7 +3521,7 @@ static int snd_trident_sis_init(struct snd_trident *trident)
    Description: This routine will create the device specific class for
                 the 4DWave card. It will also perform basic initialization.
                 
-   Paramters:   card  - which card to create
+   Parameters:  card  - which card to create
                 pci   - interface to PCI bus resource info
                 dma1ptr - playback dma buffer
                 dma2ptr - capture dma buffer
@@ -3667,7 +3667,7 @@ int __devinit snd_trident_create(struct snd_card *card,
    Description: This routine will free the device specific class for
                 the 4DWave card. 
                 
-   Paramters:   trident  - device specific private data for 4DWave card
+   Parameters:  trident  - device specific private data for 4DWave card
 
    Returns:     None.
   
@@ -3705,7 +3705,7 @@ static int snd_trident_free(struct snd_trident *trident)
   
    Description: ISR for Trident 4DWave device
                 
-   Paramters:   trident  - device specific private data for 4DWave card
+   Parameters:  trident  - device specific private data for 4DWave card
 
    Problems:    It seems that Trident chips generates interrupts more than
                 one time in special cases. The spurious interrupts are
@@ -3820,7 +3820,7 @@ static irqreturn_t snd_trident_interrupt(int irq, void *dev_id)
   
    Description: Attach synthesizer hooks
                 
-   Paramters:   trident  - device specific private data for 4DWave card
+   Parameters:  trident  - device specific private data for 4DWave card
 
    Returns:     None.
   
-- 
1.5.3.7.949.g2221a6

