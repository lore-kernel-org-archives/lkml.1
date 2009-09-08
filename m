Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbZIHWT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbZIHWT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZIHWT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:19:28 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:41902 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZIHWT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:19:27 -0400
Message-ID: <4AA6D858.6040505@t-online.de>
Date: Wed, 09 Sep 2009 00:19:04 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@osdl.org>
CC: airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Regression DRM/i915/KMS: VGA connector unusable after 2.6.31-rc8-git1,
 DVI connector ok
Content-Type: multipart/mixed;
 boundary="------------000006000600040008060309"
X-ID: rfOSX0ZTZhsYA71g92CNfddrjz1hZJqCT7QRBLsDv4mTrNyoWHKpU2NOjp6NG5kwsi
X-TOI-MSGID: f29f00ae-b4e2-4caf-ba66-247196e89fb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000006000600040008060309
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi everybody!

During the release cycle of the 2.6.31-rc* kernels KMS started to work
on my computer.

Booting with a monitor attached to both the VAG and the DVI connectors,
kernel 2.6.31-rc8-git1
detects both monitors correctly and sets the native video mode.

Booting the same configuration with kernel 2.6.31-rc8-git2 ... -rc9-git1
gives a different result:
the DVI-attached monitor is still working perfectly, the VGA-attached
monitor does not detect a
valid video signal and switches off.

Hardware: AOpen i915GMm-hfs,  Pentium-M 1.86 MHz,  2GB RAM
The Aopen i915GMm-hfs is a  desktop board with a mobile Chipset:

00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML
Express Processor to DRAM Controller (rev 04)
00:02.0 VGA compatible controller: Intel Corporation Mobile
915GM/GMS/910GML Express Graphics Controller (rev 04)
00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML
Express Graphics Controller (rev 04)

Config: AGP/DRM/I915 all compiled into kernel, KMS enabled.

Log_Broken contains the result of "cat boot.msg | grep -i drm" of a boot
with 2.6.31-rc8-git2,
Log_OK contains the result of "cat boot.msg | grep -i drm" of a boot
with 2.6.31-rc8-git1

As a black monitor is not a nice gift I think this should be fixed
before the final release of 2.6.31.

cu,
 Knut

--------------000006000600040008060309
Content-Type: text/plain;
 name="LOG_BROKEN"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="LOG_BROKEN"

