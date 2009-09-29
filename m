Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZI2Bn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZI2Bn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 21:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbZI2Bnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 21:43:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44584 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbZI2Bny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 21:43:54 -0400
Date: Mon, 28 Sep 2009 21:43:57 -0400
From: Dirk Hohndel <hohndel@infradead.org>
To: Jin Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] trivial fix of a very frequent spelling mistake
Message-ID: <20090929014357.GA3597@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

something-bility is spelled as something-blity
so a grep for 'blit' would find these lines

this is so trivial that I didn't split it by subsystem / copy 
additional maintainers - all changes are to comments
The only purpose is to get fewer false positives when grepping
around the kernel sources.

Signed-off-by: Dirk Hohndel <hohndel@infradead.org>

---
 arch/parisc/kernel/perf.c                        |    2 +-
 arch/powerpc/kernel/vdso.c                       |    2 +-
 arch/powerpc/oprofile/op_model_cell.c            |    2 +-
 drivers/char/tty_ioctl.c                         |    2 +-
 drivers/isdn/i4l/isdn_net.c                      |    2 +-
 drivers/md/dm-crypt.c                            |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c             |    2 +-
 drivers/net/tokenring/ibmtr.c                    |    2 +-
 drivers/net/wireless/orinoco/hermes_dld.c        |    4 ++--
 drivers/scsi/3w-9xxx.c                           |    2 +-
 drivers/scsi/3w-xxxx.c                           |    2 +-
 drivers/scsi/nsp32.c                             |    2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c     |    2 +-
 drivers/staging/comedi/drivers/cb_pcidda.c       |    2 +-
 drivers/staging/comedi/drivers/dmm32at.c         |    2 +-
 drivers/staging/comedi/drivers/dt2814.c          |    2 +-
 drivers/staging/comedi/drivers/dt282x.c          |    4 ++--
 drivers/staging/comedi/drivers/ni_atmio16d.c     |    2 +-
 drivers/staging/comedi/drivers/ni_mio_common.c   |    2 +-
 drivers/staging/comedi/drivers/ni_pcidio.c       |    2 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |    2 +-
 drivers/staging/comedi/drivers/rtd520.c          |    2 +-
 drivers/staging/comedi/drivers/s626.c            |    2 +-
 drivers/staging/comedi/drivers/skel.c            |    2 +-
 drivers/staging/comedi/drivers/usbdux.c          |    4 ++--
 drivers/uwb/neh.c                                |    2 +-
 net/sched/act_api.c                              |    2 +-
 sound/pci/ice1712/juli.c                         |    2 +-
 28 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/parisc/kernel/perf.c b/arch/parisc/kernel/perf.c
index 75099ef..f9f6783 100644
--- a/arch/parisc/kernel/perf.c
+++ b/arch/parisc/kernel/perf.c
@@ -24,7 +24,7 @@
  *
  *  This driver programs the PCX-U/PCX-W performance counters
  *  on the PA-RISC 2.0 chips.  The driver keeps all images now
- *  internally to the kernel to hopefully eliminate the possiblity
+ *  internally to the kernel to hopefully eliminate the possibility
  *  of a bad image halting the CPU.  Also, there are different
  *  images for the PCX-W and later chips vs the PCX-U chips.
  *
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 94e2df3..4ae0449 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -712,7 +712,7 @@ static int __init vdso_init(void)
 
 #ifdef CONFIG_PPC64
 	/*
-	 * Fill up the "systemcfg" stuff for backward compatiblity
+	 * Fill up the "systemcfg" stuff for backward compatibility
 	 */
 	strcpy((char *)vdso_data->eye_catcher, "SYSTEMCFG:PPC64");
 	vdso_data->version.major = SYSTEMCFG_MAJOR;
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index ae06c62..52c98ed 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -248,7 +248,7 @@ static int pm_rtas_activate_signals(u32 node, u32 count)
 	 * There is no debug setup required for the cycles event.
 	 * Note that only events in the same group can be used.
 	 * Otherwise, there will be conflicts in correctly routing
