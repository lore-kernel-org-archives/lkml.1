Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbYLULzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbYLULzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 06:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYLULzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 06:55:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36307 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYLULze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 06:55:34 -0500
Subject: [PATCH] firmware: Arrange WHENCE in alphabetical order to avoid
	conflicts
From: Jaswinder Singh <jaswinder@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 21 Dec 2008 17:23:47 +0530
Message-Id: <1229860427.6846.3.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, driver name in alhabetical order

We are facing problems while we prepare patch for firmware as we add new stuff at the end.
As per David Woodhouse suggestion, I am arranging WHENCE to aplhabetical order by driver name to avoid conflicts.
Thanks to my son Gurchet Singh to help me in arranging driver names in alphabetical order.

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 firmware/WHENCE |  314 ++++++++++++++++++++++++++++---------------------------
 1 files changed, 158 insertions(+), 156 deletions(-)

diff --git a/firmware/WHENCE b/firmware/WHENCE
index 57002cd..352bc89 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -5,75 +5,135 @@
 This file attempts to document the origin and licensing information,
 if known, for each piece of firmware distributed for use with the Linux
 kernel.
+Please maintain driver name in alphabetical order to avoid conflicts
+while patching.
 
 --------------------------------------------------------------------------
 
-Driver: korg1212 -- Korg 1212 IO audio device
+Driver: ATARI_DSP56K - Atari DSP56k support
 
-File: korg/k1212.dsp
+File: dsp56k/bootstrap.bin
+Source: dsp56k/bootstrap.asm
 
-Licence: Unknown
+Licence: GPLv2 or later
 
-Found in alsa-firmware package in hex form; no licensing information.
+DSP56001 assembler, possibly buildable with a56 from
+http://www.zdomain.com/a56.html
 
 --------------------------------------------------------------------------
 
-Driver: maestro3 -- ESS Allegro Maestro3 audio device
+Driver: CASSINI - Sun Cassini
 
-File: ess/maestro3_assp_kernel.fw
-File: ess/maestro3_assp_minisrc.fw
+File: sun/cassini.bin
 
 Licence: Unknown
 
-Found in alsa-firmware package in hex form with a comment claiming to
-be GPLv2+, but without source -- and with another comment saying "ESS
-drops binary dsp code images on our heads, but we don't get to see
-specs on the dsp."
+Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: ymfpci -- Yamaha YMF724/740/744/754 audio devices
+Driver: CPiA2 -- cameras based on Vision's CPiA2
 
-File: yamaha/ds1_ctrl.fw
-File: yamaha/ds1_dsp.fw
-File: yamaha/ds1e_ctrl.fw
+File: cpia2/stv0672_vp4.bin
 
-Licence: Unknown
+Licence: Allegedly GPLv2+, but no source visible. Marked:
+	Copyright (C) 2001 STMicroelectronics, Inc.
+	Contact:  steve.miller@st.com
+	Description: This file contains patch data for the CPiA2 (stv0672) VP4.
 
-Found alsa-firmware package in hex form, with the following comment:
-   Copyright (c) 1997-1999 Yamaha Corporation. All Rights Reserved.
+Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: smctr -- SMC ISA/MCA Token Ring adapter
+Driver: DABUSB -- Digital Audio Broadcasting (DAB) Receiver for USB and Linux
 
-File: tr_smctr.bin
-Info: MCT.BIN v6.3C1 03/01/95
+File: dabusb/firmware.fw
+File: dabusb/bitstream.bin
 
-Original licence info:
+Licence: Distributable
 
- * This firmware is licensed to you strictly for use in conjunction
- * with the use of SMC TokenRing adapters. There is no waranty
- * expressed or implied about its fitness for any purpose.
+ * Copyright (C) 1999 BayCom GmbH
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that redistributions of source
+ * code retain the above copyright notice and this comment without
+ * modification.
 
 --------------------------------------------------------------------------
 
-Driver: kaweth -- USB KLSI KL5USB101-based Ethernet device
+Driver: emi26 -- EMI 2|6 USB Audio interface
 
