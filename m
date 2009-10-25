Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZJYNH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZJYNH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 09:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZJYNH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 09:07:29 -0400
Received: from smtp.witbe.net ([81.88.96.48]:58699 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbZJYNH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 09:07:27 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Oct 2009 09:07:27 EDT
Date: Sun, 25 Oct 2009 14:02:08 +0100
From: Paul Rolland <rol@as2917.net>
To: linux-kernel@vger.kernel.org
Cc: rol@as2917.net
Subject: Intel Video : screen is "flickering"
Message-ID: <20091025140208.35ed1476@tux.DEF.witbe.net>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm running a 2.6.32-rc5 kernel, and I'm facing a flickering screen with
X (running KDE 4.3 and compiz)...
It's not always, but I can't find why it starts and why it stops.
Some logs/traces/informations are below.

Is this a known issue ? Is there anything I can test to debug or to fix
this problem ?

Xorg log reports :

(II) Loading /usr/lib64/xorg/modules/drivers//intel_drv.so
(II) Module intel: vendor="X.Org Foundation"
        compiled for 1.6.1.901, module version = 2.7.0
        Module class: X.Org Video Driver
        ABI class: X.Org Video Driver, version 5.0
(II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
        i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
        E7221 (i915), 915GM, 945G, 945GM, 945GME, IGD_GM, IGD_G, 965G, G35,
        965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33,
        Mobile Intel® GM45 Express Chipset,
        Intel Integrated Graphics Device, G45/G43, Q45/Q43, G41
(II) Primary Device is: PCI 00@00:02:0
(II) resource ranges after xf86ClaimFixedResources() call:
        [0] -1  0       0xffffffff - 0xffffffff (0x1) MX[B]
        [1] -1  0       0x000f0000 - 0x000fffff (0x10000) MX[B]
        [2] -1  0       0x000c0000 - 0x000effff (0x30000) MX[B]
        [3] -1  0       0x00000000 - 0x0009ffff (0xa0000) MX[B]
        [4] -1  0       0x0000ffff - 0x0000ffff (0x1) IX[B]
        [5] -1  0       0x00000000 - 0x00000000 (0x1) IX[B]
(II) resource ranges after probing:
        [0] -1  0       0xffffffff - 0xffffffff (0x1) MX[B]
        [1] -1  0       0x000f0000 - 0x000fffff (0x10000) MX[B]
        [2] -1  0       0x000c0000 - 0x000effff (0x30000) MX[B]
        [3] -1  0       0x00000000 - 0x0009ffff (0xa0000) MX[B]
        [4] 0   0       0x000a0000 - 0x000affff (0x10000) MS[B]
        [5] 0   0       0x000b0000 - 0x000b7fff (0x8000) MS[B]
        [6] 0   0       0x000b8000 - 0x000bffff (0x8000) MS[B]
        [7] -1  0       0x0000ffff - 0x0000ffff (0x1) IX[B]
        [8] -1  0       0x00000000 - 0x00000000 (0x1) IX[B]
        [9] 0   0       0x000003b0 - 0x000003bb (0xc) IS[B]
        [10] 0  0       0x000003c0 - 0x000003df (0x20) IS[B]
(**) intel(0): Depth 24, (--) framebuffer bpp 32
(==) intel(0): RGB weight 888
(==) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) Mobile Intel® GM45 Express Chipset
(--) intel(0): Chipset: "Mobile Intel® GM45 Express Chipset"
(II) intel(0): Resizable framebuffer: available (0 4)

keyword "intel" in /var/log/Xorg.0.log gives :
(II) intel(0): Manufacturer: AUO  Model: 2177  Serial#: 0
(II) intel(0): Year: 2008  Week: 1
(II) intel(0): EDID Version: 1.3
(II) intel(0): Digital Display Input
(II) intel(0): Max Image Size [cm]: horiz.: 33  vert.: 21
(II) intel(0): Gamma: 2.20
(II) intel(0): No DPMS capabilities specified
(II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) intel(0): First detailed timing is preferred mode
(II) intel(0): redX: 0.590 redY: 0.345   greenX: 0.315 greenY: 0.555
(II) intel(0): blueX: 0.155 blueY: 0.155   whiteX: 0.313 whiteY: 0.329
(II) intel(0): Manufacturer's mask: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 108.0 MHz   Image Size:  331 x 207 mm
(II) intel(0): h_active: 1440  h_sync: 1504  h_sync_end 1536 h_blank_end 1970 h_border: 0
(II) intel(0): v_active: 900  v_sync: 903  v_sync_end 906 v_blanking: 912 v_border: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 108.0 MHz   Image Size:  331 x 207 mm
(II) intel(0): h_active: 1440  h_sync: 1504  h_sync_end 1536 h_blank_end 1970 h_border: 0
(II) intel(0): v_active: 900  v_sync: 903  v_sync_end 906 v_blanking: 912 v_border: 0
(II) intel(0):  NY850�B154PW2
(WW) intel(0): Unknown vendor-specific block 0
(II) intel(0): EDID (in hex):
(II) intel(0):  00ffffffffffff0006af772100000000
(II) intel(0):  01120103902115780a1cf59758508e27
(II) intel(0):  27505400000001010101010101010101
(II) intel(0):  010101010101302aa01252840c304020
(II) intel(0):  33004bcf1000001a302aa01252840c30
(II) intel(0):  402033004bcf1000001a000000fe004e
(II) intel(0):  59383530804231353450573200000000
(II) intel(0):  00000000000000000002010a202000cc
(II) intel(0): EDID vendor "AUO", prod id 8567
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1440x900"x0.0  108.00  1440 1504 1536 1970  900 903 906 912 +hsync -vsync (54.8 kHz)
(II) intel(0): Modeline "1440x900"x0.0  108.00  1440 1504 1536 1970  900 903 906 912 +hsync -vsync (54.8 kHz)
(II) intel(0): Printing probed modes for output LVDS1
(II) intel(0): Modeline "1440x900"x60.1  108.00  1440 1504 1536 1970  900 903 906 912 +hsync -vsync (54.8 kHz)
(II) intel(0): EDID for output DP1

glx keyword in /var/log/Xorg.0.log gives :
(II) LoadModule: "glx"
(II) Loading /usr/lib64/xorg/modules/extensions//libglx.so
(II) Module glx: vendor="X.Org Foundation"
(==) AIGLX enabled
(II) Loading extension GLX
(II) AIGLX: enabled GLX_MESA_copy_sub_buffer
(II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
(II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
(II) AIGLX: Loaded and initialized /usr/lib64/dri/i965_dri.so
(II) GLX: Initialized DRI2 GL provider for screen 0

lspci -n says :
00:02.0 0300: 8086:2a42 (rev 07)
00:02.1 0380: 8086:2a43 (rev 07)

lspci reports :
00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)

lspci -vvv reports :

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA controller])
        Subsystem: Dell Device 02bc
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 30
        Region 0: Memory at f6800000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 1800 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0200c  Data: 4199
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
        Subsystem: Dell Device 02bc
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at f6100000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Paul