-	 * the signals on the debug bus.  It is the responsiblity
+	 * the signals on the debug bus.  It is the responsibility
 	 * of the OProfile user tool to check the events are in
 	 * the same group.
 	 */
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 8e67d5c..6bd5f88 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -315,7 +315,7 @@ EXPORT_SYMBOL(tty_termios_input_baud_rate);
  *	For maximal back compatibility with legacy SYS5/POSIX *nix behaviour
  *	we need to carefully set the bits when the user does not get the
  *	desired speed. We allow small margins and preserve as much of possible
- *	of the input intent to keep compatiblity.
+ *	of the input intent to keep compatibility.
  *
  *	Locking: Caller should hold termios lock. This is already held
  *	when calling this function from the driver termios handler.
diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index 90b56ed..507e13d 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -1563,7 +1563,7 @@ isdn_net_ciscohdlck_slarp_send_keepalive(unsigned long data)
 	*(__be32 *)(p +  4) = cpu_to_be32(CISCO_SLARP_KEEPALIVE);
 	*(__be32 *)(p +  8) = cpu_to_be32(lp->cisco_myseq);
 	*(__be32 *)(p + 12) = cpu_to_be32(lp->cisco_yourseq);
-	*(__be16 *)(p + 16) = cpu_to_be16(0xffff); // reliablity, always 0xffff
+	*(__be16 *)(p + 16) = cpu_to_be16(0xffff); // reliability, always 0xffff
 	p += 18;
 
 	isdn_net_write_super(lp, skb);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ed10381..e412980 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -988,7 +988,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_cipher;
 	}
 
