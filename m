Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbYD0CdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbYD0CdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 22:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYD0Ccv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 22:32:51 -0400
Received: from smtp124.sbc.mail.re3.yahoo.com ([66.196.96.97]:47321 "HELO
	smtp124.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751669AbYD0Ccu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 22:32:50 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Apr 2008 22:32:49 EDT
X-YMail-OSG: ADVF6nAVM1kua3F.fcsIcpfM9fkcpDjWwEle6tbL40kjXoAFrVSvyh5MGeGgOotm2c3RY.eL1nHEU_tdIBctyjJSWK3qcuGPRNR_fIZrsjRRoK3.KHQ97Fd6AlzFoptZE.g-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4813E43E.4070604@smithhikers.net>
Date: Sat, 26 Apr 2008 21:26:06 -0500
From: Arthur Smith <asmith@smithhikers.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080229)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.25 Hauppauge 950 sysfs: duplicate filename...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 I have 2.6.25 and just got a Hauppauge 950. Built the v4l modules and 
loaded them, also followed the instructions in Documentation to get the 
firmware, and put that in /lib/firmware. When the modules load, I get 
two sysfs:duplicate filename warnings and the firmware appears to fail 
to load. Am I missing something? Here's the dmesg output:

Linux video capture interface: v2.00
em28xx v4l2 driver version 0.1.0 loaded
em28xx new video device (2040:6513): interface 0, class 255
em28xx Doesn't have usb audio class
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: em28xx chip ID = 36
em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 13 65 d0 12 5c 03 82 1e 6a 18
em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 01 01 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
em28xx #0: i2c eeprom 70: 33 00 30 00 36 00 30 00 37 00 34 00 37 00 32 00
em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 38 00 30 00 00 00
em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 70 30
em28xx #0: i2c eeprom c0: 3e f0 74 02 01 00 01 79 c8 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 70 30
em28xx #0: i2c eeprom f0: 3e f0 74 02 01 00 01 79 c8 00 00 00 00 00 00 00
EEPROM ID= 0x9567eb1a, hash = 0x4a2b29dd
Vendor/Product ID= 2040:6513
AC97 audio (5 sample rates)
500mA max power
Table at 0x24, strings=0x1e82, 0x186a, 0x0000
tveeprom 0-0050: Hauppauge model 65201, rev A1C0, serial# 4075632
tveeprom 0-0050: tuner model is Xceive XC3028 (idx 120, type 71)
tveeprom 0-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
tveeprom 0-0050: audio processor is None (idx 0)
tveeprom 0-0050: has radio
tuner' 0-0061: chip found @ 0xc2 (em28xx #0)
xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 0-0061: xc2028/3028 firmware name not set!
sysfs: duplicate filename 'i2c-0' can not be created
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one+0x31/0x7a()
Modules linked in: tuner tuner_xc2028 v4l2_common ir_kbd_i2c ath5k(+) mac80211 em28xx(+) videodev cfg80211 compat_ioctl32 ir_common tveeprom
Pid: 1361, comm: modprobe Not tainted 2.6.25n #27
 [<c011c0e7>] warn_on_slowpath+0x40/0x4f
 [<c01f87af>] vsnprintf+0x28a/0x435
 [<c011c88b>] release_console_sem+0x184/0x19d
 [<c01f4d04>] ida_get_new_above+0x148/0x162
 [<c0156e66>] kmem_cache_free+0x60/0x69
 [<c01f4d04>] ida_get_new_above+0x148/0x162
 [<c01f4d04>] ida_get_new_above+0x148/0x162
 [<c0168ae5>] find_inode+0x1b/0x56
 [<c018b4c7>] sysfs_ilookup_test+0x0/0xd
 [<c011cd05>] printk+0x14/0x18
 [<c018b718>] sysfs_add_one+0x31/0x7a
 [<c018bbaf>] create_dir+0x3c/0x6c
 [<c018bc08>] sysfs_create_dir+0x29/0x3b
 [<c01f5464>] kobject_get+0xf/0x13
 [<c01f5568>] kobject_add_internal+0xa8/0x141
 [<c01f5698>] kobject_add_varg+0x39/0x42
 [<c01f58f8>] kobject_add+0x4a/0x4e
 [<c025775d>] device_add+0x62/0x3d0
 [<c01f533a>] kobject_init+0x32/0x53
 [<c025c026>] _request_firmware+0x110/0x276
 [<c025c1f6>] request_firmware+0x7/0x9
 [<f886de42>] generic_set_freq+0x1b9/0x11f6 [tuner_xc2028]
 [<c0117ce0>] finish_task_switch+0x1f/0x69
 [<f886f183>] xc2028_set_analog_freq+0x1a7/0x1af [tuner_xc2028]
 [<f886f183>] xc2028_set_analog_freq+0x1a7/0x1af [tuner_xc2028]
 [<f88cfc41>] fe_set_params+0x40/0x42 [tuner]
 [<f88cf4ef>] set_freq+0x1f2/0x233 [tuner]
 [<f88d0cb0>] tuner_command+0xa86/0xf11 [tuner]
 [<c036b2a2>] klist_next+0x58/0x6d
 [<f88d022a>] tuner_command+0x0/0xf11 [tuner]
 [<c02b5e71>] i2c_cmd+0x0/0x2b
 [<c02b5e98>] i2c_cmd+0x27/0x2b
 [<c0257354>] device_for_each_child+0x1a/0x3c
 [<c02b492c>] i2c_clients_command+0x19/0x1c
 [<f88754a6>] em28xx_card_setup+0x326/0x341 [em28xx]
 [<f88754c1>] em28xx_tuner_callback+0x0/0xc9 [em28xx]
 [<f8873e2c>] em28xx_usb_probe+0x383/0x721 [em28xx]
 [<c0294896>] usb_match_one_id+0x1c/0x71
 [<c0295330>] usb_probe_interface+0x9b/0xcf
 [<c02590b2>] driver_probe_device+0xb6/0x128
 [<c02591b1>] __driver_attach+0x0/0x79
 [<c02591f7>] __driver_attach+0x46/0x79
 [<c0258708>] bus_for_each_dev+0x34/0x56
 [<c0258f4c>] driver_attach+0x11/0x13
 [<c02591b1>] __driver_attach+0x0/0x79
 [<c0258d70>] bus_add_driver+0x8a/0x1a6
 [<c02b5170>] i2c_master_send+0x0/0x41
 [<c025939d>] driver_register+0x45/0x99
 [<c0294f95>] usb_register_driver+0x5d/0xb4
 [<f8832025>] em28xx_module_init+0x25/0x3f [em28xx]
 [<c0137d5a>] sys_init_module+0x80/0x15e
 [<c0103b2a>] sysenter_past_esp+0x5f/0x85
 =======================
