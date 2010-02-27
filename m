Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812Ab0B0Va4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:30:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56290 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934585Ab0B0Val convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:30:41 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1267306076.16186.103.camel@localhost>
References: <1267306076.16186.103.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 27 Feb 2010 21:30:35 +0000
Message-ID: <1267306235.16186.106.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH firmware 3/6] Specify drivers using firmware by
 module/object name
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers are currently specified by a mixture of module name, config
option or description, which is not that useful.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE |   72 ++++++++++++++++++++++++++++++++--------------------------------
 1 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/WHENCE b/WHENCE
index c291289..690157d 100644
--- a/WHENCE
+++ b/WHENCE
@@ -26,7 +26,7 @@ Licence: Allegedly GPLv2+, but no source visible. Marked:
 
 --------------------------------------------------------------------------
 
-Driver: korg1212 -- Korg 1212 IO audio device
+Driver: snd-korg1212 -- Korg 1212 IO audio device
 
 File: korg/k1212.dsp
 
@@ -36,7 +36,7 @@ Found in alsa-firmware package in hex form; no licensing information.
 
 --------------------------------------------------------------------------
 
-Driver: maestro3 -- ESS Allegro Maestro3 audio device
+Driver: snd-maestro3 -- ESS Allegro Maestro3 audio device
 
 File: ess/maestro3_assp_kernel.fw
 File: ess/maestro3_assp_minisrc.fw
@@ -50,7 +50,7 @@ specs on the dsp."
 
 --------------------------------------------------------------------------
 
-Driver: ymfpci -- Yamaha YMF724/740/744/754 audio devices
+Driver: snd-ymfpci -- Yamaha YMF724/740/744/754 audio devices
 
 File: yamaha/ds1_ctrl.fw
 File: yamaha/ds1_dsp.fw
@@ -63,7 +63,7 @@ Found alsa-firmware package in hex form, with the following comment:
 
 --------------------------------------------------------------------------
 
-Driver: SCSI_ADVANSYS - AdvanSys SCSI
+Driver: advansys - AdvanSys SCSI
 
 File: advansys/mcode.bin
 File: advansys/3550.bin
@@ -76,7 +76,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: SCSI_QLOGIC_1280 - Qlogic QLA 1240/1x80/1x160 SCSI support
+Driver: qla1280 - Qlogic QLA 1240/1x80/1x160 SCSI support
 
 File: qlogic/1040.bin
 File: qlogic/1280.bin
@@ -116,7 +116,7 @@ Found in hex form in the kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: ttusb-budget -- Technotrend/Hauppauge Nova-USB devices
+Driver: dvb-ttusb-budget -- Technotrend/Hauppauge Nova-USB devices
 
 File: ttusb-budget/dspbootcode.bin
 
@@ -295,7 +295,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: CPiA2 -- cameras based on Vision's CPiA2
+Driver: cpia2 -- cameras based on Vision's CPiA2
 
 File: cpia2/stv0672_vp4.bin
 
@@ -308,7 +308,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: DABUSB -- Digital Audio Broadcasting (DAB) Receiver for USB and Linux
+Driver: dabusb -- Digital Audio Broadcasting (DAB) Receiver for USB and Linux
 
 File: dabusb/firmware.fw
 File: dabusb/bitstream.bin
@@ -324,7 +324,7 @@ Licence: Distributable
 
 --------------------------------------------------------------------------
 
-Driver: USB_VICAM -- USB 3com HomeConnect (aka vicam)
+Driver: vicam -- USB 3com HomeConnect (aka vicam)
 
 File: vicam/firmware.fw
 
@@ -334,7 +334,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: USB_SERIAL_EDGEPORT - USB Inside Out Edgeport Serial Driver
+Driver: io_edgeport - USB Inside Out Edgeport Serial Driver
 
 File: edgeport/boot.fw
 File: edgeport/boot2.fw
@@ -352,7 +352,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: USB_SERIAL_EDGEPORT_TI - USB Inside Out Edgeport Serial Driver
+Driver: io_ti - USB Inside Out Edgeport Serial Driver
 (TI Devices)
 
 File: edgeport/down3.bin
@@ -368,7 +368,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: ATARI_DSP56K - Atari DSP56k support
+Driver: dsp56k - Atari DSP56k support
 
 File: dsp56k/bootstrap.bin
 Source: dsp56k/bootstrap.asm
@@ -380,7 +380,7 @@ http://www.zdomain.com/a56.html
 
 --------------------------------------------------------------------------
 
-Driver: SND_SB16_CSP - Sound Blaster 16/AWE CSP support
+Driver: snd-sb16-csp - Sound Blaster 16/AWE CSP support
 
 File: sb16/mulaw_main.csp
 File: sb16/alaw_main.csp
@@ -398,7 +398,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: SCSI_QLA_FC - QLogic QLA2XXX Fibre Channel
+Driver: qla2xxx - QLogic QLA2XXX Fibre Channel
 
 File: ql2100_fw.bin -- 1.19.38 TP
 File: ql2200_fw.bin -- 2.02.08 TP
@@ -413,7 +413,7 @@ Available from ftp://ftp.qlogic.com/outgoing/linux/firmware/
 
 --------------------------------------------------------------------------
 
-Driver: ORINOCO - Agere/Prism/Symbol Orinoco support
+Driver: orinoco - Agere/Prism/Symbol Orinoco support
 
 File: agere_sta_fw.bin -- 9.48 Hermes I
 File: agere_ap_fw.bin  -- 9.48 Hermes I
@@ -422,7 +422,7 @@ Licence: Redistributable. See LICENCE.agere for details
 
 --------------------------------------------------------------------------
 
-Driver: AR9170 - Atheros 802.11n "otus" USB
+Driver: ar9170 - Atheros 802.11n "otus" USB
 
 File: ar9170-1.fw
 File: ar9170-2.fw