-File: kaweth/new_code.bin
-File: kaweth/new_code_fix.bin
-File: kaweth/trigger_code.bin
-File: kaweth/trigger_code_fix.bin
+File: emi26/bitstream.fw
+Info: VERSION=1.1.1.131 DATE=2001dec06
+
+File: emi26/firmware.fw
+Info: VERSION=1.0.2.916 DATE=12.02.2002
+
+File: emi26/loader.fw
+
+Converted from Intel HEX files, used in our binary representation of ihex.
+
+Original licence information:
+/*
+ * This firmware is for the Emagic EMI 2|6 Audio Interface
+ *
+ * The firmware contained herein is Copyright (c) 1999-2002 Emagic
+ * as an unpublished work. This notice does not imply unrestricted
+ * or public access to this firmware which is a trade secret of Emagic,
+ * and which may not be reproduced, used, sold or transferred to
+ * any third party without Emagic's written consent. All Rights Reserved.
+ *
+ * Permission is hereby granted for the distribution of this firmware
+ * image as part of a Linux or other Open Source operating system kernel
+ * in text or binary form as required.
+ *
+ * This firmware may not be modified and may only be used with the
+ * Emagic EMI 2|6 Audio Interface. Distribution and/or Modification of
+ * any driver which includes this firmware, in whole or in part,
+ * requires the inclusion of this statement.
+ */
+
+--------------------------------------------------------------------------
+
+Driver: emi62 -- EMI 6|2m USB Audio interface
+
+File: emi62/bitstream.fw
+Info: VERSION=1.0.0.191 DATE= 2002oct28
+
+File: emi62/loader.fw
+Source: EMILOAD.HEX
+Info: VERSION=1.0.2.002 DATE=10.01.2002
+
+File: emi62/midi.fw
+Source: EMI62MFW.HEX
+Info: VERSION=1.04.062 DATE=16.10.2002
+
+File: emi62/spdif.fw
+Source: EMI62SFW.HEX
+Info: VERSION=1.04.062 DATE=16.10.2002
+
+Converted from Intel HEX files, used in our binary representation of ihex.
+
+Original licence information: None
+
+--------------------------------------------------------------------------
+
+Driver: ip2 -- Computone IntelliPort Plus serial device
+
+File: intelliport2.bin
 
 Licence: Unknown
 
-Found in hex form in the kernel source.
+Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: ttusb-budget -- Technotrend/Hauppauge Nova-USB devices
+Driver: kaweth -- USB KLSI KL5USB101-based Ethernet device
 
-File: ttusb-budget/dspbootcode.bin
+File: kaweth/new_code.bin
+File: kaweth/new_code_fix.bin
+File: kaweth/trigger_code.bin
+File: kaweth/trigger_code_fix.bin
 
 Licence: Unknown
 
@@ -134,145 +194,83 @@ Compiled from original 8051 source into Intel HEX, used in our binary ihex form.
 
 --------------------------------------------------------------------------
 
-Driver: emi26 -- EMI 2|6 USB Audio interface
-
-File: emi26/bitstream.fw
-Info: VERSION=1.1.1.131 DATE=2001dec06
-
-File: emi26/firmware.fw
-Info: VERSION=1.0.2.916 DATE=12.02.2002
-
-File: emi26/loader.fw
-
-Converted from Intel HEX files, used in our binary representation of ihex.
-
-Original licence information:
-/*
- * This firmware is for the Emagic EMI 2|6 Audio Interface
- *
- * The firmware contained herein is Copyright (c) 1999-2002 Emagic
- * as an unpublished work. This notice does not imply unrestricted
- * or public access to this firmware which is a trade secret of Emagic,
- * and which may not be reproduced, used, sold or transferred to
- * any third party without Emagic's written consent. All Rights Reserved.
- *
- * Permission is hereby granted for the distribution of this firmware
- * image as part of a Linux or other Open Source operating system kernel
- * in text or binary form as required.
- *
- * This firmware may not be modified and may only be used with the
- * Emagic EMI 2|6 Audio Interface. Distribution and/or Modification of
- * any driver which includes this firmware, in whole or in part,
- * requires the inclusion of this statement.
- */
-
---------------------------------------------------------------------------
-
-Driver: emi62 -- EMI 6|2m USB Audio interface
-
-File: emi62/bitstream.fw
-Info: VERSION=1.0.0.191 DATE= 2002oct28
-
-File: emi62/loader.fw
-Source: EMILOAD.HEX
-Info: VERSION=1.0.2.002 DATE=10.01.2002
-
-File: emi62/midi.fw
-Source: EMI62MFW.HEX
-Info: VERSION=1.04.062 DATE=16.10.2002
+Driver: korg1212 -- Korg 1212 IO audio device
 
