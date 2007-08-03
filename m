Return-Path: <linux-kernel-owner+w=401wt.eu-S1762592AbXHCN7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762592AbXHCN7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759505AbXHCN70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:59:26 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.134]:55452 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022AbXHCN7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:59:24 -0400
X-Greylist: delayed 1743 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Aug 2007 09:59:24 EDT
X-Authenticated-Name: sbromle
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <46B32E15.2060308@pangeosubsea.com>
Date: Fri, 03 Aug 2007 11:01:01 -0230
From: Sam Bromley <sbromley@pangeosubsea.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070723)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: EIP: [dnotify_flush+104/160] dnotify_flush+0x68/0xa0 SS:ESP 0068:ecf85f80
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,
Sorry to bother you all, but I've been unable to find anything
definitive about this crash.

I suspect it's a harddrive or ram issue, perhaps, but I really
don't know for sure. The details from the crash are below.
If any of you know that "yep, it's just hardware", I'd really
appreciate the info. Thank you for any insight that you can provide.

Cheers,
Sam

( Linux version 2.6.20-15-generic (root@palmer) (gcc version 4.1.2 
(Ubuntu 4.1.2-0ubuntu4)) #2 SMP Sun Apr 15 07:36:31
UTC 2007 (Ubuntu 2.6.20-15.27-generic)


Aug  2 07:37:29 correo kernel: [7847300.896000] BUG: unable to handle 
kernel NULL pointer dereference at virtual address 00000011
Aug  2 07:37:29 correo kernel: [7847300.896000]  printing eip:
Aug  2 07:37:29 correo kernel: [7847300.896000] c01a8e38
Aug  2 07:37:29 correo kernel: [7847300.896000] *pde = 00000000
Aug  2 07:37:29 correo kernel: [7847300.896000] Oops: 0000 [#1]
Aug  2 07:37:29 correo kernel: [7847300.896000] SMP
Aug  2 07:37:29 correo kernel: [7847300.896000] Modules linked in: 
nls_iso8859_1 vfat fat usb_storage libusual lp parport_pc joydev st 
sr_mod ppp_generic slhc
nls_cp437 isofs udf nfsd exportfs nfs lockd sunrpc binfmt_misc rfcomm 
l2cap bluetooth ppdev powernow_k8 cpufreq_userspace cpufreq_stats 
cpufreq_powersave cpufr
eq_ondemand freq_table cpufreq_conservative tc1100_wmi pcc_acpi dev_acpi 
sony_acpi video sbs i2c_ec dock button battery container ac asus_acpi 
backlight af_pac
ket sbp2 snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm 
snd_mpu401 snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi ide_cd 
snd_rawmidi snd
_seq_midi_event snd_seq snd_timer snd_seq_device cdrom snd analog 
snd_page_alloc pcspkr gameport nvidia(P) parport serio_raw soundcore 
agpgart psmouse i2c_nfor
ce2 k8temp i2c_core shpchp pci_hotplug evdev tsdev ipv6 ext3 jbd mbcache 
sg sd_mod forcedeth floppy ohci1394 ieee1394 ohci_hcd amd74xx 3c59x mii 
ehci_hcd usbco
re sata_nv ata_generic libata scsi_mod generic thermal processor fan fbc
Aug  2 07:37:29 correo kernel: n tileblit font bitblit softcursor vesafb 
capability commoncap
Aug  2 07:37:29 correo kernel: [7847300.896000] CPU:    1
Aug  2 07:37:29 correo kernel: [7847300.896000] EIP: 
0060:[dnotify_flush+104/160]    Tainted: P      VLI
Aug  2 07:37:29 correo kernel: [7847300.896000] EFLAGS: 00010202 
(2.6.20-15-generic #2)
Aug  2 07:37:29 correo kernel: [7847300.896000] EIP is at 
dnotify_flush+0x68/0xa0
Aug  2 07:37:29 correo kernel: [7847300.896000] eax: dc7dfebc   ebx: 
00000001   ecx: 00000000   edx: dc7dff68
Aug  2 07:37:29 correo kernel: [7847300.896000] esi: dc7dfe50   edi: 
f7c49380   ebp: c9442a80   esp: ecf85f80
Aug  2 07:37:29 correo kernel: [7847300.896000] ds: 007b   es: 007b 
ss: 0068
Aug  2 07:37:29 correo kernel: [7847300.896000] Process updatedb (pid: 
24836, ti=ecf84000 task=f3fe3030 task.ti=ecf84000)
Aug  2 07:37:29 correo kernel: [7847300.896000] Stack: c9442a80 f7c49380 
00000000 ecf84000 c0174ad7 08056154 f7c49380 00000008
Aug  2 07:37:29 correo kernel: [7847300.896000]        c9442a80 c0175e4b 
00000008 00000008 080531e8 c01031f0 00000008 00000001
Aug  2 07:37:29 correo kernel: [7847300.896000]        b7f51ff4 00000008 
080531e8 bffa9348 00000006 0000007b 0000007b 00000033
Aug  2 07:37:29 correo kernel: [7847300.896000] Call Trace:
Aug  2 07:37:29 correo kernel: [7847300.896000]  [filp_close+55/128] 
filp_close+0x37/0x80
Aug  2 07:37:29 correo kernel: [7847300.896000]  [sys_close+107/208] 
sys_close+0x6b/0xd0
Aug  2 07:37:29 correo kernel: [7847300.896000] 
[sysenter_past_esp+105/169] sysenter_past_esp+0x69/0xa9
Aug  2 07:37:29 correo kernel: [7847300.896000]  =======================
Aug  2 07:37:29 correo kernel: [7847300.896000] Code: 10 c3 8d 46 6c e8 
e9 58 14 00 8b 9e 18 01 00 00 8d 96 18 01 00 00 85 db 75 11 eb 30 8d b4 
26 00 00 00 00
89 da 8b 1b 85 db 74 21 <39> 7b 10 75 f3 3b 6b 0c 75 ee 8b 03 89 02 89 
f0 e8 c3 fe ff ff
Aug  2 07:37:29 correo kernel: [7847300.896000] EIP: 
[dnotify_flush+104/160] dnotify_flush+0x68/0xa0 SS:ESP 0068:ecf85f80
Aug  3 07:37:23 correo kernel: [7847300.896000]  <3>BUG: soft lockup 
detected on CPU#1!
Aug  3 07:37:23 correo kernel: [7933690.896000] 
[softlockup_tick+156/240] softlockup_tick+0x9c/0xf0
Aug  3 07:37:23 correo kernel: [7933690.896000] 
[update_process_times+51/128] update_process_times+0x33/0x80
Aug  3 07:37:23 correo kernel: [7933690.896000] 
[smp_apic_timer_interrupt+112/128] smp_apic_timer_interrupt+0x70/0x80
Aug  3 07:37:23 correo kernel: [7933690.896000] 
[apic_timer_interrupt+40/48] apic_timer_interrupt+0x28/0x30
Aug  3 07:37:23 correo kernel: [7933690.896000]  [_spin_lock+7/16] 
_spin_lock+0x7/0x10
Aug  3 07:37:23 correo kernel: [7933690.896000]  [dnotify_flush+71/160] 
dnotify_flush+0x47/0xa0
Aug  3 07:37:23 correo kernel: [7933690.896000]  [filp_close+55/128] 
filp_close+0x37/0x80
Aug  3 07:37:23 correo kernel: [7933690.896000]  [sys_close+107/208] 
sys_close+0x6b/0xd0
Aug  3 07:37:23 correo kernel: [7933690.896000] 
[sysenter_past_esp+105/169] sysenter_past_esp+0x69/0xa9
Aug  3 07:37:23 correo kernel: [7933690.896000]  =======================