@@ -431,7 +431,7 @@ Licence: Redistributable. See LICENCE.atheros_firmware for details
 
 --------------------------------------------------------------------------
 
-Driver: CASSINI - Sun Cassini
+Driver: cassini - Sun Cassini
 
 File: sun/cassini.bin
 
@@ -441,7 +441,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: SLICOSS - Alacritech IS-NIC products
+Driver: slicoss - Alacritech IS-NIC products
 
 File: slicoss/gbdownload.sys
 File: slicoss/gbrcvucode.sys
@@ -468,7 +468,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: SXG - Alacritech IS-NIC products
+Driver: sxg - Alacritech IS-NIC products
 
 File: sxg/saharadownloadB.sys
 File: sxg/saharadbgdownloadB.sys
@@ -545,7 +545,7 @@ http://alteon.shareable.org/
 
 --------------------------------------------------------------------------
 
-Driver: tigon3 -- Broadcom Tigon3 based gigabit Ethernet cards
+Driver: tg3 -- Broadcom Tigon3 based gigabit Ethernet cards
 
 File: tigon/tg3.bin
 File: tigon/tg3_tso.bin
@@ -564,7 +564,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: ADAPTEC_STARFIRE - Adaptec Starfire/DuraLAN support
+Driver: starfire - Adaptec Starfire/DuraLAN support
 
 File: adaptec/starfire_rx.bin
 File: adaptec/starfire_tx.bin
@@ -675,7 +675,7 @@ Licence:
 
 --------------------------------------------------------------------------
 
-Driver: TEHUTI - Tehuti Networks 10G Ethernet
+Driver: tehuti - Tehuti Networks 10G Ethernet
 
 File: tehuti/bdx.bin
 
@@ -691,7 +691,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: TYPHOON - 3cr990 series Typhoon
+Driver: typhoon - 3cr990 series Typhoon
 
 File: 3com/typhoon.bin
 
@@ -733,7 +733,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: YAM - YAM driver for AX.25
+Driver: yam - YAM driver for AX.25
 
 File: yam/1200.bin
 File: yam/9600.bin
@@ -745,7 +745,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: 3C359 - 3Com 3C359 Token Link Velocity XL adapter
+Driver: 3c359 - 3Com 3C359 Token Link Velocity XL adapter
 
 File: 3com/3C359.bin
 
@@ -771,7 +771,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: PCMCIA_PCNET - NE2000 compatible PCMCIA adapter
+Driver: pcnet_cs - NE2000 compatible PCMCIA adapter
 
 File: cis/LA-PCM.cis
 File: cis/PCMLM28.cis
@@ -786,7 +786,7 @@ Originally developed by the pcmcia-cs project
 
 --------------------------------------------------------------------------
 
-Driver: PCMCIA_3C589 - 3Com PCMCIA adapter
+Driver: 3c589_cs - 3Com PCMCIA adapter
 
 File: cis/3CXEM556.cis
 
@@ -796,7 +796,7 @@ Originally developed by the pcmcia-cs project
 
 --------------------------------------------------------------------------
 
-Driver: PCMCIA_3C574 - 3Com PCMCIA adapter
+Driver: 3c574_cs - 3Com PCMCIA adapter
 
 File: cis/3CCFEM556.cis
 
@@ -806,7 +806,7 @@ Originally developed by the pcmcia-cs project
 
 --------------------------------------------------------------------------
 
-Driver: SERIAL_8250_CS - Serial PCMCIA adapter
+Driver: serial_cs - Serial PCMCIA adapter
 
 File: cis/MT5634ZLX.cis
 File: cis/RS-COM-2P.cis
@@ -822,7 +822,7 @@ Originally developed by the pcmcia-cs project
 
 --------------------------------------------------------------------------
 
-Driver: PCMCIA_SMC91C92 - SMC 91Cxx PCMCIA
+Driver: smc91c92_cs - SMC 91Cxx PCMCIA
 
 File: ositech/Xilinx7OD.bin
 
@@ -882,7 +882,7 @@ Licence:
 
 --------------------------------------------------------------------------
 
-Driver: SCSI_QLOGICPTI - PTI Qlogic, ISP Driver
+Driver: qlogicpti - PTI Qlogic, ISP Driver
 
 File: qlogic/isp1000.bin
 
@@ -892,7 +892,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: MYRI_SBUS - MyriCOM Gigabit Ethernet
+Driver: myri_sbus - MyriCOM Gigabit Ethernet
 
 File: myricom/lanai.bin
 
@@ -924,7 +924,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: BNX2 - Broadcom NetXtremeII
+Driver: bnx2 - Broadcom NetXtremeII
 
 File: bnx2/bnx2-mips-06-4.6.16.fw
 File: bnx2/bnx2-mips-06-5.0.0.j3.fw
@@ -949,7 +949,7 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: DVB AV7110 -- AV7110 cards
+Driver: dvb-ttpci -- AV7110 cards
 
 File: av7110/bootcode.bin
 
@@ -959,7 +959,7 @@ ARM assembly source code available at http://www.linuxtv.org/downloads/firmware/
 
 --------------------------------------------------------------------------
 
-Driver: wavefront - ISA WaveFront sound card
+Driver: snd-wavefront - ISA WaveFront sound card
 
 File: yamaha/yss225_registers.bin
 
@@ -1042,7 +1042,7 @@ Licence: Redistributable. See LICENCE.dib0700 for details
 
 --------------------------------------------------------------------------
 
-Driver: DFU Driver for Atheros bluetooth chipset AR3011
+Driver: ath3k - DFU Driver for Atheros bluetooth chipset AR3011
 
 File: ath3k-1.fw
 Info: v1.0
-- 
1.6.6.2