-File: emi62/spdif.fw
-Source: EMI62SFW.HEX
-Info: VERSION=1.04.062 DATE=16.10.2002
+File: korg/k1212.dsp
 
-Converted from Intel HEX files, used in our binary representation of ihex.
+Licence: Unknown
 
-Original licence information: None
+Found in alsa-firmware package in hex form; no licensing information.
 
 --------------------------------------------------------------------------
 
-Driver: tu_usb_3410_5052 -- USB TI 3410/5052 serial device
-
-File: ti_3410.fw
-Info: firmware 9/10/04 FW3410_Special_StartWdogOnStartPort
+Driver: maestro3 -- ESS Allegro Maestro3 audio device
 
-File: ti_5052.fw
-Info: firmware 9/18/04
+File: ess/maestro3_assp_kernel.fw
+File: ess/maestro3_assp_minisrc.fw
 
-Licence: Allegedly GPLv2+, but no source visible. Marked:
-	 Copyright (C) 2004 Texas Instruments
+Licence: Unknown
 
-Found in hex form in kernel source.
+Found in alsa-firmware package in hex form with a comment claiming to
+be GPLv2+, but without source -- and with another comment saying "ESS
+drops binary dsp code images on our heads, but we don't get to see
+specs on the dsp."
 
 --------------------------------------------------------------------------
 
-Driver: whiteheat -- USB ConnectTech WhiteHEAT serial device
-
-File: whiteheat.fw
-Version: 4.06
-
-File: whiteheat_loader.fw
-File: whiteheat_loader_debug.fw
+Driver: smctr -- SMC ISA/MCA Token Ring adapter
 
-Licence: Allegedly GPLv2, but no source visible. Marked:
-	 Copyright (C) 2000-2002  ConnectTech Inc
+File: tr_smctr.bin
+Info: MCT.BIN v6.3C1 03/01/95
 
-Debug loader claims the following behaviour:
-	Port 1 LED flashes when the vend_ax program is running
-	Port 2 LED flashes when any SETUP command arrives
-	Port 3 LED flashes when any valid VENDOR request occurs
-	Port 4 LED flashes when the EXTERNAL RAM DOWNLOAD request occurs
+Original licence info:
 
-Converted from Intel HEX files, used in our binary representation of ihex.
+ * This firmware is licensed to you strictly for use in conjunction
+ * with the use of SMC TokenRing adapters. There is no waranty
+ * expressed or implied about its fitness for any purpose.
 
 --------------------------------------------------------------------------
 
-Driver: ip2 -- Computone IntelliPort Plus serial device
+Driver: SND_SB16_CSP - Sound Blaster 16/AWE CSP support
 
-File: intelliport2.bin
+File: sb16/mulaw_main.csp
+File: sb16/alaw_main.csp
+File: sb16/ima_adpcm_init.csp
+File: sb16/ima_adpcm_playback.csp
+File: sb16/ima_adpcm_capture.csp
 
-Licence: Unknown
+Licence: Allegedly GPLv2+, but no source visible. Marked:
+/*
+ *  Copyright (c) 1994 Creative Technology Ltd.
+ *  Microcode files for SB16 Advanced Signal Processor
+ */
 
 Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: CPiA2 -- cameras based on Vision's CPiA2
