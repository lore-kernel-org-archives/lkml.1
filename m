Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbYHSVgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbYHSVgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbYHSVgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:36:25 -0400
Received: from lucidpixels.com ([75.144.35.66]:51110 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757609AbYHSVgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:36:24 -0400
Date: Tue, 19 Aug 2008 17:36:22 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: ivtv-users@ivtvdriver.org
Subject: Hauppauge 1192 WinTV-HVR-1950: Kernel Oops :(
Message-ID: <alpine.DEB.1.10.0808191631030.8579@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26.2:

[   15.745116] usbcore: registered new interface driver pvrusb2
[   15.745116] pvrusb2: Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner : V4L in-tree version
[   15.746180] pvrusb2: Debug mask is 31 (0x1f)
[   15.849246] usb 1-4: reset high speed USB device using ehci_hcd and address 4
[   16.022828] tveeprom 0-00a2: Hauppauge model 75111, rev C3E9, serial# 3474275
[   16.022877] tveeprom 0-00a2: MAC address is 00-0D-FE-35-03-63
[   16.022921] tveeprom 0-00a2: tuner model is Philips 18271_8295 (idx 149, type 54)
[   16.022978] tveeprom 0-00a2: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
[   16.023040] tveeprom 0-00a2: audio processor is CX25843 (idx 37)
[   16.023081] tveeprom 0-00a2: decoder processor is CX25843 (idx 30)
[   16.023122] tveeprom 0-00a2: has radio, has IR receiver, has IR transmitter
[   16.023137] pvrusb2: Supported video standard(s) reported available in hardware: PAL-M/N/Nc;NTSC-M/Mj/Mk;ATSC-8VSB/16VSB
[   16.023137] pvrusb2: Mapping standards mask=0x300b700 (PAL-M/N/Nc;NTSC-M/Mj/Mk;ATSC-8VSB/16VSB)
[   16.023137] pvrusb2: Setting up 6 unique standard(s)
[   16.023179] pvrusb2: Set up standard idx=0 name=PAL-M
[   16.023219] pvrusb2: Set up standard idx=1 name=PAL-N
[   16.023259] pvrusb2: Set up standard idx=2 name=PAL-Nc
[   16.023299] pvrusb2: Set up standard idx=3 name=NTSC-M
[   16.023340] pvrusb2: Set up standard idx=4 name=NTSC-Mj
[   16.023380] pvrusb2: Set up standard idx=5 name=NTSC-Mk
[   16.023421] pvrusb2: Initial video standard (determined by device type): NTSC-M
[   16.023474] pvrusb2: Device initialization completed successfully.
[   16.023531] pvrusb2: registered device video0 [mpeg]
[   16.023572] DVB: registering new adapter (pvrusb2-dvb)
[   16.074116] firmware: requesting v4l-cx2341x-enc.fw
[   16.431146] DVB: Unable to find symbol s5h1411_attach()
[   16.431146] pvrusb2: no frontend was attached!
[   16.431146] pvrusb2: unregistering DVB devices

Has anyone got one of these working in Linux?

When I compiled them in (instead of making them modules), I get an OOPS

[   15.950121] pvrusb2: Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner : V4L in-tree version
[   15.950121] pvrusb2: Debug mask is 31 (0x1f)
[   16.052664] usb 1-4: reset high speed USB device using ehci_hcd and address 4
[   16.238140] tvaudio' 1-0042: tda9840 found @ 0x84 (pvrusb2_a)
[   16.351636] tveeprom 1-00a2: Hauppauge model 75111, rev C3E9, serial# 3474275
[   16.351681] tveeprom 1-00a2: MAC address is 00-0D-FE-35-03-63
[   16.351722] tveeprom 1-00a2: tuner model is Philips 18271_8295 (idx 149, type 54)
[   16.351775] tveeprom 1-00a2: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
[   16.351824] tveeprom 1-00a2: audio processor is CX25843 (idx 37)
[   16.351865] tveeprom 1-00a2: decoder processor is CX25843 (idx 30)
[   16.351907] tveeprom 1-00a2: has radio, has IR receiver, has IR transmitter
[   16.351950] pvrusb2: Supported video standard(s) reported available in hardware: PAL-M/N/Nc;NTSC-M/Mj/Mk;ATSC-8VSB/16VSB
[   16.352004] pvrusb2: Mapping standards mask=0x300b700 (PAL-M/N/Nc;NTSC-M/Mj/Mk;ATSC-8VSB/16VSB)
[   16.352055] pvrusb2: Setting up 6 unique standard(s)
[   16.352096] pvrusb2: Set up standard idx=0 name=PAL-M
[   16.352136] pvrusb2: Set up standard idx=1 name=PAL-N
[   16.352178] pvrusb2: Set up standard idx=2 name=PAL-Nc
[   16.352219] pvrusb2: Set up standard idx=3 name=NTSC-M
[   16.352259] pvrusb2: Set up standard idx=4 name=NTSC-Mj
[   16.352300] pvrusb2: Set up standard idx=5 name=NTSC-Mk
[   16.352341] pvrusb2: Initial video standard (determined by device type): NTSC-M
[   16.353240] pvrusb2: Device initialization completed successfully.
[   16.353295] pvrusb2: registered device video1 [mpeg]
[   16.354221] DVB: registering new adapter (pvrusb2-dvb)
[   16.355002] BUG: unable to handle kernel NULL pointer dereference at 00000000
[   16.355069] IP: [<00000000>]
[   16.355138] *pdpt = 000000003779f001 *pde = 0000000000000000 
[   16.355236] Oops: 0010 [#1] PREEMPT SMP 
[   16.355358] Modules linked in: pvrusb2 snd_hda_intel snd_hwdep
[   16.355510] 
[   16.355548] Pid: 1518, comm: pvrusb2_a Not tainted (2.6.26.2 #6)
[   16.355589] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 1
[   16.355630] EIP is at 0x0
[   16.355658] EAX: 00000000 EBX: c0700020 ECX: f775ff28 EDX: c008561c
[   16.355658] ESI: f7275400 EDI: f70ac240 EBP: f775ff28 ESP: f775fe20
[   16.355700]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   16.355700] Process pvrusb2_a (pid: 1518, ti=f775e000 task=f7fdc040 task.ti=f775e000)
[   16.355700] Stack: c03563de 00000000 00000c31 c07a5940 c3613990 f775ff38 f775fed8 c361c940 
[   16.355700]        c0700020 c0700020 c0355f20 f7275400 f7190500 c008561c f899cc65 f899cc72 
[   16.355700]        00000000 c0355f20 c0362810 f7249000 f775ff28 f775ff28 00000000 00000000 
[   16.355999] Call Trace:
[   16.355999]  [<c03563de>] chip_command+0x4be/0x640
[   16.355999]  [<c0355f20>] chip_command+0x0/0x640
[   16.355999]  [<f899cc65>] pvr2_i2c_client_cmd+0x175/0x1a0 [pvrusb2]
[   16.355999]  [<f899cc72>] pvr2_i2c_client_cmd+0x182/0x1a0 [pvrusb2]
[   16.355999]  [<c0355f20>] chip_command+0x0/0x640
[   16.355999]  [<c0362810>] saa7185_command+0x0/0x210
[   16.355999]  [<f899cd29>] pvr2_i2c_core_cmd+0x99/0xb0 [pvrusb2]
[   16.355999]  [<f899cf5c>] set_audiomode+0x3c/0x50 [pvrusb2]
[   16.355999]  [<f899cd0d>] pvr2_i2c_core_cmd+0x7d/0xb0 [pvrusb2]
[   16.355999]  [<f899d01a>] set_volume+0xaa/0x120 [pvrusb2]
[   16.355999]  [<f899d13d>] set_bcsh+0xad/0x100 [pvrusb2]
[   16.355999]  [<f899c8ad>] pvr2_i2c_core_sync+0x26d/0x4b0 [pvrusb2]
[   16.355999]  [<f89a1ee7>] pvr2_hdw_worker_i2c+0x27/0x40 [pvrusb2]
[   16.356074]  [<c0133f4c>] run_workqueue+0x6c/0x130
[   16.356074]  [<f89a1ec0>] pvr2_hdw_worker_i2c+0x0/0x40 [pvrusb2]
[   16.356074]  [<c01342b7>] worker_thread+0x47/0xa0
[   16.356074]  [<c0137910>] autoremove_wake_function+0x0/0x50
[   16.356074]  [<c0134270>] worker_thread+0x0/0xa0
[   16.356074]  [<c0137629>] kthread+0x39/0x70
[   16.356074]  [<c01375f0>] kthread+0x0/0x70
[   16.356074]  [<c0103d0f>] kernel_thread_helper+0x7/0x18
[   16.356074]  =======================
[   16.356074] Code:  Bad EIP value.
[   16.356074] EIP: [<00000000>] 0x0 SS:ESP 0068:f775fe20
[   16.358193] ---[ end trace 3415345cac36f149 ]---

