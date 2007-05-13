Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbXEMTQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbXEMTQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760324AbXEMTPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:15:46 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:63969 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758553AbXEMTPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:15:42 -0400
From: muli@il.ibm.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Muli Ben-Yehuda <muli@il.ibm.com>
Subject: [PATCH 1/3] OSS trident: massive whitespace removal
Date: Sun, 13 May 2007 22:15:26 +0300
Message-Id: <11790837282758-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11790837281608-git-send-email-muli@il.ibm.com>
References: <11790837281608-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 sound/oss/trident.c |  358 +++++++++++++++++++++++++-------------------------
 1 files changed, 179 insertions(+), 179 deletions(-)

diff --git a/sound/oss/trident.c b/sound/oss/trident.c
index 3bc1f6e..3e408f4 100644
--- a/sound/oss/trident.c
+++ b/sound/oss/trident.c
@@ -11,12 +11,12 @@
  *  Built from:
  *	Low level code: <audio@tridentmicro.com> from ALSA
  *	Framework: Thomas Sailer <sailer@ife.ee.ethz.ch>
- *	Extended by: Zach Brown <zab@redhat.com>  
+ *	Extended by: Zach Brown <zab@redhat.com>
  *
  *  Hacked up by:
  *	Aaron Holtzman <aholtzma@ess.engr.uvic.ca>
  *	Ollie Lho <ollie@sis.com.tw> SiS 7018 Audio Core Support
- *	Ching-Ling Lee <cling-li@ali.com.tw> ALi 5451 Audio Core Support 
+ *	Ching-Ling Lee <cling-li@ali.com.tw> ALi 5451 Audio Core Support
  *	Matt Wu <mattwu@acersoftech.com.cn> ALi 5451 Audio Core Support
  *	Peter WÃ¤chtler <pwaechtler@loewe-komp.de> CyberPro5050 support
  *      Muli Ben-Yehuda <mulix@mulix.org>
@@ -54,33 +54,33 @@
  *	adapt to new pci joystick attachment interface
  *  v0.14.10f
  *      July 24 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
- *      patch from Eric Lemar (via Ian Soboroff): in suspend and resume, 
- *      fix wrong cast from pci_dev* to struct trident_card*. 
+ *      patch from Eric Lemar (via Ian Soboroff): in suspend and resume,
+ *      fix wrong cast from pci_dev* to struct trident_card*.
  *  v0.14.10e
  *      July 19 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
- *      rewrite the DMA buffer allocation/deallcoation functions, to make it 
- *      modular and fix a bug where we would call free_pages on memory 
- *      obtained with pci_alloc_consistent. Also remove unnecessary #ifdef 
+ *      rewrite the DMA buffer allocation/deallcoation functions, to make it
+ *      modular and fix a bug where we would call free_pages on memory
+ *      obtained with pci_alloc_consistent. Also remove unnecessary #ifdef
  *      CONFIG_PROC_FS and various other cleanups.
  *  v0.14.10d
  *      July 19 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
  *      made several printk(KERN_NOTICE...) into TRDBG(...), to avoid spamming
- *      my syslog with hundreds of messages. 
+ *      my syslog with hundreds of messages.
  *  v0.14.10c
  *      July 16 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
  *      Cleaned up Lei Hu's 0.4.10 driver to conform to Documentation/CodingStyle
- *      and the coding style used in the rest of the file. 
+ *      and the coding style used in the rest of the file.
  *  v0.14.10b
  *      June 23 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
- *      add a missing unlock_set_fmt, remove a superflous lock/unlock pair 
- *      with nothing in between. 
+ *      add a missing unlock_set_fmt, remove a superflous lock/unlock pair
+ *      with nothing in between.
  *  v0.14.10a
- *      June 21 2002 Muli Ben-Yehuda <mulix@actcom.co.il> 
- *      use a debug macro instead of #ifdef CONFIG_DEBUG, trim to 80 columns 
- *      per line, use 'do {} while (0)' in statement macros. 
+ *      June 21 2002 Muli Ben-Yehuda <mulix@actcom.co.il>
+ *      use a debug macro instead of #ifdef CONFIG_DEBUG, trim to 80 columns
+ *      per line, use 'do {} while (0)' in statement macros.
  *  v0.14.10
  *      June 6 2002 Lei Hu <Lei_hu@ali.com.tw>
- *      rewrite the part to read/write registers of audio codec for Ali5451 
+ *      rewrite the part to read/write registers of audio codec for Ali5451
  *  v0.14.9e
  *      January 2 2002 Vojtech Pavlik <vojtech@ucw.cz> added gameport
  *      support to avoid resource conflict with pcigame.c
@@ -111,7 +111,7 @@
  *	Set EBUF1 and EBUF2 to still mode
  *	Add dc97/ac97 reset function
  *	Fix power management: ali_restore_regs
- *  unreleased 
+ *  unreleased
  *	Mar 09 2001 Matt Wu
  *	Add cache for ac97 access
  *  v0.14.7
@@ -120,7 +120,7 @@
  *	Fix bug: an extra tail will be played when playing
  *	Jan 05 2001 Matt Wu
  *	Implement multi-channels and S/PDIF in support for ALi 1535+
- *  v0.14.6 
+ *  v0.14.6
  *	Nov 1 2000 Ching-Ling Lee
  *	Fix the bug of memory leak when switching 5.1-channels to 2 channels.
  *	Add lock protection into dynamic changing format of data.
@@ -138,7 +138,7 @@
  *  v0.14.3 May 10 2000 Ollie Lho
  *	fixed a small bug in trident_update_ptr, xmms 1.0.1 no longer uses 100% CPU
  *  v0.14.2 Mar 29 2000 Ching-Ling Lee
- *	Add clear to silence advance in trident_update_ptr 
+ *	Add clear to silence advance in trident_update_ptr
  *	fix invalid data of the end of the sound
  *  v0.14.1 Mar 24 2000 Ching-Ling Lee
  *	ALi 5451 support added, playback and recording O.K.
@@ -178,7 +178,7 @@
  *	SiS 7018 support added, playback O.K.
  *  v0.01 Alan Cox et. al.
  *	Initial Release in kernel 2.3.30, does not work
- * 
+ *
  *  ToDo
  *	Clean up of low level channel register access code. (done)
  *	Fix the bug on dma buffer management in update_ptr, read/write, drain_dac (done)