+Driver: tu_usb_3410_5052 -- USB TI 3410/5052 serial device
 
-File: cpia2/stv0672_vp4.bin
+File: ti_3410.fw
+Info: firmware 9/10/04 FW3410_Special_StartWdogOnStartPort
+
+File: ti_5052.fw
+Info: firmware 9/18/04
 
 Licence: Allegedly GPLv2+, but no source visible. Marked:
-	Copyright (C) 2001 STMicroelectronics, Inc.
-	Contact:  steve.miller@st.com
-	Description: This file contains patch data for the CPiA2 (stv0672) VP4.
+	 Copyright (C) 2004 Texas Instruments
 
 Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: DABUSB -- Digital Audio Broadcasting (DAB) Receiver for USB and Linux
-
-File: dabusb/firmware.fw
-File: dabusb/bitstream.bin
-
-Licence: Distributable
-
- * Copyright (C) 1999 BayCom GmbH
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that redistributions of source
- * code retain the above copyright notice and this comment without
- * modification.
-
---------------------------------------------------------------------------
-
-Driver: USB_VICAM -- USB 3com HomeConnect (aka vicam)
+Driver: ttusb-budget -- Technotrend/Hauppauge Nova-USB devices
 
-File: vicam/firmware.fw
+File: ttusb-budget/dspbootcode.bin
 
 Licence: Unknown
 
-Found in hex form in kernel source.
+Found in hex form in the kernel source.
 
 --------------------------------------------------------------------------
 
@@ -310,42 +308,46 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: ATARI_DSP56K - Atari DSP56k support
+Driver: USB_VICAM -- USB 3com HomeConnect (aka vicam)
 
-File: dsp56k/bootstrap.bin
-Source: dsp56k/bootstrap.asm
+File: vicam/firmware.fw
 
-Licence: GPLv2 or later
+Licence: Unknown
 
-DSP56001 assembler, possibly buildable with a56 from 
-http://www.zdomain.com/a56.html
+Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-Driver: SND_SB16_CSP - Sound Blaster 16/AWE CSP support
+Driver: whiteheat -- USB ConnectTech WhiteHEAT serial device
 
-File: sb16/mulaw_main.csp
-File: sb16/alaw_main.csp
-File: sb16/ima_adpcm_init.csp
-File: sb16/ima_adpcm_playback.csp
-File: sb16/ima_adpcm_capture.csp
+File: whiteheat.fw
+Version: 4.06
 
-Licence: Allegedly GPLv2+, but no source visible. Marked:
-/*
- *  Copyright (c) 1994 Creative Technology Ltd.
- *  Microcode files for SB16 Advanced Signal Processor
- */
+File: whiteheat_loader.fw
+File: whiteheat_loader_debug.fw
 
-Found in hex form in kernel source.
+Licence: Allegedly GPLv2, but no source visible. Marked:
+	 Copyright (C) 2000-2002  ConnectTech Inc
+
+Debug loader claims the following behaviour:
+	Port 1 LED flashes when the vend_ax program is running
+	Port 2 LED flashes when any SETUP command arrives
+	Port 3 LED flashes when any valid VENDOR request occurs
+	Port 4 LED flashes when the EXTERNAL RAM DOWNLOAD request occurs
+
+Converted from Intel HEX files, used in our binary representation of ihex.
 
 --------------------------------------------------------------------------
 
-Driver: CASSINI - Sun Cassini
+Driver: ymfpci -- Yamaha YMF724/740/744/754 audio devices
 
-File: sun/cassini.bin
+File: yamaha/ds1_ctrl.fw
+File: yamaha/ds1_dsp.fw
+File: yamaha/ds1e_ctrl.fw
 
 Licence: Unknown
 
-Found in hex form in kernel source.
+Found alsa-firmware package in hex form, with the following comment:
+   Copyright (c) 1997-1999 Yamaha Corporation. All Rights Reserved.
 
 --------------------------------------------------------------------------
-- 
1.5.5.1



