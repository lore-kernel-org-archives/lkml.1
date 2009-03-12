Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZCLG3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZCLG3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 02:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZCLG2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 02:28:53 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55776 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZCLG2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 02:28:52 -0400
Date: Thu, 12 Mar 2009 15:27:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       bug-tar@gnu.org
Subject: Re: I just got got another Oops
Message-Id: <20090312152727.45007c44.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200903120133.11583.gene.heskett@gmail.com>
References: <200903120133.11583.gene.heskett@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 01:33:11 -0400
Gene Heskett <gene.heskett@gmail.com> wrote:

> Greetings all;
> 
> This is the 2nd or 3rd one of these I've seen.
> 
Could you show me .config and disassemble of get_page_from_freelist()?

Thanks,
-Kame

> This one may have a better set of clues as it occured about 1 second 
> after amanda started the backup run:
> ==============================
> Mar 12 01:15:01 coyote xinetd[2583]: START: amanda pid=8970 from=::ffff:192.168.71.3                                                     
> Mar 12 01:16:21 coyote kernel: [10353.910914] BUG: unable to handle kernel NULL pointer dereference at 00000006                          
> Mar 12 01:16:21 coyote kernel: [10353.910921] IP: [<c046520b>] get_page_from_freelist+0x24b/0x4c0                                        
> Mar 12 01:16:21 coyote kernel: [10353.910929] *pdpt = 0000000000b38001 *pde = 0000000000000000                                           
> Mar 12 01:16:21 coyote kernel: [10353.910934] Oops: 0000 [#1] PREEMPT SMP                                                                
> Mar 12 01:16:21 coyote kernel: [10353.910937] last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/irq                                  
> Mar 12 01:16:21 coyote kernel: [10353.910940] Modules linked in: nls_utf8 cifs radeon drm nfsd lockd nfs_acl auth_rpcgss rfcomm 
> exportfs sco bridge stp llc bnep l2cap autofs4 sunrpc ipv6 or51132 cx88_dvb snd_emu10k1_synth videobuf_dvb snd_emux_synth 
> dvb_core snd_seq_virmidi snd_seq_midi_emul tuner_simple tuner_types snd_emu10k1 tda9887 snd_rawmidi tda8290 snd_ac97_codec 
> ac97_bus snd_seq_dummy snd_seq_oss tuner snd_seq_midi_event snd_seq snd_pcm_oss cx8800 cx8802 cx88xx snd_mixer_oss snd_pcm 
> snd_seq_device ir_common v4l2_common videodev i2c_algo_bit snd_timer snd_page_alloc tveeprom v4l1_compat snd_util_mem btcx_risc 
> snd_hwdep ftdi_sio videobuf_dma_sg usb_storage snd forcedethfirewire_ohci floppy videobuf_core btusb firewire_core usbserial 
> sr_mod usblp bluetooth cdrom sg soundcore i2c_nforce2 pcspkr crc_itu_t joydev i2c_core evdev button ahci pata_jmicron pata_amd 
> ata_generic pata_acpi sata_nv libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: 
> scsi_wait_scan]
> Mar 12 01:16:21 coyote kernel: [10353.910986]
> Mar 12 01:16:21 coyote kernel: [10353.910989] Pid: 9222, comm: tar Not tainted (2.6.29-rc7 #4) System Product Name
> Mar 12 01:16:21 coyote kernel: [10353.910992] EIP: 0060:[<c046520b>] EFLAGS: 00210202 CPU: 2
> Mar 12 01:16:21 coyote kernel: [10353.910995] EIP is at get_page_from_freelist+0x24b/0x4c0
> Mar 12 01:16:21 coyote kernel: [10353.910997] EAX: ffffffff EBX: 80004000 ECX: 00000001 EDX: 00000002
> Mar 12 01:16:21 coyote kernel: [10353.910999] ESI: c28fc260 EDI: 00000000 EBP: c0b35d5c ESP: c0b35cfc
> Mar 12 01:16:21 coyote kernel: [10353.911001]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Mar 12 01:16:21 coyote kernel: [10353.911004] Process tar (pid: 9222, ti=c0b35000 task=f2817520 task.ti=c0b35000)
> Mar 12 01:16:21 coyote kernel: [10353.911005] Stack:
> Mar 12 01:16:21 coyote kernel: [10353.911006]  00000002 00000044 00000000 00000000 00000000 c0744b80 c06d6480 00000002
> Mar 12 01:16:21 coyote kernel: [10353.911011]  00000000 00000000 001201d2 00000002 00200246 00000001 c06d6900 00000100
> Mar 12 01:16:21 coyote kernel: [10353.911015]  00000000 c0b35dac c06d7484 c06d6480 c06d6480 c06d6480 f2817520 00002f66
> Mar 12 01:16:21 coyote kernel: [10353.911020] Call Trace:
> Mar 12 01:16:21 coyote kernel: [10353.911022]  [<c04655fe>] ? __alloc_pages_internal+0xae/0x430
> Mar 12 01:16:21 coyote kernel: [10353.911028]  [<f82b5c60>] ? ext3_readpages+0x0/0x20 [ext3]
> Mar 12 01:16:21 coyote kernel: [10353.911040]  [<c04676b4>] ? __do_page_cache_readahead+0xe4/0x1e0
> Mar 12 01:16:21 coyote kernel: [10353.911044]  [<c0467a9b>] ? ondemand_readahead+0x15b/0x180
> Mar 12 01:16:21 coyote kernel: [10353.911047]  [<c0467b38>] ? page_cache_async_readahead+0x78/0x90
> Mar 12 01:16:21 coyote kernel: [10353.911050]  [<c0461434>] ? generic_file_aio_read+0x314/0x670
> Mar 12 01:16:21 coyote kernel: [10353.911058]  [<c048a011>] ? do_sync_read+0xd1/0x110
> Mar 12 01:16:21 coyote kernel: [10353.911061]  [<c04133a3>] ? lapic_next_event+0x13/0x20
> Mar 12 01:16:21 coyote kernel: [10353.911065]  [<c043c3c0>] ? autoremove_wake_function+0x0/0x50
> Mar 12 01:16:21 coyote kernel: [10353.911069]  [<c0447c4b>] ? tick_program_event+0x2b/0x40
> Mar 12 01:16:21 coyote kernel: [10353.911072]  [<c0440086>] ? hrtimer_interrupt+0xd6/0x220
> Mar 12 01:16:21 coyote kernel: [10353.911075]  [<c048aac9>] ? vfs_read+0x99/0x140
> Mar 12 01:16:21 coyote kernel: [10353.911077]  [<c0458e20>] ? audit_syscall_exit+0x1e0/0x3e0
> Mar 12 01:16:21 coyote kernel: [10353.911081]  [<c0489f40>] ? do_sync_read+0x0/0x110
> Mar 12 01:16:21 coyote kernel: [10353.911083]  [<c048ac2d>] ? sys_read+0x3d/0x70
> Mar 12 01:16:21 coyote kernel: [10353.911085]  [<c040336d>] ? sysenter_do_call+0x12/0x21
> Mar 12 01:16:21 coyote kernel: [10353.911088] Code: ff 75 d0 9d 89 e0 25 00 f0 ff ff 83 68 14 01 f6 40 08 08 0f 85 30 02 00 00 
> 8b 1e 89 f2 8b 46 08 8b 7e 10 f6 c7 40 74 03 8b 56 0c <8b> 4a 04 31 d2 85 ff 0f 95 c2 83 c0 01 09 c2 31 c0 85 c9 0f 95
> Mar 12 01:16:21 coyote kernel: [10353.911112] EIP: [<c046520b>] get_page_from_freelist+0x24b/0x4c0 SS:ESP 0068:c0b35cfc
> Mar 12 01:16:21 coyote kernel: [10353.911117] ---[ end trace 8d9559cb0f5d9d82 ]---
> ========================
> 
> And it was accompanied by some sort of an alert mechanism in F10 that said 
> 'KDE Write Daemon' in a series of 22 stacked vertically boxes, and duplicated 
> many but not all, of the above messages.  They weren't clipboardable. :(
> 
> -- 
> Cheers, Gene
> "There are four boxes to be used in defense of liberty:
>  soap, ballot, jury, and ammo. Please use in that order."
> -Ed Howdershelt (Author)
> It's difficult to see the picture when you are inside the frame.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