---[ end trace 69bd025f109e6a51 ]---
kobject_add_internal failed for i2c-0 with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1361, comm: modprobe Not tainted 2.6.25n #27
 [<c01f55cb>] kobject_add_internal+0x10b/0x141
 [<c01f5698>] kobject_add_varg+0x39/0x42
 [<c01f58f8>] kobject_add+0x4a/0x4e
 [<c025775d>] device_add+0x62/0x3d0
 [<c01f533a>] kobject_init+0x32/0x53
 [<c025c026>] _request_firmware+0x110/0x276
 [<c025c1f6>] request_firmware+0x7/0x9
 [<f886de42>] generic_set_freq+0x1b9/0x11f6 [tuner_xc2028]
 [<c0117ce0>] finish_task_switch+0x1f/0x69
 [<f886f183>] xc2028_set_analog_freq+0x1a7/0x1af [tuner_xc2028]
 [<f886f183>] xc2028_set_analog_freq+0x1a7/0x1af [tuner_xc2028]
 [<f88cfc41>] fe_set_params+0x40/0x42 [tuner]
 [<f88cf4ef>] set_freq+0x1f2/0x233 [tuner]
 [<f88d0cb0>] tuner_command+0xa86/0xf11 [tuner]
 [<c036b2a2>] klist_next+0x58/0x6d
 [<f88d022a>] tuner_command+0x0/0xf11 [tuner]
 [<c02b5e71>] i2c_cmd+0x0/0x2b
 [<c02b5e98>] i2c_cmd+0x27/0x2b
 [<c0257354>] device_for_each_child+0x1a/0x3c
 [<c02b492c>] i2c_clients_command+0x19/0x1c
 [<f88754a6>] em28xx_card_setup+0x326/0x341 [em28xx]
 [<f88754c1>] em28xx_tuner_callback+0x0/0xc9 [em28xx]
 [<f8873e2c>] em28xx_usb_probe+0x383/0x721 [em28xx]
 [<c0294896>] usb_match_one_id+0x1c/0x71
 [<c0295330>] usb_probe_interface+0x9b/0xcf
 [<c02590b2>] driver_probe_device+0xb6/0x128
 [<c02591b1>] __driver_attach+0x0/0x79
 [<c02591f7>] __driver_attach+0x46/0x79
 [<c0258708>] bus_for_each_dev+0x34/0x56
 [<c0258f4c>] driver_attach+0x11/0x13
 [<c02591b1>] __driver_attach+0x0/0x79
 [<c0258d70>] bus_add_driver+0x8a/0x1a6
 [<c02b5170>] i2c_master_send+0x0/0x41
 [<c025939d>] driver_register+0x45/0x99
 [<c0294f95>] usb_register_driver+0x5d/0xb4
 [<f8832025>] em28xx_module_init+0x25/0x3f [em28xx]
 [<c0137d5a>] sys_init_module+0x80/0x15e
 [<c0103b2a>] sysenter_past_esp+0x5f/0x85
 =======================
fw_register_device: device_register failed
xc2028 0-0061: Error -17 while requesting firmware xc3028-v27.fw 
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Hauppauge WinTV HVR 950
usbcore: registered new interface driver em28xx
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Em28xx: Initialized (Em28xx Audio Extension) extension

Thanks,
   Art Smith


