Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbXLDPJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbXLDPJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbXLDPJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:09:22 -0500
Received: from gmrelay.centrum.cz ([213.29.7.208]:48793 "EHLO
	gmrelay.centrum.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbXLDPJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:09:21 -0500
X-Greylist: delayed 1730 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2007 10:09:20 EST
Date: Tue, 04 Dec 2007 15:40:15 +0100
From: <tovarekl@centrum.cz>
To: <linux-kernel@vger.kernel.org>
X-Mailer: Centrum Mail 1.0
MIME-Version: 1.0
X-Priority: 1
Message-ID: <200712041540.24458@centrum.cz>
References: <200712041345.380@centrum.cz>
In-Reply-To: <200712041345.380@centrum.cz>
Subject: EIP problem (kernel: BUG: unable to handle kernel NULL pointer)
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Kernel Gurus,

Please find kindly the description of EIP problems below.
I greatfully appreciate your kind help.

Thank you so much. :)

Much love
Leos.


Brief Description:
=============
1. Today (Dec 4) at 14:43 (GMT+3) EIP was sent, several minutes later my terminal window (on the same machine) got "hanging".
2. Writting text was possible in the window but no prompt came, no reaction on ^C neither ^Z.
3. Mouse: Mouse cursor ok, but it was impossible to switch desktops or windows (in the active desktop) with a mouse-click (no reaction).
4. Otherwise the machine was working (Apache, cron), it also responded to ping from the LAN. 
5. I restarted the machine (no fsck required) and since that time it runs ok.
6. Similar problem came yesterday, restart required manual fsck - what helped. 
7. Before it was running for 9 months (24/7) when the PC was bought, without any error.
Note: Internet access enabled through FW (yum-updatesd running).
 
 # uname -a
 Linux mocca 2.6.18-1.2798.fc6 #1 SMP Mon Oct 16 14:54:20 EDT 2006 i686 i686 i386 GNU/Linux
 
 messages:
 Dec  4 11:08:21 mocca ntpd[2316]: synchronized to 58.73.137.250, stratum 1
 Dec  4 14:43:07 mocca kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000040
 Dec  4 14:43:07 mocca kernel:  printing eip:
 Dec  4 14:43:07 mocca kernel: c04d525c
 Dec  4 14:43:07 mocca kernel: *pde = 6ed37067
 Dec  4 14:43:07 mocca kernel: Oops: 0000 [#1]
 Dec  4 14:43:07 mocca kernel: SMP 
 Dec  4 14:43:07 mocca kernel: last sysfs file: /devices/system/cpu/cpu1/cpufreq/scaling_setspeed
 Dec  4 14:43:07 mocca kernel: Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc acpi_cpufreq freq_table dm_multipath video sbs i2c_ec button 
 battery ac ipv6 parport_pc lp parport snd_hda_intel snd_hda_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mix
 er_oss snd_pcm floppy snd_timer sky2 ohci1394 ide_cd snd soundcore snd_page_alloc i2c_i801 i2c_core ieee1394 cdrom serio_raw pcspkr dm_snapshot dm_zero d
 m_mirror dm_mod ata_piix ahci libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
 Dec  4 14:43:07 mocca kernel: CPU:    1
 Dec  4 14:43:07 mocca kernel: EIP:    0060:[<c04d525c>]    Not tainted VLI
 Dec  4 14:43:07 mocca kernel: EFLAGS: 00010246   (2.6.18-1.2798.fc6 #1) 
 Dec  4 14:43:07 mocca kernel: EIP is at generic_make_request+0x26/0x2b3
 Dec  4 14:43:07 mocca kernel: eax: 00000000   ebx: 00001000   ecx: 00000001   edx: f7f50000
 Dec  4 14:43:07 mocca kernel: esi: 00000008   edi: 00000000   ebp: cb5e07c0   esp: f7f50ce4
 Dec  4 14:43:07 mocca kernel: ds: 007b   es: 007b   ss: 0068
 Dec  4 14:43:07 mocca kernel: Process pdflush (pid: 214, ti=f7f50000 task=f7f07440 task.ti=f7f50000)
 Dec  4 14:43:07 mocca kernel: Stack: c0679500 00011200 c0679500 f7f07440 c045391c 00000044 00000086 00000400 
 Dec  4 14:43:07 mocca kernel:        f7543be8 0fd00000 f7f07440 00000001 00000040 00000003 006b99d2 ad1dd135 
 Dec  4 14:43:07 mocca kernel:        00000095 c7b46000 00000095 c0467650 000000b9 00011200 f7fe0980 f7fe23c0 
 Dec  4 14:43:07 mocca kernel: Call Trace:
 Dec  4 14:43:07 mocca kernel:  [<c04d7314>] submit_bio+0xd5/0xdd
 Dec  4 14:43:07 mocca kernel:  [<c046ca05>] submit_bh+0xe5/0x103
 Dec  4 14:43:07 mocca kernel:  [<c046e0c5>] __block_write_full_page+0x240/0x346
 Dec  4 14:43:07 mocca kernel:  [<c046e483>] block_write_full_page+0xd9/0xe1
 Dec  4 14:43:07 mocca kernel:  [<c048a592>] mpage_writepages+0x1b1/0x340
 Dec  4 14:43:07 mocca kernel:  [<c04542b5>] do_writepages+0x20/0x32
 Dec  4 14:43:07 mocca kernel:  [<c0488d04>] __writeback_single_inode+0x195/0x2dc
 Dec  4 14:43:07 mocca kernel:  [<c04891a3>] sync_sb_inodes+0x17f/0x22a
 Dec  4 14:43:07 mocca kernel:  [<c0489417>] writeback_inodes+0x7b/0xc3
 Dec  4 14:43:07 mocca kernel:  [<c0454730>] wb_kupdate+0x82/0xe5
 Dec  4 14:43:07 mocca kernel:  [<c0454c7b>] pdflush+0x111/0x1aa
 Dec  4 14:43:07 mocca kernel:  [<c0432807>] kthread+0xc0/0xed
 Dec  4 14:43:07 mocca kernel:  [<c0405447>] kernel_thread_helper+0x7/0x10
 Dec  4 14:43:07 mocca kernel: DWARF2 unwinder stuck at kernel_thread_helper+0x7/0x10
 Dec  4 14:43:07 mocca kernel: Leftover inexact backtrace:
 Dec  4 14:43:07 mocca kernel:  =======================
 Dec  4 14:43:07 mocca kernel: Code: e9 24 fb ff ff 55 ba d3 0b 00 00 57 89 c5 56 53 83 c4 80 8b 58 20 b8 4a 63 63 c0 e8 cb 55 f4 ff e8 ef 50 13 00 8b 45 
 0c 8b 40 04 <8b> 50 40 8b 40 3c 0f ac d0 09 c1 fa 09 89 d1 09 c1 0f 84 b3 00 
 Dec  4 14:43:07 mocca kernel: EIP: [<c04d525c>] generic_make_request+0x26/0x2b3 SS:ESP 0068:f7f50ce4
 Dec  4 15:02:38 mocca syslogd 1.4.1: restart.
 Dec  4 15:02:38 mocca kernel: klogd 1.4.1, log source = /proc/kmsg started.
 Dec  4 15:02:38 mocca kernel: Linux version 2.6.18-1.2798.fc6 (brewbuilder@hs20-bc2-3.build.redhat.com) (gcc version 4.1.1 20061011 (Red Hat 4.1.1-30)) #1 
 SMP Mon Oct 16 14:54:20 EDT 2006
 Dec  4 15:02:38 mocca kernel: BIOS-provided physical RAM map:
 Dec  4 15:02:38 mocca kernel:  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 Dec  4 15:02:38 mocca kernel:  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 Dec  4 15:02:38 mocca kernel:  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 Dec  4 15:02:38 mocca kernel:  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 Dec  4 15:02:38 mocca kernel:  BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 Dec  4 15:02:38 mocca kernel:  BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 Dec  4 15:02:38 mocca kernel:  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 Dec  4 15:02:38 mocca kernel:  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 Dec  4 15:02:38 mocca kernel: 1151MB HIGHMEM available.
 Dec  4 15:02:38 mocca kernel: 896MB LOWMEM available.
 Dec  4 15:02:39 mocca kernel: found SMP MP-table at 000f5480
 Dec  4 15:02:39 mocca kernel: Using x86 segment limits to approximate NX protection
 Dec  4 15:02:41 mocca kernel: DMI 2.3 present.
 Dec  4 15:02:42 mocca kernel: Using APIC driver default
 Dec  4 15:02:42 mocca rpc.statd[2070]: Version 1.0.9 Starting
 ...
 Dec  4 15:03:34 mocca smartd[2561]: smartd has fork()ed into background mode. New PID=2561. 
 Dec  4 15:03:34 mocca kernel: Bluetooth: Core ver 2.10
 Dec  4 15:03:34 mocca kernel: NET: Registered protocol family 31
 Dec  4 15:03:35 mocca kernel: Bluetooth: HCI device and connection manager initialized
 Dec  4 15:03:35 mocca kernel: Bluetooth: HCI socket layer initialized
 Dec  4 15:03:35 mocca pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
 Dec  4 15:03:35 mocca kernel: Bluetooth: L2CAP ver 2.8
 Dec  4 15:03:35 mocca pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
 Dec  4 15:03:35 mocca kernel: Bluetooth: L2CAP socket layer initialized
 Dec  4 15:03:35 mocca pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
 Dec  4 15:03:36 mocca kernel: Bluetooth: RFCOMM socket layer initialized
 Dec  4 15:03:36 mocca pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
 Dec  4 15:03:36 mocca kernel: Bluetooth: RFCOMM TTY layer initialized
 Dec  4 15:03:36 mocca kernel: Bluetooth: RFCOMM ver 1.8
 Dec  4 15:03:36 mocca pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
 Dec  4 15:03:36 mocca kernel: Bluetooth: HIDP (Human Interface Emulation) ver 1.1
 Dec  4 15:03:36 mocca pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
 Dec  4 15:03:36 mocca kernel: hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
 Dec  4 15:03:36 mocca pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
 Dec  4 15:03:36 mocca kernel: hda: drive_cmd: error=0x04 { DriveStatusError }
 Dec  4 15:03:37 mocca pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
 Dec  4 15:03:37 mocca kernel: ide: failed opcode was: 0xb0
 Dec  4 15:03:37 mocca pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
 Dec  4 15:03:38 mocca kernel: hdc: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
 Dec  4 15:03:38 mocca pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
 Dec  4 15:03:38 mocca kernel: hdc: drive_cmd: error=0x04 { DriveStatusError }
 Dec  4 15:03:39 mocca kernel: ide: failed opcode was: 0xb0
 Dec  4 15:03:54 mocca gconfd (root-2765): starting (version 2.14.0), pid 2765 user 'root'
 Dec  4 15:03:54 mocca gconfd (root-2765): Resolved address "xml:readonly:/etc/gconf/gconf.xml.mandatory" to a read-only configuration source at position 0
 Dec  4 15:03:54 mocca gconfd (root-2765): Resolved address "xml:readwrite:/root/.gconf" to a writable configuration source at position 1
 Dec  4 15:03:54 mocca gconfd (root-2765): Resolved address "xml:readonly:/etc/gconf/gconf.xml.defaults" to a read-only configuration source at position 2
 Dec  4 15:03:57 mocca gconfd (root-2765): Resolved address "xml:readwrite:/root/.gconf" to a writable configuration source at position 0
 Dec  4 15:03:59 mocca pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
 Dec  4 15:03:59 mocca last message repeated 4 times
 Dec  4 15:06:19 mocca ntpd[2283]: synchronized to LOCAL(0), stratum 10
 Dec  4 15:06:19 mocca ntpd[2283]: kernel time sync enabled 0001
 Dec  4 15:07:23 mocca ntpd[2283]: synchronized to 63.240.161.99, stratum 2
 
 Since that time running normal way.
 
 