@@ -326,7 +326,7 @@ struct trident_state {
 
 		unsigned error;	/* number of over/underruns */
                 /* put process on wait queue when no more space in buffer */
-		wait_queue_head_t wait;	
+		wait_queue_head_t wait;
 
 		/* redundant, but makes calculations easier */
 		unsigned fragsize;
@@ -358,7 +358,7 @@ struct trident_state {
 struct trident_channel {
 	int num; /* channel number */
 	u32 lba; /* Loop Begine Address, where dma buffer starts */
-	u32 eso; /* End Sample Offset, wehre dma buffer ends */ 
+	u32 eso; /* End Sample Offset, wehre dma buffer ends */
 	         /* (in the unit of samples) */
 	u32 delta; /* delta value, sample rate / 48k for playback, */
 	           /* 48k/sample rate for recording */
@@ -417,7 +417,7 @@ struct trident_card {
 	/* soundcore stuff */
 	int dev_audio;
 
-	/* structures for abstraction of hardware facilities, codecs, */ 
+	/* structures for abstraction of hardware facilities, codecs, */
 	/* banks and channels */
 	struct ac97_codec *ac97_codec[NR_AC97];
 	struct trident_pcm_bank banks[NR_BANKS];
@@ -479,7 +479,7 @@ static void trident_ac97_set(struct ac97
 static u16 trident_ac97_get(struct ac97_codec *codec, u8 reg);
 
 static int trident_open_mixdev(struct inode *inode, struct file *file);
-static int trident_ioctl_mixdev(struct inode *inode, struct file *file, 
+static int trident_ioctl_mixdev(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg);
 
 static void ali_ac97_set(struct trident_card *card, int secondary, u8 reg, u16 val);
@@ -496,10 +496,10 @@ static void ali_disable_spdif_in(struct
 static void ali_disable_special_channel(struct trident_card *card, int ch);
 static void ali_setup_spdif_out(struct trident_card *card, int flag);
 static int ali_write_5_1(struct trident_state *state,
-			 const char __user *buffer, 
-			 int cnt_for_multi_channel, unsigned int *copy_count, 
+			 const char __user *buffer,
+			 int cnt_for_multi_channel, unsigned int *copy_count,
 			 unsigned int *state_cnt);
-static int ali_allocate_other_states_resources(struct trident_state *state, 
+static int ali_allocate_other_states_resources(struct trident_state *state,
 					       int chan_nums);
 static void ali_free_other_states_resources(struct trident_state *state);
 
@@ -722,7 +722,7 @@ trident_free_pcm_channel(struct trident_
 	if (channel < 31 || channel > 63)
 		return;
 
-	if (card->pci_id == PCI_DEVICE_ID_TRIDENT_4DWAVE_DX || 
+	if (card->pci_id == PCI_DEVICE_ID_TRIDENT_4DWAVE_DX ||
 	    card->pci_id == PCI_DEVICE_ID_TRIDENT_4DWAVE_NX) {
 		b = inb(TRID_REG(card, T4D_REC_CH));
 		if ((b & ~0x80) == channel)
@@ -742,7 +742,7 @@ cyber_alloc_pcm_channel(struct trident_c
 	int idx;
 
 	/* The cyberpro 5050 has only 32 voices and one bank */
-	/* .. at least they are not documented (if you want to call that 
+	/* .. at least they are not documented (if you want to call that
 	 * crap documentation), perhaps broken ? */
 
 	bank = &card->banks[BANK_A];
@@ -802,7 +802,7 @@ cyber_init_ritual(struct trident_card *c
 	/* enable, if it was disabled */
 	if ((portDat & CYBER_BMSK_AUENZ) != CYBER_BMSK_AUENZ_ENABLE) {
 		printk(KERN_INFO "cyberpro5050: enabling audio controller\n");
-		cyber_outidx(CYBER_PORT_AUDIO, CYBER_IDX_AUDIO_ENABLE, 
+		cyber_outidx(CYBER_PORT_AUDIO, CYBER_IDX_AUDIO_ENABLE,
 			     portDat | CYBER_BMSK_AUENZ_ENABLE);
 		/* check again if hardware is enabled now */
 		portDat = cyber_inidx(CYBER_PORT_AUDIO, CYBER_IDX_AUDIO_ENABLE);
@@ -811,7 +811,7 @@ cyber_init_ritual(struct trident_card *c
 		printk(KERN_ERR "cyberpro5050: initAudioAccess: no success\n");
 		ret = -1;
 	} else {
-		cyber_outidx(CYBER_PORT_AUDIO, CYBER_IDX_IRQ_ENABLE, 
+		cyber_outidx(CYBER_PORT_AUDIO, CYBER_IDX_IRQ_ENABLE,
 			     CYBER_BMSK_AUDIO_INT_ENABLE);
 		cyber_outidx(CYBER_PORT_AUDIO, 0xbf, 0x01);
 		cyber_outidx(CYBER_PORT_AUDIO, 0xba, 0x20);
@@ -827,7 +827,7 @@ cyber_init_ritual(struct trident_card *c
 /*  called with spin lock held */
 
 static int
-trident_load_channel_registers(struct trident_card *card, u32 * data, 
+trident_load_channel_registers(struct trident_card *card, u32 * data,
 			       unsigned int channel)
 {
 	int i;
@@ -845,7 +845,7 @@ trident_load_channel_registers(struct tr
 			continue;
 		outl(data[i], TRID_REG(card, CHANNEL_START + 4 * i));
 	}
-	if (card->pci_id == PCI_DEVICE_ID_ALI_5451 || 
+	if (card->pci_id == PCI_DEVICE_ID_ALI_5451 ||
 	    card->pci_id == PCI_DEVICE_ID_INTERG_5050) {
 		outl(ALI_EMOD_Still, TRID_REG(card, ALI_EBUF1));
 		outl(ALI_EMOD_Still, TRID_REG(card, ALI_EBUF2));
@@ -884,7 +884,7 @@ trident_write_voice_regs(struct trident_
 		break;
 	case PCI_DEVICE_ID_TRIDENT_4DWAVE_NX:
 		data[0] = (channel->delta << 24);
-		data[2] = ((channel->delta << 16) & 0xff000000) | 
+		data[2] = ((channel->delta << 16) & 0xff000000) |
 			(channel->eso & 0x00ffffff);
 		data[3] = channel->fm_vol & 0xffff;
 		break;
@@ -989,13 +989,13 @@ trident_play_setup(struct trident_state
 	if (state->card->pci_id != PCI_DEVICE_ID_SI_7018) {
 		channel->attribute = 0;
 		if (state->card->pci_id == PCI_DEVICE_ID_ALI_5451) {
-			if ((channel->num == ALI_SPDIF_IN_CHANNEL) || 
+			if ((channel->num == ALI_SPDIF_IN_CHANNEL) ||
 			    (channel->num == ALI_PCM_IN_CHANNEL))
 				ali_disable_special_channel(state->card, channel->num);
-			else if ((inl(TRID_REG(state->card, ALI_GLOBAL_CONTROL)) 
+			else if ((inl(TRID_REG(state->card, ALI_GLOBAL_CONTROL))
 				  & ALI_SPDIF_OUT_CH_ENABLE)
 				 && (channel->num == ALI_SPDIF_OUT_CHANNEL)) {
-				ali_set_spdif_out_rate(state->card, 
+				ali_set_spdif_out_rate(state->card,
 						       state->dmabuf.rate);
 				state->dmabuf.channel->delta = 0x1000;
 			}
@@ -1063,7 +1063,7 @@ trident_rec_setup(struct trident_state *
 
 	channel->lba = dmabuf->dma_handle;
 	channel->delta = compute_rate_rec(dmabuf->rate);
-	if ((card->pci_id == PCI_DEVICE_ID_ALI_5451) && 
+	if ((card->pci_id == PCI_DEVICE_ID_ALI_5451) &&
 	    (channel->num == ALI_SPDIF_IN_CHANNEL)) {
 		rate = ali_get_spdif_in_rate(card);
 		if (rate == 0) {
@@ -1180,8 +1180,8 @@ start_adc(struct trident_state *state)
 	unsigned long flags;
 
 	spin_lock_irqsave(&card->lock, flags);
-	if ((dmabuf->mapped || 
-	     dmabuf->count < (signed) dmabuf->dmasize) && 
+	if ((dmabuf->mapped ||
+	     dmabuf->count < (signed) dmabuf->dmasize) &&
 	    dmabuf->ready) {
 		dmabuf->enable |= ADC_RUNNING;
 		trident_enable_voice_irq(card, chan_num);
@@ -1261,7 +1261,7 @@ alloc_dmabuf(struct dmabuf *dmabuf, stru
 	void *rawbuf = NULL;
 	struct page *page, *pend;
 
-	if (!(rawbuf = pci_alloc_consistent(pci_dev, PAGE_SIZE << order, 
+	if (!(rawbuf = pci_alloc_consistent(pci_dev, PAGE_SIZE << order,
 					    &dmabuf->dma_handle)))
 		return -ENOMEM;
 
@@ -1272,7 +1272,7 @@ alloc_dmabuf(struct dmabuf *dmabuf, stru
 	dmabuf->rawbuf = rawbuf;
 	dmabuf->buforder = order;
 
-	/* now mark the pages as reserved; otherwise */ 
+	/* now mark the pages as reserved; otherwise */
 	/* remap_pfn_range doesn't do what we want */
 	pend = virt_to_page(rawbuf + (PAGE_SIZE << order) - 1);
 	for (page = virt_to_page(rawbuf); page <= pend; page++)
@@ -1310,7 +1310,7 @@ dealloc_dmabuf(struct dmabuf *dmabuf, st
 		pend = virt_to_page(dmabuf->rawbuf + (PAGE_SIZE << dmabuf->buforder) - 1);
 		for (page = virt_to_page(dmabuf->rawbuf); page <= pend; page++)
 			ClearPageReserved(page);
-		pci_free_consistent(pci_dev, PAGE_SIZE << dmabuf->buforder, 
+		pci_free_consistent(pci_dev, PAGE_SIZE << dmabuf->buforder,
 				    dmabuf->rawbuf, dmabuf->dma_handle);
 		dmabuf->rawbuf = NULL;
 	}
@@ -1368,7 +1368,7 @@ prog_dmabuf(struct trident_state *state,
 					dealloc_dmabuf(&state->dmabuf, state->card->pci_dev);
 					/* release the auxiliary DMA buffers */
 					for (i -= 2; i >= 0; i--)
-						dealloc_dmabuf(&state->other_states[i]->dmabuf, 
+						dealloc_dmabuf(&state->other_states[i]->dmabuf,
 							       state->card->pci_dev);
 					unlock_set_fmt(state);
 					return ret;
@@ -1398,7 +1398,7 @@ prog_dmabuf(struct trident_state *state,
 		dmabuf->fragsamples = dmabuf->fragsize >> sample_shift[dmabuf->fmt];
 		dmabuf->dmasize = dmabuf->numfrag << dmabuf->fragshift;
 
-		memset(dmabuf->rawbuf, (dmabuf->fmt & TRIDENT_FMT_16BIT) ? 0 : 0x80, 
+		memset(dmabuf->rawbuf, (dmabuf->fmt & TRIDENT_FMT_16BIT) ? 0 : 0x80,
 		       dmabuf->dmasize);
 
 		spin_lock_irqsave(&s->card->lock, flags);
@@ -1453,7 +1453,7 @@ trident_clear_tail(struct trident_state
 	swptr = dmabuf->swptr;
 	spin_unlock_irqrestore(&state->card->lock, flags);
 
-	if (swptr == 0 || swptr == dmabuf->dmasize / 2 || 
+	if (swptr == 0 || swptr == dmabuf->dmasize / 2 ||
 	    swptr == dmabuf->dmasize)
 		return;
 
@@ -1511,7 +1511,7 @@ drain_dac(struct trident_state *state, i
 
 		/* No matter how much data is left in the buffer, we have to wait until
 		   CSO == ESO/2 or CSO == ESO when address engine interrupts */
-		if (state->card->pci_id == PCI_DEVICE_ID_ALI_5451 || 
+		if (state->card->pci_id == PCI_DEVICE_ID_ALI_5451 ||
 		    state->card->pci_id == PCI_DEVICE_ID_INTERG_5050) {
 			diff = dmabuf->swptr - trident_get_dma_addr(state) + dmabuf->dmasize;
 			diff = diff % (dmabuf->dmasize);
@@ -1532,7 +1532,7 @@ drain_dac(struct trident_state *state, i
 	return 0;
 }
 
-/* update buffer manangement pointers, especially, */ 
+/* update buffer manangement pointers, especially, */
 /* dmabuf->count and dmabuf->hwptr */
 static void
 trident_update_ptr(struct trident_state *state)
@@ -1559,11 +1559,11 @@ trident_update_ptr(struct trident_state
 		} else {
 			dmabuf->count += diff;
 
-			if (dmabuf->count < 0 || 
+			if (dmabuf->count < 0 ||
 			    dmabuf->count > dmabuf->dmasize) {
-				/* buffer underrun or buffer overrun, */ 
-				/* we have no way to recover it here, just */ 
-				/* stop the machine and let the process */ 
+				/* buffer underrun or buffer overrun, */
+				/* we have no way to recover it here, just */
+				/* stop the machine and let the process */
 				/* force hwptr and swptr to sync */
 				__stop_adc(state);
 				dmabuf->error++;
@@ -1582,7 +1582,7 @@ trident_update_ptr(struct trident_state
 		} else {
 			dmabuf->count -= diff;
 
-			if (dmabuf->count < 0 || 
+			if (dmabuf->count < 0 ||
 			    dmabuf->count > dmabuf->dmasize) {
 				/* buffer underrun or buffer overrun, we have no way to recover
 				   it here, just stop the machine and let the process force hwptr
@@ -1608,13 +1608,13 @@ trident_update_ptr(struct trident_state
 						if (state->chans_num == 6) {
 							clear_cnt = clear_cnt / 2;
 							swptr = swptr / 2;
-							memset(state->other_states[0]->dmabuf.rawbuf + swptr, 
+							memset(state->other_states[0]->dmabuf.rawbuf + swptr,
 							       silence, clear_cnt);
-							memset(state->other_states[1]->dmabuf.rawbuf + swptr, 
+							memset(state->other_states[1]->dmabuf.rawbuf + swptr,
 							       silence, clear_cnt);
-							memset(state->other_states[2]->dmabuf.rawbuf + swptr, 
+							memset(state->other_states[2]->dmabuf.rawbuf + swptr,
 							       silence, clear_cnt);
-							memset(state->other_states[3]->dmabuf.rawbuf + swptr, 
+							memset(state->other_states[3]->dmabuf.rawbuf + swptr,
 							       silence, clear_cnt);
 						}
 						dmabuf->endcleared = 1;
@@ -1627,13 +1627,13 @@ trident_update_ptr(struct trident_state
 					if (state->chans_num == 6) {
 						clear_cnt = clear_cnt / 2;
 						swptr = swptr / 2;
-						memset(state->other_states[0]->dmabuf.rawbuf + swptr, 
+						memset(state->other_states[0]->dmabuf.rawbuf + swptr,
 						       silence, clear_cnt);
-						memset(state->other_states[1]->dmabuf.rawbuf + swptr, 
+						memset(state->other_states[1]->dmabuf.rawbuf + swptr,
 						       silence, clear_cnt);
-						memset(state->other_states[2]->dmabuf.rawbuf + swptr, 
+						memset(state->other_states[2]->dmabuf.rawbuf + swptr,
 						       silence, clear_cnt);
-						memset(state->other_states[3]->dmabuf.rawbuf + swptr, 
+						memset(state->other_states[3]->dmabuf.rawbuf + swptr,
 						       silence, clear_cnt);
 					}
 					dmabuf->endcleared = 1;
@@ -1665,7 +1665,7 @@ trident_address_interrupt(struct trident
 			if ((state = card->states[i]) != NULL) {
 				trident_update_ptr(state);
 			} else {
-				printk(KERN_WARNING "trident: spurious channel " 
+				printk(KERN_WARNING "trident: spurious channel "
 				       "irq %d.\n", channel);
 				trident_stop_voice(card, channel);
 				trident_disable_voice_irq(card, channel);
@@ -1694,7 +1694,7 @@ ali_hwvol_control(struct trident_card *c
 
 	if (opt == 1) {		// MUTE
 		dwTemp ^= 0x8000;
-		ali_ac97_write(card->ac97_codec[0], 
+		ali_ac97_write(card->ac97_codec[0],
 			       0x02, dwTemp);
 	} else if (opt == 2) {	// Down
 		if (mute)
@@ -1706,7 +1706,7 @@ ali_hwvol_control(struct trident_card *c
 		dwTemp &= 0xe0e0;
 		dwTemp |= (volume[0]) | (volume[1] << 8);
 		ali_ac97_write(card->ac97_codec[0], 0x02, dwTemp);
-		card->ac97_codec[0]->mixer_state[0] = ((32 - volume[0]) * 25 / 8) | 
+		card->ac97_codec[0]->mixer_state[0] = ((32 - volume[0]) * 25 / 8) |
 			(((32 - volume[1]) * 25 / 8) << 8);
 	} else if (opt == 4) {	// Up
 		if (mute)
@@ -1718,7 +1718,7 @@ ali_hwvol_control(struct trident_card *c
 		dwTemp &= 0xe0e0;
 		dwTemp |= (volume[0]) | (volume[1] << 8);
 		ali_ac97_write(card->ac97_codec[0], 0x02, dwTemp);
-		card->ac97_codec[0]->mixer_state[0] = ((32 - volume[0]) * 25 / 8) | 
+		card->ac97_codec[0]->mixer_state[0] = ((32 - volume[0]) * 25 / 8) |
 			(((32 - volume[1]) * 25 / 8) << 8);
 	} else {
 		/* Nothing needs doing */
@@ -1801,7 +1801,7 @@ cyber_address_interrupt(struct trident_c
 			if ((state = card->states[i]) != NULL) {
 				trident_update_ptr(state);
 			} else {
-				printk(KERN_WARNING "cyber5050: spurious " 
+				printk(KERN_WARNING "cyber5050: spurious "
 				       "channel irq %d.\n", channel);
 				trident_stop_voice(card, channel);
 				trident_disable_voice_irq(card, channel);
@@ -1836,21 +1836,21 @@ trident_interrupt(int irq, void *dev_id)
 				ali_queue_task(card, gpio & 0x07);
 		}
 		event = inl(TRID_REG(card, T4D_MISCINT));
-		outl(event | (ST_TARGET_REACHED | MIXER_OVERFLOW | MIXER_UNDERFLOW), 
+		outl(event | (ST_TARGET_REACHED | MIXER_OVERFLOW | MIXER_UNDERFLOW),
 		     TRID_REG(card, T4D_MISCINT));
 		spin_unlock(&card->lock);
 		return IRQ_HANDLED;
 	}
 
 	/* manually clear interrupt status, bad hardware design, blame T^2 */
-	outl((ST_TARGET_REACHED | MIXER_OVERFLOW | MIXER_UNDERFLOW), 
+	outl((ST_TARGET_REACHED | MIXER_OVERFLOW | MIXER_UNDERFLOW),
 	     TRID_REG(card, T4D_MISCINT));
 	spin_unlock(&card->lock);
 	return IRQ_HANDLED;
 }
 
-/* in this loop, dmabuf.count signifies the amount of data that is waiting */ 
-/* to be copied to the user's buffer.  it is filled by the dma machine and */ 
+/* in this loop, dmabuf.count signifies the amount of data that is waiting */
+/* to be copied to the user's buffer.  it is filled by the dma machine and */
 /* drained by this loop. */
 static ssize_t
 trident_read(struct file *file, char __user *buffer, size_t count, loff_t * ppos)
@@ -1878,8 +1878,8 @@ trident_read(struct file *file, char __u
 	while (count > 0) {
 		spin_lock_irqsave(&state->card->lock, flags);
 		if (dmabuf->count > (signed) dmabuf->dmasize) {
-			/* buffer overrun, we are recovering from */ 
-			/* sleep_on_timeout, resync hwptr and swptr, */ 
+			/* buffer overrun, we are recovering from */
+			/* sleep_on_timeout, resync hwptr and swptr, */
 			/* make process flush the buffer */
 			dmabuf->count = dmabuf->dmasize;
 			dmabuf->swptr = dmabuf->hwptr;
@@ -1894,7 +1894,7 @@ trident_read(struct file *file, char __u
 			cnt = count;
 		if (cnt <= 0) {
 			unsigned long tmo;
-			/* buffer is empty, start the dma machine and */ 
+			/* buffer is empty, start the dma machine and */
 			/* wait for data to be recorded */
 			start_adc(state);
 			if (file->f_flags & O_NONBLOCK) {
@@ -1904,8 +1904,8 @@ trident_read(struct file *file, char __u
 			}
 
 			mutex_unlock(&state->sem);
-			/* No matter how much space left in the buffer, */ 
-			/* we have to wait until CSO == ESO/2 or CSO == ESO */ 
+			/* No matter how much space left in the buffer, */
+			/* we have to wait until CSO == ESO/2 or CSO == ESO */
 			/* when address engine interrupts */
 			tmo = (dmabuf->dmasize * HZ) / (dmabuf->rate * 2);
 			tmo >>= sample_shift[dmabuf->fmt];
@@ -2005,7 +2005,7 @@ trident_write(struct file *file, const c
 	while (count > 0) {
 		spin_lock_irqsave(&state->card->lock, flags);
 		if (dmabuf->count < 0) {
-			/* buffer underrun, we are recovering from */ 
+			/* buffer underrun, we are recovering from */
 			/* sleep_on_timeout, resync hwptr and swptr */
 			dmabuf->count = 0;
 			dmabuf->swptr = dmabuf->hwptr;
@@ -2020,7 +2020,7 @@ trident_write(struct file *file, const c
 			cnt = count;
 		if (cnt <= 0) {
 			unsigned long tmo;
-			/* buffer is full, start the dma machine and */ 
+			/* buffer is full, start the dma machine and */
 			/* wait for data to be played */
 			start_dac(state);
 			if (file->f_flags & O_NONBLOCK) {
@@ -2028,8 +2028,8 @@ trident_write(struct file *file, const c
 					ret = -EAGAIN;
 				goto out;
 			}
-			/* No matter how much data left in the buffer, */ 
-			/* we have to wait until CSO == ESO/2 or CSO == ESO */ 
+			/* No matter how much data left in the buffer, */
+			/* we have to wait until CSO == ESO/2 or CSO == ESO */
 			/* when address engine interrupts */
 			lock_set_fmt(state);
 			tmo = (dmabuf->dmasize * HZ) / (dmabuf->rate * 2);
@@ -2037,15 +2037,15 @@ trident_write(struct file *file, const c
 			unlock_set_fmt(state);
 			mutex_unlock(&state->sem);
 
-			/* There are two situations when sleep_on_timeout */ 
-			/* returns, one is when the interrupt is serviced */ 
-			/* correctly and the process is waked up by ISR */ 
-			/* ON TIME. Another is when timeout is expired, which */ 
-			/* means that either interrupt is NOT serviced */ 
-			/* correctly (pending interrupt) or it is TOO LATE */ 
-			/* for the process to be scheduled to run */ 
-			/* (scheduler latency) which results in a (potential) */ 
-			/* buffer underrun. And worse, there is NOTHING we */ 
+			/* There are two situations when sleep_on_timeout */
+			/* returns, one is when the interrupt is serviced */
+			/* correctly and the process is waked up by ISR */
+			/* ON TIME. Another is when timeout is expired, which */
+			/* means that either interrupt is NOT serviced */
+			/* correctly (pending interrupt) or it is TOO LATE */
+			/* for the process to be scheduled to run */
+			/* (scheduler latency) which results in a (potential) */
+			/* buffer underrun. And worse, there is NOTHING we */
 			/* can do to prevent it. */
 			if (!interruptible_sleep_on_timeout(&dmabuf->wait, tmo)) {
 				pr_debug(KERN_ERR "trident: playback schedule "
@@ -2054,8 +2054,8 @@ trident_write(struct file *file, const c
 					 dmabuf->fragsize, dmabuf->count,
 					 dmabuf->hwptr, dmabuf->swptr);
 
-				/* a buffer underrun, we delay the recovery */ 
-				/* until next time the while loop begin and */ 
+				/* a buffer underrun, we delay the recovery */
+				/* until next time the while loop begin and */
 				/* we REALLY have data to play */
 			}
 			if (signal_pending(current)) {
@@ -2079,7 +2079,7 @@ trident_write(struct file *file, const c
 		if (state->chans_num == 6) {
 			copy_count = 0;
 			state_cnt = 0;
-			if (ali_write_5_1(state, buffer, cnt, &copy_count, 
+			if (ali_write_5_1(state, buffer, cnt, &copy_count,
 					  &state_cnt) == -EFAULT) {
 				if (state_cnt) {
 					swptr = (swptr + state_cnt) % dmabuf->dmasize;
@@ -2096,7 +2096,7 @@ trident_write(struct file *file, const c
 				goto out;
 			}
 		} else {
-			if (copy_from_user(dmabuf->rawbuf + swptr, 
+			if (copy_from_user(dmabuf->rawbuf + swptr,
 					   buffer, cnt)) {
 				if (!ret)
 					ret = -EFAULT;
@@ -2172,7 +2172,7 @@ trident_poll(struct file *file, struct p
 			if (dmabuf->count >= (signed) dmabuf->fragsize)
 				mask |= POLLOUT | POLLWRNORM;
 		} else {
-			if ((signed) dmabuf->dmasize >= dmabuf->count + 
+			if ((signed) dmabuf->dmasize >= dmabuf->count +
 			    (signed) dmabuf->fragsize)
 				mask |= POLLOUT | POLLWRNORM;
 		}
@@ -2227,7 +2227,7 @@ out:
 }
 
 static int
-trident_ioctl(struct inode *inode, struct file *file, 
+trident_ioctl(struct inode *inode, struct file *file,
 	      unsigned int cmd, unsigned long arg)
 {
 	struct trident_state *state = (struct trident_state *)file->private_data;
@@ -2348,7 +2348,7 @@ trident_ioctl(struct inode *inode, struc
 
 
 	case SNDCTL_DSP_GETFMTS: /* Returns a mask of supported sample format */
-		ret = put_user(AFMT_S16_LE | AFMT_U16_LE | AFMT_S8 | 
+		ret = put_user(AFMT_S16_LE | AFMT_U16_LE | AFMT_S8 |
 			       AFMT_U8, p);
 		break;
 
@@ -2379,7 +2379,7 @@ trident_ioctl(struct inode *inode, struc
 			}
 		}
 		unlock_set_fmt(state);
-		ret = put_user((dmabuf->fmt & TRIDENT_FMT_16BIT) ? AFMT_S16_LE : 
+		ret = put_user((dmabuf->fmt & TRIDENT_FMT_16BIT) ? AFMT_S16_LE :
 			       AFMT_U8, p);
 		break;
 
@@ -2438,7 +2438,7 @@ trident_ioctl(struct inode *inode, struc
 				stop_adc(state);
 				dmabuf->ready = 0;
 				if (val >= 2) {
-					if (!((file->f_mode & FMODE_WRITE) && 
+					if (!((file->f_mode & FMODE_WRITE) &&
 					      (val == 6)))
 						val = 2;
 					dmabuf->fmt |= TRIDENT_FMT_STEREO;
@@ -2504,7 +2504,7 @@ trident_ioctl(struct inode *inode, struc
 		abinfo.fragstotal = dmabuf->numfrag;
 		abinfo.fragments = abinfo.bytes >> dmabuf->fragshift;
 		spin_unlock_irqrestore(&state->card->lock, flags);
-		ret = copy_to_user(argp, &abinfo, sizeof (abinfo)) ? 
+		ret = copy_to_user(argp, &abinfo, sizeof (abinfo)) ?
 			-EFAULT : 0;
 		break;
 
@@ -2524,7 +2524,7 @@ trident_ioctl(struct inode *inode, struc
 		abinfo.fragstotal = dmabuf->numfrag;
 		abinfo.fragments = abinfo.bytes >> dmabuf->fragshift;
 		spin_unlock_irqrestore(&state->card->lock, flags);
-		ret = copy_to_user(argp, &abinfo, sizeof (abinfo)) ? 
+		ret = copy_to_user(argp, &abinfo, sizeof (abinfo)) ?
 			-EFAULT : 0;
 		break;
 
@@ -2533,7 +2533,7 @@ trident_ioctl(struct inode *inode, struc
 		break;
 
 	case SNDCTL_DSP_GETCAPS:
-		ret = put_user(DSP_CAP_REALTIME | DSP_CAP_TRIGGER | 
+		ret = put_user(DSP_CAP_REALTIME | DSP_CAP_TRIGGER |
 			       DSP_CAP_MMAP | DSP_CAP_BIND, p);
 		break;
 
@@ -2553,7 +2553,7 @@ trident_ioctl(struct inode *inode, struc
 		}
 		if (file->f_mode & FMODE_READ) {
 			if (val & PCM_ENABLE_INPUT) {
-				if (!dmabuf->ready && 
+				if (!dmabuf->ready &&
 				    (ret = prog_dmabuf_record(state)))
 					break;
 				start_adc(state);
@@ -2562,7 +2562,7 @@ trident_ioctl(struct inode *inode, struc
 		}
 		if (file->f_mode & FMODE_WRITE) {
 			if (val & PCM_ENABLE_OUTPUT) {
-				if (!dmabuf->ready && 
+				if (!dmabuf->ready &&
 				    (ret = prog_dmabuf_playback(state)))
 					break;
 				start_dac(state);
@@ -2589,7 +2589,7 @@ trident_ioctl(struct inode *inode, struc
 		if (dmabuf->mapped)
 			dmabuf->count &= dmabuf->fragsize - 1;
 		spin_unlock_irqrestore(&state->card->lock, flags);
-		ret = copy_to_user(argp, &cinfo, sizeof (cinfo)) ? 
+		ret = copy_to_user(argp, &cinfo, sizeof (cinfo)) ?
 			-EFAULT : 0;
 		break;
 
@@ -2612,7 +2612,7 @@ trident_ioctl(struct inode *inode, struc
 		if (dmabuf->mapped)
 			dmabuf->count &= dmabuf->fragsize - 1;
 		spin_unlock_irqrestore(&state->card->lock, flags);
-		ret = copy_to_user(argp, &cinfo, sizeof (cinfo)) ? 
+		ret = copy_to_user(argp, &cinfo, sizeof (cinfo)) ?
 			-EFAULT : 0;
 		break;
 
@@ -2641,17 +2641,17 @@ trident_ioctl(struct inode *inode, struc
 		break;
 
 	case SOUND_PCM_READ_CHANNELS:
-		ret = put_user((dmabuf->fmt & TRIDENT_FMT_STEREO) ? 2 : 1, 
+		ret = put_user((dmabuf->fmt & TRIDENT_FMT_STEREO) ? 2 : 1,
 			       p);
 		break;
 
 	case SOUND_PCM_READ_BITS:
-		ret = put_user((dmabuf->fmt & TRIDENT_FMT_16BIT) ? AFMT_S16_LE : 
+		ret = put_user((dmabuf->fmt & TRIDENT_FMT_16BIT) ? AFMT_S16_LE :
 			       AFMT_U8, p);
 		break;
 
 	case SNDCTL_DSP_GETCHANNELMASK:
-		ret = put_user(DSP_BIND_FRONT | DSP_BIND_SURR | 
+		ret = put_user(DSP_BIND_FRONT | DSP_BIND_SURR |
 			       DSP_BIND_CENTER_LFE,  p);
 		break;
 
@@ -2671,10 +2671,10 @@ trident_ioctl(struct inode *inode, struc
 		} else {
 			dmabuf->ready = 0;
 			if (file->f_mode & FMODE_READ)
-				dmabuf->channel->attribute = (CHANNEL_REC | 
+				dmabuf->channel->attribute = (CHANNEL_REC |
 							      SRC_ENABLE);
 			if (file->f_mode & FMODE_WRITE)
-				dmabuf->channel->attribute = (CHANNEL_SPC_PB | 
+				dmabuf->channel->attribute = (CHANNEL_SPC_PB |
 							      SRC_ENABLE);
 			dmabuf->channel->attribute |= mask2attr[ffs(val)];
 		}
@@ -2765,8 +2765,8 @@ trident_open(struct inode *inode, struct
 	init_waitqueue_head(&dmabuf->wait);
 	file->private_data = state;
 
-	/* set default sample format. According to OSS Programmer's */ 
-	/* Guide  /dev/dsp should be default to unsigned 8-bits, mono, */ 
+	/* set default sample format. According to OSS Programmer's */
+	/* Guide  /dev/dsp should be default to unsigned 8-bits, mono, */
 	/* with sample rate 8kHz and /dev/dspW will accept 16-bits sample */
 	if (file->f_mode & FMODE_WRITE) {
 		dmabuf->fmt &= ~TRIDENT_FMT_MASK;
@@ -2783,7 +2783,7 @@ trident_open(struct inode *inode, struct
 	}
 
 	if (file->f_mode & FMODE_READ) {
-		/* FIXME: Trident 4d can only record in signed 16-bits stereo, */ 
+		/* FIXME: Trident 4d can only record in signed 16-bits stereo, */
 		/* 48kHz sample, to be dealed with in trident_set_adc_rate() ?? */
 		dmabuf->fmt &= ~TRIDENT_FMT_MASK;
 		if ((minor & 0x0f) == SND_DEV_DSP16)
@@ -2794,7 +2794,7 @@ trident_open(struct inode *inode, struct
 		if (card->pci_id == PCI_DEVICE_ID_SI_7018) {
 			/* set default channel attribute to 0x8a80, record from
 			   PCM L/R FIFO and mono = (left + right + 1)/2 */
-			dmabuf->channel->attribute = (CHANNEL_REC | PCM_LR | 
+			dmabuf->channel->attribute = (CHANNEL_REC | PCM_LR |
 						      MONO_MIX);
 		}
 		trident_set_adc_rate(state, 8000);
@@ -3020,7 +3020,7 @@ acquirecodecaccess(struct trident_card *
 			break;
 		if (wsemabits == 0) {
 		      unlock:
-			outl(((u32) (wcontrol & 0x1eff) | 0x00004000), 
+			outl(((u32) (wcontrol & 0x1eff) | 0x00004000),
 			     TRID_REG(card, ALI_AC97_WRITE));
 			continue;
 		}
@@ -3104,7 +3104,7 @@ ali_ac97_get(struct trident_card *card,
 	ncount = 10;
 
 	while (1) {
-		if ((inw(TRID_REG(card, ALI_AC97_WRITE)) & ALI_AC97_BUSY_READ) 
+		if ((inw(TRID_REG(card, ALI_AC97_WRITE)) & ALI_AC97_BUSY_READ)
 		    != 0)
 			break;
 		if (ncount <= 0)
@@ -3112,7 +3112,7 @@ ali_ac97_get(struct trident_card *card,
 		if (ncount-- == 1) {
 			pr_debug("ali_ac97_read :try clear busy flag\n");
 			aud_reg = inl(TRID_REG(card, ALI_AC97_WRITE));
-			outl((aud_reg & 0xffff7fff), 
+			outl((aud_reg & 0xffff7fff),
 			     TRID_REG(card, ALI_AC97_WRITE));
 		}
 		udelay(10);
@@ -3159,7 +3159,7 @@ ali_ac97_set(struct trident_card *card,
 
 	wcontrol = inw(TRID_REG(card, ALI_AC97_WRITE));
 	wcontrol &= 0xff00;
-	wcontrol |= (0x8100 | reg); /* bit 8=1: (ali1535 )reserved/ */ 
+	wcontrol |= (0x8100 | reg); /* bit 8=1: (ali1535 )reserved/ */
 	                            /* ali1535+ write */
 	outl((data | wcontrol), TRID_REG(card, ALI_AC97_WRITE));
 
@@ -3177,7 +3177,7 @@ ali_ac97_set(struct trident_card *card,
 			break;
 		if (ncount-- == 1) {
 			pr_debug("ali_ac97_set :try clear busy flag!!\n");
-			outw(wcontrol & 0x7fff, 
+			outw(wcontrol & 0x7fff,
 			     TRID_REG(card, ALI_AC97_WRITE));
 		}
 		udelay(10);
@@ -3382,7 +3382,7 @@ ali_detect_spdif_rate(struct trident_car
 	bval |= 0x1F;
 	outb(bval, TRID_REG(card, ALI_SPDIF_CTRL + 1));
 
-	while (((R1 < 0x0B) || (R1 > 0x0E)) && (R1 != 0x12) && 
+	while (((R1 < 0x0B) || (R1 > 0x0E)) && (R1 != 0x12) &&
 	       count <= 50000) {
 		count++;
 
@@ -3669,14 +3669,14 @@ ali_save_regs(struct trident_card *card)
 	spin_lock_irqsave(&card->lock, flags);
 
 	ali_registers.global_regs[0x2c] = inl(TRID_REG(card, T4D_MISCINT));
-	//ali_registers.global_regs[0x20] = inl(TRID_REG(card,T4D_START_A));    
+	//ali_registers.global_regs[0x20] = inl(TRID_REG(card,T4D_START_A));
 	ali_registers.global_regs[0x21] = inl(TRID_REG(card, T4D_STOP_A));
 
 	//disable all IRQ bits
 	outl(ALI_DISABLE_ALL_IRQ, TRID_REG(card, T4D_MISCINT));
 
 	for (i = 1; i < ALI_MIXER_REGS; i++)
-		ali_registers.mixer_regs[i] = ali_ac97_read(card->ac97_codec[0], 
+		ali_registers.mixer_regs[i] = ali_ac97_read(card->ac97_codec[0],
 							    i * 2);
 
 	for (i = 0; i < ALI_GLOBAL_REGS; i++) {
@@ -3688,7 +3688,7 @@ ali_save_regs(struct trident_card *card)
 	for (i = 0; i < ALI_CHANNELS; i++) {
 		outb(i, TRID_REG(card, T4D_LFO_GC_CIR));
 		for (j = 0; j < ALI_CHANNEL_REGS; j++)
-			ali_registers.channel_regs[i][j] = inl(TRID_REG(card, 
+			ali_registers.channel_regs[i][j] = inl(TRID_REG(card,
 									j * 4 + 0xe0));
 	}
 
@@ -3707,18 +3707,18 @@ ali_restore_regs(struct trident_card *ca
 	spin_lock_irqsave(&card->lock, flags);
 
 	for (i = 1; i < ALI_MIXER_REGS; i++)
-		ali_ac97_write(card->ac97_codec[0], i * 2, 
+		ali_ac97_write(card->ac97_codec[0], i * 2,
 			       ali_registers.mixer_regs[i]);
 
 	for (i = 0; i < ALI_CHANNELS; i++) {
 		outb(i, TRID_REG(card, T4D_LFO_GC_CIR));
 		for (j = 0; j < ALI_CHANNEL_REGS; j++)
-			outl(ali_registers.channel_regs[i][j], 
+			outl(ali_registers.channel_regs[i][j],
 			     TRID_REG(card, j * 4 + 0xe0));
 	}
 
 	for (i = 0; i < ALI_GLOBAL_REGS; i++) {
-		if ((i * 4 == T4D_MISCINT) || (i * 4 == T4D_STOP_A) || 
+		if ((i * 4 == T4D_MISCINT) || (i * 4 == T4D_STOP_A) ||
 		    (i * 4 == T4D_START_A))
 			continue;
 		outl(ali_registers.global_regs[i], TRID_REG(card, i * 4));
@@ -3763,7 +3763,7 @@ ali_alloc_pcm_channel(struct trident_car
 
 	bank = &card->banks[BANK_A];
 
-	if (inl(TRID_REG(card, ALI_GLOBAL_CONTROL)) & 
+	if (inl(TRID_REG(card, ALI_GLOBAL_CONTROL)) &
 	    (ALI_SPDIF_OUT_CH_ENABLE)) {
 		idx = ALI_SPDIF_OUT_CHANNEL;
 		if (!(bank->bitmap & (1 << idx))) {
@@ -3774,7 +3774,7 @@ ali_alloc_pcm_channel(struct trident_car
 		}
 	}
 
-	for (idx = ALI_PCM_OUT_CHANNEL_FIRST; idx <= ALI_PCM_OUT_CHANNEL_LAST; 
+	for (idx = ALI_PCM_OUT_CHANNEL_FIRST; idx <= ALI_PCM_OUT_CHANNEL_LAST;
 	     idx++) {
 		if (!(bank->bitmap & (1 << idx))) {
 			struct trident_channel *channel = &bank->channels[idx];
@@ -3785,9 +3785,9 @@ ali_alloc_pcm_channel(struct trident_car
 	}
 
 	/* no more free channels avaliable */
-#if 0 
+#if 0
 	printk(KERN_ERR "ali: no more channels available on Bank A.\n");
-#endif /* 0 */ 
+#endif /* 0 */
 	return NULL;
 }
 
@@ -3812,9 +3812,9 @@ ali_alloc_rec_pcm_channel(struct trident
 	}
 
 	/* no free recordable channels avaliable */
-#if 0 
+#if 0
 	printk(KERN_ERR "ali: no recordable channels available on Bank A.\n");
-#endif /* 0 */ 
+#endif /* 0 */
 	return NULL;
 }
 
@@ -3837,14 +3837,14 @@ ali_set_spdif_out_rate(struct trident_ca
 		break;
 	}
 
-	/* select spdif_out */ 
+	/* select spdif_out */
 	ch_st_sel = inb(TRID_REG(card, ALI_SPDIF_CTRL)) & ALI_SPDIF_OUT_CH_STATUS;
 
-	ch_st_sel |= 0x80;	/* select right */ 
+	ch_st_sel |= 0x80;	/* select right */
 	outb(ch_st_sel, TRID_REG(card, ALI_SPDIF_CTRL));
 	outb(status_rate | 0x20, TRID_REG(card, ALI_SPDIF_CS + 2));
 
-	ch_st_sel &= (~0x80);	/* select left */ 
+	ch_st_sel &= (~0x80);	/* select left */
 	outb(ch_st_sel, TRID_REG(card, ALI_SPDIF_CTRL));
 	outw(status_rate | 0x10, TRID_REG(card, ALI_SPDIF_CS + 2));
 }
@@ -3881,14 +3881,14 @@ ali_address_interrupt(struct trident_car
 	}
 }
 
-/* Updating the values of counters of other_states' DMAs without lock 
+/* Updating the values of counters of other_states' DMAs without lock
 protection is no harm because all DMAs of multi-channels and interrupt
 depend on a master state's DMA, and changing the counters of the master
 state DMA is protected by a spinlock.
 */
 static int
-ali_write_5_1(struct trident_state *state, const char __user *buf, 
-	      int cnt_for_multi_channel, unsigned int *copy_count, 
+ali_write_5_1(struct trident_state *state, const char __user *buf,
+	      int cnt_for_multi_channel, unsigned int *copy_count,
 	      unsigned int *state_cnt)
 {
 
@@ -3904,10 +3904,10 @@ ali_write_5_1(struct trident_state *stat
 
 	if ((i = state->multi_channels_adjust_count) > 0) {
 		if (i == 1) {
-			if (copy_from_user(dmabuf->rawbuf + swptr, 
+			if (copy_from_user(dmabuf->rawbuf + swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(swptr, buffer, cnt_for_multi_channel, 
+			seek_offset(swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
 			i--;
 			(*state_cnt) += sample_s;
@@ -3916,10 +3916,10 @@ ali_write_5_1(struct trident_state *stat
 			i = i - (state->chans_num - other_dma_nums);
 		for (; (i < other_dma_nums) && (cnt_for_multi_channel > 0); i++) {
 			dmabuf_temp = &state->other_states[i]->dmabuf;
-			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr, 
+			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel, 
+			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
 		}
 		if (cnt_for_multi_channel == 0)
@@ -3928,39 +3928,39 @@ ali_write_5_1(struct trident_state *stat
 	if (cnt_for_multi_channel > 0) {
 		loop = cnt_for_multi_channel / (state->chans_num * sample_s);
 		for (i = 0; i < loop; i++) {
-			if (copy_from_user(dmabuf->rawbuf + swptr, buffer, 
+			if (copy_from_user(dmabuf->rawbuf + swptr, buffer,
 					   sample_s * 2))
 				return -EFAULT;
-			seek_offset(swptr, buffer, cnt_for_multi_channel, 
+			seek_offset(swptr, buffer, cnt_for_multi_channel,
 				    sample_s * 2, *copy_count);
 			(*state_cnt) += (sample_s * 2);
 
 			dmabuf_temp = &state->other_states[0]->dmabuf;
-			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr, 
+			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel, 
+			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
 
 			dmabuf_temp = &state->other_states[1]->dmabuf;
-			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr, 
+			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel, 
+			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
 
 			dmabuf_temp = &state->other_states[2]->dmabuf;
-			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr, 
+			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel, 
+			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
 
 			dmabuf_temp = &state->other_states[3]->dmabuf;
-			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr, 
+			if (copy_from_user(dmabuf_temp->rawbuf + dmabuf_temp->swptr,
 					   buffer, sample_s))
 				return -EFAULT;
-			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel, 
+			seek_offset(dmabuf_temp->swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
 		}
 
@@ -3969,15 +3969,15 @@ ali_write_5_1(struct trident_state *stat
 
 			if (copy_from_user(dmabuf->rawbuf + swptr, buffer, sample_s))
 				return -EFAULT;
-			seek_offset(swptr, buffer, cnt_for_multi_channel, 
+			seek_offset(swptr, buffer, cnt_for_multi_channel,
 				    sample_s, *copy_count);
 			(*state_cnt) += sample_s;
 
 			if (cnt_for_multi_channel > 0) {
-				if (copy_from_user(dmabuf->rawbuf + swptr, 
+				if (copy_from_user(dmabuf->rawbuf + swptr,
 						   buffer, sample_s))
 					return -EFAULT;
-				seek_offset(swptr, buffer, cnt_for_multi_channel, 
+				seek_offset(swptr, buffer, cnt_for_multi_channel,
 					    sample_s, *copy_count);
 				(*state_cnt) += sample_s;
 
@@ -3986,12 +3986,12 @@ ali_write_5_1(struct trident_state *stat
 					loop = state->multi_channels_adjust_count - diff;
 					for (i = 0; i < loop; i++) {
 						dmabuf_temp = &state->other_states[i]->dmabuf;
-						if (copy_from_user(dmabuf_temp->rawbuf + 
-								   dmabuf_temp->swptr, 
+						if (copy_from_user(dmabuf_temp->rawbuf +
+								   dmabuf_temp->swptr,
 								   buffer, sample_s))
 							return -EFAULT;
-						seek_offset(dmabuf_temp->swptr, buffer, 
-							    cnt_for_multi_channel, 
+						seek_offset(dmabuf_temp->swptr, buffer,
+							    cnt_for_multi_channel,
 							    sample_s, *copy_count);
 					}
 				}
@@ -4048,11 +4048,11 @@ ali_write_proc(struct file *file, const
 		ali_disable_special_channel(card, ALI_SPDIF_OUT_CHANNEL);
 		break;
 	case '1':
-		ali_setup_spdif_out(card, ALI_SPDIF_OUT_TO_SPDIF_OUT | 
+		ali_setup_spdif_out(card, ALI_SPDIF_OUT_TO_SPDIF_OUT |
 				    ALI_SPDIF_OUT_PCM);
 		break;
 	case '2':
-		ali_setup_spdif_out(card, ALI_SPDIF_OUT_TO_SPDIF_OUT | 
+		ali_setup_spdif_out(card, ALI_SPDIF_OUT_TO_SPDIF_OUT |
 				    ALI_SPDIF_OUT_NON_PCM);
 		break;
 	case '3':
@@ -4077,7 +4077,7 @@ trident_open_mixdev(struct inode *inode,
 
 	for (card = devs; card != NULL; card = card->next)
 		for (i = 0; i < NR_AC97; i++)
-			if (card->ac97_codec[i] != NULL && 
+			if (card->ac97_codec[i] != NULL &&
 			    card->ac97_codec[i]->dev_mixer == minor)
 				goto match;
 
@@ -4091,7 +4091,7 @@ trident_open_mixdev(struct inode *inode,
 }
 
 static int
-trident_ioctl_mixdev(struct inode *inode, struct file *file, unsigned int cmd, 
+trident_ioctl_mixdev(struct inode *inode, struct file *file, unsigned int cmd,
 		     unsigned long arg)
 {
 	struct ac97_codec *codec = (struct ac97_codec *) file->private_data;
@@ -4185,9 +4185,9 @@ trident_ac97_init(struct trident_card *c
 		/* disable AC97 GPIO interrupt */
 		outl(0x00, TRID_REG(card, SI_AC97_GPIO));
 		/* when power up the AC link is in cold reset mode so stop it */
-		outl(PCMOUT | SURROUT | CENTEROUT | LFEOUT | SECONDARY_ID, 
+		outl(PCMOUT | SURROUT | CENTEROUT | LFEOUT | SECONDARY_ID,
 		     TRID_REG(card, SI_SERIAL_INTF_CTRL));
-		/* it take a long time to recover from a cold reset */ 
+		/* it take a long time to recover from a cold reset */
 		/* (especially when you have more than one codec) */
 		udelay(2000);
 		ready_2nd = inl(TRID_REG(card, SI_SERIAL_INTF_CTRL));
@@ -4207,9 +4207,9 @@ trident_ac97_init(struct trident_card *c
 		/* disable AC97 GPIO interrupt */
 		outl(0x00, TRID_REG(card, SI_AC97_GPIO));
 		/* when power up, the AC link is in cold reset mode, so stop it */
-		outl(PCMOUT | SURROUT | CENTEROUT | LFEOUT, 
+		outl(PCMOUT | SURROUT | CENTEROUT | LFEOUT,
 		     TRID_REG(card, SI_SERIAL_INTF_CTRL));
-		/* it take a long time to recover from a cold reset (especially */ 
+		/* it take a long time to recover from a cold reset (especially */
 		/* when you have more than one codec) */
 		udelay(2000);
 		ready_2nd = inl(TRID_REG(card, SI_SERIAL_INTF_CTRL));
@@ -4221,7 +4221,7 @@ trident_ac97_init(struct trident_card *c
 		if ((codec = ac97_alloc_codec()) == NULL)
 			return -ENOMEM;
 
-		/* initialize some basic codec information, other fields */ 
+		/* initialize some basic codec information, other fields */
 		/* will be filled in ac97_probe_codec */
 		codec->private_data = card;
 		codec->id = num_ac97;
@@ -4352,8 +4352,8 @@ static inline int trident_register_gamep
 static inline void trident_unregister_gameport(struct trident_card *card) { }
 #endif /* SUPPORT_JOYSTICK */
 
-/* install the driver, we do not allocate hardware channel nor DMA buffer */ 
-/* now, they are defered until "ACCESS" time (in prog_dmabuf called by */ 
+/* install the driver, we do not allocate hardware channel nor DMA buffer */
+/* now, they are defered until "ACCESS" time (in prog_dmabuf called by */
 /* open/read/write/ioctl/mmap) */
 static int __devinit
 trident_probe(struct pci_dev *pci_dev, const struct pci_device_id *pci_id)
@@ -4376,9 +4376,9 @@ trident_probe(struct pci_dev *pci_dev, c
 	else
 		dma_mask = TRIDENT_DMA_MASK;
 	if (pci_set_dma_mask(pci_dev, dma_mask)) {
-		printk(KERN_ERR "trident: architecture does not support" 
-		       " %s PCI busmaster DMA\n", 
-		       pci_dev->device == PCI_DEVICE_ID_ALI_5451 ? 
+		printk(KERN_ERR "trident: architecture does not support"
+		       " %s PCI busmaster DMA\n",
+		       pci_dev->device == PCI_DEVICE_ID_ALI_5451 ?
 		       "32-bit" : "30-bit");
 		goto out;
 	}
@@ -4422,7 +4422,7 @@ trident_probe(struct pci_dev *pci_dev, c
 
 	pci_set_master(pci_dev);
 
-	printk(KERN_INFO "trident: %s found at IO 0x%04lx, IRQ %d\n", 
+	printk(KERN_INFO "trident: %s found at IO 0x%04lx, IRQ %d\n",
 	       card_names[pci_id->driver_data], card->iobase, card->irq);
 
 	if (card->pci_id == PCI_DEVICE_ID_ALI_5451) {
@@ -4449,8 +4449,8 @@ trident_probe(struct pci_dev *pci_dev, c
 
 		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */
 		card->hwvolctl = 0;
-		pci_dev_m1533 = pci_find_device(PCI_VENDOR_ID_AL, 
-						PCI_DEVICE_ID_AL_M1533, 
+		pci_dev_m1533 = pci_find_device(PCI_VENDOR_ID_AL,
+						PCI_DEVICE_ID_AL_M1533,
 						pci_dev_m1533);
 		rc = -ENODEV;
 		if (pci_dev_m1533 == NULL)
@@ -4482,7 +4482,7 @@ trident_probe(struct pci_dev *pci_dev, c
 	rc = -ENODEV;
 	if (request_irq(card->irq, &trident_interrupt, IRQF_SHARED,
 			card_names[pci_id->driver_data], card)) {
-		printk(KERN_ERR "trident: unable to allocate irq %d\n", 
+		printk(KERN_ERR "trident: unable to allocate irq %d\n",
 		       card->irq);
 		goto out_proc_fs;
 	}
@@ -4533,7 +4533,7 @@ trident_probe(struct pci_dev *pci_dev, c
 				printk(KERN_INFO "trident: Running on Alpha system "
 				       "type Nautilus\n");
 				ac97_data = ali_ac97_get(card, 0, AC97_POWER_CONTROL);
-				ali_ac97_set(card, 0, AC97_POWER_CONTROL, 
+				ali_ac97_set(card, 0, AC97_POWER_CONTROL,
 					     ac97_data | ALI_EAPD_POWER_DOWN);
 			}
 		}
@@ -4566,7 +4566,7 @@ out_proc_fs:
 	devs = NULL;
 out_release_region:
 	release_region(iobase, 256);
-	return rc; 
+	return rc;
 }
 
 static void __devexit
@@ -4634,8 +4634,8 @@ static struct pci_driver trident_pci_dri
 static int __init
 trident_init_module(void)
 {
-	printk(KERN_INFO "Trident 4DWave/SiS 7018/ALi 5451,Tvia CyberPro " 
-	       "5050 PCI Audio, version " DRIVER_VERSION ", " __TIME__ " " 
+	printk(KERN_INFO "Trident 4DWave/SiS 7018/ALi 5451,Tvia CyberPro "
+	       "5050 PCI Audio, version " DRIVER_VERSION ", " __TIME__ " "
 	       __DATE__ "\n");
 
 	return pci_register_driver(&trident_pci_driver);
-- 
1.4.4

