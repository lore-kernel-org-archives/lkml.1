Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbYHACSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbYHACSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 22:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYHACSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 22:18:42 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:37445 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbYHACSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 22:18:41 -0400
Date: Thu, 31 Jul 2008 22:18:39 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Kernel (2.6.26 final) Oops, problem?
To: linux-kernel@vger.kernel.org
Message-id: <200807312218.39479.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Kernel 2.6.26 final, 32 bit x86 athlon xp-2800, F8 install.  Running kernels 
as linus blesses them without incident for most of a year now, but it looks 
like my luck runneth out.

>From /var/log/messages, because syslog is broadcasting -wall on every shell 
open:
Jul 31 20:27:40 coyote kernel: [ 7026.294406] usb 1-1.1: USB disconnect, 
address 6
Jul 31 20:27:40 coyote kernel: [ 7026.479139] usb 1-1.1: new low speed USB 
device using ehci_hcd and address 13
Jul 31 20:27:40 coyote kernel: [ 7026.677314] usb 1-1.1: configuration #1 
chosen from 1 choice
Jul 31 20:27:41 coyote kernel: [ 7027.414590] hiddev97hidraw2: USB HID v1.11 
Device [Belkin  Belkin UPS] on usb-0000:00:02.2-1.1
Jul 31 21:11:49 coyote ntpd[1986]: kernel time sync status change 4001
Jul 31 21:28:54 coyote ntpd[1986]: kernel time sync status change 0001
Jul 31 21:36:03 coyote kernel: [11130.112101] ACPI Error (psargs-0358): [SENF] 
Namespace lookup failure, AE_NOT_FOUND
Jul 31 21:36:03 coyote kernel: [11130.112112] ACPI Error (psparse-0530): ACPI 
Error (nsnames-0186): Invalid NS Node (f7811f90) while traversing path 
[20080321]
Jul 31 21:36:03 coyote kernel: [11130.112145] BUG: unable to handle kernel 
NULL pointer dereference at 0000000f
Jul 31 21:36:03 coyote kernel: [11130.112148] IP: [<c05279d5>] 
acpi_ns_build_external_path+0x1e/0x7b
Jul 31 21:36:03 coyote kernel: [11130.112159] *pde = 00000000
Jul 31 21:36:03 coyote kernel: [11130.112162] Oops: 0002 [#1] PREEMPT
Jul 31 21:36:03 coyote kernel: [11130.112165] Modules linked in: radeon drm 
eeprom autofs4 w83627hf hwmon_vid hwmon fuse sunrpc ipv6 cx88_dvb 
cx88_vp3054_i2c mt352 dvb_pll s5h1411 or51132 videobuf_dvb nxt200x isl6421 
zl10353 cx24123 lgdt330x snd_intel8x0 dvb_core snd_emu10k1_synth cx22702 
tuner tda8290 tda18271 tda827x tda9887 tuner_simple tuner_types 
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_ac97_codec 
ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq cx8800 
snd_pcm_oss snd_mixer_oss snd_pcm cx8802 snd_mpu401 snd_mpu401_uart 
snd_rawmidi cx88xx snd_seq_device videodev snd_timer floppy snd_util_mem 
snd_hwdep snd ir_common i2c_algo_bit tveeprom firewire_ohci pcspkr 
v4l1_compat compat_ioctl32 v4l2_common btcx_risc videobuf_dma_sg 
firewire_core crc_itu_t soundcore videobuf_core snd_page_alloc forcedeth 
ftdi_sio usbserial i2c_nforce2 i2c_core usblp sg sr_mod cdrom sata_sil 
ata_generic pata_acpi pata_amd libata dock sd_mod scsi_mod ext3 jbd mbcache 
uhci_hcd ohci_hcd ehci_hcd [last un
Jul 31 21:36:03 coyote kernel: loaded: scsi_wait_scan]
Jul 31 21:36:03 coyote kernel: [11130.112210]
Jul 31 21:36:03 coyote kernel: [11130.112213] Pid: 2670, comm: ksensors Not 
tainted (2.6.26 #2)
Jul 31 21:36:03 coyote kernel: [11130.112215] EIP: 0060:[<c05279d5>] EFLAGS: 
00010286 CPU: 0
Jul 31 21:36:03 coyote kernel: [11130.112220] EIP is at 
acpi_ns_build_external_path+0x1e/0x7b
Jul 31 21:36:03 coyote kernel: [11130.112222] EAX: f7813078 EBX: ffffffff ECX: 
00000010 EDX: f7813078
Jul 31 21:36:03 coyote kernel: [11130.112225] ESI: 00000010 EDI: 00000010 EBP: 
00000000 ESP: f1210e28
Jul 31 21:36:03 coyote kernel: [11130.112227]  DS: 007b ES: 007b FS: 0000 GS: 
0033 SS: 0068
Jul 31 21:36:03 coyote kernel: [11130.112229] Process ksensors (pid: 2670, 
ti=f1210000 task=f11413b0 task.ti=f1210000)
Jul 31 21:36:03 coyote kernel: [11130.112232] Stack: f7813078 00000000 
00000000 f1210e50 c0527a6a f7813078 c0688619 c0688619
Jul 31 21:36:03 coyote kernel: [11130.112237]        00000005 c0527f94 
00000000 00000010 00000000 f7813078 c0528017 f7813078
Jul 31 21:36:03 coyote kernel: [11130.112241]        00000000 f1027400 
f7b02810 c05292b5 f7813078 00000000 00000005 00000000
Jul 31 21:36:03 coyote kernel: [11130.112246] Call Trace:
Jul 31 21:36:03 coyote kernel: [11130.112251]  [<c0527a6a>] 
acpi_ns_handle_to_pathname+0x38/0x42
Jul 31 21:36:03 coyote kernel: [11130.112258]  [<c0527f94>] 
acpi_ns_print_node_pathname+0x28/0x5d
Jul 31 21:36:03 coyote kernel: [11130.112264]  [<c0528017>] 
acpi_ns_report_method_error+0x4e/0x69
Jul 31 21:36:03 coyote kernel: [11130.112270]  [<c05292b5>] 
acpi_ps_parse_aml+0xcf/0x26b
Jul 31 21:36:03 coyote kernel: [11130.112278]  [<c052a47b>] 
acpi_ps_execute_method+0x10a/0x1a7
Jul 31 21:36:03 coyote kernel: [11130.112285]  [<c0527918>] 
acpi_ns_evaluate+0x90/0xe4
Jul 31 21:36:03 coyote kernel: [11130.112290]  [<c052759f>] 
acpi_evaluate_object+0x124/0x1c9
Jul 31 21:36:03 coyote kernel: [11130.112298]  [<c051a1e6>] 
acpi_evaluate_integer+0x78/0xac
Jul 31 21:36:03 coyote kernel: [11130.112307]  [<c0535e2f>] 
acpi_thermal_get_temperature+0x26/0x33
Jul 31 21:36:03 coyote kernel: [11130.112313]  [<c0537325>] 
acpi_thermal_temp_seq_show+0x12/0x4a
Jul 31 21:36:03 coyote kernel: [11130.112318]  [<c0494ea5>] 
seq_read+0x65/0x2a0
Jul 31 21:36:03 coyote kernel: [11130.112324]  [<c04d7374>] 
selinux_file_permission+0x104/0x150
Jul 31 21:36:03 coyote kernel: [11130.112332]  [<c0494e40>] seq_read+0x0/0x2a0
Jul 31 21:36:03 coyote kernel: [11130.112336]  [<c04ae3de>] 
proc_reg_read+0x6e/0xc0
Jul 31 21:36:03 coyote kernel: [11130.112346]  [<c0479081>] 
vfs_read+0xa1/0x160
Jul 31 21:36:03 coyote kernel: [11130.112353]  [<c04ae370>] 
proc_reg_read+0x0/0xc0
Jul 31 21:36:03 coyote kernel: [11130.112358]  [<c0479511>] sys_read+0x41/0x70
Jul 31 21:36:03 coyote kernel: [11130.112365]  [<c0403006>] 
syscall_call+0x7/0xb
Jul 31 21:36:03 coyote kernel: [11130.112378]  =======================
Jul 31 21:36:03 coyote kernel: [11130.112380] Code: 00 00 00 85 db 0f 44 d8 8d 
43 01 5b c3 55 89 d5 57 56 89 ce 53 8d 5a ff 83 fb 03 77 09 c6 01 5c c6 41 01 
00 eb 5d 8d 3c 11 89 c2 <c6> 04 19 00 eb 15 8b 42 08 83 eb 05 89 07 89 d0 e8 
e3 01 00 00
Jul 31 21:36:03 coyote kernel: [11130.112400] EIP: [<c05279d5>] 
acpi_ns_build_external_path+0x1e/0x7b SS:ESP 0068:f1210e28
Jul 31 21:36:03 coyote kernel: [11130.112406] ---[ end trace 
0d63271c2d334fd8 ]---

This seems to point at ksensors, but I wasn't aware it was even running.  I 
use gkrellm for such, and it appears to be indicating things are passably 
normal.

The machine is still up and running fairly well, so what do I do next, other 
than reboot?

Thanks all.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Avoid Quiet and Placid persons unless you are in Need of Sleep.
		-- National Lampoon, "Deteriorata"
