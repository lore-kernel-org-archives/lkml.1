Return-Path: <linux-kernel-owner+w=401wt.eu-S935492AbXHJLkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935492AbXHJLkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761962AbXHJLjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:39:53 -0400
Received: from mailrelay.tu-graz.ac.at ([129.27.2.202]:58724 "EHLO
	mailrelay.tugraz.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078AbXHJLjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:39:51 -0400
X-Greylist: delayed 4410 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 07:39:51 EDT
X-DKIM: Sendmail DKIM Filter v2.0.0 mailrelay1.tugraz.at l7AAQF1J027094
Message-ID: <20070810122614.zm7yplmk0skgg080@webmail.tugraz.at>
X-Priority: 3 (Normal)
Date: Fri, 10 Aug 2007 12:26:14 +0200
From: Sinisa Segvic <sinisa.segvic@tugraz.at>
To: linux-kernel@vger.kernel.org
Subject: Kernel oops report
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.2-cvs)
X-Organization: Graz University of Technology
X-Originating-IP: 129.27.136.2
X-Remote-Browser: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6)
	Gecko/20061201 Firefox/2.0.0.6 (Ubuntu-feisty)
X-Spam-Scanner: SpamAssassin 3.002002 
X-Spam-Score-relay: -0.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just got a kernel oops.

http://lxr.linux.no/source/Documentation/oops-tracing.txt
seems to suggest that oops reports are welcome at this address.

Cheers,

Sinisa

$ uname -a
Linux PCs129.EMT.tugraz.at 2.6.20-16-386 #2 Thu Jun 7 20:16:13 UTC  
2007 i686 GNU/Linux



[326735.692443] BUG: unable to handle kernel NULL pointer dereference  
at virtual address 0000001b
[326735.692454]  printing eip:
[326735.692457] c015f581
[326735.692458] *pde = 00000000
[326735.692463] Oops: 0000 [#1]
[326735.692466] Modules linked in: nls_cp437 isofs udf binfmt_misc  
rfcomm l2cap bluetooth nfs lockd sunrpc xt_limit xt_tcpudp  
iptable_mangle ipt_LOG ipt_MASQUERADE nf_nat ipt_TOS ipt_REJECT  
nf_conntrack_irc nf_conntrack_ftp nf_conntrack_ipv4 xt_state  
nf_conntrack nfnetlink iptable_filter ip_tables x_tables ppdev radeon  
drm cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand  
freq_table cpufreq_conservative tc1100_wmi pcc_acpi dev_acpi sony_acpi  
video sbs i2c_ec dock button battery container ac asus_acpi backlight  
ipv6 fuse lp snd_cmipci gameport snd_pcm_oss snd_mixer_oss snd_pcm  
snd_page_alloc snd_opl3_lib snd_hwdep snd_mpu401_uart snd_seq_dummy  
snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event i2c_viapro  
parport_pc parport pcspkr psmouse i2c_core snd_seq snd_timer  
snd_seq_device rtc via_ircc snd irda soundcore crc_ccitt serio_raw  
via_agp agpgart shpchp pci_hotplug af_packet evdev tsdev ext3 jbd  
mbcache ide_cd cdrom ide_disk ata_generic libata scsi_mod via82cxxx  
8139too floppy 8139cp mii generic ohci1394 ieee1394 ehci_hcd uhci_hcd  
usbcore raid10 raid456 xor raid1 raid0 multipath linear md_mod thermal  
processor fan dm_mod fbcon tileblit font bitblit softcursor vesafb  
capability commoncap
[326735.692550] CPU:    0
[326735.692552] EIP:    0060:[<c015f581>]    Not tainted VLI
[326735.692553] EFLAGS: 00210082   (2.6.20-16-386 #2)
[326735.692565] EIP is at kfree+0x41/0x80
[326735.692568] eax: 40000080   ebx: 0000001b   ecx: dfffb3c4   edx: c11ce340
[326735.692572] esi: ce71ac00   edi: 00200286   ebp: cb2d64a0   esp: d0e4bdd8
[326735.692575] ds: 007b   es: 007b   ss: 0068
[326735.692579] Process firefox-bin (pid: 6763, ti=d0e4a000  
task=cf56c590 task.ti=d0e4a000)
[326735.692582] Stack: cb2d64a0 d0e4bedc d0e4bea0 c02701f8 00000020  
c02d0c4d c026d39d ffffffff
[326735.692589]        d032bc80 d032bdc0 cb2d64d0 d032bcd4 d0e4bea0  
cf12d8c0 00000020 00000001
[326735.692596]        00000001 ffffffa1 00000000 d0e4be80 00001302  
00000000 00000000 00000000
[326735.692601] Call Trace:
[326735.692608]  [<c02701f8>] kfree_skbmem+0x8/0x80
[326735.692619]  [<c02d0c4d>] unix_stream_recvmsg+0x1ad/0x540
[326735.692627]  [<c026d39d>] sock_alloc_send_skb+0x16d/0x1c0
[326735.692659]  [<c011fad6>] current_fs_time+0x46/0x50
[326735.692670]  [<c026a37f>] sock_aio_read+0x11f/0x130
[326735.692679]  [<c0168f2b>] pipe_write+0x22b/0x470
[326735.692706]  [<c0162ce5>] do_sync_read+0xd5/0x120
[326735.692729]  [<c012ded0>] autoremove_wake_function+0x0/0x50
[326735.692746]  [<c0130a72>] hrtimer_run_queues+0xf2/0x120
[326735.692754]  [<c02cfb79>] unix_ioctl+0x89/0xc0
[326735.692771]  [<c016375c>] vfs_read+0x17c/0x190
[326735.692782]  [<c0163b11>] sys_read+0x41/0x70
[326735.692793]  [<c0102fc0>] sysenter_past_esp+0x69/0xa9
[326735.692817]  =======================
[326735.692819] Code: 05 00 00 00 00 8d 96 00 00 00 40 89 c7 c1 ea 0c  
c1 e2 05 03 15 80 ba 44 c0 8b 02 f6 c4 40 75 2b 8b 02 84 c0 79 37 8b  
4a 18 8b 19 <8b> 03 3b 43 04 73 1e 89 74 83 10 83 c0 01 89 03 89 f8 50  
9d 8d
[326735.692843] EIP: [<c015f581>] kfree+0x41/0x80 SS:ESP 0068:d0e4bdd8
[326735.692849]