-	/* Compatiblity mode for old dm-crypt cipher strings */
+	/* Compatibility mode for old dm-crypt cipher strings */
 	if (!chainmode || (strcmp(chainmode, "plain") == 0 && !ivmode)) {
 		chainmode = "cbc";
 		ivmode = "plain";
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 8c9ae0a..039c6e4 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -1395,7 +1395,7 @@ static int dvb_net_do_ioctl(struct inode *inode, struct file *file,
 		return ret;
 	}
 
-	/* binary compatiblity cruft */
+	/* binary compatibility cruft */
 	case __NET_ADD_IF_OLD:
 	{
 		struct __dvb_net_if_old *dvbnetif = parg;
diff --git a/drivers/net/tokenring/ibmtr.c b/drivers/net/tokenring/ibmtr.c
index 525bbc5..dedba2c 100644
--- a/drivers/net/tokenring/ibmtr.c
+++ b/drivers/net/tokenring/ibmtr.c
@@ -96,7 +96,7 @@
  *
  *      Change by Mike Sullivan et al.:
  *      + added turbo card support. No need to use lanaid to configure
- *      the adapter into isa compatiblity mode.
+ *      the adapter into isa compatibility mode.
  *
  *      Changes by Burt Silverman to allow the computer to behave nicely when
  *	a cable is pulled or not in place, or a PCMCIA card is removed hot.
diff --git a/drivers/net/wireless/orinoco/hermes_dld.c b/drivers/net/wireless/orinoco/hermes_dld.c
index a3eefe1..84200da 100644
--- a/drivers/net/wireless/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/orinoco/hermes_dld.c
@@ -550,7 +550,7 @@ static const struct {							\
 
 #define DEFAULT_PDR(pid) default_pdr_data_##pid
 
-/*  HWIF Compatiblity */
+/*  HWIF Compatibility */
 DEFINE_DEFAULT_PDR(0x0005, 10, "\x00\x00\x06\x00\x01\x00\x01\x00\x01\x00");
 
 /* PPPPSign */
@@ -656,7 +656,7 @@ int hermes_apply_pda_with_defaults(hermes_t *hw,
 					 record_id + 1, pdi);
 			}
 			break;
-		case 0x5: /*  HWIF Compatiblity */
+		case 0x5: /*  HWIF Compatibility */
 			default_pdi = (struct pdi *) &DEFAULT_PDR(0x0005);
 			break;
 		case 0x108: /* PPPPSign */
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 36c21b1..b59e240 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -732,7 +732,7 @@ static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int
 		break;
 	case TW_IOCTL_GET_COMPATIBILITY_INFO:
 		tw_ioctl->driver_command.status = 0;
-		/* Copy compatiblity struct into ioctl data buffer */
+		/* Copy compatibility struct into ioctl data buffer */
 		tw_compat_info = (TW_Compatibility_Info *)tw_ioctl->data_buffer;
 		memcpy(tw_compat_info, &tw_dev->tw_compat_info, sizeof(TW_Compatibility_Info));
 		break;
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index faa0fcf..ff04821 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -8,7 +8,7 @@
 
    Copyright (C) 1999-2009 3ware Inc.
 
-   Kernel compatiblity By: 	Andre Hedrick <andre@suse.com>
+   Kernel compatibility By: 	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
    
    Further tiny build fixes and trivial hoovering    Alan Cox
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 2be7d5b..2c98a6e 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -1419,7 +1419,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 		nsp32_msg(KERN_ERR, "Received unexpected BMCNTERR IRQ! ");
 		/*
 		 * TODO: To be implemented improving bus master
-		 * transfer reliablity when BMCNTERR is occurred in
+		 * transfer reliability when BMCNTERR is occurred in
 		 * AutoSCSI phase described in specification.
 		 */
 	}
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 12d12b4..576f5a7 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -395,7 +395,7 @@ static int das16cs_ai_cmdtest(struct comedi_device *dev,
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
 	    cmd->scan_begin_src != TRIG_EXT)
 		err++;
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 7a5d46e..7823577 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -497,7 +497,7 @@ static int cb_pcidda_ai_cmdtest(struct comedi_device *dev,
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER
 	    && cmd->scan_begin_src != TRIG_EXT)
 		err++;
diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index aeec1ee..9db9a46 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -629,7 +629,7 @@ static int dmm32at_ai_cmdtest(struct comedi_device *dev,
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
 	    cmd->scan_begin_src != TRIG_EXT)
 		err++;
diff --git a/drivers/staging/comedi/drivers/dt2814.c b/drivers/staging/comedi/drivers/dt2814.c
index 0364bbf..e1b7375 100644
--- a/drivers/staging/comedi/drivers/dt2814.c
+++ b/drivers/staging/comedi/drivers/dt2814.c
@@ -175,7 +175,7 @@ static int dt2814_ai_cmdtest(struct comedi_device *dev,
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->stop_src != TRIG_TIMER && cmd->stop_src != TRIG_EXT)
 		err++;
 
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index a4c96c0..99ca294 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -777,7 +777,7 @@ static int dt282x_ai_cmdtest(struct comedi_device *dev,
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_FOLLOW &&
 	    cmd->scan_begin_src != TRIG_EXT)
 		err++;
@@ -1050,7 +1050,7 @@ static int dt282x_ao_cmdtest(struct comedi_device *dev,
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->stop_src != TRIG_COUNT && cmd->stop_src != TRIG_NONE)
 		err++;
 
diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 901833d..49ace5e 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -325,7 +325,7 @@ static int atmio16d_ai_cmdtest(struct comedi_device *dev,
 		return 1;
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_FOLLOW &&
 	    cmd->scan_begin_src != TRIG_EXT &&
 	    cmd->scan_begin_src != TRIG_TIMER)
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index e3ffb06..45d2862 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -2206,7 +2206,7 @@ static int ni_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->start_src != TRIG_NOW &&
 	    cmd->start_src != TRIG_INT && cmd->start_src != TRIG_EXT)
 		err++;
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 52b2eca..340b4e5 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -794,7 +794,7 @@ static int ni_pcidio_cmdtest(struct comedi_device *dev,
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_INT)
 		err++;
 	if (cmd->scan_begin_src != TRIG_TIMER &&
diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index f63bdc3..49b88ea 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -506,7 +506,7 @@ static int daqp_ai_cmdtest(struct comedi_device *dev,
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
 	    cmd->scan_begin_src != TRIG_FOLLOW)
 		err++;
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index f35cce5..8626658 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1768,7 +1768,7 @@ static int rtd_ai_cmdtest(struct comedi_device *dev,
 
 	/* step 2: make sure trigger sources are unique
 	   and mutually compatible */
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
 	    cmd->scan_begin_src != TRIG_EXT) {
 		err++;
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 80d2787..fdd7ab9 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1926,7 +1926,7 @@ static int s626_ai_cmdtest(struct comedi_device *dev,
 	/* step 2: make sure trigger sources are unique and mutually
 	   compatible */
 
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
 	    cmd->scan_begin_src != TRIG_EXT
 	    && cmd->scan_begin_src != TRIG_FOLLOW)
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 3dee62a..aba57d9 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -399,7 +399,7 @@ static int skel_ai_cmdtest(struct comedi_device *dev,
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
-	/* note that mutual compatiblity is not an issue here */
+	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
 	    cmd->scan_begin_src != TRIG_EXT)
 		err++;
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index cca4e86..cec028e 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -979,7 +979,7 @@ static int usbdux_ai_cmdtest(struct comedi_device *dev,
 
 	/*
 	 * step 2: make sure trigger sources are unique and mutually compatible
-	 * note that mutual compatiblity is not an issue here
+	 * note that mutual compatibility is not an issue here
 	 */
 	if (cmd->scan_begin_src != TRIG_FOLLOW &&
 	    cmd->scan_begin_src != TRIG_EXT &&
@@ -1557,7 +1557,7 @@ static int usbdux_ao_cmdtest(struct comedi_device *dev,
 
 	/*
 	 * step 2: make sure trigger sources are unique and mutually compatible
-	 * note that mutual compatiblity is not an issue here
+	 * note that mutual compatibility is not an issue here
 	 */
 	if (cmd->scan_begin_src != TRIG_FOLLOW &&
 	    cmd->scan_begin_src != TRIG_EXT &&
diff --git a/drivers/uwb/neh.c b/drivers/uwb/neh.c
index 0af8916..78510a1 100644
--- a/drivers/uwb/neh.c
+++ b/drivers/uwb/neh.c
@@ -150,7 +150,7 @@ void uwb_rc_neh_put(struct uwb_rc_neh *neh)
  *	 0xff is invalid, so they must not be used. Initialization
  *	 fills up those two in the bitmap so they are not allocated.
  *
- * We spread the allocation around to reduce the posiblity of two
+ * We spread the allocation around to reduce the possibility of two
  * consecutive opened @neh's getting the same context ID assigned (to
  * avoid surprises with late events that timed out long time ago). So
  * first we search from where @rc->ctx_roll is, if not found, we
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 2dfb3e7..5364d0b 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -598,7 +598,7 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *a,
 		goto errout;
 
 	/* compat_mode being true specifies a call that is supposed
-	 * to add additional backward compatiblity statistic TLVs.
+	 * to add additional backward compatibility statistic TLVs.
 	 */
 	if (compat_mode) {
 		if (a->type == TCA_OLD_COMPAT)
diff --git a/sound/pci/ice1712/juli.c b/sound/pci/ice1712/juli.c
index fd948bf..9c0f78e 100644
--- a/sound/pci/ice1712/juli.c
+++ b/sound/pci/ice1712/juli.c
@@ -380,7 +380,7 @@ static struct snd_kcontrol_new juli_mute_controls[] __devinitdata = {
 	 * inputs) are fed from Xilinx.
 	 *
 	 * I even checked traces on board and coded a support in driver for
-	 * an alternative possiblity - the unused I2S ICE output channels
+	 * an alternative possibility - the unused I2S ICE output channels
 	 * switched to HW-IN/SPDIF-IN and providing the monitoring signal to
 	 * the DAC - to no avail. The I2S outputs seem to be unconnected.
 	 *
-- 
1.6.2.5