<5> Kernel command line: root=/dev/sdb6 showopts acpi_enforce_resources=lax drm.debug=15
<6> [drm] Initialized drm 1.1.0 20060810
<7> [drm:drm_init], 
<7> [drm:drm_get_dev], 
<7> [drm:drm_get_minor], 
<7> [drm:drm_get_minor], new minor assigned 64
<7> [drm:drm_get_minor], 
<7> [drm:drm_get_minor], new minor assigned 0
<7> [drm:drm_agp_bind_pages], 
<7> [drm:parse_general_definitions], crt_ddc_bus_pin: 2
<7> [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0x0
<7> [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 70 is found on SDVOB port
<7> [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 72 is found on SDVOC port
<7> [drm:drm_irq_install], irq=16
<7> [drm:intel_modeset_init], 2 display pipes available.
<7> [drm:drm_sysfs_connector_add], adding "VGA-1" to sysfs
<7> [drm:drm_sysfs_hotplug_event], generating hotplug event
<7> [drm:drm_sysfs_connector_add], adding "DVI-D-1" to sysfs
<7> [drm:drm_sysfs_hotplug_event], generating hotplug event
<7> [drm:drm_sysfs_connector_add], adding "SVIDEO-1" to sysfs
<7> [drm:drm_sysfs_hotplug_event], generating hotplug event
<7> [drm:drm_sysfs_connector_add], adding "SVIDEO-2" to sysfs
<7> [drm:drm_sysfs_hotplug_event], generating hotplug event
<7> [drm:drm_helper_probe_single_connector_modes], VGA-1
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 39:"0x0" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
<7> [drm_mode:drm_mode_prune_invalid], Not using 0x0 mode 16
<7> [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 28:"1280x1024" 75024 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 35:"1152x864" 75000 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 29:"1024x768" 75075 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 30:"1024x768" 70068 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 31:"1024x768" 60003 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 32:"832x624" 74550 57284 832 864 928 1152 624 625 628 667 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 34:"800x600" 72186 50000 800 856 976 1040 600 637 643 666 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 33:"800x600" 75000 49500 800 816 896 1056 600 601 604 625 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60315 40000 800 840 968 1056 600 601 605 628 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 22:"800x600" 56249 36000 800 824 896 1024 600 601 603 625 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 24:"640x480" 72807 31500 640 664 704 832 480 489 491 520 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 23:"640x480" 75000 31500 640 656 720 840 480 481 484 500 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 25:"640x480" 66666 30240 640 704 768 864 480 483 486 525 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 26:"640x480" 60000 25200 640 656 752 800 480 490 492 525 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 27:"720x400" 70080 28320 720 738 846 900 400 412 414 449 0x40 0x6
<7> [drm:drm_helper_probe_single_connector_modes], DVI-D-1
<7> [drm:intel_sdvo_detect], SDVO response 1 0
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 42:"0x0" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
<7> [drm_mode:drm_mode_prune_invalid], Not using 0x0 mode 16
<7> [drm:drm_helper_probe_single_connector_modes], Probed modes for DVI-D-1
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 43:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 60003 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 37:"800x600" 60315 40000 800 840 968 1056 600 601 605 628 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60000 25200 640 656 752 800 480 490 492 525 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70080 28320 720 738 846 900 400 412 414 449 0x40 0x6
<7> [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
<7> [drm:intel_sdvo_detect], SDVO response 0 0
<7> [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
<7> [drm:drm_helper_probe_single_connector_modes], SVIDEO-2
<7> [drm:drm_helper_probe_single_connector_modes], SVIDEO-2 is disconnected
<7> [drm:drm_setup_crtcs], 
<7> [drm:drm_enable_connectors], connector 5 enabled? yes
<7> [drm:drm_enable_connectors], connector 7 enabled? yes
<7> [drm:drm_enable_connectors], connector 9 enabled? no
<7> [drm:drm_enable_connectors], connector 11 enabled? no
<7> [drm:drm_target_preferred], looking for preferred mode on connector 5
<7> [drm:drm_target_preferred], found mode 1280x1024
<7> [drm:drm_target_preferred], looking for preferred mode on connector 7
<7> [drm:drm_target_preferred], found mode 1280x1024
<7> [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
<7> [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
<7> [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 4
<7> [drm:intelfb_probe], 
<7> [drm:intelfb_single_fb_probe], 
<7> [drm:intelfb_single_fb_probe], creating new fb (console size 1280x1024, buffer size 1280x1024)
<7> [drm:drm_agp_bind_pages], 
<7> [drm:intelfb_create], allocated 1280x1024 fb: 0x007df000, bo f738cec0
<7> [drm:intelfb_set_par], 1280 -1
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f737e000 3 fb: f737ab00 connectors: f737e448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
<7> [drm:drm_crtc_helper_set_config], modes are different, full mode set
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 44:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<7> [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 44:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7> [drm:intel_calculate_wm], FIFO watermark level: 29
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 29
<7> [drm:i9xx_update_wm], self-refresh entries: 43
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 29, C: 2, SR 52
<7> [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
<7> [drm:intel_crtc_mode_set], Mode for pipe A:
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 44:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm:intel_pipe_set_base], Writing base 007DF000 00000000 0 0
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7> [drm:intel_calculate_wm], FIFO watermark level: 29
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 29
<7> [drm:i9xx_update_wm], self-refresh entries: 43
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 29, C: 2, SR 52
<6> [drm] DAC-6: set mode 1280x1024 2c
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7> [drm:intel_calculate_wm], FIFO watermark level: 29
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 29
<7> [drm:i9xx_update_wm], self-refresh entries: 43
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 29, C: 2, SR 52
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f7385000 4 fb: f737ab00 connectors: f7385448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
<7> [drm:drm_crtc_helper_set_config], modes are different, full mode set
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 45:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<7> [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 45:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<3> [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_update_watermarks], plane B (pipe 1) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 9
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 9
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 9, C: 2, SR 1
<7> [drm:drm_vblank_get], enabling vblank on crtc 1, ret: -22
<7> [drm:intel_crtc_mode_set], Mode for pipe B:
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 45:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm:intel_pipe_set_base], Writing base 007DF000 00000000 0 0
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_update_watermarks], plane B (pipe 1) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 9
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 9
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 9, C: 2, SR 1
<6> [drm] TMDS-8: set mode 1280x1024 2d
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_update_watermarks], plane B (pipe 1) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 9
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 9
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 9, C: 2, SR 1
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f737e000 3 fb: f737ab00 connectors: f737e448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f7385000 4 fb: f737ab00 connectors: f7385448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f737e000 3 fb: f737ab00 connectors: f737e448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f7385000 4 fb: f737ab00 connectors: f7385448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<6> [drm] fb0: inteldrmfb frame buffer device
<7> [drm:intelfb_single_fb_probe], registered panic notifier
<7> [drm:intel_opregion_init], graphic opregion physical addr: 0x0
<7> [drm:intel_opregion_init], ACPI OpRegion not supported!
<6> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
<7> [drm:i915_error_work_func], generating error event

--------------000006000600040008060309
Content-Type: text/plain;
 name="LOG_OK"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="LOG_OK"

<5> Kernel command line: root=/dev/sdb6 showopts acpi_enforce_resources=lax drm.debug=15
<6> [drm] Initialized drm 1.1.0 20060810
<7> [drm:drm_init], 
<7> [drm:drm_get_dev], 
<7> [drm:drm_get_minor], 
<7> [drm:drm_get_minor], new minor assigned 64
<7> [drm:drm_get_minor], 
<7> [drm:drm_get_minor], new minor assigned 0
<7> [drm:drm_agp_bind_pages], 
<7> [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0x0
<7> [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 70 is found on SDVOB port
<7> [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 72 is found on SDVOC port
<7> [drm:drm_irq_install], irq=16
<7> [drm:intel_modeset_init], 2 display pipes available.
<7> [drm:drm_sysfs_connector_add], adding "VGA-1" to sysfs
<7> [drm:drm_sysfs_hotplug_event], generating hotplug event
<7> [drm:drm_sysfs_connector_add], adding "DVI-D-1" to sysfs
<7> [drm:drm_sysfs_hotplug_event], generating hotplug event
<7> [drm:drm_sysfs_connector_add], adding "SVIDEO-1" to sysfs
<7> [drm:drm_sysfs_hotplug_event], generating hotplug event
<7> [drm:drm_sysfs_connector_add], adding "SVIDEO-2" to sysfs
<7> [drm:drm_sysfs_hotplug_event], generating hotplug event
<7> [drm:drm_helper_probe_single_connector_modes], VGA-1
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 39:"0x0" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
<7> [drm_mode:drm_mode_prune_invalid], Not using 0x0 mode 16
<7> [drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 40:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 28:"1280x1024" 75024 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 35:"1152x864" 75000 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 29:"1024x768" 75075 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 30:"1024x768" 70068 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 31:"1024x768" 60003 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 32:"832x624" 74550 57284 832 864 928 1152 624 625 628 667 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 34:"800x600" 72186 50000 800 856 976 1040 600 637 643 666 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 33:"800x600" 75000 49500 800 816 896 1056 600 601 604 625 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60315 40000 800 840 968 1056 600 601 605 628 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 22:"800x600" 56249 36000 800 824 896 1024 600 601 603 625 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 24:"640x480" 72807 31500 640 664 704 832 480 489 491 520 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 23:"640x480" 75000 31500 640 656 720 840 480 481 484 500 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 25:"640x480" 66666 30240 640 704 768 864 480 483 486 525 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 26:"640x480" 60000 25200 640 656 752 800 480 490 492 525 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 27:"720x400" 70080 28320 720 738 846 900 400 412 414 449 0x40 0x6
<7> [drm:drm_helper_probe_single_connector_modes], DVI-D-1
<7> [drm:intel_sdvo_detect], SDVO response 1 0
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 42:"0x0" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
<7> [drm_mode:drm_mode_prune_invalid], Not using 0x0 mode 16
<7> [drm:drm_helper_probe_single_connector_modes], Probed modes for DVI-D-1
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 43:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 41:"1024x768" 60003 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 37:"800x600" 60315 40000 800 840 968 1056 600 601 605 628 0x40 0x5
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60000 25200 640 656 752 800 480 490 492 525 0x40 0xa
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 39:"720x400" 70080 28320 720 738 846 900 400 412 414 449 0x40 0x6
<7> [drm:drm_helper_probe_single_connector_modes], SVIDEO-1
<7> [drm:intel_sdvo_detect], SDVO response 0 0
<7> [drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
<7> [drm:drm_helper_probe_single_connector_modes], SVIDEO-2
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 107520
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7> [drm:intel_calculate_wm], FIFO watermark level: 29
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 29
<7> [drm:i9xx_update_wm], self-refresh entries: 43
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 29, C: 2, SR 52
<7> [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
<7> [drm:intel_crtc_mode_set], Mode for pipe A:
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
<7> [drm:intel_pipe_set_base], No FB bound
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 107520
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7> [drm:intel_calculate_wm], FIFO watermark level: 29
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 29
<7> [drm:i9xx_update_wm], self-refresh entries: 43
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 29, C: 2, SR 52
<6> [drm] TV-12: set mode NTSC 480i 0
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 107520
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7> [drm:intel_calculate_wm], FIFO watermark level: 29
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 29
<7> [drm:i9xx_update_wm], self-refresh entries: 43
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 29, C: 2, SR 52
<7> [drm:intel_tv_detect_type], No TV connection detected
<7> [drm:drm_helper_probe_single_connector_modes], SVIDEO-2 is disconnected
<7> [drm:drm_setup_crtcs], 
<7> [drm:drm_enable_connectors], connector 5 enabled? yes
<7> [drm:drm_enable_connectors], connector 7 enabled? yes
<7> [drm:drm_enable_connectors], connector 9 enabled? no
<7> [drm:drm_enable_connectors], connector 11 enabled? no
<7> [drm:drm_target_preferred], looking for preferred mode on connector 5
<7> [drm:drm_target_preferred], found mode 1280x1024
<7> [drm:drm_target_preferred], looking for preferred mode on connector 7
<7> [drm:drm_target_preferred], found mode 1280x1024
<7> [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
<7> [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
<7> [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 4
<7> [drm:intelfb_probe], 
<7> [drm:intelfb_single_fb_probe], 
<7> [drm:intelfb_single_fb_probe], creating new fb (console size 1280x1024, buffer size 1280x1024)
<7> [drm:drm_agp_bind_pages], 
<7> [drm:intelfb_create], allocated 1280x1024 fb: 0x007df000, bo f738cec0
<7> [drm:intelfb_set_par], 1280 -1
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f737e000 3 fb: f737ab00 connectors: f737e448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
<7> [drm:drm_crtc_helper_set_config], modes are different, full mode set
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 44:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<7> [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 44:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7> [drm:intel_calculate_wm], FIFO watermark level: 29
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 29
<7> [drm:i9xx_update_wm], self-refresh entries: 43
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 29, C: 2, SR 52
<7> [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
<7> [drm:intel_crtc_mode_set], Mode for pipe A:
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 44:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm:intel_pipe_set_base], Writing base 007DF000 00000000 0 0
<3> [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7> [drm:intel_calculate_wm], FIFO watermark level: 29
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 29
<7> [drm:i9xx_update_wm], self-refresh entries: 43
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 29, C: 2, SR 52
<6> [drm] DAC-6: set mode 1280x1024 2c
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 0
<7> [drm:intel_calculate_wm], FIFO watermark level: 29
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 29
<7> [drm:i9xx_update_wm], self-refresh entries: 43
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 29, C: 2, SR 52
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f7385000 4 fb: f737ab00 connectors: f7385448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
<7> [drm:drm_crtc_helper_set_config], modes are different, full mode set
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 45:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<7> [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 45:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_update_watermarks], plane B (pipe 1) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 9
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 9
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 9, C: 2, SR 1
<7> [drm:drm_vblank_get], enabling vblank on crtc 1, ret: -22
<7> [drm:intel_crtc_mode_set], Mode for pipe B:
<7> [drm_mode:drm_mode_debug_printmodeline], Modeline 45:"1280x1024" 60019 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
<7> [drm:intel_pipe_set_base], Writing base 007DF000 00000000 0 0
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_update_watermarks], plane B (pipe 1) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 9
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 9
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 9, C: 2, SR 1
<6> [drm] TMDS-8: set mode 1280x1024 2d
<7> [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
<7> [drm:intel_update_watermarks], plane B (pipe 1) clock: 108000
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7> [drm:intel_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 6
<7> [drm:intel_calculate_wm], FIFO entries required for mode: 20
<7> [drm:intel_calculate_wm], FIFO watermark level: 9
<7> [drm:i9xx_update_wm], FIFO watermarks - A: 6, B: 9
<7> [drm:i9xx_update_wm], Setting FIFO watermarks - A: 6, B: 9, C: 2, SR 1
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f737e000 3 fb: f737ab00 connectors: f737e448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f7385000 4 fb: f737ab00 connectors: f7385448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f737e000 3 fb: f737ab00 connectors: f737e448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<7> [drm:drm_crtc_helper_set_config], 
<7> [drm:drm_crtc_helper_set_config], crtc: f7385000 4 fb: f737ab00 connectors: f7385448 num_connectors: 1 (x, y) (0, 0)
<7> [drm:drm_crtc_helper_set_config], setting connector 5 crtc to f737e000
<7> [drm:drm_crtc_helper_set_config], setting connector 7 crtc to f7385000
<6> [drm] fb0: inteldrmfb frame buffer device
<7> [drm:intelfb_single_fb_probe], registered panic notifier
<7> [drm:intel_opregion_init], graphic opregion physical addr: 0x0
<7> [drm:intel_opregion_init], ACPI OpRegion not supported!
<6> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
<7> [drm:i915_error_work_func], generating error event

--------------000006000600040008060309--
