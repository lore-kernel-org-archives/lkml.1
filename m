Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbYHAEAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbYHAEAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 00:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYHAD76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 23:59:58 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:57699 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYHAD7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 23:59:53 -0400
Date: Thu, 31 Jul 2008 23:59:13 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Kernel (2.6.26 final) Oops, problem?
In-reply-to: <1217558803.2969.173.camel@rzhang-dt>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, ming.m.lin@intel.com
Message-id: <200807312359.13737.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: Multipart/Mixed; boundary="Boundary-00=_RookIvV3pjCtVkU"
References: <200807312218.39479.gene.heskett@gmail.com>
 <20080731193715.60e389ba.akpm@linux-foundation.org>
 <1217558803.2969.173.camel@rzhang-dt>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_RookIvV3pjCtVkU
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 31 July 2008, Zhang Rui wrote:
[...]

Word wrap off, Oops pasted again:

Jul 31 21:36:03 coyote kernel: [11130.112101] ACPI Error (psargs-0358): [SENF] Namespace lookup failure, AE_NOT_FOUND
Jul 31 21:36:03 coyote kernel: [11130.112112] ACPI Error (psparse-0530): ACPI Error (nsnames-0186): Invalid NS Node 
(f7811f90) while traversing path [20080321]
Jul 31 21:36:03 coyote kernel: [11130.112145] BUG: unable to handle kernel NULL pointer dereference at 0000000f
Jul 31 21:36:03 coyote kernel: [11130.112148] IP: [<c05279d5>] acpi_ns_build_external_path+0x1e/0x7b
Jul 31 21:36:03 coyote kernel: [11130.112159] *pde = 00000000
Jul 31 21:36:03 coyote kernel: [11130.112162] Oops: 0002 [#1] PREEMPT
Jul 31 21:36:03 coyote kernel: [11130.112165] Modules linked in: radeon drm eeprom autofs4 w83627hf hwmon_vid hwmon fuse 
sunrpc ipv6 cx88_dvb cx88_vp3054_i2c mt352 dvb_pll s5h1411 or51132 videobuf_dvb nxt200x isl6421 zl10353 cx24123 lgdt330x 
snd_intel8x0 dvb_core snd_emu10k1_synth cx22702 tuner tda8290 tda18271 tda827x tda9887 tuner_simple tuner_types 
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq cx8800 snd_pcm_oss snd_mixer_oss snd_pcm cx8802 snd_mpu401 snd_mpu401_uart snd_rawmidi cx88xx 
snd_seq_device videodev snd_timer floppy snd_util_mem snd_hwdep snd ir_common i2c_algo_bit tveeprom firewire_ohci pcspkr 
v4l1_compat compat_ioctl32 v4l2_common btcx_risc videobuf_dma_sg firewire_core crc_itu_t soundcore videobuf_core 
snd_page_alloc forcedeth ftdi_sio usbserial i2c_nforce2 i2c_core usblp sg sr_mod cdrom sata_sil ata_generic pata_acpi 
pata_amd libata dock sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last un
Jul 31 21:36:03 coyote kernel: loaded: scsi_wait_scan]
Jul 31 21:36:03 coyote kernel: [11130.112210]
Jul 31 21:36:03 coyote kernel: [11130.112213] Pid: 2670, comm: ksensors Not tainted (2.6.26 #2)
Jul 31 21:36:03 coyote kernel: [11130.112215] EIP: 0060:[<c05279d5>] EFLAGS: 00010286 CPU: 0
Jul 31 21:36:03 coyote kernel: [11130.112220] EIP is at acpi_ns_build_external_path+0x1e/0x7b
Jul 31 21:36:03 coyote kernel: [11130.112222] EAX: f7813078 EBX: ffffffff ECX: 00000010 EDX: f7813078
Jul 31 21:36:03 coyote kernel: [11130.112225] ESI: 00000010 EDI: 00000010 EBP: 00000000 ESP: f1210e28
Jul 31 21:36:03 coyote kernel: [11130.112227]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Jul 31 21:36:03 coyote kernel: [11130.112229] Process ksensors (pid: 2670, ti=f1210000 task=f11413b0 task.ti=f1210000)
Jul 31 21:36:03 coyote kernel: [11130.112232] Stack: f7813078 00000000 00000000 f1210e50 c0527a6a f7813078 c0688619 
c0688619
Jul 31 21:36:03 coyote kernel: [11130.112237]        00000005 c0527f94 00000000 00000010 00000000 f7813078 c0528017 
f7813078
Jul 31 21:36:03 coyote kernel: [11130.112241]        00000000 f1027400 f7b02810 c05292b5 f7813078 00000000 00000005 
00000000
Jul 31 21:36:03 coyote kernel: [11130.112246] Call Trace:
Jul 31 21:36:03 coyote kernel: [11130.112251]  [<c0527a6a>] acpi_ns_handle_to_pathname+0x38/0x42
Jul 31 21:36:03 coyote kernel: [11130.112258]  [<c0527f94>] acpi_ns_print_node_pathname+0x28/0x5d
Jul 31 21:36:03 coyote kernel: [11130.112264]  [<c0528017>] acpi_ns_report_method_error+0x4e/0x69
Jul 31 21:36:03 coyote kernel: [11130.112270]  [<c05292b5>] acpi_ps_parse_aml+0xcf/0x26b
Jul 31 21:36:03 coyote kernel: [11130.112278]  [<c052a47b>] acpi_ps_execute_method+0x10a/0x1a7
Jul 31 21:36:03 coyote kernel: [11130.112285]  [<c0527918>] acpi_ns_evaluate+0x90/0xe4
Jul 31 21:36:03 coyote kernel: [11130.112290]  [<c052759f>] acpi_evaluate_object+0x124/0x1c9
Jul 31 21:36:03 coyote kernel: [11130.112298]  [<c051a1e6>] acpi_evaluate_integer+0x78/0xac
Jul 31 21:36:03 coyote kernel: [11130.112307]  [<c0535e2f>] acpi_thermal_get_temperature+0x26/0x33
Jul 31 21:36:03 coyote kernel: [11130.112313]  [<c0537325>] acpi_thermal_temp_seq_show+0x12/0x4a
Jul 31 21:36:03 coyote kernel: [11130.112318]  [<c0494ea5>] seq_read+0x65/0x2a0
Jul 31 21:36:03 coyote kernel: [11130.112324]  [<c04d7374>] selinux_file_permission+0x104/0x150
Jul 31 21:36:03 coyote kernel: [11130.112332]  [<c0494e40>] seq_read+0x0/0x2a0
Jul 31 21:36:03 coyote kernel: [11130.112336]  [<c04ae3de>] proc_reg_read+0x6e/0xc0
Jul 31 21:36:03 coyote kernel: [11130.112346]  [<c0479081>] vfs_read+0xa1/0x160
Jul 31 21:36:03 coyote kernel: [11130.112353]  [<c04ae370>] proc_reg_read+0x0/0xc0
Jul 31 21:36:03 coyote kernel: [11130.112358]  [<c0479511>] sys_read+0x41/0x70
Jul 31 21:36:03 coyote kernel: [11130.112365]  [<c0403006>] syscall_call+0x7/0xb
Jul 31 21:36:03 coyote kernel: [11130.112378]  =======================
Jul 31 21:36:03 coyote kernel: [11130.112380] Code: 00 00 00 85 db 0f 44 d8 8d 43 01 5b c3 55 89 d5 57 56 89 ce 53 8d 5a 
ff 83 fb 03 77 09 c6 01 5c c6 41 01 00 eb 5d 8d 3c 11 89 c2 <c6> 04 19 00 eb 15 8b 42 08 83 eb 05 89 07 89 d0 e8 e3 01 00 
00
Jul 31 21:36:03 coyote kernel: [11130.112400] EIP: [<c05279d5>] acpi_ns_build_external_path+0x1e/0x7b SS:ESP 0068:f1210e28
Jul 31 21:36:03 coyote kernel: [11130.112406] ---[ end trace 0d63271c2d334fd8 ]---


>It seems like a BIOS/ACPICA  issue, cc Ming.
>
>Gene,
>Please attach the acpidump using the latest pmtools at
>http://www.lesswatts.org/patches/linux_acpi/
>
>thanks,
>rui

Attached, thank you.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Some people have parts that are so private they themselves have no
knowledge of them.

--Boundary-00=_RookIvV3pjCtVkU
Content-Type: text/plain;
  charset="utf-8";
  name="acpidump.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="acpidump.txt"

DSDT @ 0x3fff30c0
  0000: 44 53 44 54 c4 4c 00 00 01 60 4e 56 49 44 49 41  DSDT.L...`NVIDIA
  0010: 41 57 52 44 41 43 50 49 00 10 00 00 4d 53 46 54  AWRDACPI....MSFT
  0020: 0e 00 00 01 10 19 5c 5f 50 52 5f 5b 83 11 5c 2e  ......\_PR_[..\.
  0030: 5f 50 52 5f 43 50 55 30 00 00 00 00 00 00 08 5c  _PR_CPU0.......\
  0040: 5f 53 30 5f 12 0a 04 0a 00 0a 00 0a 00 0a 00 08  _S0_............
  0050: 5c 5f 53 31 5f 12 0a 04 0a 01 0a 01 0a 00 0a 00  \_S1_...........
  0060: 08 5c 53 53 33 5f 12 0a 04 0a 05 0a 05 0a 00 0a  .\SS3_..........
  0070: 00 08 5c 5f 53 34 5f 12 0a 04 0a 06 0a 06 0a 00  ..\_S4_.........
  0080: 0a 00 08 5c 5f 53 35 5f 12 0a 04 0a 07 0a 07 0a  ...\_S5_........
  0090: 00 0a 00 5b 80 5c 44 45 42 47 01 0a 80 0a 01 5b  ...[.\DEBG.....[
  00a0: 81 0c 5c 44 45 42 47 01 44 42 47 31 08 5b 80 5a  ..\DEBG.DBG1.[.Z
  00b0: 30 30 32 01 0a 21 0a 01 5b 81 0b 5a 30 30 32 01  002..!..[..Z002.
  00c0: 5a 30 30 30 08 5b 80 4b 42 43 5f 01 0a 64 0a 01  Z000.[.KBC_..d..
  00d0: 5b 81 0b 4b 42 43 5f 01 4b 43 4d 44 08 5b 80 45  [..KBC_.KCMD.[.E
  00e0: 58 54 4d 00 0c 30 f8 0f 00 0a 10 5b 81 29 45 58  XTM..0.....[.)EX
  00f0: 54 4d 02 52 4f 4d 31 10 52 4d 53 31 10 52 4f 4d  TM.ROM1.RMS1.ROM
  0100: 32 10 52 4d 53 32 10 52 4f 4d 33 10 52 4d 53 33  2.RMS2.ROM3.RMS3
  0110: 10 41 4d 45 4d 20 5b 80 5c 50 4d 31 53 01 0b 00  .AMEM [.\PM1S...
  0120: 40 0a 02 5b 81 1c 5c 50 4d 31 53 01 00 08 50 42  @..[..\PM1S...PB
  0130: 54 53 01 00 01 52 54 43 53 01 00 04 57 41 4b 53  TS...RTCS...WAKS
  0140: 01 5b 80 45 4c 43 52 01 0b d0 04 0a 02 5b 81 10  .[.ELCR......[..
  0150: 45 4c 43 52 01 45 4c 43 31 08 45 4c 43 32 08 5b  ELCR.ELC1.ELC2.[
  0160: 80 5c 53 54 55 53 01 0b 00 44 0a 04 5b 81 0c 5c  .\STUS...D..[..\
  0170: 53 54 55 53 01 47 5f 53 54 20 5b 80 5c 53 4d 49  STUS.G_ST [.\SMI
  0180: 53 01 0b 20 40 0a 04 5b 81 0c 5c 53 4d 49 53 01  S.. @..[..\SMIS.
  0190: 50 5f 32 30 20 5b 80 5c 53 4d 49 43 01 0b 2e 44  P_20 [.\SMIC...D
  01a0: 0a 01 5b 81 0c 5c 53 4d 49 43 01 53 43 50 5f 08  ..[..\SMIC.SCP_.
  01b0: 5b 80 5c 47 50 31 5f 01 0b c0 44 0a 32 5b 81 4f  [.\GP1_...D.2[.O
  01c0: 0f 5c 47 50 31 5f 01 47 50 30 30 08 47 50 30 31  .\GP1_.GP00.GP01
  01d0: 08 47 50 30 32 08 47 50 30 33 08 47 50 30 34 08  .GP02.GP03.GP04.
  01e0: 47 50 30 35 08 47 50 30 36 08 47 50 30 37 08 47  GP05.GP06.GP07.G
  01f0: 50 30 38 08 47 50 30 39 08 47 50 31 30 08 47 50  P08.GP09.GP10.GP
  0200: 31 31 08 47 50 31 32 08 47 50 31 33 08 47 50 31  11.GP12.GP13.GP1
  0210: 34 08 47 50 31 35 08 47 50 31 36 08 47 50 31 37  4.GP15.GP16.GP17
  0220: 08 47 50 31 38 08 47 50 31 39 08 47 50 32 30 08  .GP18.GP19.GP20.
  0230: 47 50 32 31 08 47 50 32 32 08 00 08 47 50 32 34  GP21.GP22...GP24
  0240: 08 47 50 32 35 08 47 50 32 36 08 47 50 32 37 08  .GP25.GP26.GP27.
  0250: 47 50 32 38 08 47 50 32 39 08 47 50 33 30 08 47  GP28.GP29.GP30.G
  0260: 50 33 31 08 47 50 33 32 08 47 50 33 33 08 47 50  P31.GP32.GP33.GP
  0270: 33 34 08 47 50 33 35 08 47 50 33 36 08 47 50 33  34.GP35.GP36.GP3
  0280: 37 08 47 50 33 38 08 47 50 33 39 08 47 50 34 30  7.GP38.GP39.GP40
  0290: 08 47 50 34 31 08 47 50 34 32 08 47 50 34 33 08  .GP41.GP42.GP43.
  02a0: 47 50 34 34 08 47 50 34 35 08 47 50 34 36 08 47  GP44.GP45.GP46.G
  02b0: 50 34 37 08 47 50 34 38 08 47 50 34 39 08 08 4f  P47.GP48.GP49..O
  02c0: 53 46 4c 0a 01 14 41 05 53 54 52 43 02 a0 0a 92  SFL...A.STRC....
  02d0: 93 87 68 87 69 a4 0a 00 72 87 68 0a 01 60 08 42  ..h.i...r.h..`.B
  02e0: 55 46 30 11 02 60 08 42 55 46 31 11 02 60 70 68  UF0..`.BUF1..`ph
  02f0: 42 55 46 30 70 69 42 55 46 31 a2 1a 60 76 60 a0  BUF0piBUF1..`v`.
  0300: 15 92 93 83 88 42 55 46 30 60 00 83 88 42 55 46  .....BUF0`...BUF
  0310: 31 60 00 a4 00 a4 01 5b 80 52 54 43 4d 01 0a 70  1`.....[.RTCM..p
  0320: 0a 02 5b 81 10 52 54 43 4d 01 43 4d 49 4e 08 43  ..[..RTCM.CMIN.C
  0330: 4d 44 41 08 5b 86 12 43 4d 49 4e 43 4d 44 41 01  MDA.[..CMINCMDA.
  0340: 00 48 07 53 48 55 54 08 5b 80 49 4e 46 4f 00 0c  .H.SHUT.[.INFO..
  0350: 40 f8 0f 00 0a 01 5b 81 24 49 4e 46 4f 01 4b 42  @.....[.$INFO.KB
  0360: 44 49 01 52 54 43 57 01 50 53 32 46 01 49 52 46  DI.RTCW.PS2F.IRF
  0370: 4c 02 44 49 53 45 01 53 53 48 55 01 5b 80 42 45  L.DISE.SSHU.[.BE
  0380: 45 50 01 0a 61 0a 01 5b 81 0b 42 45 45 50 01 53  EP..a..[..BEEP.S
  0390: 31 42 5f 08 5b 80 43 4f 4e 54 01 0a 40 0a 04 5b  1B_.[.CONT..@..[
  03a0: 81 1a 43 4f 4e 54 01 43 4e 54 30 08 43 4e 54 31  ..CONT.CNT0.CNT1
  03b0: 08 43 4e 54 32 08 43 54 52 4c 08 14 43 06 53 50  .CNT2.CTRL..C.SP
  03c0: 4b 52 01 70 53 31 42 5f 60 70 0a b6 43 54 52 4c  KR.pS1B_`p..CTRL
  03d0: 70 0a 55 43 4e 54 32 70 0a 03 43 4e 54 32 70 68  p.UCNT2p..CNT2ph
  03e0: 62 a2 37 94 62 0a 00 7d 53 31 42 5f 0a 03 53 31  b.7.b..}S1B_..S1
  03f0: 42 5f 70 0b ff 5f 63 a2 07 94 63 0a 00 76 63 7b  B_p.._c...c..vc{
  0400: 53 31 42 5f 0a fc 53 31 42 5f 70 0b ff 0e 63 a2  S1B_..S1B_p...c.
  0410: 07 94 63 0a 00 76 63 76 62 70 60 53 31 42 5f 10  ..c..vcvbp`S1B_.
  0420: 17 5c 00 08 50 49 43 46 0a 00 14 0c 5f 50 49 43  .\..PICF...._PIC
  0430: 01 70 68 50 49 43 46 08 53 49 44 34 0a 00 08 53  .phPICF.SID4...S
  0440: 4c 47 30 0a 00 08 53 4c 47 31 0a 00 08 53 4c 47  LG0...SLG1...SLG
  0450: 32 0a 00 08 53 4c 47 33 0a 00 08 53 4c 47 34 0a  2...SLG3...SLG4.
  0460: 00 08 53 4c 47 35 0a 00 08 53 4c 47 36 0a 00 08  ..SLG5...SLG6...
  0470: 53 4c 47 37 0a 00 08 53 4c 47 38 0a 00 08 53 4c  SLG7...SLG8...SL
  0480: 47 39 0a 00 08 53 4c 47 41 0a 00 08 53 49 44 35  G9...SLGA...SID5
  0490: 0a 00 08 53 53 4d 30 0a 00 08 53 53 4d 31 0a 00  ...SSM0...SSM1..
  04a0: 08 53 53 4d 32 0a 00 08 53 53 4d 33 0a 00 08 53  .SSM2...SSM3...S
  04b0: 53 4d 34 0a 00 08 53 55 41 30 0a 00 08 53 55 42  SM4...SUA0...SUB
  04c0: 30 0a 00 08 53 58 5f 5f 0a 00 08 53 46 4c 47 0a  0...SX__...SFLG.
  04d0: 00 08 53 49 44 30 0a 00 08 53 49 44 31 0a 00 08  ..SID0...SID1...
  04e0: 53 49 44 32 0a 00 08 53 49 44 33 0a 00 14 48 18  SID2...SID3...H.
  04f0: 5c 5f 50 54 53 01 a0 10 93 47 50 33 34 0a 08 70  \_PTS....GP34..p
  0500: 68 60 53 41 4c 44 60 a1 01 70 68 60 70 60 53 58  h`SALD`..ph`p`SX
  0510: 5f 5f 7d 68 0a f0 60 70 60 44 42 47 31 4f 53 54  __}h..`p`DBG1OST
  0520: 50 70 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45  Pp\/._SB_PCI0IDE
  0530: 30 49 44 32 30 53 49 44 30 70 5c 2f 04 5f 53 42  0ID20SID0p\/._SB
  0540: 5f 50 43 49 30 49 44 45 30 49 44 54 53 53 49 44  _PCI0IDE0IDTSSID
  0550: 31 70 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45  1p\/._SB_PCI0IDE
  0560: 30 49 44 54 50 53 49 44 32 70 5c 2f 04 5f 53 42  0IDTPSID2p\/._SB
  0570: 5f 50 43 49 30 49 44 45 30 49 44 32 32 53 49 44  _PCI0IDE0ID22SID
  0580: 33 70 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45  3p\/._SB_PCI0IDE
  0590: 30 55 4d 53 53 53 49 44 34 70 5c 2f 04 5f 53 42  0UMSSSID4p\/._SB
  05a0: 5f 50 43 49 30 49 44 45 30 55 4d 53 50 53 49 44  _PCI0IDE0UMSPSID
  05b0: 35 a0 43 04 93 68 0a 01 a0 10 93 47 50 33 34 0a  5.C..h.....GP34.
  05c0: 08 70 68 60 53 41 4c 44 60 a1 01 70 5c 2f 03 5f  .ph`SALD`..p\/._
  05d0: 53 42 5f 50 43 49 30 43 54 4c 30 60 7d 60 0c 00  SB_PCI0CTL0`}`..
  05e0: 00 00 04 60 70 60 5c 2f 03 5f 53 42 5f 50 43 49  ...`p`\/._SB_PCI
  05f0: 30 43 54 4c 30 a0 43 04 93 68 0a 03 a0 10 93 47  0CTL0.C..h.....G
  0600: 50 33 34 0a 08 70 68 60 53 41 4c 44 60 a1 01 70  P34..ph`SALD`..p
  0610: 5c 2f 03 5f 53 42 5f 50 43 49 30 43 54 4c 30 60  \/._SB_PCI0CTL0`
  0620: 7d 60 0c 00 00 00 04 60 70 60 5c 2f 03 5f 53 42  }`.....`p`\/._SB
  0630: 5f 50 43 49 30 43 54 4c 30 a0 14 93 68 0a 04 a0  _PCI0CTL0...h...
  0640: 0e 92 93 4f 53 46 4c 0a 00 5b 22 0b f4 01 a0 27  ...OSFL..["....'
  0650: 93 68 0a 05 a0 10 93 47 50 33 34 0a 08 70 68 60  .h.....GP34..ph`
  0660: 53 41 4c 44 60 a1 01 a0 0e 92 93 4f 53 46 4c 0a  SALD`......OSFL.
  0670: 00 5b 22 0b f4 01 14 42 0e 5c 5f 57 41 4b 01 a0  .["....B.\_WAK..
  0680: 0e 93 47 50 33 34 0a 08 53 41 4c 44 0a 00 a1 01  ..GP34..SALD....
  0690: 70 0a ff 44 42 47 31 70 0a 00 53 46 4c 47 86 5c  p..DBG1p..SFLG.\
  06a0: 2e 5f 53 42 5f 50 57 52 42 0a 02 86 5c 2f 03 5f  ._SB_PWRB...\/._
  06b0: 53 42 5f 50 43 49 30 55 53 42 30 0a 00 86 5c 2f  SB_PCI0USB0...\/
  06c0: 03 5f 53 42 5f 50 43 49 30 55 53 42 31 0a 00 70  ._SB_PCI0USB1..p
  06d0: 5c 2f 03 5f 53 42 5f 50 43 49 30 43 54 4c 30 60  \/._SB_PCI0CTL0`
  06e0: 7b 60 0c ff ff ff fb 60 70 60 5c 2f 03 5f 53 42  {`.....`p`\/._SB
  06f0: 5f 50 43 49 30 43 54 4c 30 a0 0e 93 47 50 33 34  _PCI0CTL0...GP34
  0700: 0a 08 53 41 4c 44 0a 00 a1 01 a0 4e 04 92 95 4f  ..SALD.....N...O
  0710: 53 46 4c 0a 01 70 0a 00 5c 2f 04 5f 53 42 5f 50  SFL..p..\/._SB_P
  0720: 43 49 30 53 4d 42 30 53 4d 50 4d 70 0b 00 50 5c  CI0SMB0SMPMp..P\
  0730: 2f 04 5f 53 42 5f 50 43 49 30 53 4d 42 30 53 42  /._SB_PCI0SMB0SB
  0740: 31 5f 70 0b 00 51 5c 2f 04 5f 53 42 5f 50 43 49  1_p..Q\/._SB_PCI
  0750: 30 53 4d 42 30 53 42 32 5f 10 49 04 5c 5f 53 49  0SMB0SB2_.I.\_SI
  0760: 5f 14 20 5f 4d 53 47 01 70 0d 3d 3d 3d 3d 20 4d  _. _MSG.p.==== M
  0770: 53 47 20 57 6f 72 6b 69 6e 67 20 3d 3d 3d 3d 00  SG Working ====.
  0780: 5b 31 14 20 5f 53 53 54 01 70 0d 3d 3d 3d 3d 20  [1. _SST.p.==== 
  0790: 53 53 54 20 57 6f 72 6b 69 6e 67 20 3d 3d 3d 3d  SST Working ====
  07a0: 00 5b 31 5b 80 54 45 4d 4d 00 0c 10 f8 0f 00 0a  .[1[.TEMM.......
  07b0: 0c 5b 81 24 54 45 4d 4d 02 54 50 31 48 10 54 50  .[.$TEMM.TP1H.TP
  07c0: 31 4c 10 54 50 32 48 10 54 50 32 4c 10 54 52 50  1L.TP2H.TP2L.TRP
  07d0: 43 10 53 45 4e 46 10 08 54 56 41 52 11 08 0a 05  C.SENF..TVAR....
  07e0: 00 00 00 00 00 8c 54 56 41 52 0a 00 50 4c 43 59  ......TVAR..PLCY
  07f0: 8b 54 56 41 52 0a 01 43 54 4f 53 8b 54 56 41 52  .TVAR..CTOS.TVAR
  0800: 0a 03 43 54 48 59 08 54 42 55 46 11 07 0a 04 00  ..CTHY.TBUF.....
  0810: 00 00 00 8c 54 42 55 46 0a 00 44 42 30 30 8c 54  ....TBUF..DB00.T
  0820: 42 55 46 0a 01 44 42 30 31 8b 54 42 55 46 0a 00  BUF..DB01.TBUF..
  0830: 44 57 30 30 8b 54 42 55 46 0a 02 44 57 30 31 8a  DW00.TBUF..DW01.
  0840: 54 42 55 46 0a 00 44 41 54 44 5b 80 49 50 5f 5f  TBUF..DATD[.IP__
  0850: 01 0b 95 02 0a 02 5b 81 10 49 50 5f 5f 01 49 4e  ......[..IP__.IN
  0860: 44 53 08 44 41 54 53 08 14 0d 53 43 46 47 01 53  DS.DATS...SCFG.S
  0870: 42 59 54 0a 40 68 14 2f 53 54 4f 53 03 70 47 42  BYT.@h./STOS.pGB
  0880: 59 54 0a 4e 60 7d 60 0a 01 61 53 42 59 54 0a 4e  YT.N`}`..aSBYT.N
  0890: 61 53 42 59 54 0a 55 69 53 42 59 54 0a 56 68 53  aSBYT.UiSBYT.VhS
  08a0: 42 59 54 0a 4e 60 14 2f 53 54 48 59 03 70 47 42  BYT.N`./STHY.pGB
  08b0: 59 54 0a 4e 60 7d 60 0a 01 61 53 42 59 54 0a 4e  YT.N`}`..aSBYT.N
  08c0: 61 53 42 59 54 0a 53 69 53 42 59 54 0a 54 68 53  aSBYT.SiSBYT.ThS
  08d0: 42 59 54 0a 4e 60 14 4d 05 52 54 4d 50 00 70 47  BYT.N`.M.RTMP.pG
  08e0: 42 59 54 0a 4e 60 7d 60 0a 01 61 53 42 59 54 0a  BYT.N`}`..aSBYT.
  08f0: 4e 61 70 47 42 59 54 0a 50 61 70 47 42 59 54 0a  NapGBYT.PapGBYT.
  0900: 51 62 79 61 0a 08 61 7d 61 62 63 7a 63 0a 07 63  Qbya..a}abczc..c
  0910: 79 63 0a 02 61 72 63 61 63 72 63 0b ac 0a 63 a0  yc..arcacrc...c.
  0920: 0b 94 63 0b 8a 0e 70 0b ac 0a 63 53 42 59 54 0a  ..c...p...cSBYT.
  0930: 4e 60 a4 63 14 12 53 42 59 54 02 70 68 49 4e 44  N`.c..SBYT.phIND
  0940: 53 70 69 44 41 54 53 14 14 47 42 59 54 01 70 68  SpiDATS..GBYT.ph
  0950: 49 4e 44 53 70 44 41 54 53 67 a4 67 10 4d 12 5c  INDSpDATSg.g.M.\
  0960: 5f 54 5a 5f 5b 82 28 46 41 4e 5f 08 5f 48 49 44  _TZ_[.(FAN_._HID
  0970: 0c 41 d0 0c 0b 14 18 5f 49 4e 49 00 70 54 50 31  .A....._INI.pTP1
  0980: 48 43 54 4f 53 70 54 50 31 4c 43 54 48 59 5b 85  HCTOSpTP1LCTHY[.
  0990: 4a 0f 54 48 52 4d 08 5f 41 4c 30 12 06 01 46 41  J.THRM._AL0...FA
  09a0: 4e 5f 14 1e 5f 41 43 30 00 a0 10 7d 50 4c 43 59  N_.._AC0...}PLCY
  09b0: 50 4c 43 59 67 a4 54 50 32 48 a1 06 a4 54 50 31  PLCYg.TP2H...TP1
  09c0: 48 08 5f 50 53 4c 12 0c 01 5c 2e 5f 50 52 5f 43  H._PSL...\._PR_C
  09d0: 50 55 30 08 5f 54 53 50 0a 3c 08 5f 54 43 31 0a  PU0._TSP.<._TC1.
  09e0: 04 08 5f 54 43 32 0a 03 14 1e 5f 50 53 56 00 a0  .._TC2...._PSV..
  09f0: 10 7d 50 4c 43 59 50 4c 43 59 67 a4 54 50 31 48  .}PLCYPLCYg.TP1H
  0a00: a1 06 a4 54 50 32 48 14 0b 5f 43 52 54 00 a4 54  ...TP2H.._CRT..T
  0a10: 52 50 43 14 1f 5f 54 4d 50 00 7b 53 45 4e 46 0a  RPC.._TMP.{SENF.
  0a20: 01 66 a0 0a 93 66 0a 01 a4 52 54 4d 50 a1 05 a4  .f...f...RTMP...
  0a30: 0b 86 0b 14 24 5f 53 43 50 01 a0 08 68 70 01 50  ....$_SCP...hp.P
  0a40: 4c 43 59 a1 07 70 00 50 4c 43 59 86 5c 2e 5f 54  LCY..p.PLCY.\._T
  0a50: 5a 5f 54 48 52 4d 0a 81 14 31 53 54 4d 50 02 70  Z_THRM...1STMP.p
  0a60: 69 44 57 30 30 a0 12 68 53 54 48 59 44 42 30 30  iDW00..hSTHYDB00
  0a70: 44 42 30 31 44 57 30 30 a1 11 53 54 4f 53 44 42  DB01DW00..STOSDB
  0a80: 30 30 44 42 30 31 44 57 30 30 10 4c 0f 5c 5f 47  00DB01DW00.L.\_G
  0a90: 50 45 14 18 5f 4c 30 30 00 86 5c 2f 03 5f 53 42  PE.._L00..\/._SB
  0aa0: 5f 50 43 49 30 48 55 42 30 0a 02 14 18 5f 4c 30  _PCI0HUB0...._L0
  0ab0: 33 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55 41  3..\/._SB_PCI0UA
  0ac0: 52 31 0a 02 14 18 5f 4c 30 42 00 86 5c 2f 03 5f  R1...._L0B..\/._
  0ad0: 53 42 5f 50 43 49 30 4d 4d 41 43 0a 02 14 18 5f  SB_PCI0MMAC...._
  0ae0: 4c 30 44 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30  L0D..\/._SB_PCI0
  0af0: 55 53 42 30 0a 02 14 18 5f 4c 30 43 00 86 5c 2f  USB0...._L0C..\/
  0b00: 03 5f 53 42 5f 50 43 49 30 55 53 42 31 0a 02 14  ._SB_PCI0USB1...
  0b10: 18 5f 4c 30 35 00 86 5c 2f 03 5f 53 42 5f 50 43  ._L05..\/._SB_PC
  0b20: 49 30 55 53 42 32 0a 02 14 18 5f 4c 30 46 00 86  I0USB2...._L0F..
  0b30: 5c 2f 03 5f 53 42 5f 50 43 49 30 46 31 33 39 0a  \/._SB_PCI0F139.
  0b40: 02 14 18 5f 4c 30 41 00 86 5c 2f 03 5f 53 42 5f  ..._L0A..\/._SB_
  0b50: 50 43 49 30 48 55 42 31 0a 02 14 13 5f 4c 30 31  PCI0HUB1...._L01
  0b60: 00 86 5c 2e 5f 53 42 5f 53 4c 50 42 0a 80 14 18  ..\._SB_SLPB....
  0b70: 5f 4c 30 37 00 86 5c 2f 03 5f 53 42 5f 50 43 49  _L07..\/._SB_PCI
  0b80: 30 4d 4d 43 49 0a 02 10 8c 13 04 5c 5f 53 42 5f  0MMCI......\_SB_
  0b90: 5b 82 42 18 50 4d 49 4f 08 5f 48 49 44 0c 41 d0  [.B.PMIO._HID.A.
  0ba0: 0c 02 08 5f 55 49 44 0a 03 14 4a 16 5f 43 52 53  ..._UID...J._CRS
  0bb0: 00 08 49 4f 44 4d 11 0d 0a 0a 47 01 00 00 00 00  ..IODM....G.....
  0bc0: 00 00 79 00 08 49 4f 52 54 11 35 0a 32 47 01 00  ..y..IORT.5.2G..
  0bd0: 00 00 00 01 80 47 01 00 00 00 00 01 80 47 01 00  .....G.......G..
  0be0: 00 00 00 01 80 47 01 00 00 00 00 01 80 47 01 00  .....G.......G..
  0bf0: 00 00 00 01 80 47 01 00 00 00 00 01 80 79 00 8b  .....G.......y..
  0c00: 49 4f 52 54 0a 02 49 31 4d 4e 8b 49 4f 52 54 0a  IORT..I1MN.IORT.
  0c10: 04 49 31 4d 58 8b 49 4f 52 54 0a 0a 49 32 4d 4e  .I1MX.IORT..I2MN
  0c20: 8b 49 4f 52 54 0a 0c 49 32 4d 58 8b 49 4f 52 54  .IORT..I2MX.IORT
  0c30: 0a 12 49 33 4d 4e 8b 49 4f 52 54 0a 14 49 33 4d  ..I3MN.IORT..I3M
  0c40: 58 8b 49 4f 52 54 0a 1a 49 34 4d 4e 8b 49 4f 52  X.IORT..I4MN.IOR
  0c50: 54 0a 1c 49 34 4d 58 8b 49 4f 52 54 0a 22 49 35  T..I4MX.IORT."I5
  0c60: 4d 4e 8b 49 4f 52 54 0a 24 49 35 4d 58 8b 49 4f  MN.IORT.$I5MX.IO
  0c70: 52 54 0a 2a 49 36 4d 4e 8b 49 4f 52 54 0a 2c 49  RT.*I6MN.IORT.,I
  0c80: 36 4d 58 7b 50 4d 42 52 0b fc ff 49 31 4d 4e 70  6MX{PMBR...I1MNp
  0c90: 49 31 4d 4e 49 31 4d 58 72 49 31 4d 4e 0a 80 60  I1MNI1MXrI1MN..`
  0ca0: 70 60 49 32 4d 4e 70 60 49 32 4d 58 7b 4e 56 53  p`I2MNp`I2MX{NVS
  0cb0: 42 0b fc ff 49 33 4d 4e 70 49 33 4d 4e 49 33 4d  B...I3MNpI3MNI3M
  0cc0: 58 72 49 33 4d 4e 0a 80 60 70 60 49 34 4d 4e 70  XrI3MN..`p`I4MNp
  0cd0: 60 49 34 4d 58 7b 41 4e 4c 47 0b fc ff 49 35 4d  `I4MX{ANLG...I5M
  0ce0: 4e 70 49 35 4d 4e 49 35 4d 58 72 49 35 4d 4e 0a  NpI5MNI5MXrI5MN.
  0cf0: 80 60 70 60 49 36 4d 4e 70 60 49 36 4d 58 a0 0b  .`p`I6MNp`I6MX..
  0d00: 49 31 4d 4e 70 49 4f 52 54 60 a1 07 70 49 4f 44  I1MNpIORT`..pIOD
  0d10: 4d 60 a4 60 5b 82 31 53 4d 49 4f 08 5f 48 49 44  M`.`[.1SMIO._HID
  0d20: 0c 41 d0 0c 02 08 5f 55 49 44 0a 04 08 5f 43 52  .A...._UID..._CR
  0d30: 53 11 15 0a 12 47 01 00 50 00 50 01 40 47 01 00  S....G..P.P.@G..
  0d40: 51 00 51 01 40 79 00 5b 82 19 50 57 52 42 08 5f  Q.Q.@y.[..PWRB._
  0d50: 48 49 44 0c 41 d0 0c 0c 14 09 5f 53 54 41 00 a4  HID.A....._STA..
  0d60: 0a 0b 5b 82 25 53 4c 50 42 08 5f 48 49 44 0c 41  ..[.%SLPB._HID.A
  0d70: d0 0c 0e 14 09 5f 53 54 41 00 a4 0a 0b 08 5f 50  ....._STA....._P
  0d80: 52 57 12 06 02 0a 01 0a 05 5b 82 4a 1c 4d 45 4d  RW.......[.J.MEM
  0d90: 5f 08 5f 48 49 44 0c 41 d0 0c 01 14 49 1b 5f 43  _._HID.A....I._C
  0da0: 52 53 00 08 42 55 46 30 11 4e 07 0a 7a 86 09 00  RS..BUF0.N..z...
  0db0: 01 00 00 0f 00 00 40 00 00 86 09 00 01 00 40 0f  ......@.......@.
  0dc0: 00 00 40 00 00 86 09 00 01 00 80 0f 00 00 40 00  ..@...........@.
  0dd0: 00 86 09 00 01 00 c0 0f 00 00 40 00 00 86 09 00  ..........@.....
  0de0: 01 00 00 00 00 00 00 01 00 86 09 00 01 00 00 ff  ................
  0df0: ff 00 00 01 00 86 09 00 01 00 00 00 00 00 00 0a  ................
  0e00: 00 86 09 00 01 00 00 10 00 00 00 00 00 86 09 00  ................
  0e10: 01 00 00 c0 fe 00 10 00 00 86 09 00 01 00 00 e0  ................
  0e20: fe 00 10 00 00 79 00 8a 42 55 46 30 0a 34 41 43  .....y..BUF0.4AC
  0e30: 4d 4d 8a 42 55 46 30 0a 04 52 4d 41 31 8a 42 55  MM.BUF0..RMA1.BU
  0e40: 46 30 0a 08 52 53 53 31 8a 42 55 46 30 0a 10 52  F0..RSS1.BUF0..R
  0e50: 4d 41 32 8a 42 55 46 30 0a 14 52 53 53 32 8a 42  MA2.BUF0..RSS2.B
  0e60: 55 46 30 0a 1c 52 4d 41 33 8a 42 55 46 30 0a 20  UF0..RMA3.BUF0. 
  0e70: 52 53 53 33 8a 42 55 46 30 0a 28 52 4d 41 34 8a  RSS3.BUF0.(RMA4.
  0e80: 42 55 46 30 0a 2c 52 53 53 34 8a 42 55 46 30 0a  BUF0.,RSS4.BUF0.
  0e90: 5c 45 58 54 4d 74 41 4d 45 4d 0c 00 00 10 00 45  \EXTMtAMEM.....E
  0ea0: 58 54 4d a0 35 92 93 52 4f 4d 31 00 70 52 4d 41  XTM.5..ROM1.pRMA
  0eb0: 31 52 4d 41 32 79 52 4f 4d 31 0a 08 60 70 60 52  1RMA2yROM1..`p`R
  0ec0: 4d 41 31 79 52 4d 53 31 0a 08 60 70 60 52 53 53  MA1yRMS1..`p`RSS
  0ed0: 31 70 0b 00 80 52 53 53 32 a0 35 92 93 52 4f 4d  1p...RSS2.5..ROM
  0ee0: 32 00 70 52 4d 41 32 52 4d 41 33 79 52 4f 4d 32  2.pRMA2RMA3yROM2
  0ef0: 0a 08 60 70 60 52 4d 41 32 79 52 4d 53 32 0a 08  ..`p`RMA2yRMS2..
  0f00: 60 70 60 52 53 53 32 70 0b 00 c0 52 53 53 33 a0  `p`RSS2p...RSS3.
  0f10: 37 92 93 52 4f 4d 33 00 70 52 4d 41 33 52 4d 41  7..ROM3.pRMA3RMA
  0f20: 34 79 52 4f 4d 33 0a 08 60 70 60 52 4d 41 33 79  4yROM3..`p`RMA3y
  0f30: 52 4d 53 33 0a 08 60 70 60 52 53 53 33 70 0c 00  RMS3..`p`RSS3p..
  0f40: 00 01 00 52 53 53 34 70 41 4d 45 4d 41 43 4d 4d  ...RSS4pAMEMACMM
  0f50: a4 42 55 46 30 5b 82 8d d6 03 50 43 49 30 08 5f  .BUF0[....PCI0._
  0f60: 48 49 44 0c 41 d0 0a 03 08 5f 41 44 52 0a 00 08  HID.A...._ADR...
  0f70: 5f 55 49 44 0a 01 08 5f 42 42 4e 0a 00 08 4e 41  _UID..._BBN...NA
  0f80: 54 41 12 07 01 0c 00 00 09 00 14 17 53 53 33 44  TA..........SS3D
  0f90: 00 a0 0b 93 4f 53 46 4c 0a 02 a4 0a 02 a1 04 a4  ....OSFL........
  0fa0: 0a 03 14 09 5f 53 54 41 00 a4 0a 0f 5b 80 4c 44  ...._STA....[.LD
  0fb0: 54 33 02 0a 6c 0a 04 5b 81 0b 4c 44 54 33 03 55  T3..l..[..LDT3.U
  0fc0: 43 46 47 20 5b 80 53 32 4b 43 02 0a e4 0a 04 5b  CFG [.S2KC.....[
  0fd0: 81 0b 53 32 4b 43 03 43 54 4c 30 20 14 48 0d 5f  ..S2KC.CTL0 .H._
  0fe0: 43 52 53 00 08 42 55 46 30 11 44 09 0a 90 88 0d  CRS..BUF0.D.....
  0ff0: 00 02 01 00 00 00 00 00 ff 00 00 00 00 01 47 01  ..............G.
  1000: f8 0c f8 0c 01 08 47 01 f0 0c f0 0c 01 04 88 0d  ......G.........
  1010: 00 01 0c 03 00 00 00 00 f7 0c 00 00 f8 0c 88 0d  ................
  1020: 00 01 0c 03 00 00 00 0d ff ff 00 00 00 f3 87 17  ................
  1030: 00 00 0c 03 00 00 00 00 00 00 0a 00 ff ff 0b 00  ................
  1040: 00 00 00 00 00 00 02 00 87 17 00 00 0c 03 00 00  ................
  1050: 00 00 00 00 0c 00 ff ff 0d 00 00 00 00 00 00 00  ................
  1060: 02 00 87 17 00 00 0c 03 00 00 00 00 00 00 10 00  ................
  1070: ff ff bf fe 00 00 00 00 00 00 f0 ff 79 00 8a 42  ............y..B
  1080: 55 46 30 0a 7e 54 43 4d 4d 8a 42 55 46 30 0a 8a  UF0.~TCMM.BUF0..
  1090: 54 4f 4d 4d 72 41 4d 45 4d 0c 00 00 01 00 54 43  TOMMrAMEM.....TC
  10a0: 4d 4d 74 0c 00 00 c0 fe 54 43 4d 4d 54 4f 4d 4d  MMt.....TCMMTOMM
  10b0: a4 42 55 46 30 08 50 49 43 4d 12 4e 1e 13 12 0f  .BUF0.PICM.N....
  10c0: 04 0c ff ff 01 00 0a 00 4c 53 4d 42 0a 00 12 0f  ........LSMB....
  10d0: 04 0c ff ff 01 00 0a 01 4c 53 4d 42 0a 00 12 1a  ........LSMB....
  10e0: 04 0c ff ff 02 00 0a 00 5c 2f 03 5f 53 42 5f 50  ........\/._SB_P
  10f0: 43 49 30 4c 55 42 41 0a 00 12 1a 04 0c ff ff 02  CI0LUBA.........
  1100: 00 0a 01 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 55  ...\/._SB_PCI0LU
  1110: 42 42 0a 00 12 1a 04 0c ff ff 02 00 0a 02 5c 2f  BB............\/
  1120: 03 5f 53 42 5f 50 43 49 30 4c 55 42 32 0a 00 12  ._SB_PCI0LUB2...
  1130: 1a 04 0c ff ff 04 00 0a 00 5c 2f 03 5f 53 42 5f  .........\/._SB_
  1140: 50 43 49 30 4c 4d 41 43 0a 00 12 1a 04 0c ff ff  PCI0LMAC........
  1150: 05 00 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30 4c  ....\/._SB_PCI0L
  1160: 41 50 55 0a 00 12 1a 04 0c ff ff 06 00 0a 00 5c  APU............\
  1170: 2f 03 5f 53 42 5f 50 43 49 30 4c 41 43 49 0a 00  /._SB_PCI0LACI..
  1180: 12 1a 04 0c ff ff 06 00 0a 01 5c 2f 03 5f 53 42  ..........\/._SB
  1190: 5f 50 43 49 30 4c 4d 43 49 0a 00 12 1a 04 0c ff  _PCI0LMCI.......
  11a0: ff 0d 00 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  11b0: 4c 46 49 52 0a 00 12 1a 04 0c ff ff 09 00 0a 00  LFIR............
  11c0: 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 49 44 45 0a  \/._SB_PCI0LIDE.
  11d0: 00 12 1a 04 0c ff ff 08 00 0a 00 5c 2f 03 5f 53  ...........\/._S
  11e0: 42 5f 50 43 49 30 4c 4e 4b 31 0a 00 12 1a 04 0c  B_PCI0LNK1......
  11f0: ff ff 08 00 0a 01 5c 2f 03 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  1200: 30 4c 4e 4b 32 0a 00 12 1a 04 0c ff ff 08 00 0a  0LNK2...........
  1210: 02 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 33  .\/._SB_PCI0LNK3
  1220: 0a 00 12 1a 04 0c ff ff 08 00 0a 03 5c 2f 03 5f  ............\/._
  1230: 53 42 5f 50 43 49 30 4c 4e 4b 34 0a 00 12 1a 04  SB_PCI0LNK4.....
  1240: 0c ff ff 1e 00 0a 00 5c 2f 03 5f 53 42 5f 50 43  .......\/._SB_PC
  1250: 49 30 4c 4e 4b 35 0a 00 12 1a 04 0c ff ff 1e 00  I0LNK5..........
  1260: 0a 01 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b  ..\/._SB_PCI0LNK
  1270: 35 0a 00 12 1a 04 0c ff ff 1e 00 0a 02 5c 2f 03  5............\/.
  1280: 5f 53 42 5f 50 43 49 30 4c 4e 4b 35 0a 00 12 1a  _SB_PCI0LNK5....
  1290: 04 0c ff ff 1e 00 0a 03 5c 2f 03 5f 53 42 5f 50  ........\/._SB_P
  12a0: 43 49 30 4c 4e 4b 35 0a 00 08 41 50 49 43 12 4c  CI0LNK5...APIC.L
  12b0: 12 0b 12 1a 04 0c ff ff 01 00 0a 00 5c 2f 03 5f  ............\/._
  12c0: 53 42 5f 50 43 49 30 41 50 43 53 0a 00 12 1a 04  SB_PCI0APCS.....
  12d0: 0c ff ff 01 00 0a 01 5c 2f 03 5f 53 42 5f 50 43  .......\/._SB_PC
  12e0: 49 30 41 50 43 53 0a 00 12 1a 04 0c ff ff 02 00  I0APCS..........
  12f0: 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30 41 50 43  ..\/._SB_PCI0APC
  1300: 46 0a 00 12 1a 04 0c ff ff 02 00 0a 01 5c 2f 03  F............\/.
  1310: 5f 53 42 5f 50 43 49 30 41 50 43 47 0a 00 12 1a  _SB_PCI0APCG....
  1320: 04 0c ff ff 02 00 0a 02 5c 2f 03 5f 53 42 5f 50  ........\/._SB_P
  1330: 43 49 30 41 50 43 4c 0a 00 12 1a 04 0c ff ff 04  CI0APCL.........
  1340: 00 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30 41 50  ...\/._SB_PCI0AP
  1350: 43 48 0a 00 12 1a 04 0c ff ff 05 00 0a 00 5c 2f  CH............\/
  1360: 03 5f 53 42 5f 50 43 49 30 41 50 43 49 0a 00 12  ._SB_PCI0APCI...
  1370: 1a 04 0c ff ff 06 00 0a 00 5c 2f 03 5f 53 42 5f  .........\/._SB_
  1380: 50 43 49 30 41 50 43 4a 0a 00 12 1a 04 0c ff ff  PCI0APCJ........
  1390: 06 00 0a 01 5c 2f 03 5f 53 42 5f 50 43 49 30 41  ....\/._SB_PCI0A
  13a0: 50 43 4b 0a 00 12 1a 04 0c ff ff 0d 00 0a 00 5c  PCK............\
  13b0: 2f 03 5f 53 42 5f 50 43 49 30 41 50 43 4d 0a 00  /._SB_PCI0APCM..
  13c0: 12 1a 04 0c ff ff 09 00 0a 00 5c 2f 03 5f 53 42  ..........\/._SB
  13d0: 5f 50 43 49 30 41 50 43 5a 0a 00 14 19 5f 50 52  _PCI0APCZ...._PR
  13e0: 54 00 a0 0b 92 50 49 43 46 a4 50 49 43 4d a1 06  T....PICF.PICM..
  13f0: a4 41 50 49 43 5b 82 4a 63 48 55 42 30 08 5f 41  .APIC[.JcHUB0._A
  1400: 44 52 0c 00 00 08 00 14 09 5f 53 54 41 00 a4 0a  DR......._STA...
  1410: 0f 08 50 49 43 4d 12 47 2f 1c 12 1a 04 0c ff ff  ..PICM.G/.......
  1420: 06 00 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30 4c  ....\/._SB_PCI0L
  1430: 4e 4b 31 0a 00 12 1a 04 0c ff ff 06 00 0a 01 5c  NK1............\
  1440: 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 32 0a 00  /._SB_PCI0LNK2..
  1450: 12 1a 04 0c ff ff 06 00 0a 02 5c 2f 03 5f 53 42  ..........\/._SB
  1460: 5f 50 43 49 30 4c 4e 4b 33 0a 00 12 1a 04 0c ff  _PCI0LNK3.......
  1470: ff 06 00 0a 03 5c 2f 03 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  1480: 4c 4e 4b 34 0a 00 12 1a 04 0c ff ff 07 00 0a 00  LNK4............
  1490: 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 32 0a  \/._SB_PCI0LNK2.
  14a0: 00 12 1a 04 0c ff ff 07 00 0a 01 5c 2f 03 5f 53  ...........\/._S
  14b0: 42 5f 50 43 49 30 4c 4e 4b 33 0a 00 12 1a 04 0c  B_PCI0LNK3......
  14c0: ff ff 07 00 0a 02 5c 2f 03 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  14d0: 30 4c 4e 4b 34 0a 00 12 1a 04 0c ff ff 07 00 0a  0LNK4...........
  14e0: 03 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 31  .\/._SB_PCI0LNK1
  14f0: 0a 00 12 1a 04 0c ff ff 08 00 0a 00 5c 2f 03 5f  ............\/._
  1500: 53 42 5f 50 43 49 30 4c 4e 4b 33 0a 00 12 1a 04  SB_PCI0LNK3.....
  1510: 0c ff ff 08 00 0a 01 5c 2f 03 5f 53 42 5f 50 43  .......\/._SB_PC
  1520: 49 30 4c 4e 4b 34 0a 00 12 1a 04 0c ff ff 08 00  I0LNK4..........
  1530: 0a 02 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b  ..\/._SB_PCI0LNK
  1540: 31 0a 00 12 1a 04 0c ff ff 08 00 0a 03 5c 2f 03  1............\/.
  1550: 5f 53 42 5f 50 43 49 30 4c 4e 4b 32 0a 00 12 1a  _SB_PCI0LNK2....
  1560: 04 0c ff ff 09 00 0a 00 5c 2f 03 5f 53 42 5f 50  ........\/._SB_P
  1570: 43 49 30 4c 4e 4b 34 0a 00 12 1a 04 0c ff ff 09  CI0LNK4.........
  1580: 00 0a 01 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e  ...\/._SB_PCI0LN
  1590: 4b 31 0a 00 12 1a 04 0c ff ff 09 00 0a 02 5c 2f  K1............\/
  15a0: 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 32 0a 00 12  ._SB_PCI0LNK2...
  15b0: 1a 04 0c ff ff 09 00 0a 03 5c 2f 03 5f 53 42 5f  .........\/._SB_
  15c0: 50 43 49 30 4c 4e 4b 33 0a 00 12 1a 04 0c ff ff  PCI0LNK3........
  15d0: 0a 00 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30 4c  ....\/._SB_PCI0L
  15e0: 4e 4b 31 0a 00 12 1a 04 0c ff ff 0a 00 0a 01 5c  NK1............\
  15f0: 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 32 0a 00  /._SB_PCI0LNK2..
  1600: 12 1a 04 0c ff ff 0a 00 0a 02 5c 2f 03 5f 53 42  ..........\/._SB
  1610: 5f 50 43 49 30 4c 4e 4b 33 0a 00 12 1a 04 0c ff  _PCI0LNK3.......
  1620: ff 0a 00 0a 03 5c 2f 03 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  1630: 4c 4e 4b 34 0a 00 12 1a 04 0c ff ff 0b 00 0a 00  LNK4............
  1640: 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 32 0a  \/._SB_PCI0LNK2.
  1650: 00 12 1a 04 0c ff ff 0b 00 0a 01 5c 2f 03 5f 53  ...........\/._S
  1660: 42 5f 50 43 49 30 4c 4e 4b 33 0a 00 12 1a 04 0c  B_PCI0LNK3......
  1670: ff ff 0b 00 0a 02 5c 2f 03 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  1680: 30 4c 4e 4b 34 0a 00 12 1a 04 0c ff ff 0b 00 0a  0LNK4...........
  1690: 03 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 31  .\/._SB_PCI0LNK1
  16a0: 0a 00 12 1a 04 0c ff ff 0c 00 0a 00 5c 2f 03 5f  ............\/._
  16b0: 53 42 5f 50 43 49 30 4c 4e 4b 33 0a 00 12 1a 04  SB_PCI0LNK3.....
  16c0: 0c ff ff 0c 00 0a 01 5c 2f 03 5f 53 42 5f 50 43  .......\/._SB_PC
  16d0: 49 30 4c 4e 4b 34 0a 00 12 1a 04 0c ff ff 0c 00  I0LNK4..........
  16e0: 0a 02 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b  ..\/._SB_PCI0LNK
  16f0: 31 0a 00 12 1a 04 0c ff ff 0c 00 0a 03 5c 2f 03  1............\/.
  1700: 5f 53 42 5f 50 43 49 30 4c 4e 4b 32 0a 00 08 41  _SB_PCI0LNK2...A
  1710: 50 49 43 12 47 2f 1c 12 1a 04 0c ff ff 06 00 0a  PIC.G/..........
  1720: 00 5c 2f 03 5f 53 42 5f 50 43 49 30 41 50 43 31  .\/._SB_PCI0APC1
  1730: 0a 00 12 1a 04 0c ff ff 06 00 0a 01 5c 2f 03 5f  ............\/._
  1740: 53 42 5f 50 43 49 30 41 50 43 32 0a 00 12 1a 04  SB_PCI0APC2.....
  1750: 0c ff ff 06 00 0a 02 5c 2f 03 5f 53 42 5f 50 43  .......\/._SB_PC
  1760: 49 30 41 50 43 33 0a 00 12 1a 04 0c ff ff 06 00  I0APC3..........
  1770: 0a 03 5c 2f 03 5f 53 42 5f 50 43 49 30 41 50 43  ..\/._SB_PCI0APC
  1780: 34 0a 00 12 1a 04 0c ff ff 07 00 0a 00 5c 2f 03  4............\/.
  1790: 5f 53 42 5f 50 43 49 30 41 50 43 32 0a 00 12 1a  _SB_PCI0APC2....
  17a0: 04 0c ff ff 07 00 0a 01 5c 2f 03 5f 53 42 5f 50  ........\/._SB_P
  17b0: 43 49 30 41 50 43 33 0a 00 12 1a 04 0c ff ff 07  CI0APC3.........
  17c0: 00 0a 02 5c 2f 03 5f 53 42 5f 50 43 49 30 41 50  ...\/._SB_PCI0AP
  17d0: 43 34 0a 00 12 1a 04 0c ff ff 07 00 0a 03 5c 2f  C4............\/
  17e0: 03 5f 53 42 5f 50 43 49 30 41 50 43 31 0a 00 12  ._SB_PCI0APC1...
  17f0: 1a 04 0c ff ff 08 00 0a 00 5c 2f 03 5f 53 42 5f  .........\/._SB_
  1800: 50 43 49 30 41 50 43 33 0a 00 12 1a 04 0c ff ff  PCI0APC3........
  1810: 08 00 0a 01 5c 2f 03 5f 53 42 5f 50 43 49 30 41  ....\/._SB_PCI0A
  1820: 50 43 34 0a 00 12 1a 04 0c ff ff 08 00 0a 02 5c  PC4............\
  1830: 2f 03 5f 53 42 5f 50 43 49 30 41 50 43 31 0a 00  /._SB_PCI0APC1..
  1840: 12 1a 04 0c ff ff 08 00 0a 03 5c 2f 03 5f 53 42  ..........\/._SB
  1850: 5f 50 43 49 30 41 50 43 32 0a 00 12 1a 04 0c ff  _PCI0APC2.......
  1860: ff 09 00 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  1870: 41 50 43 34 0a 00 12 1a 04 0c ff ff 09 00 0a 01  APC4............
  1880: 5c 2f 03 5f 53 42 5f 50 43 49 30 41 50 43 31 0a  \/._SB_PCI0APC1.
  1890: 00 12 1a 04 0c ff ff 09 00 0a 02 5c 2f 03 5f 53  ...........\/._S
  18a0: 42 5f 50 43 49 30 41 50 43 32 0a 00 12 1a 04 0c  B_PCI0APC2......
  18b0: ff ff 09 00 0a 03 5c 2f 03 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  18c0: 30 41 50 43 33 0a 00 12 1a 04 0c ff ff 0a 00 0a  0APC3...........
  18d0: 00 5c 2f 03 5f 53 42 5f 50 43 49 30 41 50 43 31  .\/._SB_PCI0APC1
  18e0: 0a 00 12 1a 04 0c ff ff 0a 00 0a 01 5c 2f 03 5f  ............\/._
  18f0: 53 42 5f 50 43 49 30 41 50 43 32 0a 00 12 1a 04  SB_PCI0APC2.....
  1900: 0c ff ff 0a 00 0a 02 5c 2f 03 5f 53 42 5f 50 43  .......\/._SB_PC
  1910: 49 30 41 50 43 33 0a 00 12 1a 04 0c ff ff 0a 00  I0APC3..........
  1920: 0a 03 5c 2f 03 5f 53 42 5f 50 43 49 30 41 50 43  ..\/._SB_PCI0APC
  1930: 34 0a 00 12 1a 04 0c ff ff 0b 00 0a 00 5c 2f 03  4............\/.
  1940: 5f 53 42 5f 50 43 49 30 41 50 43 32 0a 00 12 1a  _SB_PCI0APC2....
  1950: 04 0c ff ff 0b 00 0a 01 5c 2f 03 5f 53 42 5f 50  ........\/._SB_P
  1960: 43 49 30 41 50 43 33 0a 00 12 1a 04 0c ff ff 0b  CI0APC3.........
  1970: 00 0a 02 5c 2f 03 5f 53 42 5f 50 43 49 30 41 50  ...\/._SB_PCI0AP
  1980: 43 34 0a 00 12 1a 04 0c ff ff 0b 00 0a 03 5c 2f  C4............\/
  1990: 03 5f 53 42 5f 50 43 49 30 41 50 43 31 0a 00 12  ._SB_PCI0APC1...
  19a0: 1a 04 0c ff ff 0c 00 0a 00 5c 2f 03 5f 53 42 5f  .........\/._SB_
  19b0: 50 43 49 30 41 50 43 33 0a 00 12 1a 04 0c ff ff  PCI0APC3........
  19c0: 0c 00 0a 01 5c 2f 03 5f 53 42 5f 50 43 49 30 41  ....\/._SB_PCI0A
  19d0: 50 43 34 0a 00 12 1a 04 0c ff ff 0c 00 0a 02 5c  PC4............\
  19e0: 2f 03 5f 53 42 5f 50 43 49 30 41 50 43 31 0a 00  /._SB_PCI0APC1..
  19f0: 12 1a 04 0c ff ff 0c 00 0a 03 5c 2f 03 5f 53 42  ..........\/._SB
  1a00: 5f 50 43 49 30 41 50 43 32 0a 00 14 19 5f 50 52  _PCI0APC2...._PR
  1a10: 54 00 a0 0b 92 50 49 43 46 a4 50 49 43 4d a1 06  T....PICF.PICM..
  1a20: a4 41 50 49 43 08 5f 50 52 57 12 06 02 0a 00 0a  .APIC._PRW......
  1a30: 05 5b 82 48 70 49 44 45 30 08 5f 41 44 52 0c 00  .[.HpIDE0._ADR..
  1a40: 00 09 00 5b 80 41 30 39 30 02 0a 48 0a 20 5b 81  ...[.A090..H. [.
  1a50: 2d 41 30 39 30 03 49 52 45 47 02 00 3e 49 44 32  -A090.IREG..>ID2
  1a60: 30 10 00 30 49 44 54 53 10 49 44 54 50 10 49 44  0..0IDTS.IDTP.ID
  1a70: 32 32 20 55 4d 53 53 10 55 4d 53 50 10 08 49 44  22 UMSS.UMSP..ID
  1a80: 41 54 00 08 49 46 4c 47 0a 01 5b 84 43 05 49 53  AT..IFLG..[.C.IS
  1a90: 41 56 00 00 00 14 0b 5f 53 54 41 00 a4 49 46 4c  AV....._STA..IFL
  1aa0: 47 14 26 5f 4f 4e 5f 00 a0 1f 93 49 46 4c 47 0a  G.&_ON_....IFLG.
  1ab0: 00 70 0a 00 49 52 45 47 70 49 44 41 54 49 44 32  .p..IREGpIDATID2
  1ac0: 30 70 0a 01 49 46 4c 47 14 16 5f 4f 46 46 00 70  0p..IFLG.._OFF.p
  1ad0: 49 44 32 30 49 44 41 54 70 0a 00 49 46 4c 47 08  ID20IDATp..IFLG.
  1ae0: 5f 50 52 30 12 06 01 49 53 41 56 08 49 44 45 50  _PR0...ISAV.IDEP
  1af0: 11 03 0a 14 08 49 44 45 53 11 03 0a 14 14 48 16  .....IDES.....H.
  1b00: 47 54 4d 5f 01 a0 19 93 53 58 5f 5f 0a 01 a0 10  GTM_....SX__....
  1b10: 4f 53 46 4c 7d 5a 30 30 30 0a 01 5a 30 30 30 a0  OSFL}Z000..Z000.
  1b20: 17 93 68 0a 00 70 49 44 54 50 60 70 55 4d 53 50  ..h..pIDTP`pUMSP
  1b30: 61 70 49 44 45 50 62 a1 13 70 49 44 54 53 60 70  apIDEPb..pIDTS`p
  1b40: 55 4d 53 53 61 70 49 44 45 53 62 8a 62 0a 00 50  UMSSapIDESb.b..P
  1b50: 49 4f 30 8a 62 0a 04 44 4d 41 30 8a 62 0a 08 50  IO0.b..DMA0.b..P
  1b60: 49 4f 31 8a 62 0a 0c 44 4d 41 31 8a 62 0a 10 46  IO1.b..DMA1.b..F
  1b70: 4c 41 47 70 0a 10 46 4c 41 47 7b 60 0b 00 0f 63  LAGp..FLAG{`...c
  1b80: 7b 60 0b 00 f0 64 7a 63 0a 08 63 7a 64 0a 0c 64  {`...dzc..czd..d
  1b90: 72 63 64 63 77 72 63 0a 02 00 0a 1e 50 49 4f 30  rcdcwrc.....PIO0
  1ba0: a0 14 92 94 50 49 4f 30 0a b4 7d 46 4c 41 47 0a  ....PIO0..}FLAG.
  1bb0: 02 46 4c 41 47 a0 27 7b 61 0b 00 40 00 7d 46 4c  .FLAG.'{a..@.}FL
  1bc0: 41 47 0a 01 46 4c 41 47 7b 61 0b 00 07 63 7a 63  AG..FLAG{a...czc
  1bd0: 0a 08 63 70 55 32 54 5f 63 44 4d 41 30 a1 0a 70  ..cpU2T_cDMA0..p
  1be0: 50 49 4f 30 44 4d 41 30 7b 60 0a 0f 63 7b 60 0a  PIO0DMA0{`..c{`.
  1bf0: f0 64 7a 64 0a 04 64 72 63 64 63 77 72 63 0a 02  .dzd..drcdcwrc..
  1c00: 00 0a 1e 50 49 4f 31 a0 14 92 94 50 49 4f 31 0a  ...PIO1....PIO1.
  1c10: b4 7d 46 4c 41 47 0a 08 46 4c 41 47 a0 20 7b 61  .}FLAG..FLAG. {a
  1c20: 0a 40 00 7d 46 4c 41 47 0a 04 46 4c 41 47 7b 61  .@.}FLAG..FLAG{a
  1c30: 0a 07 63 70 55 32 54 5f 63 44 4d 41 31 a1 0a 70  ..cpU2T_cDMA1..p
  1c40: 50 49 4f 31 44 4d 41 31 a0 10 93 68 0a 00 70 62  PIO1DMA1...h..pb
  1c50: 49 44 45 50 a4 49 44 45 50 a1 0c 70 62 49 44 45  IDEP.IDEP..pbIDE
  1c60: 53 a4 49 44 45 53 14 49 04 55 32 54 5f 01 a0 08  S.IDES.I.U2T_...
  1c70: 93 68 0a 00 a4 0a 3c a0 08 93 68 0a 01 a4 0a 5a  .h....<...h....Z
  1c80: a0 08 93 68 0a 02 a4 0a 78 a0 08 93 68 0a 03 a4  ...h....x...h...
  1c90: 0a 96 a0 08 93 68 0a 04 a4 0a 2d a0 08 93 68 0a  .....h....-...h.
  1ca0: 05 a4 0a 1e a0 08 93 68 0a 06 a4 0a 14 a4 0a 0f  .......h........
  1cb0: 14 49 04 54 32 55 5f 01 a0 08 94 68 0a 78 a4 0a  .I.T2U_....h.x..
  1cc0: 03 a0 08 94 68 0a 5a a4 0a 02 a0 08 94 68 0a 3c  ....h.Z......h.<
  1cd0: a4 0a 01 a0 08 94 68 0a 2d a4 0a 00 a0 08 94 68  ......h.-......h
  1ce0: 0a 1e a4 0a 04 a0 08 94 68 0a 14 a4 0a 05 a0 08  ........h.......
  1cf0: 94 68 0a 0f a4 0a 06 a4 0a 07 14 42 04 54 32 44  .h.........B.T2D
  1d00: 5f 01 a0 09 94 68 0b e0 01 a4 0a a8 a0 09 94 68  _....h.........h
  1d10: 0b 86 01 a4 0a 77 a0 08 94 68 0a f0 a4 0a 47 a0  .....w...h....G.
  1d20: 08 94 68 0a b4 a4 0a 33 a0 08 94 68 0a 96 a4 0a  ..h....3...h....
  1d30: 22 a0 08 94 68 0a 78 a4 0a 21 a4 0a 20 14 43 1b  "...h.x..!.. .C.
  1d40: 53 54 4d 5f 04 a0 3b 53 58 5f 5f 70 53 49 44 30  STM_..;SX__pSID0
  1d50: 49 44 32 30 70 53 49 44 31 49 44 54 53 70 53 49  ID20pSID1IDTSpSI
  1d60: 44 32 49 44 54 50 70 53 49 44 33 49 44 32 32 70  D2IDTPpSID3ID22p
  1d70: 53 49 44 34 55 4d 53 53 70 53 49 44 35 55 4d 53  SID4UMSSpSID5UMS
  1d80: 50 a1 37 70 49 44 32 30 53 49 44 30 70 49 44 54  P.7pID20SID0pIDT
  1d90: 53 53 49 44 31 70 49 44 54 50 53 49 44 32 70 49  SSID1pIDTPSID2pI
  1da0: 44 32 32 53 49 44 33 70 55 4d 53 53 53 49 44 34  D22SID3pUMSSSID4
  1db0: 70 55 4d 53 50 53 49 44 35 70 0a 00 53 58 5f 5f  pUMSPSID5p..SX__
  1dc0: 8a 68 0a 00 50 49 4f 30 8a 68 0a 04 44 4d 41 30  .h..PIO0.h..DMA0
  1dd0: 8a 68 0a 08 50 49 4f 31 8a 68 0a 0c 44 4d 41 31  .h..PIO1.h..DMA1
  1de0: 8a 68 0a 10 46 4c 41 47 a0 11 93 6b 0a 00 70 53  .h..FLAG...k..pS
  1df0: 49 44 32 60 70 53 49 44 35 61 a1 0d 70 53 49 44  ID2`pSID5a..pSID
  1e00: 31 60 70 53 49 44 34 61 a0 21 92 93 50 49 4f 30  1`pSID4a.!..PIO0
  1e10: 0c ff ff ff ff 7b 60 0a ff 60 79 54 32 44 5f 50  .....{`..`yT2D_P
  1e20: 49 4f 30 0a 08 62 7d 60 62 60 a0 1d 92 93 50 49  IO0..b}`b`....PI
  1e30: 4f 31 0c ff ff ff ff 7b 60 0b 00 ff 60 7d 60 54  O1.....{`...`}`T
  1e40: 32 44 5f 50 49 4f 31 60 a0 24 7b 46 4c 41 47 0a  2D_PIO1`.${FLAG.
  1e50: 01 00 7b 61 0a ff 61 79 54 32 55 5f 44 4d 41 30  ..{a..ayT2U_DMA0
  1e60: 0a 08 62 7d 0b 00 c0 62 62 7d 62 61 61 a1 23 a0  ..b}...bb}baa.#.
  1e70: 21 92 93 44 4d 41 30 0c ff ff ff ff 7b 60 0a ff  !..DMA0.....{`..
  1e80: 60 79 54 32 44 5f 44 4d 41 30 0a 08 62 7d 60 62  `yT2D_DMA0..b}`b
  1e90: 60 a0 1f 7b 46 4c 41 47 0a 04 00 7b 61 0b 00 ff  `..{FLAG...{a...
  1ea0: 61 7d 0a c0 54 32 55 5f 44 4d 41 31 62 7d 62 61  a}..T2U_DMA1b}ba
  1eb0: 61 a1 1f a0 1d 92 93 44 4d 41 31 0c ff ff ff ff  a......DMA1.....
  1ec0: 7b 60 0b 00 ff 60 7d 60 54 32 44 5f 44 4d 41 31  {`...`}`T2D_DMA1
  1ed0: 60 a0 11 93 6b 0a 00 70 60 49 44 54 50 70 61 55  `...k..p`IDTPpaU
  1ee0: 4d 53 50 a1 0d 70 60 49 44 54 53 70 61 55 4d 53  MSP..p`IDTSpaUMS
  1ef0: 53 14 47 17 47 54 46 5f 02 70 11 0a 0a 07 03 00  S.G.GTF_.p......
  1f00: 00 00 00 a0 ef 60 8c 60 0a 01 4d 4f 44 45 8c 60  .....`.`..MODE.`
  1f10: 0a 05 44 52 49 56 70 69 44 52 49 56 a0 0b 93 68  ..DRIVpiDRIV...h
  1f20: 0a 00 70 49 44 45 50 61 a1 07 70 49 44 45 53 61  ..pIDEPa..pIDESa
  1f30: 8a 61 0a 00 50 49 4f 30 8a 61 0a 04 44 4d 41 30  .a..PIO0.a..DMA0
  1f40: 8a 61 0a 08 50 49 4f 31 8a 61 0a 0c 44 4d 41 31  .a..PIO1.a..DMA1
  1f50: 8a 61 0a 10 46 4c 47 58 a0 1c 93 69 0a a0 70 50  .a..FLGX...i..pP
  1f60: 49 4f 30 62 70 44 4d 41 30 63 7b 46 4c 47 58 0a  IO0bpDMA0c{FLGX.
  1f70: 01 46 4c 47 58 a1 18 70 50 49 4f 31 62 70 44 4d  .FLGX..pPIO1bpDM
  1f80: 41 31 63 7b 46 4c 47 58 0a 04 46 4c 47 58 70 46  A1c{FLGX..FLGXpF
  1f90: 4c 47 58 61 a0 0a 94 62 0b 86 01 70 0a 00 62 a1  LGXa...b...p..b.
  1fa0: 29 a0 09 94 62 0a f0 70 0a 01 62 a1 1d a0 09 94  )...b..p..b.....
  1fb0: 62 0a b4 70 0a 02 62 a1 11 a0 09 94 62 0a 78 70  b..p..b.....b.xp
  1fc0: 0a 03 62 a1 05 70 0a 04 62 7d 0a 08 62 4d 4f 44  ..b..p..b}..bMOD
  1fd0: 45 70 60 62 a0 4b 05 46 4c 47 58 a0 09 94 63 0a  Ep`b.K.FLGX...c.
  1fe0: 5a 70 0a 00 63 a1 42 04 a0 09 94 63 0a 3c 70 0a  Zp..c.B....c.<p.
  1ff0: 01 63 a1 35 a0 09 94 63 0a 2d 70 0a 02 63 a1 29  .c.5...c.-p..c.)
  2000: a0 09 94 63 0a 1e 70 0a 03 63 a1 1d a0 09 94 63  ...c..p..c.....c
  2010: 0a 14 70 0a 04 63 a1 11 a0 09 94 63 0a 0f 70 0a  ..p..c.....c..p.
  2020: 05 63 a1 05 70 0a 06 63 7d 0a 40 63 4d 4f 44 45  .c..p..c}.@cMODE
  2030: a1 32 a0 0a 93 63 0c ff ff ff ff a4 60 a1 25 a0  .2...c......`.%.
  2040: 09 94 63 0a 96 70 0a 00 63 a1 11 a0 09 94 63 0a  ..c..p..c.....c.
  2050: 78 70 0a 01 63 a1 05 70 0a 02 63 7d 0a 20 63 4d  xp..c..p..c}. cM
  2060: 4f 44 45 73 60 62 61 a4 61 5b 82 47 06 50 52 49  ODEs`ba.a[.G.PRI
  2070: 30 08 5f 41 44 52 0a 00 14 0d 5f 47 54 4d 00 a4  0._ADR...._GTM..
  2080: 47 54 4d 5f 0a 00 14 0f 5f 53 54 4d 03 53 54 4d  GTM_...._STM.STM
  2090: 5f 68 69 6a 0a 00 5b 82 1c 4d 41 53 54 08 5f 41  _hij..[..MAST._A
  20a0: 44 52 0a 00 14 0f 5f 47 54 46 00 a4 47 54 46 5f  DR...._GTF..GTF_
  20b0: 0a 00 0a a0 5b 82 1c 53 4c 41 56 08 5f 41 44 52  ....[..SLAV._ADR
  20c0: 0a 01 14 0f 5f 47 54 46 00 a4 47 54 46 5f 0a 00  ...._GTF..GTF_..
  20d0: 0a b0 5b 82 47 06 53 45 43 30 08 5f 41 44 52 0a  ..[.G.SEC0._ADR.
  20e0: 01 14 0d 5f 47 54 4d 00 a4 47 54 4d 5f 0a 01 14  ..._GTM..GTM_...
  20f0: 0f 5f 53 54 4d 03 53 54 4d 5f 68 69 6a 0a 01 5b  ._STM.STM_hij..[
  2100: 82 1c 4d 41 53 54 08 5f 41 44 52 0a 00 14 0f 5f  ..MAST._ADR...._
  2110: 47 54 46 00 a4 47 54 46 5f 0a 01 0a a0 5b 82 1c  GTF..GTF_....[..
  2120: 53 4c 41 56 08 5f 41 44 52 0a 01 14 0f 5f 47 54  SLAV._ADR...._GT
  2130: 46 00 a4 47 54 46 5f 0a 01 0a b0 5b 82 43 0e 41  F..GTF_....[.C.A
  2140: 47 50 42 08 5f 41 44 52 0c 00 00 1e 00 08 4f 4e  GPB._ADR......ON
  2150: 42 56 0a 00 08 50 49 43 4d 12 1b 01 12 18 04 0b  BV...PICM.......
  2160: ff ff 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30 4c  ....\/._SB_PCI0L
  2170: 4e 4b 35 0a 00 08 41 50 49 43 12 1b 01 12 18 04  NK5...APIC......
  2180: 0b ff ff 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  2190: 41 50 43 35 0a 00 08 41 47 50 30 12 1b 01 12 18  APC5...AGP0.....
  21a0: 04 0b ff ff 0a 00 5c 2f 03 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  21b0: 30 4c 4e 4b 34 0a 00 08 41 47 50 31 12 1b 01 12  0LNK4...AGP1....
  21c0: 18 04 0b ff ff 0a 00 5c 2f 03 5f 53 42 5f 50 43  .......\/._SB_PC
  21d0: 49 30 41 50 43 34 0a 00 14 39 5f 50 52 54 00 a0  I0APC4...9_PRT..
  21e0: 1b 92 50 49 43 46 a0 0d 93 4f 4e 42 56 0a 01 a4  ..PICF...ONBV...
  21f0: 50 49 43 4d a1 06 a4 41 47 50 30 a1 16 a0 0d 93  PICM...AGP0.....
  2200: 4f 4e 42 56 0a 01 a4 41 50 49 43 a1 06 a4 41 47  ONBV...APIC...AG
  2210: 50 31 5b 82 0c 56 47 41 47 08 5f 41 44 52 0a 00  P1[..VGAG._ADR..
  2220: 5b 82 40 12 48 55 42 31 08 5f 41 44 52 0c 00 00  [.@.HUB1._ADR...
  2230: 0c 00 08 50 49 43 4d 12 4f 06 04 12 1a 04 0c ff  ...PICM.O.......
  2240: ff 01 00 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  2250: 4c 33 43 4d 0a 00 12 1a 04 0c ff ff 01 00 0a 01  L3CM............
  2260: 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 33 43 4d 0a  \/._SB_PCI0L3CM.
  2270: 00 12 1a 04 0c ff ff 01 00 0a 02 5c 2f 03 5f 53  ...........\/._S
  2280: 42 5f 50 43 49 30 4c 33 43 4d 0a 00 12 1a 04 0c  B_PCI0L3CM......
  2290: ff ff 01 00 0a 03 5c 2f 03 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  22a0: 30 4c 33 43 4d 0a 00 08 41 50 49 43 12 4f 06 04  0L3CM...APIC.O..
  22b0: 12 1a 04 0c ff ff 01 00 0a 00 5c 2f 03 5f 53 42  ..........\/._SB
  22c0: 5f 50 43 49 30 41 50 33 43 0a 00 12 1a 04 0c ff  _PCI0AP3C.......
  22d0: ff 01 00 0a 01 5c 2f 03 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  22e0: 41 50 33 43 0a 00 12 1a 04 0c ff ff 01 00 0a 02  AP3C............
  22f0: 5c 2f 03 5f 53 42 5f 50 43 49 30 41 50 33 43 0a  \/._SB_PCI0AP3C.
  2300: 00 12 1a 04 0c ff ff 01 00 0a 03 5c 2f 03 5f 53  ...........\/._S
  2310: 42 5f 50 43 49 30 41 50 33 43 0a 00 14 19 5f 50  B_PCI0AP3C...._P
  2320: 52 54 00 a0 0b 92 50 49 43 46 a4 50 49 43 4d a1  RT....PICF.PICM.
  2330: 06 a4 41 50 49 43 08 5f 50 52 57 12 06 02 0a 0a  ..APIC._PRW.....
  2340: 0a 04 5b 82 4e 04 53 4d 42 30 08 5f 41 44 52 0c  ..[.N.SMB0._ADR.
  2350: 01 00 01 00 5b 80 53 4d 43 46 02 0a 48 0a 10 5b  ....[.SMCF..H..[
  2360: 81 1f 53 4d 43 46 03 53 4d 50 4d 04 53 4d 54 31  ..SMCF.SMPM.SMT1
  2370: 1c 53 4d 54 32 20 53 42 31 5f 20 53 42 32 5f 20  .SMT2 SB1_ SB2_ 
  2380: 14 11 53 4d 42 42 00 7b 53 42 31 5f 0b fe ff 60  ..SMBB.{SB1_...`
  2390: a4 60 5b 82 47 17 56 54 38 36 08 5f 41 44 52 0c  .`[.G.VT86._ADR.
  23a0: 00 00 01 00 5b 80 50 49 4f 30 02 0a 04 0a 20 10  ....[.PIO0.... .
  23b0: 29 5c 00 5b 81 24 5c 2f 04 5f 53 42 5f 50 43 49  )\.[.$\/._SB_PCI
  23c0: 30 56 54 38 36 50 49 4f 30 01 53 4d 45 4e 08 00  0VT86PIO0.SMEN..
  23d0: 48 05 00 08 53 4d 49 4f 08 10 46 0a 5c 00 5b 80  H...SMIO..F.\.[.
  23e0: 5c 2f 04 5f 53 42 5f 50 43 49 30 56 54 38 36 50  \/._SB_PCI0VT86P
  23f0: 36 30 5f 02 0a 60 0a 02 5b 81 1a 5c 2f 04 5f 53  60_..`..[..\/._S
  2400: 42 5f 50 43 49 30 56 54 38 36 50 36 30 5f 00 50  B_PCI0VT86P60_.P
  2410: 4d 42 52 10 5b 80 5c 2f 04 5f 53 42 5f 50 43 49  MBR.[.\/._SB_PCI
  2420: 30 56 54 38 36 50 36 34 5f 02 0a 64 0a 02 5b 81  0VT86P64_..d..[.
  2430: 1a 5c 2f 04 5f 53 42 5f 50 43 49 30 56 54 38 36  .\/._SB_PCI0VT86
  2440: 50 36 34 5f 00 4e 56 53 42 10 5b 80 5c 2f 04 5f  P64_.NVSB.[.\/._
  2450: 53 42 5f 50 43 49 30 56 54 38 36 50 36 38 5f 02  SB_PCI0VT86P68_.
  2460: 0a 68 0a 02 5b 81 1a 5c 2f 04 5f 53 42 5f 50 43  .h..[..\/._SB_PC
  2470: 49 30 56 54 38 36 50 36 38 5f 00 41 4e 4c 47 10  I0VT86P68_.ANLG.
  2480: 5b 80 50 49 52 51 02 0a 7c 0a 0c 10 4f 07 5c 00  [.PIRQ..|...O.\.
  2490: 5b 81 49 07 5c 2f 04 5f 53 42 5f 50 43 49 30 56  [.I.\/._SB_PCI0V
  24a0: 54 38 36 50 49 52 51 00 49 4e 54 41 04 49 4e 54  T86PIRQ.INTA.INT
  24b0: 42 04 49 4e 54 43 04 49 4e 54 44 04 49 4e 54 45  B.INTC.INTD.INTE
  24c0: 04 00 0c 53 43 49 49 04 54 43 4f 49 04 49 4e 54  ...SCII.TCOI.INT
  24d0: 46 04 49 4e 54 51 04 49 4e 54 55 04 49 4e 54 53  F.INTQ.INTU.INTS
  24e0: 04 00 08 49 4e 54 47 04 49 4e 54 48 04 49 4e 54  ...INTG.INTH.INT
  24f0: 4a 04 49 4e 54 4b 04 49 4e 54 4c 04 49 4e 54 4d  J.INTK.INTL.INTM
  2500: 04 49 4e 54 4e 04 49 4e 54 50 04 10 18 5c 00 14  .INTN.INTP...\..
  2510: 06 44 49 53 44 01 14 06 43 4b 49 4f 02 14 06 53  .DISD...CKIO...S
  2520: 4c 44 4d 02 5b 82 3d 55 53 42 30 08 5f 41 44 52  LDM.[.=USB0._ADR
  2530: 0c 00 00 02 00 14 09 5f 53 31 44 00 a4 0a 01 14  ......._S1D.....
  2540: 17 53 53 33 44 00 a0 0b 93 4f 53 46 4c 0a 02 a4  .SS3D....OSFL...
  2550: 0a 02 a1 04 a4 0a 03 08 5f 50 52 57 12 06 02 0a  ........_PRW....
  2560: 0d 0a 03 5b 82 3d 55 53 42 31 08 5f 41 44 52 0c  ...[.=USB1._ADR.
  2570: 01 00 02 00 14 09 5f 53 31 44 00 a4 0a 01 14 17  ......_S1D......
  2580: 53 53 33 44 00 a0 0b 93 4f 53 46 4c 0a 02 a4 0a  SS3D....OSFL....
  2590: 02 a1 04 a4 0a 03 08 5f 50 52 57 12 06 02 0a 0c  ......._PRW.....
  25a0: 0a 03 5b 82 42 06 55 53 42 32 08 5f 41 44 52 0c  ..[.B.USB2._ADR.
  25b0: 02 00 02 00 5b 80 50 30 32 30 02 0a 49 0a 01 5b  ....[.P020..I..[
  25c0: 81 0b 50 30 32 30 00 55 30 57 4b 01 14 19 5f 50  ..P020.U0WK..._P
  25d0: 53 57 01 a0 09 68 70 0a 01 55 30 57 4b a1 08 70  SW...hp..U0WK..p
  25e0: 0a 00 55 30 57 4b 14 09 5f 53 31 44 00 a4 0a 01  ..U0WK.._S1D....
  25f0: 14 09 53 53 33 44 00 a4 0a 01 08 5f 50 52 57 12  ..SS3D....._PRW.
  2600: 06 02 0a 05 0a 03 5b 82 3d 46 31 33 39 08 5f 41  ......[.=F139._A
  2610: 44 52 0c 00 00 0d 00 14 09 5f 53 31 44 00 a4 0a  DR......._S1D...
  2620: 01 14 17 53 53 33 44 00 a0 0b 93 4f 53 46 4c 0a  ...SS3D....OSFL.
  2630: 02 a4 0a 02 a1 04 a4 0a 03 08 5f 50 52 57 12 06  .........._PRW..
  2640: 02 0a 0f 0a 03 5b 82 1b 4d 4d 41 43 08 5f 41 44  .....[..MMAC._AD
  2650: 52 0c 00 00 04 00 08 5f 50 52 57 12 06 02 0a 0b  R......_PRW.....
  2660: 0a 05 5b 82 0f 4d 41 50 55 08 5f 41 44 52 0c 00  ..[..MAPU._ADR..
  2670: 00 05 00 5b 82 0f 4d 41 43 49 08 5f 41 44 52 0c  ...[..MACI._ADR.
  2680: 00 00 06 00 5b 82 1b 4d 4d 43 49 08 5f 41 44 52  ....[..MMCI._ADR
  2690: 0c 01 00 06 00 08 5f 50 52 57 12 06 02 0a 07 0a  ......_PRW......
  26a0: 05 08 42 55 46 41 11 09 0a 06 23 f8 dc 18 79 00  ..BUFA....#...y.
  26b0: 08 42 55 46 42 11 09 0a 06 23 00 00 18 79 00 8b  .BUFB....#...y..
  26c0: 42 55 46 42 0a 01 49 52 51 56 14 1e 43 52 53 5f  BUFB..IRQV..CRS_
  26d0: 01 a0 0a 68 79 0a 01 68 49 52 51 56 a1 07 70 00  ...hy..hIRQV..p.
  26e0: 49 52 51 56 a4 42 55 46 42 14 18 53 52 53 5f 01  IRQV.BUFB..SRS_.
  26f0: 8b 68 0a 01 49 52 51 30 82 49 52 51 30 60 76 60  .h..IRQ0.IRQ0`v`
  2700: a4 60 14 43 05 43 52 53 41 09 70 0a 00 60 a0 09  .`.C.CRSA.p..`..
  2710: 93 68 0a 08 70 0a 14 60 a0 09 93 68 0a 0d 70 0a  .h..p..`...h..p.
  2720: 15 60 a0 09 93 68 0a 02 70 0a 16 60 08 49 52 5a  .`...h..p..`.IRZ
  2730: 35 11 0e 0a 0b 89 06 00 09 01 07 00 00 00 79 00  5.............y.
  2740: 8b 49 52 5a 35 0a 05 49 4e 5a 35 70 60 49 4e 5a  .IRZ5..INZ5p`INZ
  2750: 35 a4 49 52 5a 35 14 3b 53 52 53 41 09 8b 68 0a  5.IRZ5.;SRSA..h.
  2760: 05 49 4e 5a 36 70 0a 08 60 a0 0c 93 49 4e 5a 36  .INZ6p..`...INZ6
  2770: 0a 14 70 0a 08 60 a0 0c 93 49 4e 5a 36 0a 15 70  ..p..`...INZ6..p
  2780: 0a 0d 60 a0 0c 93 49 4e 5a 36 0a 16 70 0a 02 60  ..`...INZ6..p..`
  2790: a4 60 5b 82 47 06 4c 4e 4b 31 08 5f 48 49 44 0c  .`[.G.LNK1._HID.
  27a0: 41 d0 0c 0f 08 5f 55 49 44 0a 01 14 14 5f 53 54  A...._UID...._ST
  27b0: 41 00 a0 08 49 4e 54 41 a4 0a 0b a1 04 a4 0a 09  A...INTA........
  27c0: 14 0b 5f 50 52 53 00 a4 42 55 46 41 14 0d 5f 44  .._PRS..BUFA.._D
  27d0: 49 53 00 70 0a 00 49 4e 54 41 14 0f 5f 43 52 53  IS.p..INTA.._CRS
  27e0: 00 a4 43 52 53 5f 49 4e 54 41 14 10 5f 53 52 53  ..CRS_INTA.._SRS
  27f0: 01 70 53 52 53 5f 68 49 4e 54 41 5b 82 47 06 4c  .pSRS_hINTA[.G.L
  2800: 4e 4b 32 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55  NK2._HID.A...._U
  2810: 49 44 0a 02 14 14 5f 53 54 41 00 a0 08 49 4e 54  ID...._STA...INT
  2820: 42 a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52 53 00  B.........._PRS.
  2830: a4 42 55 46 41 14 0d 5f 44 49 53 00 70 0a 00 49  .BUFA.._DIS.p..I
  2840: 4e 54 42 14 0f 5f 43 52 53 00 a4 43 52 53 5f 49  NTB.._CRS..CRS_I
  2850: 4e 54 42 14 10 5f 53 52 53 01 70 53 52 53 5f 68  NTB.._SRS.pSRS_h
  2860: 49 4e 54 42 5b 82 47 06 4c 4e 4b 33 08 5f 48 49  INTB[.G.LNK3._HI
  2870: 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 03 14 14 5f  D.A...._UID...._
  2880: 53 54 41 00 a0 08 49 4e 54 43 a4 0a 0b a1 04 a4  STA...INTC......
  2890: 0a 09 14 0b 5f 50 52 53 00 a4 42 55 46 41 14 0d  ...._PRS..BUFA..
  28a0: 5f 44 49 53 00 70 0a 00 49 4e 54 43 14 0f 5f 43  _DIS.p..INTC.._C
  28b0: 52 53 00 a4 43 52 53 5f 49 4e 54 43 14 10 5f 53  RS..CRS_INTC.._S
  28c0: 52 53 01 70 53 52 53 5f 68 49 4e 54 43 5b 82 47  RS.pSRS_hINTC[.G
  28d0: 06 4c 4e 4b 34 08 5f 48 49 44 0c 41 d0 0c 0f 08  .LNK4._HID.A....
  28e0: 5f 55 49 44 0a 04 14 14 5f 53 54 41 00 a0 08 49  _UID...._STA...I
  28f0: 4e 54 44 a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52  NTD.........._PR
  2900: 53 00 a4 42 55 46 41 14 0d 5f 44 49 53 00 70 0a  S..BUFA.._DIS.p.
  2910: 00 49 4e 54 44 14 0f 5f 43 52 53 00 a4 43 52 53  .INTD.._CRS..CRS
  2920: 5f 49 4e 54 44 14 10 5f 53 52 53 01 70 53 52 53  _INTD.._SRS.pSRS
  2930: 5f 68 49 4e 54 44 5b 82 47 06 4c 4e 4b 35 08 5f  _hINTD[.G.LNK5._
  2940: 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 05 14  HID.A...._UID...
  2950: 14 5f 53 54 41 00 a0 08 49 4e 54 45 a4 0a 0b a1  ._STA...INTE....
  2960: 04 a4 0a 09 14 0b 5f 50 52 53 00 a4 42 55 46 41  ......_PRS..BUFA
  2970: 14 0d 5f 44 49 53 00 70 0a 00 49 4e 54 45 14 0f  .._DIS.p..INTE..
  2980: 5f 43 52 53 00 a4 43 52 53 5f 49 4e 54 45 14 10  _CRS..CRS_INTE..
  2990: 5f 53 52 53 01 70 53 52 53 5f 68 49 4e 54 45 5b  _SRS.pSRS_hINTE[
  29a0: 82 47 06 4c 55 42 41 08 5f 48 49 44 0c 41 d0 0c  .G.LUBA._HID.A..
  29b0: 0f 08 5f 55 49 44 0a 06 14 14 5f 53 54 41 00 a0  .._UID...._STA..
  29c0: 08 49 4e 54 47 a4 0a 0b a1 04 a4 0a 09 14 0b 5f  .INTG.........._
  29d0: 50 52 53 00 a4 42 55 46 41 14 0d 5f 44 49 53 00  PRS..BUFA.._DIS.
  29e0: 70 0a 00 49 4e 54 47 14 0f 5f 43 52 53 00 a4 43  p..INTG.._CRS..C
  29f0: 52 53 5f 49 4e 54 47 14 10 5f 53 52 53 01 70 53  RS_INTG.._SRS.pS
  2a00: 52 53 5f 68 49 4e 54 47 5b 82 47 06 4c 55 42 42  RS_hINTG[.G.LUBB
  2a10: 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a  ._HID.A...._UID.
  2a20: 07 14 14 5f 53 54 41 00 a0 08 49 4e 54 48 a4 0a  ..._STA...INTH..
  2a30: 0b a1 04 a4 0a 09 14 0b 5f 50 52 53 00 a4 42 55  ........_PRS..BU
  2a40: 46 41 14 0d 5f 44 49 53 00 70 0a 00 49 4e 54 48  FA.._DIS.p..INTH
  2a50: 14 0f 5f 43 52 53 00 a4 43 52 53 5f 49 4e 54 48  .._CRS..CRS_INTH
  2a60: 14 10 5f 53 52 53 01 70 53 52 53 5f 68 49 4e 54  .._SRS.pSRS_hINT
  2a70: 48 5b 82 47 06 4c 4d 41 43 08 5f 48 49 44 0c 41  H[.G.LMAC._HID.A
  2a80: d0 0c 0f 08 5f 55 49 44 0a 08 14 14 5f 53 54 41  ...._UID...._STA
  2a90: 00 a0 08 49 4e 54 4a a4 0a 0b a1 04 a4 0a 09 14  ...INTJ.........
  2aa0: 0b 5f 50 52 53 00 a4 42 55 46 41 14 0d 5f 44 49  ._PRS..BUFA.._DI
  2ab0: 53 00 70 0a 00 49 4e 54 4a 14 0f 5f 43 52 53 00  S.p..INTJ.._CRS.
  2ac0: a4 43 52 53 5f 49 4e 54 4a 14 10 5f 53 52 53 01  .CRS_INTJ.._SRS.
  2ad0: 70 53 52 53 5f 68 49 4e 54 4a 5b 82 47 06 4c 41  pSRS_hINTJ[.G.LA
  2ae0: 50 55 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49  PU._HID.A...._UI
  2af0: 44 0a 09 14 14 5f 53 54 41 00 a0 08 49 4e 54 4b  D...._STA...INTK
  2b00: a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52 53 00 a4  .........._PRS..
  2b10: 42 55 46 41 14 0d 5f 44 49 53 00 70 0a 00 49 4e  BUFA.._DIS.p..IN
  2b20: 54 4b 14 0f 5f 43 52 53 00 a4 43 52 53 5f 49 4e  TK.._CRS..CRS_IN
  2b30: 54 4b 14 10 5f 53 52 53 01 70 53 52 53 5f 68 49  TK.._SRS.pSRS_hI
  2b40: 4e 54 4b 5b 82 47 06 4c 41 43 49 08 5f 48 49 44  NTK[.G.LACI._HID
  2b50: 0c 41 d0 0c 0f 08 5f 55 49 44 0a 0a 14 14 5f 53  .A...._UID...._S
  2b60: 54 41 00 a0 08 49 4e 54 4c a4 0a 0b a1 04 a4 0a  TA...INTL.......
  2b70: 09 14 0b 5f 50 52 53 00 a4 42 55 46 41 14 0d 5f  ..._PRS..BUFA.._
  2b80: 44 49 53 00 70 0a 00 49 4e 54 4c 14 0f 5f 43 52  DIS.p..INTL.._CR
  2b90: 53 00 a4 43 52 53 5f 49 4e 54 4c 14 10 5f 53 52  S..CRS_INTL.._SR
  2ba0: 53 01 70 53 52 53 5f 68 49 4e 54 4c 5b 82 47 06  S.pSRS_hINTL[.G.
  2bb0: 4c 4d 43 49 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f  LMCI._HID.A...._
  2bc0: 55 49 44 0a 0b 14 14 5f 53 54 41 00 a0 08 49 4e  UID...._STA...IN
  2bd0: 54 4d a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52 53  TM.........._PRS
  2be0: 00 a4 42 55 46 41 14 0d 5f 44 49 53 00 70 0a 00  ..BUFA.._DIS.p..
  2bf0: 49 4e 54 4d 14 0f 5f 43 52 53 00 a4 43 52 53 5f  INTM.._CRS..CRS_
  2c00: 49 4e 54 4d 14 10 5f 53 52 53 01 70 53 52 53 5f  INTM.._SRS.pSRS_
  2c10: 68 49 4e 54 4d 5b 82 47 06 4c 53 4d 42 08 5f 48  hINTM[.G.LSMB._H
  2c20: 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 0c 14 14  ID.A...._UID....
  2c30: 5f 53 54 41 00 a0 08 49 4e 54 46 a4 0a 0b a1 04  _STA...INTF.....
  2c40: a4 0a 09 14 0b 5f 50 52 53 00 a4 42 55 46 41 14  ....._PRS..BUFA.
  2c50: 0d 5f 44 49 53 00 70 0a 00 49 4e 54 46 14 0f 5f  ._DIS.p..INTF.._
  2c60: 43 52 53 00 a4 43 52 53 5f 49 4e 54 46 14 10 5f  CRS..CRS_INTF.._
  2c70: 53 52 53 01 70 53 52 53 5f 68 49 4e 54 46 5b 82  SRS.pSRS_hINTF[.
  2c80: 47 06 4c 55 42 32 08 5f 48 49 44 0c 41 d0 0c 0f  G.LUB2._HID.A...
  2c90: 08 5f 55 49 44 0a 0d 14 14 5f 53 54 41 00 a0 08  ._UID...._STA...
  2ca0: 49 4e 54 51 a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50  INTQ.........._P
  2cb0: 52 53 00 a4 42 55 46 41 14 0d 5f 44 49 53 00 70  RS..BUFA.._DIS.p
  2cc0: 0a 00 49 4e 54 51 14 0f 5f 43 52 53 00 a4 43 52  ..INTQ.._CRS..CR
  2cd0: 53 5f 49 4e 54 51 14 10 5f 53 52 53 01 70 53 52  S_INTQ.._SRS.pSR
  2ce0: 53 5f 68 49 4e 54 51 5b 82 47 06 4c 46 49 52 08  S_hINTQ[.G.LFIR.
  2cf0: 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 0e  _HID.A...._UID..
  2d00: 14 14 5f 53 54 41 00 a0 08 49 4e 54 55 a4 0a 0b  .._STA...INTU...
  2d10: a1 04 a4 0a 09 14 0b 5f 50 52 53 00 a4 42 55 46  ......._PRS..BUF
  2d20: 41 14 0d 5f 44 49 53 00 70 0a 00 49 4e 54 55 14  A.._DIS.p..INTU.
  2d30: 0f 5f 43 52 53 00 a4 43 52 53 5f 49 4e 54 55 14  ._CRS..CRS_INTU.
  2d40: 10 5f 53 52 53 01 70 53 52 53 5f 68 49 4e 54 55  ._SRS.pSRS_hINTU
  2d50: 5b 82 47 06 4c 33 43 4d 08 5f 48 49 44 0c 41 d0  [.G.L3CM._HID.A.
  2d60: 0c 0f 08 5f 55 49 44 0a 0f 14 14 5f 53 54 41 00  ..._UID...._STA.
  2d70: a0 08 49 4e 54 53 a4 0a 0b a1 04 a4 0a 09 14 0b  ..INTS..........
  2d80: 5f 50 52 53 00 a4 42 55 46 41 14 0d 5f 44 49 53  _PRS..BUFA.._DIS
  2d90: 00 70 0a 00 49 4e 54 53 14 0f 5f 43 52 53 00 a4  .p..INTS.._CRS..
  2da0: 43 52 53 5f 49 4e 54 53 14 10 5f 53 52 53 01 70  CRS_INTS.._SRS.p
  2db0: 53 52 53 5f 68 49 4e 54 53 5b 82 48 07 4c 49 44  SRS_hINTS[.H.LID
  2dc0: 45 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44  E._HID.A...._UID
  2dd0: 0a 10 14 14 5f 53 54 41 00 a0 08 49 4e 54 4e a4  ...._STA...INTN.
  2de0: 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52 53 00 a4 42  ........._PRS..B
  2df0: 55 46 41 14 14 5f 44 49 53 00 70 0a 00 49 4e 54  UFA.._DIS.p..INT
  2e00: 4e 70 0a 00 49 4e 54 50 14 0f 5f 43 52 53 00 a4  Np..INTP.._CRS..
  2e10: 43 52 53 5f 49 4e 54 4e 14 1a 5f 53 52 53 01 70  CRS_INTN.._SRS.p
  2e20: 53 52 53 5f 68 49 4e 54 4e 70 53 52 53 5f 68 49  SRS_hINTNpSRS_hI
  2e30: 4e 54 50 08 42 55 46 31 11 0e 0a 0b 89 06 00 09  NTP.BUF1........
  2e40: 01 10 00 00 00 79 00 08 42 55 46 32 11 0e 0a 0b  .....y..BUF2....
  2e50: 89 06 00 09 01 11 00 00 00 79 00 08 42 55 46 33  .........y..BUF3
  2e60: 11 0e 0a 0b 89 06 00 09 01 12 00 00 00 79 00 08  .............y..
  2e70: 42 55 46 34 11 0e 0a 0b 89 06 00 09 01 13 00 00  BUF4............
  2e80: 00 79 00 08 42 55 46 46 11 16 0a 13 89 0e 00 09  .y..BUFF........
  2e90: 03 14 00 00 00 15 00 00 00 16 00 00 00 79 00 08  .............y..
  2ea0: 42 55 46 49 11 0e 0a 0b 89 06 00 09 01 17 00 00  BUFI............
  2eb0: 00 79 00 08 49 52 5a 31 11 0e 0a 0b 89 06 00 09  .y..IRZ1........
  2ec0: 01 07 00 00 00 79 00 5b 82 42 07 41 50 43 31 08  .....y.[.B.APC1.
  2ed0: 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 0b  _HID.A...._UID..
  2ee0: 14 14 5f 53 54 41 00 a0 08 49 4e 54 41 a4 0a 0b  .._STA...INTA...
  2ef0: a1 04 a4 0a 09 14 0b 5f 50 52 53 00 a4 42 55 46  ......._PRS..BUF
  2f00: 31 14 0d 5f 44 49 53 00 70 0a 00 49 4e 54 41 14  1.._DIS.p..INTA.
  2f10: 1d 5f 43 52 53 00 8b 49 52 5a 31 0a 05 49 52 51  ._CRS..IRZ1..IRQ
  2f20: 31 70 0a 10 49 52 51 31 a4 49 52 5a 31 14 0d 5f  1p..IRQ1.IRZ1.._
  2f30: 53 52 53 01 70 0a 08 49 4e 54 41 5b 82 42 07 41  SRS.p..INTA[.B.A
  2f40: 50 43 32 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55  PC2._HID.A...._U
  2f50: 49 44 0a 0c 14 14 5f 53 54 41 00 a0 08 49 4e 54  ID...._STA...INT
  2f60: 42 a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52 53 00  B.........._PRS.
  2f70: a4 42 55 46 32 14 0d 5f 44 49 53 00 70 0a 00 49  .BUF2.._DIS.p..I
  2f80: 4e 54 42 14 1d 5f 43 52 53 00 8b 49 52 5a 31 0a  NTB.._CRS..IRZ1.
  2f90: 05 49 52 51 31 70 0a 11 49 52 51 31 a4 49 52 5a  .IRQ1p..IRQ1.IRZ
  2fa0: 31 14 0d 5f 53 52 53 01 70 0a 01 49 4e 54 42 5b  1.._SRS.p..INTB[
  2fb0: 82 42 07 41 50 43 33 08 5f 48 49 44 0c 41 d0 0c  .B.APC3._HID.A..
  2fc0: 0f 08 5f 55 49 44 0a 0d 14 14 5f 53 54 41 00 a0  .._UID...._STA..
  2fd0: 08 49 4e 54 43 a4 0a 0b a1 04 a4 0a 09 14 0b 5f  .INTC.........._
  2fe0: 50 52 53 00 a4 42 55 46 33 14 0d 5f 44 49 53 00  PRS..BUF3.._DIS.
  2ff0: 70 0a 00 49 4e 54 43 14 1d 5f 43 52 53 00 8b 49  p..INTC.._CRS..I
  3000: 52 5a 31 0a 05 49 52 51 31 70 0a 12 49 52 51 31  RZ1..IRQ1p..IRQ1
  3010: a4 49 52 5a 31 14 0d 5f 53 52 53 01 70 0a 02 49  .IRZ1.._SRS.p..I
  3020: 4e 54 43 5b 82 40 08 41 50 43 34 08 5f 48 49 44  NTC[.@.APC4._HID
  3030: 0c 41 d0 0c 0f 08 5f 55 49 44 0a 0e 14 14 5f 53  .A...._UID...._S
  3040: 54 41 00 a0 08 49 4e 54 44 a4 0a 0b a1 04 a4 0a  TA...INTD.......
  3050: 09 14 0b 5f 50 52 53 00 a4 42 55 46 34 14 14 5f  ..._PRS..BUF4.._
  3060: 44 49 53 00 70 0a 00 49 4e 54 44 70 0a 00 49 4e  DIS.p..INTDp..IN
  3070: 54 45 14 1d 5f 43 52 53 00 8b 49 52 5a 31 0a 05  TE.._CRS..IRZ1..
  3080: 49 52 51 31 70 0a 13 49 52 51 31 a4 49 52 5a 31  IRQ1p..IRQ1.IRZ1
  3090: 14 14 5f 53 52 53 01 70 0a 0d 49 4e 54 44 70 0a  .._SRS.p..INTDp.
  30a0: 0d 49 4e 54 45 5b 82 42 07 41 50 43 35 08 5f 48  .INTE[.B.APC5._H
  30b0: 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 0f 14 14  ID.A...._UID....
  30c0: 5f 53 54 41 00 a0 08 49 4e 54 45 a4 0a 0b a1 04  _STA...INTE.....
  30d0: a4 0a 09 14 0b 5f 50 52 53 00 a4 42 55 46 31 14  ....._PRS..BUF1.
  30e0: 0d 5f 44 49 53 00 70 0a 00 49 4e 54 45 14 1d 5f  ._DIS.p..INTE.._
  30f0: 43 52 53 00 8b 49 52 5a 31 0a 05 49 52 51 31 70  CRS..IRZ1..IRQ1p
  3100: 0a 10 49 52 51 31 a4 49 52 5a 31 14 0d 5f 53 52  ..IRQ1.IRZ1.._SR
  3110: 53 01 70 0a 08 49 4e 54 45 5b 82 47 06 41 50 43  S.p..INTE[.G.APC
  3120: 46 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44  F._HID.A...._UID
  3130: 0a 10 14 14 5f 53 54 41 00 a0 08 49 4e 54 47 a4  ...._STA...INTG.
  3140: 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52 53 00 a4 42  ........._PRS..B
  3150: 55 46 46 14 0d 5f 44 49 53 00 70 0a 00 49 4e 54  UFF.._DIS.p..INT
  3160: 47 14 0f 5f 43 52 53 00 a4 43 52 53 41 49 4e 54  G.._CRS..CRSAINT
  3170: 47 14 10 5f 53 52 53 01 70 53 52 53 41 68 49 4e  G.._SRS.pSRSAhIN
  3180: 54 47 5b 82 47 06 41 50 43 47 08 5f 48 49 44 0c  TG[.G.APCG._HID.
  3190: 41 d0 0c 0f 08 5f 55 49 44 0a 11 14 14 5f 53 54  A...._UID...._ST
  31a0: 41 00 a0 08 49 4e 54 48 a4 0a 0b a1 04 a4 0a 09  A...INTH........
  31b0: 14 0b 5f 50 52 53 00 a4 42 55 46 46 14 0d 5f 44  .._PRS..BUFF.._D
  31c0: 49 53 00 70 0a 00 49 4e 54 48 14 0f 5f 43 52 53  IS.p..INTH.._CRS
  31d0: 00 a4 43 52 53 41 49 4e 54 48 14 10 5f 53 52 53  ..CRSAINTH.._SRS
  31e0: 01 70 53 52 53 41 68 49 4e 54 48 5b 82 47 06 41  .pSRSAhINTH[.G.A
  31f0: 50 43 48 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55  PCH._HID.A...._U
  3200: 49 44 0a 12 14 14 5f 53 54 41 00 a0 08 49 4e 54  ID...._STA...INT
  3210: 4a a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52 53 00  J.........._PRS.
  3220: a4 42 55 46 46 14 0d 5f 44 49 53 00 70 0a 00 49  .BUFF.._DIS.p..I
  3230: 4e 54 4a 14 0f 5f 43 52 53 00 a4 43 52 53 41 49  NTJ.._CRS..CRSAI
  3240: 4e 54 4a 14 10 5f 53 52 53 01 70 53 52 53 41 68  NTJ.._SRS.pSRSAh
  3250: 49 4e 54 4a 5b 82 47 06 41 50 43 49 08 5f 48 49  INTJ[.G.APCI._HI
  3260: 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 1a 14 14 5f  D.A...._UID...._
  3270: 53 54 41 00 a0 08 49 4e 54 4b a4 0a 0b a1 04 a4  STA...INTK......
  3280: 0a 09 14 0b 5f 50 52 53 00 a4 42 55 46 46 14 0d  ...._PRS..BUFF..
  3290: 5f 44 49 53 00 70 0a 00 49 4e 54 4b 14 0f 5f 43  _DIS.p..INTK.._C
  32a0: 52 53 00 a4 43 52 53 41 49 4e 54 4b 14 10 5f 53  RS..CRSAINTK.._S
  32b0: 52 53 01 70 53 52 53 41 68 49 4e 54 4b 5b 82 47  RS.pSRSAhINTK[.G
  32c0: 06 41 50 43 4a 08 5f 48 49 44 0c 41 d0 0c 0f 08  .APCJ._HID.A....
  32d0: 5f 55 49 44 0a 1b 14 14 5f 53 54 41 00 a0 08 49  _UID...._STA...I
  32e0: 4e 54 4c a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52  NTL.........._PR
  32f0: 53 00 a4 42 55 46 46 14 0d 5f 44 49 53 00 70 0a  S..BUFF.._DIS.p.
  3300: 00 49 4e 54 4c 14 0f 5f 43 52 53 00 a4 43 52 53  .INTL.._CRS..CRS
  3310: 41 49 4e 54 4c 14 10 5f 53 52 53 01 70 53 52 53  AINTL.._SRS.pSRS
  3320: 41 68 49 4e 54 4c 5b 82 47 06 41 50 43 4b 08 5f  AhINTL[.G.APCK._
  3330: 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 1c 14  HID.A...._UID...
  3340: 14 5f 53 54 41 00 a0 08 49 4e 54 4d a4 0a 0b a1  ._STA...INTM....
  3350: 04 a4 0a 09 14 0b 5f 50 52 53 00 a4 42 55 46 46  ......_PRS..BUFF
  3360: 14 0d 5f 44 49 53 00 70 0a 00 49 4e 54 4d 14 0f  .._DIS.p..INTM..
  3370: 5f 43 52 53 00 a4 43 52 53 41 49 4e 54 4d 14 10  _CRS..CRSAINTM..
  3380: 5f 53 52 53 01 70 53 52 53 41 68 49 4e 54 4d 5b  _SRS.pSRSAhINTM[
  3390: 82 42 07 41 50 43 53 08 5f 48 49 44 0c 41 d0 0c  .B.APCS._HID.A..
  33a0: 0f 08 5f 55 49 44 0a 1d 14 14 5f 53 54 41 00 a0  .._UID...._STA..
  33b0: 08 49 4e 54 46 a4 0a 0b a1 04 a4 0a 09 14 0b 5f  .INTF.........._
  33c0: 50 52 53 00 a4 42 55 46 49 14 0d 5f 44 49 53 00  PRS..BUFI.._DIS.
  33d0: 70 0a 00 49 4e 54 46 14 1d 5f 43 52 53 00 8b 49  p..INTF.._CRS..I
  33e0: 52 5a 31 0a 05 49 52 51 31 70 0a 17 49 52 51 31  RZ1..IRQ1p..IRQ1
  33f0: a4 49 52 5a 31 14 0d 5f 53 52 53 01 70 0a 02 49  .IRZ1.._SRS.p..I
  3400: 4e 54 46 5b 82 47 06 41 50 43 4c 08 5f 48 49 44  NTF[.G.APCL._HID
  3410: 0c 41 d0 0c 0f 08 5f 55 49 44 0a 1e 14 14 5f 53  .A...._UID...._S
  3420: 54 41 00 a0 08 49 4e 54 51 a4 0a 0b a1 04 a4 0a  TA...INTQ.......
  3430: 09 14 0b 5f 50 52 53 00 a4 42 55 46 46 14 0d 5f  ..._PRS..BUFF.._
  3440: 44 49 53 00 70 0a 00 49 4e 54 51 14 0f 5f 43 52  DIS.p..INTQ.._CR
  3450: 53 00 a4 43 52 53 41 49 4e 54 51 14 10 5f 53 52  S..CRSAINTQ.._SR
  3460: 53 01 70 53 52 53 41 68 49 4e 54 51 5b 82 47 06  S.pSRSAhINTQ[.G.
  3470: 41 50 43 4d 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f  APCM._HID.A...._
  3480: 55 49 44 0a 1f 14 14 5f 53 54 41 00 a0 08 49 4e  UID...._STA...IN
  3490: 54 55 a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52 53  TU.........._PRS
  34a0: 00 a4 42 55 46 46 14 0d 5f 44 49 53 00 70 0a 00  ..BUFF.._DIS.p..
  34b0: 49 4e 54 55 14 0f 5f 43 52 53 00 a4 43 52 53 41  INTU.._CRS..CRSA
  34c0: 49 4e 54 55 14 10 5f 53 52 53 01 70 53 52 53 41  INTU.._SRS.pSRSA
  34d0: 68 49 4e 54 55 5b 82 47 06 41 50 33 43 08 5f 48  hINTU[.G.AP3C._H
  34e0: 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 20 14 14  ID.A...._UID. ..
  34f0: 5f 53 54 41 00 a0 08 49 4e 54 53 a4 0a 0b a1 04  _STA...INTS.....
  3500: a4 0a 09 14 0b 5f 50 52 53 00 a4 42 55 46 46 14  ....._PRS..BUFF.
  3510: 0d 5f 44 49 53 00 70 0a 00 49 4e 54 53 14 0f 5f  ._DIS.p..INTS.._
  3520: 43 52 53 00 a4 43 52 53 41 49 4e 54 53 14 10 5f  CRS..CRSAINTS.._
  3530: 53 52 53 01 70 53 52 53 41 68 49 4e 54 53 5b 82  SRS.pSRSAhINTS[.
  3540: 48 07 41 50 43 5a 08 5f 48 49 44 0c 41 d0 0c 0f  H.APCZ._HID.A...
  3550: 08 5f 55 49 44 0a 21 14 14 5f 53 54 41 00 a0 08  ._UID.!.._STA...
  3560: 49 4e 54 4e a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50  INTN.........._P
  3570: 52 53 00 a4 42 55 46 46 14 14 5f 44 49 53 00 70  RS..BUFF.._DIS.p
  3580: 0a 00 49 4e 54 4e 70 0a 00 49 4e 54 50 14 0f 5f  ..INTNp..INTP.._
  3590: 43 52 53 00 a4 43 52 53 41 49 4e 54 4e 14 1a 5f  CRS..CRSAINTN.._
  35a0: 53 52 53 01 70 53 52 53 41 68 49 4e 54 4e 70 53  SRS.pSRSAhINTNpS
  35b0: 52 53 41 68 49 4e 54 50 10 1e 5c 00 5b 80 5c 53  RSAhINTP..\.[.\S
  35c0: 43 50 50 01 0b 2e 44 0a 01 5b 81 0c 5c 53 43 50  CPP...D..[..\SCP
  35d0: 50 01 53 4d 49 50 08 14 49 07 5c 2f 03 5f 53 42  P.SMIP..I.\/._SB
  35e0: 5f 50 43 49 30 5f 49 4e 49 00 a0 24 53 54 52 43  _PCI0_INI..$STRC
  35f0: 5c 5f 4f 53 5f 0d 4d 69 63 72 6f 73 6f 66 74 20  \_OS_.Microsoft 
  3600: 57 69 6e 64 6f 77 73 00 70 0a 56 53 4d 49 50 a1  Windows.p.VSMIP.
  3610: 41 04 a0 2e 53 54 52 43 5c 5f 4f 53 5f 0d 4d 69  A...STRC\_OS_.Mi
  3620: 63 72 6f 73 6f 66 74 20 57 69 6e 64 6f 77 73 20  crosoft Windows 
  3630: 4e 54 00 70 0a 58 53 4d 49 50 70 0a 00 4f 53 46  NT.p.XSMIPp..OSF
  3640: 4c a1 0f 70 0a 57 53 4d 49 50 70 0a 02 4f 53 46  L..p.WSMIPp..OSF
  3650: 4c 10 3a 5c 00 14 36 4f 53 54 50 00 a0 0f 93 4f  L.:\..6OSTP....O
  3660: 53 46 4c 0a 01 70 0a 56 53 4d 49 50 a0 0f 93 4f  SFL..p.VSMIP...O
  3670: 53 46 4c 0a 02 70 0a 57 53 4d 49 50 a0 0f 93 4f  SFL..p.WSMIP...O
  3680: 53 46 4c 0a 00 70 0a 58 53 4d 49 50 5b 82 4b 0a  SFL..p.XSMIP[.K.
  3690: 53 59 53 52 08 5f 48 49 44 0c 41 d0 0c 02 08 5f  SYSR._HID.A...._
  36a0: 55 49 44 0a 01 08 5f 43 52 53 11 4e 08 0a 8a 47  UID..._CRS.N...G
  36b0: 01 10 00 10 00 01 10 47 01 22 00 22 00 01 1e 47  .......G."."...G
  36c0: 01 44 00 44 00 01 1c 47 01 62 00 62 00 01 02 47  .D.D...G.b.b...G
  36d0: 01 65 00 65 00 01 0b 47 01 74 00 74 00 01 0c 47  .e.e...G.t.t...G
  36e0: 01 91 00 91 00 01 03 47 01 a2 00 a2 00 01 1e 47  .......G.......G
  36f0: 01 e0 00 e0 00 01 10 47 01 78 0b 78 0b 04 04 47  .......G.x.x...G
  3700: 01 78 0f 78 0f 04 04 47 01 78 0a 78 0a 04 04 47  .x.x...G.x.x...G
  3710: 01 78 0e 78 0e 04 04 47 01 bc 0b bc 0b 04 04 47  .x.x...G.......G
  3720: 01 bc 0f bc 0f 04 04 47 01 d0 04 d0 04 01 02 47  .......G.......G
  3730: 01 94 02 94 02 01 04 79 00 5b 82 2b 50 49 43 5f  .......y.[.+PIC_
  3740: 08 5f 48 49 44 0b 41 d0 08 5f 43 52 53 11 18 0a  ._HID.A.._CRS...
  3750: 15 47 01 20 00 20 00 01 02 47 01 a0 00 a0 00 01  .G. . ...G......
  3760: 02 22 04 00 79 00 5b 82 3d 44 4d 41 31 08 5f 48  ."..y.[.=DMA1._H
  3770: 49 44 0c 41 d0 02 00 08 5f 43 52 53 11 28 0a 25  ID.A...._CRS.(.%
  3780: 2a 10 04 47 01 00 00 00 00 01 10 47 01 80 00 80  *..G.......G....
  3790: 00 01 11 47 01 94 00 94 00 01 0c 47 01 c0 00 c0  ...G.......G....
  37a0: 00 01 20 79 00 5b 82 25 54 4d 52 5f 08 5f 48 49  .. y.[.%TMR_._HI
  37b0: 44 0c 41 d0 01 00 08 5f 43 52 53 11 10 0a 0d 47  D.A...._CRS....G
  37c0: 01 40 00 40 00 01 04 22 01 00 79 00 5b 82 25 52  .@.@..."..y.[.%R
  37d0: 54 43 5f 08 5f 48 49 44 0c 41 d0 0b 00 08 5f 43  TC_._HID.A...._C
  37e0: 52 53 11 10 0a 0d 47 01 70 00 70 00 04 04 22 00  RS....G.p.p...".
  37f0: 01 79 00 5b 82 22 53 50 4b 52 08 5f 48 49 44 0c  .y.[."SPKR._HID.
  3800: 41 d0 08 00 08 5f 43 52 53 11 0d 0a 0a 47 01 61  A...._CRS....G.a
  3810: 00 61 00 01 01 79 00 5b 82 25 43 4f 50 52 08 5f  .a...y.[.%COPR._
  3820: 48 49 44 0c 41 d0 0c 04 08 5f 43 52 53 11 10 0a  HID.A...._CRS...
  3830: 0d 47 01 f0 00 f0 00 01 10 22 00 20 79 00 10 47  .G.......". y..G
  3840: 0f 5c 00 5b 80 57 49 4e 31 01 0a 2e 0a 02 5b 81  .\.[.WIN1.....[.
  3850: 10 57 49 4e 31 01 49 4e 44 50 08 44 41 54 41 08  .WIN1.INDP.DATA.
  3860: 5b 86 41 0b 49 4e 44 50 44 41 54 41 01 00 10 43  [.A.INDPDATA...C
  3870: 46 47 5f 08 00 20 4c 44 4e 5f 08 00 40 0c 49 44  FG_.. LDN_..@.ID
  3880: 48 49 08 49 44 4c 4f 08 50 4f 57 43 08 00 48 06  HI.IDLO.POWC..H.
  3890: 41 43 54 52 08 00 48 17 49 4f 41 48 08 49 4f 41  ACTR..H.IOAH.IOA
  38a0: 4c 08 49 4f 32 48 08 49 4f 32 4c 08 00 40 06 49  L.IO2H.IO2L..@.I
  38b0: 4e 54 52 08 00 08 49 4e 54 31 08 00 08 44 4d 43  NTR...INT1...DMC
  38c0: 48 08 00 48 35 43 52 45 30 08 43 52 45 31 08 43  H..H5CRE0.CRE1.C
  38d0: 52 45 32 08 43 52 45 33 08 43 52 45 34 08 00 48  RE2.CRE3.CRE4..H
  38e0: 05 4f 50 54 31 08 4f 50 54 32 08 4f 50 54 33 08  .OPT1.OPT2.OPT3.
  38f0: 4f 50 54 34 08 4f 50 54 35 08 4f 50 54 36 08 4f  OPT4.OPT5.OPT6.O
  3900: 50 54 37 08 4f 50 54 38 08 4f 50 54 39 08 4f 50  PT7.OPT8.OPT9.OP
  3910: 54 41 08 14 14 45 4e 46 47 00 70 0a 87 49 4e 44  TA...ENFG.p..IND
  3920: 50 70 0a 87 49 4e 44 50 14 0d 45 58 46 47 00 70  Pp..INDP..EXFG.p
  3930: 0a aa 49 4e 44 50 5b 80 43 4f 4d 31 01 0b f8 03  ..INDP[.COM1....
  3940: 0a 08 5b 81 2e 43 4f 4d 31 01 50 33 46 38 08 50  ..[..COM1.P3F8.P
  3950: 33 46 39 08 50 33 46 41 08 50 33 46 42 08 50 33  3F9.P3FA.P3FB.P3
  3960: 46 43 08 50 33 46 44 08 50 33 46 45 08 50 33 46  FC.P3FD.P3FE.P3F
  3970: 46 08 5b 80 43 4f 4d 32 01 0b f8 02 0a 08 5b 81  F.[.COM2......[.
  3980: 2e 43 4f 4d 32 01 50 32 46 38 08 50 32 46 39 08  .COM2.P2F8.P2F9.
  3990: 50 32 46 41 08 50 32 46 42 08 50 32 46 43 08 50  P2FA.P2FB.P2FC.P
  39a0: 32 46 44 08 50 32 46 45 08 50 32 46 46 08 5b 80  2FD.P2FE.P2FF.[.
  39b0: 43 4f 4d 33 01 0b e8 03 0a 08 5b 81 2e 43 4f 4d  COM3......[..COM
  39c0: 33 01 50 33 45 38 08 50 33 45 39 08 50 33 45 41  3.P3E8.P3E9.P3EA
  39d0: 08 50 33 45 42 08 50 33 45 43 08 50 33 45 44 08  .P3EB.P3EC.P3ED.
  39e0: 50 33 45 45 08 50 33 45 46 08 5b 80 43 4f 4d 34  P3EE.P3EF.[.COM4
  39f0: 01 0b e8 02 0a 08 5b 81 2e 43 4f 4d 34 01 50 32  ......[..COM4.P2
  3a00: 45 38 08 50 32 45 39 08 50 32 45 41 08 50 32 45  E8.P2E9.P2EA.P2E
  3a10: 42 08 50 32 45 43 08 50 32 45 44 08 50 32 45 45  B.P2EC.P2ED.P2EE
  3a20: 08 50 32 45 46 08 14 4a 0b 49 43 4f 4d 01 70 68  .P2EF..J.ICOM.ph
  3a30: 60 a0 29 93 60 0b f8 03 70 50 33 46 44 60 70 50  `.).`...pP3FD`pP
  3a40: 33 46 44 60 70 0a c3 50 33 46 41 a2 0f 92 93 50  3FD`p..P3FA....P
  3a50: 33 46 41 0a c1 70 50 33 46 45 60 a1 45 08 a0 29  3FA..pP3FE`.E..)
  3a60: 93 60 0b f8 02 70 50 32 46 44 60 70 50 32 46 44  .`...pP2FD`pP2FD
  3a70: 60 70 0a c3 50 32 46 41 a2 0f 92 93 50 32 46 41  `p..P2FA....P2FA
  3a80: 0a c1 70 50 32 46 45 60 a1 48 05 a0 29 93 60 0b  ..pP2FE`.H..).`.
  3a90: e8 03 70 50 33 45 44 60 70 50 33 45 44 60 70 0a  ..pP3ED`pP3ED`p.
  3aa0: c3 50 33 45 41 a2 0f 92 93 50 33 45 41 0a c1 70  .P3EA....P3EA..p
  3ab0: 50 33 45 45 60 a1 2b a0 29 93 60 0b e8 02 70 50  P3EE`.+.).`...pP
  3ac0: 32 45 44 60 70 50 32 45 44 60 70 0a c3 50 32 45  2ED`pP2ED`p..P2E
  3ad0: 41 a2 0f 92 93 50 32 45 41 0a c1 70 50 32 45 45  A....P2EA..pP2EE
  3ae0: 60 5b 82 46 15 46 44 43 30 08 5f 48 49 44 0c 41  `[.F.FDC0._HID.A
  3af0: d0 07 00 14 3a 5f 53 54 41 00 45 4e 46 47 70 00  ....:_STA.ENFGp.
  3b00: 4c 44 4e 5f a0 0c 41 43 54 52 45 58 46 47 a4 0a  LDN_..ACTREXFG..
  3b10: 0f a1 1c a0 11 91 49 4f 41 48 49 4f 41 4c 45 58  ......IOAHIOALEX
  3b20: 46 47 a4 0a 0d a1 08 45 58 46 47 a4 0a 00 14 2b  FG.....EXFG....+
  3b30: 5f 44 49 53 00 45 4e 46 47 70 0a 00 4c 44 4e 5f  _DIS.ENFGp..LDN_
  3b40: 70 00 41 43 54 52 53 4c 44 4d 44 4d 43 48 0a 04  p.ACTRSLDMDMCH..
  3b50: 45 58 46 47 44 49 53 44 0a 03 14 41 06 5f 43 52  EXFGDISD...A._CR
  3b60: 53 00 08 42 55 46 30 11 1b 0a 18 47 01 f0 03 f0  S..BUF0....G....
  3b70: 03 01 06 47 01 f7 03 f7 03 01 01 22 40 00 2a 04  ...G......."@.*.
  3b80: 00 79 00 8c 42 55 46 30 0a 02 49 4f 4c 4f 8c 42  .y..BUF0..IOLO.B
  3b90: 55 46 30 0a 03 49 4f 48 49 8c 42 55 46 30 0a 04  UF0..IOHI.BUF0..
  3ba0: 49 4f 52 4c 8c 42 55 46 30 0a 05 49 4f 52 48 45  IORL.BUF0..IORHE
  3bb0: 4e 46 47 45 58 46 47 a4 42 55 46 30 08 5f 50 52  NFGEXFG.BUF0._PR
  3bc0: 53 11 1d 0a 1a 30 47 01 f0 03 f0 03 01 06 47 01  S....0G.......G.
  3bd0: f7 03 f7 03 01 01 22 40 00 2a 04 00 38 79 00 14  ......"@.*..8y..
  3be0: 49 05 5f 53 52 53 01 8c 68 0a 02 49 4f 4c 4f 8c  I._SRS..h..IOLO.
  3bf0: 68 0a 03 49 4f 48 49 8b 68 0a 02 49 4f 41 44 8b  h..IOHI.h..IOAD.
  3c00: 68 0a 19 49 52 51 4c 8c 68 0a 1c 44 4d 41 56 45  h..IRQL.h..DMAVE
  3c10: 4e 46 47 70 00 4c 44 4e 5f 70 01 41 43 54 52 53  NFGp.LDN_p.ACTRS
  3c20: 4c 44 4d 44 4d 43 48 44 4d 43 48 45 58 46 47 43  LDMDMCHDMCHEXFGC
  3c30: 4b 49 4f 49 4f 41 44 0a 03 5b 82 46 1b 55 41 52  KIOIOAD..[.F.UAR
  3c40: 31 08 5f 48 49 44 0c 41 d0 05 01 08 5f 55 49 44  1._HID.A...._UID
  3c50: 0a 01 14 3f 5f 53 54 41 00 45 4e 46 47 70 0a 02  ...?_STA.ENFGp..
  3c60: 4c 44 4e 5f a0 0c 41 43 54 52 45 58 46 47 a4 0a  LDN_..ACTREXFG..
  3c70: 0f a1 1c a0 11 91 49 4f 41 48 49 4f 41 4c 45 58  ......IOAHIOALEX
  3c80: 46 47 a4 0a 0d a1 08 45 58 46 47 a4 0a 00 45 58  FG.....EXFG...EX
  3c90: 46 47 14 21 5f 44 49 53 00 45 4e 46 47 70 0a 02  FG.!_DIS.ENFGp..
  3ca0: 4c 44 4e 5f 70 00 41 43 54 52 45 58 46 47 44 49  LDN_p.ACTREXFGDI
  3cb0: 53 44 0a 00 14 49 09 5f 43 52 53 00 08 42 55 46  SD...I._CRS..BUF
  3cc0: 31 11 10 0a 0d 47 01 00 00 00 00 01 08 22 00 00  1....G......."..
  3cd0: 79 00 8c 42 55 46 31 0a 02 49 4f 4c 4f 8c 42 55  y..BUF1..IOLO.BU
  3ce0: 46 31 0a 03 49 4f 48 49 8c 42 55 46 31 0a 04 49  F1..IOHI.BUF1..I
  3cf0: 4f 52 4c 8c 42 55 46 31 0a 05 49 4f 52 48 8b 42  ORL.BUF1..IORH.B
  3d00: 55 46 31 0a 09 49 52 51 57 45 4e 46 47 70 0a 02  UF1..IRQWENFGp..
  3d10: 4c 44 4e 5f 70 49 4f 41 4c 49 4f 4c 4f 70 49 4f  LDN_pIOALIOLOpIO
  3d20: 41 4c 49 4f 52 4c 70 49 4f 41 48 49 4f 48 49 70  ALIORLpIOAHIOHIp
  3d30: 49 4f 41 48 49 4f 52 48 70 01 60 79 60 49 4e 54  IOAHIORHp.`y`INT
  3d40: 52 49 52 51 57 45 58 46 47 a4 42 55 46 31 08 5f  RIRQWEXFG.BUF1._
  3d50: 50 52 53 11 36 0a 33 30 47 01 f8 03 f8 03 01 08  PRS.6.30G.......
  3d60: 22 b8 1e 30 47 01 f8 02 f8 02 01 08 22 b8 1e 30  "..0G......."..0
  3d70: 47 01 e8 03 e8 03 01 08 22 b8 1e 30 47 01 e8 02  G......."..0G...
  3d80: e8 02 01 08 22 b8 1e 38 79 00 14 46 06 5f 53 52  ...."..8y..F._SR
  3d90: 53 01 8c 68 0a 02 49 4f 4c 4f 8c 68 0a 03 49 4f  S..h..IOLO.h..IO
  3da0: 48 49 8b 68 0a 02 49 4f 41 44 8b 68 0a 09 49 52  HI.h..IOAD.h..IR
  3db0: 51 57 45 4e 46 47 70 0a 02 4c 44 4e 5f 70 01 41  QWENFGp..LDN_p.A
  3dc0: 43 54 52 70 49 4f 4c 4f 49 4f 41 4c 70 49 4f 48  CTRpIOLOIOALpIOH
  3dd0: 49 49 4f 41 48 82 49 52 51 57 60 74 60 0a 01 49  IIOAH.IRQW`t`..I
  3de0: 4e 54 52 45 58 46 47 43 4b 49 4f 49 4f 41 44 0a  NTREXFGCKIOIOAD.
  3df0: 00 5b 82 49 1d 55 41 52 32 08 5f 48 49 44 0c 41  .[.I.UAR2._HID.A
  3e00: d0 05 01 08 5f 55 49 44 0a 02 14 44 05 5f 53 54  ...._UID...D._ST
  3e10: 41 00 45 4e 46 47 70 0a 03 4c 44 4e 5f 7b 4f 50  A.ENFGp..LDN_{OP
  3e20: 54 32 0a 30 60 a0 30 92 93 60 0a 10 a0 0c 41 43  T2.0`.0..`....AC
  3e30: 54 52 45 58 46 47 a4 0a 0f a1 1c a0 11 91 49 4f  TREXFG........IO
  3e40: 41 48 49 4f 41 4c 45 58 46 47 a4 0a 0d a1 08 45  AHIOALEXFG.....E
  3e50: 58 46 47 a4 0a 00 a1 08 45 58 46 47 a4 0a 00 14  XFG.....EXFG....
  3e60: 2f 5f 44 49 53 00 45 4e 46 47 70 0a 03 4c 44 4e  /_DIS.ENFGp..LDN
  3e70: 5f 7b 4f 50 54 32 0a 38 60 a0 0b 93 60 0a 00 70  _{OPT2.8`...`..p
  3e80: 00 41 43 54 52 45 58 46 47 44 49 53 44 0a 01 14  .ACTREXFGDISD...
  3e90: 49 09 5f 43 52 53 00 08 42 55 46 32 11 10 0a 0d  I._CRS..BUF2....
  3ea0: 47 01 00 00 00 00 01 08 22 10 00 79 00 8c 42 55  G......."..y..BU
  3eb0: 46 32 0a 02 49 4f 4c 4f 8c 42 55 46 32 0a 03 49  F2..IOLO.BUF2..I
  3ec0: 4f 48 49 8c 42 55 46 32 0a 04 49 4f 52 4c 8c 42  OHI.BUF2..IORL.B
  3ed0: 55 46 32 0a 05 49 4f 52 48 8b 42 55 46 32 0a 09  UF2..IORH.BUF2..
  3ee0: 49 52 51 57 45 4e 46 47 70 0a 03 4c 44 4e 5f 70  IRQWENFGp..LDN_p
  3ef0: 49 4f 41 4c 49 4f 4c 4f 70 49 4f 41 4c 49 4f 52  IOALIOLOpIOALIOR
  3f00: 4c 70 49 4f 41 48 49 4f 48 49 70 49 4f 41 48 49  LpIOAHIOHIpIOAHI
  3f10: 4f 52 48 70 01 60 79 60 49 4e 54 52 49 52 51 57  ORHp.`y`INTRIRQW
  3f20: 45 58 46 47 a4 42 55 46 32 08 5f 50 52 53 11 36  EXFG.BUF2._PRS.6
  3f30: 0a 33 30 47 01 f8 03 f8 03 01 08 22 b8 1e 30 47  .30G......."..0G
  3f40: 01 f8 02 f8 02 01 08 22 b8 1e 30 47 01 e8 03 e8  ......."..0G....
  3f50: 03 01 08 22 b8 1e 30 47 01 e8 02 e8 02 01 08 22  ..."..0G......."
  3f60: b8 1e 38 79 00 14 46 06 5f 53 52 53 01 8c 68 0a  ..8y..F._SRS..h.
  3f70: 02 49 4f 4c 4f 8c 68 0a 03 49 4f 48 49 8b 68 0a  .IOLO.h..IOHI.h.
  3f80: 02 49 4f 41 44 8b 68 0a 09 49 52 51 57 45 4e 46  .IOAD.h..IRQWENF
  3f90: 47 70 0a 03 4c 44 4e 5f 70 01 41 43 54 52 70 49  Gp..LDN_p.ACTRpI
  3fa0: 4f 4c 4f 49 4f 41 4c 70 49 4f 48 49 49 4f 41 48  OLOIOALpIOHIIOAH
  3fb0: 82 49 52 51 57 60 74 60 0a 01 49 4e 54 52 45 58  .IRQW`t`..INTREX
  3fc0: 46 47 43 4b 49 4f 49 4f 41 44 0a 01 5b 82 4c 1d  FGCKIOIOAD..[.L.
  3fd0: 49 52 44 41 08 5f 48 49 44 0c 41 d0 05 10 14 43  IRDA._HID.A....C
  3fe0: 05 5f 53 54 41 00 45 4e 46 47 70 0a 03 4c 44 4e  ._STA.ENFGp..LDN
  3ff0: 5f 7b 4f 50 54 32 0a 30 60 a0 2f 93 60 0a 10 a0  _{OPT2.0`./.`...
  4000: 0c 41 43 54 52 45 58 46 47 a4 0a 0f a1 1c a0 11  .ACTREXFG.......
  4010: 91 49 4f 41 48 49 4f 41 4c 45 58 46 47 a4 0a 0d  .IOAHIOALEXFG...
  4020: a1 08 45 58 46 47 a4 0a 00 a1 08 45 58 46 47 a4  ..EXFG.....EXFG.
  4030: 0a 00 14 3c 5f 44 49 53 00 a0 32 93 44 49 53 45  ...<_DIS..2.DISE
  4040: 0a 01 45 4e 46 47 70 0a 03 4c 44 4e 5f 7b 4f 50  ..ENFGp..LDN_{OP
  4050: 54 32 0a 38 60 a0 0c 92 93 60 0a 00 70 00 41 43  T2.8`....`..p.AC
  4060: 54 52 45 58 46 47 44 49 53 44 0a 01 70 60 60 14  TREXFGDISD..p``.
  4070: 47 09 5f 43 52 53 00 08 42 55 46 34 11 10 0a 0d  G._CRS..BUF4....
  4080: 47 01 00 00 00 00 01 08 22 00 00 79 00 8c 42 55  G......."..y..BU
  4090: 46 34 0a 02 49 4f 4c 4f 8c 42 55 46 34 0a 03 49  F4..IOLO.BUF4..I
  40a0: 4f 48 49 8c 42 55 46 34 0a 04 49 4f 52 4c 8c 42  OHI.BUF4..IORL.B
  40b0: 55 46 34 0a 05 49 4f 52 48 8b 42 55 46 34 0a 09  UF4..IORH.BUF4..
  40c0: 49 52 51 57 45 4e 46 47 70 0a 03 4c 44 4e 5f 70  IRQWENFGp..LDN_p
  40d0: 49 4f 41 4c 49 4f 4c 4f 70 49 4f 41 4c 49 4f 52  IOALIOLOpIOALIOR
  40e0: 4c 70 49 4f 41 48 49 4f 48 49 70 49 4f 41 48 49  LpIOAHIOHIpIOAHI
  40f0: 4f 52 48 79 0a 01 49 4e 54 52 49 52 51 57 45 58  ORHy..INTRIRQWEX
  4100: 46 47 a4 42 55 46 34 08 5f 50 52 53 11 36 0a 33  FG.BUF4._PRS.6.3
  4110: 30 47 01 f8 03 f8 03 01 08 22 b8 1e 30 47 01 f8  0G......."..0G..
  4120: 02 f8 02 01 08 22 b8 1e 30 47 01 e8 03 e8 03 01  ....."..0G......
  4130: 08 22 b8 1e 30 47 01 e8 02 e8 02 01 08 22 b8 1e  ."..0G......."..
  4140: 38 79 00 14 46 06 5f 53 52 53 01 8c 68 0a 02 49  8y..F._SRS..h..I
  4150: 4f 4c 4f 8c 68 0a 03 49 4f 48 49 8b 68 0a 02 49  OLO.h..IOHI.h..I
  4160: 4f 41 44 8b 68 0a 09 49 52 51 57 45 4e 46 47 70  OAD.h..IRQWENFGp
  4170: 0a 03 4c 44 4e 5f 70 01 41 43 54 52 70 49 4f 4c  ..LDN_p.ACTRpIOL
  4180: 4f 49 4f 41 4c 70 49 4f 48 49 49 4f 41 48 82 49  OIOALpIOHIIOAH.I
  4190: 52 51 57 60 74 60 0a 01 49 4e 54 52 45 58 46 47  RQW`t`..INTREXFG
  41a0: 43 4b 49 4f 49 4f 41 44 0a 01 5b 82 4d 26 4c 50  CKIOIOAD..[.M&LP
  41b0: 54 31 08 5f 48 49 44 0c 41 d0 04 00 14 44 05 5f  T1._HID.A....D._
  41c0: 53 54 41 00 45 4e 46 47 70 0a 01 4c 44 4e 5f 7b  STA.ENFGp..LDN_{
  41d0: 4f 50 54 31 0a 02 60 a0 30 92 93 60 0a 02 a0 0c  OPT1..`.0..`....
  41e0: 41 43 54 52 45 58 46 47 a4 0a 0f a1 1c a0 11 91  ACTREXFG........
  41f0: 49 4f 41 48 49 4f 41 4c 45 58 46 47 a4 0a 0d a1  IOAHIOALEXFG....
  4200: 08 45 58 46 47 a4 0a 00 a1 08 45 58 46 47 a4 0a  .EXFG.....EXFG..
  4210: 00 14 21 5f 44 49 53 00 45 4e 46 47 70 0a 01 4c  ..!_DIS.ENFGp..L
  4220: 44 4e 5f 70 00 41 43 54 52 45 58 46 47 44 49 53  DN_p.ACTREXFGDIS
  4230: 44 0a 02 14 42 12 5f 43 52 53 00 08 42 55 46 35  D...B._CRS..BUF5
  4240: 11 18 0a 15 47 01 00 00 00 00 01 08 47 01 00 00  ....G.......G...
  4250: 00 00 01 04 22 00 00 79 00 8c 42 55 46 35 0a 02  ...."..y..BUF5..
  4260: 49 4f 4c 4f 8c 42 55 46 35 0a 03 49 4f 48 49 8c  IOLO.BUF5..IOHI.
  4270: 42 55 46 35 0a 04 49 4f 52 4c 8c 42 55 46 35 0a  BUF5..IORL.BUF5.
  4280: 05 49 4f 52 48 8c 42 55 46 35 0a 07 49 4f 4c 45  .IORH.BUF5..IOLE
  4290: 8c 42 55 46 35 0a 0a 49 4f 32 31 8c 42 55 46 35  .BUF5..IO21.BUF5
  42a0: 0a 0b 49 4f 32 32 8c 42 55 46 35 0a 0c 49 4f 32  ..IO22.BUF5..IO2
  42b0: 33 8c 42 55 46 35 0a 0d 49 4f 32 34 8b 42 55 46  3.BUF5..IO24.BUF
  42c0: 35 0a 11 49 52 51 57 45 4e 46 47 70 0a 01 4c 44  5..IRQWENFGp..LD
  42d0: 4e 5f 70 49 4f 41 4c 49 4f 4c 4f 70 49 4f 4c 4f  N_pIOALIOLOpIOLO
  42e0: 49 4f 52 4c 70 49 4f 41 48 49 4f 48 49 70 49 4f  IORLpIOAHIOHIpIO
  42f0: 48 49 49 4f 52 48 70 49 4f 41 4c 49 4f 32 31 70  HIIORHpIOALIO21p
  4300: 49 4f 41 4c 49 4f 32 33 72 49 4f 41 48 0a 04 49  IOALIO23rIOAH..I
  4310: 4f 32 32 72 49 4f 41 48 0a 04 49 4f 32 34 a0 0f  O22rIOAH..IO24..
  4320: 93 49 4f 4c 4f 0a bc 70 0a 04 49 4f 4c 45 a1 08  .IOLO..p..IOLE..
  4330: 70 0a 08 49 4f 4c 45 70 01 60 70 49 4e 54 52 65  p..IOLEp.`pINTRe
  4340: 79 60 65 49 52 51 57 70 01 41 43 54 52 45 58 46  y`eIRQWp.ACTREXF
  4350: 47 a4 42 55 46 35 08 5f 50 52 53 11 43 04 0a 3f  G.BUF5._PRS.C..?
  4360: 30 47 01 78 03 78 03 01 08 47 01 78 07 78 07 01  0G.x.x...G.x.x..
  4370: 04 22 b8 1e 30 47 01 78 02 78 02 01 08 47 01 78  ."..0G.x.x...G.x
  4380: 06 78 06 01 04 22 b8 1e 30 47 01 bc 03 bc 03 01  .x..."..0G......
  4390: 04 47 01 bc 07 bc 07 01 04 22 b8 1e 38 79 00 14  .G......."..8y..
  43a0: 49 07 5f 53 52 53 01 8c 68 0a 02 49 4f 4c 4f 8c  I._SRS..h..IOLO.
  43b0: 68 0a 03 49 4f 48 49 8b 68 0a 02 49 4f 41 44 8c  h..IOHI.h..IOAD.
  43c0: 68 0a 04 49 4f 52 4c 8c 68 0a 05 49 4f 52 48 8b  h..IORL.h..IORH.
  43d0: 68 0a 11 49 52 51 57 45 4e 46 47 70 0a 01 4c 44  h..IRQWENFGp..LD
  43e0: 4e 5f 70 01 41 43 54 52 70 49 4f 4c 4f 49 4f 41  N_p.ACTRpIOLOIOA
  43f0: 4c 70 49 4f 48 49 49 4f 41 48 81 49 52 51 57 60  LpIOHIIOAH.IRQW`
  4400: 74 60 0a 01 60 70 60 49 4e 54 52 45 58 46 47 43  t`..`p`INTREXFGC
  4410: 4b 49 4f 49 4f 41 44 0a 02 5b 82 43 2b 45 43 50  KIOIOAD..[.C+ECP
  4420: 31 08 5f 48 49 44 0c 41 d0 04 01 14 43 05 5f 53  1._HID.A....C._S
  4430: 54 41 00 45 4e 46 47 70 0a 01 4c 44 4e 5f 7b 4f  TA.ENFGp..LDN_{O
  4440: 50 54 31 0a 02 60 a0 2f 93 60 0a 02 a0 0c 41 43  PT1..`./.`....AC
  4450: 54 52 45 58 46 47 a4 0a 0f a1 1c a0 11 91 49 4f  TREXFG........IO
  4460: 41 48 49 4f 41 4c 45 58 46 47 a4 0a 0d a1 08 45  AHIOALEXFG.....E
  4470: 58 46 47 a4 0a 00 a1 08 45 58 46 47 a4 0a 00 14  XFG.....EXFG....
  4480: 2b 5f 44 49 53 00 45 4e 46 47 70 0a 01 4c 44 4e  +_DIS.ENFGp..LDN
  4490: 5f 70 00 41 43 54 52 53 4c 44 4d 44 4d 43 48 0a  _p.ACTRSLDMDMCH.
  44a0: 04 45 58 46 47 44 49 53 44 0a 02 14 41 14 5f 43  .EXFGDISD...A._C
  44b0: 52 53 00 08 42 55 46 36 11 1b 0a 18 47 01 00 00  RS..BUF6....G...
  44c0: 00 00 01 08 47 01 00 00 00 00 01 04 22 00 00 2a  ....G......."..*
  44d0: 00 00 79 00 8c 42 55 46 36 0a 02 49 4f 4c 4f 8c  ..y..BUF6..IOLO.
  44e0: 42 55 46 36 0a 03 49 4f 48 49 8c 42 55 46 36 0a  BUF6..IOHI.BUF6.
  44f0: 04 49 4f 52 4c 8c 42 55 46 36 0a 05 49 4f 52 48  .IORL.BUF6..IORH
  4500: 8c 42 55 46 36 0a 0a 49 4f 45 4c 8c 42 55 46 36  .BUF6..IOEL.BUF6
  4510: 0a 0b 49 4f 45 48 8c 42 55 46 36 0a 0c 49 4f 4d  ..IOEH.BUF6..IOM
  4520: 4c 8c 42 55 46 36 0a 0d 49 4f 4d 48 8c 42 55 46  L.BUF6..IOMH.BUF
  4530: 36 0a 07 49 4f 4c 45 8b 42 55 46 36 0a 11 49 52  6..IOLE.BUF6..IR
  4540: 51 57 8c 42 55 46 36 0a 14 44 4d 41 43 45 4e 46  QW.BUF6..DMACENF
  4550: 47 70 0a 01 4c 44 4e 5f 70 01 41 43 54 52 70 49  Gp..LDN_p.ACTRpI
  4560: 4f 41 4c 62 70 62 49 4f 4c 4f 70 49 4f 41 48 63  OALbpbIOLOpIOAHc
  4570: 70 63 49 4f 48 49 7d 63 0a 04 63 70 63 49 4f 45  pcIOHI}c..cpcIOE
  4580: 48 70 63 49 4f 4d 48 70 49 4f 4c 4f 49 4f 52 4c  HpcIOMHpIOLOIORL
  4590: 70 49 4f 4c 4f 49 4f 45 4c 70 49 4f 4c 4f 49 4f  pIOLOIOELpIOLOIO
  45a0: 4d 4c 70 49 4f 48 49 49 4f 52 48 a0 0f 93 49 4f  MLpIOHIIORH...IO
  45b0: 4c 4f 0a bc 70 0a 04 49 4f 4c 45 a1 08 70 0a 08  LO..p..IOLE..p..
  45c0: 49 4f 4c 45 70 01 60 70 49 4e 54 52 65 79 60 65  IOLEp.`pINTRey`e
  45d0: 49 52 51 57 70 01 60 70 44 4d 43 48 65 79 60 65  IRQWp.`pDMCHey`e
  45e0: 44 4d 41 43 45 58 46 47 a4 42 55 46 36 08 5f 50  DMACEXFG.BUF6._P
  45f0: 52 53 11 4c 04 0a 48 30 47 01 78 03 78 03 01 08  RS.L..H0G.x.x...
  4600: 47 01 78 07 78 07 01 04 22 b8 1e 2a 0a 00 30 47  G.x.x..."..*..0G
  4610: 01 78 02 78 02 01 08 47 01 78 06 78 06 01 04 22  .x.x...G.x.x..."
  4620: b8 1e 2a 0a 00 30 47 01 bc 03 bc 03 01 04 47 01  ..*..0G.......G.
  4630: bc 07 bc 07 01 04 22 b8 1e 2a 0a 00 38 79 00 14  ......"..*..8y..
  4640: 4e 08 5f 53 52 53 01 8c 68 0a 02 49 4f 4c 4f 8c  N._SRS..h..IOLO.
  4650: 68 0a 03 49 4f 48 49 8b 68 0a 02 49 4f 41 44 8b  h..IOHI.h..IOAD.
  4660: 68 0a 11 49 52 51 57 8c 68 0a 14 44 4d 41 43 45  h..IRQW.h..DMACE
  4670: 4e 46 47 70 0a 01 4c 44 4e 5f 70 01 41 43 54 52  NFGp..LDN_p.ACTR
  4680: 70 49 4f 4c 4f 49 4f 41 4c 70 49 4f 48 49 49 4f  pIOLOIOALpIOHIIO
  4690: 41 48 81 49 52 51 57 60 74 60 0a 01 60 70 60 49  AH.IRQW`t`..`p`I
  46a0: 4e 54 52 81 44 4d 41 43 61 70 44 4d 43 48 60 74  NTR.DMACapDMCH`t
  46b0: 61 0a 01 44 4d 43 48 53 4c 44 4d 60 44 4d 43 48  a..DMCHSLDM`DMCH
  46c0: 45 58 46 47 43 4b 49 4f 49 4f 41 44 0a 02 5b 80  EXFGCKIOIOAD..[.
  46d0: 4b 42 43 54 01 0a 60 0a 05 5b 81 12 4b 42 43 54  KBCT..`..[..KBCT
  46e0: 01 50 30 36 30 08 00 18 50 30 36 34 08 5b 82 4f  .P060...P064.[.O
  46f0: 08 50 53 32 4d 08 5f 48 49 44 0c 41 d0 0f 13 14  .PS2M._HID.A....
  4700: 17 5f 53 54 41 00 a0 0b 93 50 53 32 46 0a 00 a4  ._STA....PS2F...
  4710: 0a 0f a1 04 a4 0a 00 14 46 06 5f 43 52 53 00 08  ........F._CRS..
  4720: 42 55 46 31 11 08 0a 05 22 00 10 79 00 08 42 55  BUF1...."..y..BU
  4730: 46 32 11 18 0a 15 47 01 60 00 60 00 01 01 47 01  F2....G.`.`...G.
  4740: 64 00 64 00 01 01 22 00 10 79 00 a0 2b 93 4b 42  d.d..."..y..+.KB
  4750: 44 49 0a 01 a0 0d 93 4f 53 46 4c 0a 02 a4 42 55  DI.....OSFL...BU
  4760: 46 31 a0 0d 93 4f 53 46 4c 0a 01 a4 42 55 46 31  F1...OSFL...BUF1
  4770: a1 06 a4 42 55 46 32 a1 06 a4 42 55 46 31 5b 82  ...BUF2...BUF1[.
  4780: 40 05 50 53 32 4b 08 5f 48 49 44 0c 41 d0 03 03  @.PS2K._HID.A...
  4790: 08 5f 43 49 44 0c 41 d0 03 0b 14 17 5f 53 54 41  ._CID.A....._STA
  47a0: 00 a0 0b 93 4b 42 44 49 0a 01 a4 0a 00 a1 04 a4  ....KBDI........
  47b0: 0a 0f 08 5f 43 52 53 11 18 0a 15 47 01 60 00 60  ..._CRS....G.`.`
  47c0: 00 01 01 47 01 64 00 64 00 01 01 22 02 00 79 00  ...G.d.d..."..y.
  47d0: 5b 82 4c 06 50 53 4d 52 08 5f 48 49 44 0c 41 d0  [.L.PSMR._HID.A.
  47e0: 0c 02 08 5f 55 49 44 0a 03 14 39 5f 53 54 41 00  ..._UID...9_STA.
  47f0: a0 0b 93 4b 42 44 49 0a 00 a4 0a 00 a0 23 93 50  ...KBDI......#.P
  4800: 53 32 46 0a 00 a0 0b 93 4f 53 46 4c 0a 02 a4 0a  S2F.....OSFL....
  4810: 0f a0 0b 93 4f 53 46 4c 0a 01 a4 0a 0f a4 0a 00  ....OSFL........
  4820: a4 0a 00 08 5f 43 52 53 11 15 0a 12 47 01 60 00  ...._CRS....G.`.
  4830: 60 00 01 01 47 01 64 00 64 00 01 01 79 00 5b 82  `...G.d.d...y.[.
  4840: 40 17 47 41 4d 45 08 5f 48 49 44 0c 41 d0 b0 2f  @.GAME._HID.A../
  4850: 14 44 04 5f 53 54 41 00 45 4e 46 47 70 0a 07 4c  .D._STA.ENFGp..L
  4860: 44 4e 5f a0 11 91 49 4f 41 48 49 4f 41 4c 45 58  DN_...IOAHIOALEX
  4870: 46 47 a4 0a 0f a1 1f 7b 41 43 54 52 0a 02 60 a0  FG.....{ACTR..`.
  4880: 0c 93 60 0a 02 45 58 46 47 a4 0a 0d a1 08 45 58  ..`..EXFG.....EX
  4890: 46 47 a4 0a 00 14 27 5f 44 49 53 00 45 4e 46 47  FG....'_DIS.ENFG
  48a0: 70 0a 07 4c 44 4e 5f 70 00 49 4f 41 48 70 00 49  p..LDN_p.IOAHp.I
  48b0: 4f 41 4c 45 58 46 47 44 49 53 44 0a 04 14 4e 07  OALEXFGDISD...N.
  48c0: 5f 43 52 53 00 08 42 55 46 31 11 0d 0a 0a 47 01  _CRS..BUF1....G.
  48d0: 00 00 00 00 01 08 79 00 8c 42 55 46 31 0a 02 49  ......y..BUF1..I
  48e0: 4f 4c 4f 8c 42 55 46 31 0a 03 49 4f 48 49 8c 42  OLO.BUF1..IOHI.B
  48f0: 55 46 31 0a 04 49 4f 52 4c 8c 42 55 46 31 0a 05  UF1..IORL.BUF1..
  4900: 49 4f 52 48 45 4e 46 47 70 0a 07 4c 44 4e 5f 70  IORHENFGp..LDN_p
  4910: 49 4f 41 4c 49 4f 4c 4f 70 49 4f 41 4c 49 4f 52  IOALIOLOpIOALIOR
  4920: 4c 70 49 4f 41 48 49 4f 48 49 70 49 4f 41 48 49  LpIOAHIOHIpIOAHI
  4930: 4f 52 48 45 58 46 47 a4 42 55 46 31 08 5f 50 52  ORHEXFG.BUF1._PR
  4940: 53 11 18 0a 15 30 47 01 01 02 01 02 01 01 30 47  S....0G.......0G
  4950: 01 09 02 09 02 01 01 38 79 00 14 45 05 5f 53 52  .......8y..E._SR
  4960: 53 01 8c 68 0a 02 49 4f 4c 4f 8c 68 0a 03 49 4f  S..h..IOLO.h..IO
  4970: 48 49 8b 68 0a 02 49 4f 41 44 45 4e 46 47 70 0a  HI.h..IOADENFGp.
  4980: 07 4c 44 4e 5f 7d 41 43 54 52 0a 02 41 43 54 52  .LDN_}ACTR..ACTR
  4990: 70 49 4f 4c 4f 49 4f 41 4c 70 49 4f 48 49 49 4f  pIOLOIOALpIOHIIO
  49a0: 41 48 45 58 46 47 43 4b 49 4f 49 4f 41 44 0a 04  AHEXFGCKIOIOAD..
  49b0: 5b 82 43 28 4d 49 44 49 08 5f 48 49 44 0c 41 d0  [.C(MIDI._HID.A.
  49c0: b0 06 5b 80 4d 49 44 31 01 0b 90 02 0a 02 5b 81  ..[.MID1......[.
  49d0: 10 4d 49 44 31 01 4d 44 31 5f 08 53 54 31 5f 08  .MID1.MD1_.ST1_.
  49e0: 5b 80 4d 49 44 32 01 0b 00 03 0a 02 5b 81 10 4d  [.MID2......[..M
  49f0: 49 44 32 01 4d 44 32 5f 08 53 54 32 5f 08 5b 80  ID2.MD2_.ST2_.[.
  4a00: 4d 49 44 33 01 0b 30 03 0a 02 5b 81 10 4d 49 44  MID3..0...[..MID
  4a10: 33 01 4d 44 33 5f 08 53 54 33 5f 08 14 44 04 5f  3.MD3_.ST3_..D._
  4a20: 53 54 41 00 45 4e 46 47 70 0a 07 4c 44 4e 5f a0  STA.ENFGp..LDN_.
  4a30: 11 91 49 4f 32 48 49 4f 32 4c 45 58 46 47 a4 0a  ..IO2HIO2LEXFG..
  4a40: 0f a1 1f 7b 41 43 54 52 0a 04 60 a0 0c 93 60 0a  ...{ACTR..`...`.
  4a50: 04 45 58 46 47 a4 0a 0d a1 08 45 58 46 47 a4 0a  .EXFG.....EXFG..
  4a60: 00 14 2d 5f 44 49 53 00 45 4e 46 47 70 0a 07 4c  ..-_DIS.ENFGp..L
  4a70: 44 4e 5f 70 00 49 4f 32 48 70 00 49 4f 32 4c 70  DN_p.IO2Hp.IO2Lp
  4a80: 00 49 4e 54 52 45 58 46 47 44 49 53 44 0a 05 14  .INTREXFGDISD...
  4a90: 49 09 5f 43 52 53 00 08 42 55 46 31 11 10 0a 0d  I._CRS..BUF1....
  4aa0: 47 01 00 00 00 00 01 02 22 00 00 79 00 8c 42 55  G......."..y..BU
  4ab0: 46 31 0a 02 49 4f 4c 4f 8c 42 55 46 31 0a 03 49  F1..IOLO.BUF1..I
  4ac0: 4f 48 49 8c 42 55 46 31 0a 04 49 4f 52 4c 8c 42  OHI.BUF1..IORL.B
  4ad0: 55 46 31 0a 05 49 4f 52 48 8b 42 55 46 31 0a 09  UF1..IORH.BUF1..
  4ae0: 49 52 51 57 45 4e 46 47 70 0a 07 4c 44 4e 5f 70  IRQWENFGp..LDN_p
  4af0: 49 4f 32 4c 49 4f 4c 4f 70 49 4f 32 4c 49 4f 52  IO2LIOLOpIO2LIOR
  4b00: 4c 70 49 4f 32 48 49 4f 48 49 70 49 4f 32 48 49  LpIO2HIOHIpIO2HI
  4b10: 4f 52 48 70 01 60 79 60 49 4e 54 52 49 52 51 57  ORHp.`y`INTRIRQW
  4b20: 45 58 46 47 a4 42 55 46 31 08 5f 50 52 53 11 2a  EXFG.BUF1._PRS.*
  4b30: 0a 27 30 47 01 30 03 30 03 01 02 22 b8 1e 30 47  .'0G.0.0..."..0G
  4b40: 01 00 03 00 03 01 02 22 b8 1e 30 47 01 90 02 90  ......."..0G....
  4b50: 02 01 02 22 b8 1e 38 79 00 14 4b 0d 5f 53 52 53  ..."..8y..K._SRS
  4b60: 01 8c 68 0a 02 49 4f 4c 4f 8c 68 0a 03 49 4f 48  ..h..IOLO.h..IOH
  4b70: 49 8b 68 0a 02 49 4f 41 44 8b 68 0a 09 49 52 51  I.h..IOAD.h..IRQ
  4b80: 57 45 4e 46 47 70 0a 07 4c 44 4e 5f 7d 41 43 54  WENFGp..LDN_}ACT
  4b90: 52 0a 04 41 43 54 52 70 49 4f 4c 4f 49 4f 32 4c  R..ACTRpIOLOIO2L
  4ba0: 70 49 4f 48 49 49 4f 32 48 81 49 52 51 57 60 74  pIOHIIO2H.IRQW`t
  4bb0: 60 0a 01 60 70 60 49 4e 54 52 45 58 46 47 43 4b  `..`p`INTREXFGCK
  4bc0: 49 4f 49 4f 41 44 0a 05 a0 25 93 49 4f 41 44 0b  IOIOAD...%.IOAD.
  4bd0: 90 02 7b 53 54 31 5f 0a 40 60 a2 13 93 60 0a 40  ..{ST1_.@`...`.@
  4be0: 70 4d 44 31 5f 60 7b 53 54 31 5f 0a 40 60 a1 46  pMD1_`{ST1_.@`.F
  4bf0: 04 a0 25 93 49 4f 41 44 0b 00 03 7b 53 54 32 5f  ..%.IOAD...{ST2_
  4c00: 0a 40 60 a2 13 93 60 0a 40 70 4d 44 32 5f 60 7b  .@`...`.@pMD2_`{
  4c10: 53 54 32 5f 0a 40 60 a1 1d 7b 53 54 33 5f 0a 40  ST2_.@`..{ST3_.@
  4c20: 60 a2 13 93 60 0a 40 70 4d 44 33 5f 60 7b 53 54  `...`.@pMD3_`{ST
  4c30: 33 5f 0a 40 60 10 47 04 5c 00 14 42 04 53 41 4c  3_.@`.G.\..B.SAL
  4c40: 44 01 a0 09 93 68 0a 00 70 0a 40 60 a0 09 93 68  D....h..p.@`...h
  4c50: 0a 01 70 0a 80 60 a0 09 93 68 0a 03 70 0a c0 60  ..p..`...h..p..`
  4c60: a0 0b 93 68 0a 04 7f 0a 40 0a 40 60 a0 0b 93 68  ...h....@.@`...h
  4c70: 0a 05 7f 0a 40 0a 40 60 53 4c 45 44 60 10 28 5c  ....@.@`SLED`.(\
  4c80: 00 14 24 53 4c 45 44 01 45 4e 46 47 70 0a 09 4c  ..$SLED.ENFGp..L
  4c90: 44 4e 5f 7b 4f 50 54 34 0a 3f 60 7d 60 68 4f 50  DN_{OPT4.?`}`hOP
  4ca0: 54 34 45 58 46 47 14 1d 5c 2f 04 5f 53 42 5f 50  T4EXFG..\/._SB_P
  4cb0: 43 49 30 55 41 52 31 5f 50 52 57 00 a4 12 06 02  CI0UAR1_PRW.....
  4cc0: 0a 03 0a 05                                      ....

FACS @ 0x3fff0000
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00  FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

FACP @ 0x3fff3040
  0000: 46 41 43 50 74 00 00 00 01 49 4e 76 69 64 69 61  FACPt....INvidia
  0010: 41 57 52 44 41 43 50 49 31 2e 30 42 41 57 52 44  AWRDACPI1.0BAWRD
  0020: 00 00 00 00 00 00 ff 3f c0 30 ff 3f 01 00 09 00  .......?.0.?....
  0030: 2e 44 00 00 a1 a0 00 00 00 40 00 00 00 00 00 00  .D.......@......
  0040: 04 40 00 00 00 00 00 00 00 00 00 00 08 40 00 00  .@...........@..
  0050: 20 40 00 00 a0 44 00 00 04 02 00 04 08 10 20 00   @...D........ .
  0060: 65 00 e9 03 00 00 00 00 01 00 7d 7e 32 00 00 00  e.........}~2...
  0070: 85 04 00 00                                      ....

APIC @ 0x3fff7dc0
  0000: 41 50 49 43 6e 00 00 00 01 75 4e 76 69 64 69 61  APICn....uNvidia
  0010: 41 57 52 44 41 43 50 49 31 2e 30 42 41 57 52 44  AWRDACPI1.0BAWRD
  0020: 00 00 00 00 00 00 e0 fe 01 00 00 00 00 08 00 00  ................
  0030: 01 00 00 00 01 0c 02 00 00 00 c0 fe 00 00 00 00  ................
  0040: 02 0a 00 00 02 00 00 00 00 00 02 0a 00 09 09 00  ................
  0050: 00 00 0d 00 02 0a 00 0e 0e 00 00 00 05 00 02 0a  ................
  0060: 00 0f 0f 00 00 00 05 00 04 06 00 05 00 01        ..............

RSDT @ 0x3fff3000
  0000: 52 53 44 54 2c 00 00 00 01 c8 4e 76 69 64 69 61  RSDT,.....Nvidia
  0010: 41 57 52 44 41 43 50 49 31 2e 30 42 41 57 52 44  AWRDACPI1.0BAWRD
  0020: 00 00 00 00 40 30 ff 3f c0 7d ff 3f              ....@0.?.}.?

RSD PTR @ 0xf7220
  0000: 52 53 44 20 50 54 52 20 18 4e 76 69 64 69 61 00  RSD PTR .Nvidia.
  0010: 00 30 ff 3f                                      .0.?


--Boundary-00=_RookIvV3pjCtVkU--
