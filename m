Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbYBBC6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbYBBC6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 21:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757743AbYBBC63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 21:58:29 -0500
Received: from kuber.nabble.com ([216.139.236.158]:41417 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601AbYBBC61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 21:58:27 -0500
Message-ID: <15239145.post@talk.nabble.com>
Date: Fri, 1 Feb 2008 18:58:26 -0800 (PST)
From: Martin Bauer <bluescreen@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Oops in evdev_disconnect for kernel 2.6.23.12
In-Reply-To: <47829192.7030403@uni-koeln.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: bluescreen@web.de
References: <477A93CD.9030707@rrz.uni-koeln.de> <20080105065233.GE27894@ZenIV.linux.org.uk> <47801D70.8020504@uni-koeln.de> <20080106001756.GP27894@ZenIV.linux.org.uk> <47812E5B.6080000@uni-koeln.de> <20080106201559.GU27894@ZenIV.linux.org.uk> <478144E4.501@uni-koeln.de> <20080106234528.GV27894@ZenIV.linux.org.uk> <47829192.7030403@uni-koeln.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Berthold Cogel-2 wrote:
> 
> Those two patches solved the oops. I can remove and reconnnect the 
> tablet without problems.
> 

Dear Berthold,

I saw that you have problems with Ooops in evdev_disconnect. My problem is
similar I have a USB KVM switch and if I switch beetween computers U got a
Oops in evdev_disconnect (the first one is Kernel 2.6.23.12 and the second
Kernel 2.6.24, both has this problem). My question is, can you tell me which
two patches you have applied to solve the problem? I didn't found the right
thing?

Thank you very much for your help.

Regards
Martin Bauer

fyi:

Feb  2 03:00:46 mrb usb 5-2.4: USB disconnect, address 4
Feb  2 03:00:46 mrb usb 5-2.4.1: USB disconnect, address 5
Feb  2 03:00:46 mrb usb 5-2.4.3: USB disconnect, address 6
Feb  2 03:00:46 mrb Unable to handle kernel paging request at
0000000000100100 RIP:
Feb  2 03:00:46 mrb [<ffffffff80466447>] evdev_disconnect+0x7e/0xb8
Feb  2 03:00:46 mrb PGD 72d22067 PUD 75e99067 PMD 0
Feb  2 03:00:46 mrb Oops: 0000 [1] PREEMPT SMP
Feb  2 03:00:46 mrb CPU 0
Feb  2 03:00:46 mrb Modules linked in: vmnet(P) parport_pc parport
vmmon(P) capi capifs nfsd exportfs pppoe pppox ppp_generic slhc bridge
tun ipt_LOG xt_TCPMSS ipt_REJECT xt_state iptable_filter ipt_MASQUERADE
xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink
ip_tables x_tables snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss cpufreq_ondemand acpi_cpufreq
freq_table thermal snd_hda_intel processor nvidia(P) snd_pcm snd_timer
b1pci b1dma snd b1 arcmsr kernelcapi soundcore sg button snd_page_alloc
8250_pnp i2c_i801 joydev pcspkr intel_agp nfs nfs_acl lockd sunrpc jfs
scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd usbhid ff_memless
ohci_hcd uhci_hcd usb_storage libusual ehci_hcd usbcore
Feb  2 03:00:46 mrb Pid: 1001, comm: khubd Tainted: P
2.6.23-gentoo-r3 #1
Feb  2 03:00:46 mrb RIP: 0010:[<ffffffff80466447>]  [<ffffffff80466447>]
evdev_disconnect+0x7e/0xb8
Feb  2 03:00:46 mrb RSP: 0018:ffff81007d3e3c60  EFLAGS: 00010216
Feb  2 03:00:46 mrb RAX: 0000000000000000 RBX: 00000000000ffae8 RCX:
0000000000000000
Feb  2 03:00:46 mrb RDX: 0000000000000000 RSI: ffff81007e0be080 RDI:
0000000010000000
Feb  2 03:00:46 mrb RBP: ffff81007cc3a000 R08: ffff81007d3e2000 R09:
ffff810001011da8
Feb  2 03:00:46 mrb R10: 0000000000000000 R11: ffff810072c25b98 R12:
ffff81007cc3a088
Feb  2 03:00:46 mrb R13: ffff81007cc3a098 R14: ffff81007cc50470 R15:
ffff81007cc50000
Feb  2 03:00:46 mrb FS:  0000000000000000(0000)
GS:ffffffff80687000(0000) knlGS:0000000000000000
Feb  2 03:00:46 mrb CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb  2 03:00:46 mrb CR2: 0000000000100100 CR3: 0000000073359000 CR4:
00000000000006e0
Feb  2 03:00:46 mrb DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
Feb  2 03:00:46 mrb DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
Feb  2 03:00:46 mrb Process khubd (pid: 1001, threadinfo
ffff81007d3e2000, task ffff81007e0be080)
Feb  2 03:00:46 mrb Stack:  ffff81007d2a7000 ffff81007d2a7000
ffff81007d2a7918 ffff81007d2a7940
Feb  2 03:00:46 mrb ffff810037f8c800 ffffffff80464463 ffff810037e82200
ffff81007d96b890
Feb  2 03:00:46 mrb ffff81007d96b890 ffffffff8049ea93 ffff81007d91c030
ffff81007d91c000
Feb  2 03:00:46 mrb Call Trace:
Feb  2 03:00:46 mrb [<ffffffff80464463>] input_unregister_device
+0x70/0x105
Feb  2 03:00:46 mrb [<ffffffff8049ea93>] hidinput_disconnect+0x3d/0x56
Feb  2 03:00:46 mrb [<ffffffff8805e2ca>] :usbhid:hid_disconnect
+0x8d/0xfd
Feb  2 03:00:46 mrb [<ffffffff88007aed>] :usbcore:usb_unbind_interface
+0x3c/0x89
Feb  2 03:00:46 mrb [<ffffffff803f2a7b>] __device_release_driver
+0x8e/0xb0
Feb  2 03:00:46 mrb [<ffffffff803f1da4>] klist_devices_put+0x0/0xc
Feb  2 03:00:46 mrb [<ffffffff803f2e41>] device_release_driver+0x2c/0x44
Feb  2 03:00:46 mrb [<ffffffff803f2373>] bus_remove_device+0x89/0x9c
Feb  2 03:00:46 mrb [<ffffffff803f079c>] device_del+0x230/0x2bc
Feb  2 03:00:46 mrb [<ffffffff8800559f>] :usbcore:usb_disable_device
+0x6f/0xe8
Feb  2 03:00:46 mrb [<ffffffff88001ca2>] :usbcore:usb_disconnect
+0x96/0xfd
Feb  2 03:00:46 mrb [<ffffffff88001c8f>] :usbcore:usb_disconnect
+0x83/0xfd
Feb  2 03:00:46 mrb [<ffffffff88002407>] :usbcore:hub_thread+0x3bc/0xb60
Feb  2 03:00:46 mrb [<ffffffff8024806e>] autoremove_wake_function
+0x0/0x2e
Feb  2 03:00:46 mrb [<ffffffff8800204b>] :usbcore:hub_thread+0x0/0xb60
Feb  2 03:00:46 mrb [<ffffffff80247f3f>] kthread+0x47/0x74
Feb  2 03:00:46 mrb [<ffffffff8020cdb8>] child_rip+0xa/0x12
Feb  2 03:00:46 mrb [<ffffffff80247ef8>] kthread+0x0/0x74
Feb  2 03:00:46 mrb [<ffffffff8020cdae>] child_rip+0x0/0x12
Feb  2 03:00:46 mrb
Feb  2 03:00:46 mrb
Feb  2 03:00:46 mrb Code: 48 8b 83 18 06 00 00 0f 18 08 48 8d 83 18 06
00 00 4c 39 e0
Feb  2 03:00:46 mrb RIP  [<ffffffff80466447>] evdev_disconnect+0x7e/0xb8
Feb  2 03:00:46 mrb RSP <ffff81007d3e3c60>
Feb  2 03:00:46 mrb CR2: 0000000000100100
-- 
View this message in context: http://www.nabble.com/Oops-in-evdev_disconnect-for-kernel-2.6.23.12-tp14569588p15239145.html
Sent from the linux-kernel mailing list archive at Nabble.com.

