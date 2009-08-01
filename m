Return-Path: <linux-kernel-owner+w=401wt.eu-S1751246AbZHAK4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbZHAK4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 06:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZHAKz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 06:55:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:54245 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750896AbZHAKz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 06:55:58 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19a+tAVS01a0lhDmaEZ5i2+ymap7YfX6hdi+NMBR9
	fS/r8Dboda2xGz
Subject: Re: rt2800usb: memory corruption?
From: Mike Galbraith <efault@gmx.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1249104348.7146.60.camel@marge.simson.net>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
	 <1248947740.8925.12.camel@johannes.local>
	 <1248948326.8823.4.camel@marge.simson.net>
	 <1248955916.7995.47.camel@marge.simson.net>
	 <1249104348.7146.60.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Aug 2009 12:55:54 +0200
Message-Id: <1249124154.8236.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-01 at 07:25 +0200, Mike Galbraith wrote:

> [ 1529.736962] rt2800usb 7-5:1.0: firmware: requesting rt2870.bin
> [ 1529.812574] input: rt2800usb as /devices/pci0000:00/0000:00:1a.7/usb7/7-5/7-5:1.0/input/input6
> [ 1530.011246] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 1532.575208] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
> [ 1532.589467] wlan0: authenticated
> [ 1532.599358] wlan0: associate with AP 00:1a:4f:9a:d0:12
> [ 1532.616210] wlan0: RX AssocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
> [ 1532.629818] wlan0: associated
> [ 1532.647010] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [ 1534.905025] device wlan0 entered promiscuous mode
> [ 1535.202677] martian source 255.255.255.255 from 192.168.178.1, on dev wlan0
> [ 1535.206611] ll header: ff:ff:ff:ff:ff:ff:00:1a:4f:7b:e8:48:08:00
> [ 1535.298916] martian source 255.255.255.255 from 192.168.178.1, on dev wlan0
> [ 1535.306059] ll header: ff:ff:ff:ff:ff:ff:00:1a:4f:7b:e8:48:08:00
> [ 1536.512420] ------------[ cut here ]------------
> [ 1536.516065] kernel BUG at mm/slub.c:2929!
> [ 1536.516065] invalid opcode: 0000 [#1] SMP 
> [ 1536.516065] last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
> [ 1536.516065] CPU 0 
> [ 1536.516065] Modules linked in: rt2800usb xt_tcpudp xt_pkttype xt_limit snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables cpufreq_conservative ip6table_filter cpufreq_ondemand ip6_tables cpufreq_userspace x_tables cpufreq_powersave acpi_cpufreq ipv6 microcode fuse loop dm_mod snd_hda_codec_realtek arc4 ecb snd_hda_intel snd_hda_codec rt2x00usb rt2x00lib firewire_ohci snd_hwdep snd_pcm led_class firewire_core snd_timer input_polldev crc_itu_t mac80211 snd ohci1394 usb_storage usbhid soundcore sr_mod rtc_cmos usb_libusual i2c_i801 cfg80211 snd_page_alloc rtc_core hid e1000e thermal processor ieee1394 i2c_core cdrom crc_ccitt intel_agp rtc_lib button sg uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 mbcache jbd ahci libata scsi_mod [last unloaded: rt2800usb]
> [ 1536.516065] Pid: 6982, comm: gam_server Not tainted 2.6.31-smp #1001 MS-7502
> [ 1536.516065] RIP: 0010:[<ffffffff810b7306>]  [<ffffffff810b7306>] kfree+0x82/0x187
> [ 1536.516065] RSP: 0018:ffff8800ad1b5df8  EFLAGS: 00010246
> [ 1536.516065] RAX: 4000000000000000 RBX: ffff88009d7113a8 RCX: 0000000000000000
> [ 1536.516065] RDX: ffffea0000000000 RSI: ffffffff814b39f2 RDI: ffff88001818500b
> [ 1536.516065] RBP: ffff8800ad1b5e28 R08: 0000000000000000 R09: ffff8800ad1b5e48
> [ 1536.516065] R10: ffff8800ad1b5e48 R11: 0000000000000246 R12: ffffea0000545518
> [ 1536.516065] R13: 0000000000000010 R14: ffff88001818500b R15: 0000000001eeb460
> [ 1536.516065] FS:  00007f08d83726f0(0000) GS:ffff8800014e1000(0000) knlGS:0000000000000000
> [ 1536.516065] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1536.516065] CR2: 00007f05b5c4e048 CR3: 00000000ad1a8000 CR4: 00000000000006f0
> [ 1536.516065] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1536.516065] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1536.516065] Process gam_server (pid: 6982, threadinfo ffff8800ad1b4000, task ffff8800be290cc0)
> [ 1536.516065] Stack:
> [ 1536.516065]  ffff8800ad1b5e38 ffff88009d7113a8 ffff88009d7113a8 0000000000000010
> [ 1536.516065] <0> 0000000000000002 0000000001eeb460 ffff8800ad1b5e48 ffffffff810e3b4c
> [ 1536.516065] <0> ffff8800ad1b5e48 0000000000000020 ffff8800ad1b5f08 ffffffff810e5e3b
> [ 1536.516065] Call Trace:
> [ 1536.516065]  [<ffffffff810e3b4c>] fsnotify_put_event+0x45/0x58
> [ 1536.891064]  [<ffffffff810e5e3b>] inotify_read+0x1f0/0x282
> [ 1536.891064]  [<ffffffff81050bba>] ? autoremove_wake_function+0x0/0x38
> [ 1536.891064]  [<ffffffff810bc2ac>] vfs_read+0xab/0x167
> [ 1536.891064]  [<ffffffff810bc42c>] sys_read+0x47/0x6f
> [ 1536.891064]  [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
> [ 1536.891064] Code: 00 ea ff ff 48 c1 e8 0c 48 6b c0 38 4c 8d 24 10 66 41 83 3c 24 00 79 05 4d 8b 64 24 10 49 8b 04 24 84 c0 78 17 66 a9 00 c0 75 04 <0f> 0b eb fe 4c 89 e7 e8 98 44 fe ff e9 e8 00 00 00 4d 8b 6c 24 
> [ 1536.891064] RIP  [<ffffffff810b7306>] kfree+0x82/0x187
> [ 1536.891064]  RSP <ffff8800ad1b5df8>
> [ 1537.069331] ---[ end trace 432a664becb6485b ]---
> [ 1543.056005] wlan0: no IPv6 routers present

Enabled slub/pagealloc debugging.  First down/rmmod said...

[  129.028042] wlan0: deauthenticating by local choice (reason=3)
[  140.015920] usbcore: deregistering interface driver rt2800usb
[  140.132315] =============================================================================
[  140.136190] BUG kmalloc-16: Redzone overwritten
[  140.136190] -----------------------------------------------------------------------------
[  140.136190]
[  140.136190] INFO: 0xffff8800bcdfa538-0xffff8800bcdfa53b. First byte 0xb instead of 0xcc
[  140.195773] INFO: Allocated in rt2x00usb_probe+0x127/0x1ad [rt2x00usb] age=31743 cpu=0 pid=1482
[  140.195773] INFO: Slab 0xffffea0002950eb0 objects=46 used=29 fp=0xffff8800bcdfa790 flags=0x4000000000000083
[  140.195773] INFO: Object 0xffff8800bcdfa528 @offset=1320 fp=0xffff8800bcdfa580
[  140.195773]
[  140.195773] Bytes b4 0xffff8800bcdfa518:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[  140.260506]   Object 0xffff8800bcdfa528:  00 00 00 00 cc 2e 40 18 c6 47 4c 18 51 92 16 18 ....Ì.@.ÆGL.Q...
[  140.260506]  Redzone 0xffff8800bcdfa538:  0b 50 18 18 cc cc cc cc                         .P..ÌÌÌÌ
[  140.260506]  Padding 0xffff8800bcdfa578:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
[  140.260506] Pid: 7812, comm: rmmod Not tainted 2.6.31-smp #1002
[  140.260506] Call Trace:
[  140.260506]  [<ffffffff810b820a>] print_trailer+0x13b/0x144
[  140.260506]  [<ffffffff810b871a>] check_bytes_and_report+0xb2/0xf2
[  140.260506]  [<ffffffffa0305080>] ? rt2x00usb_free_reg+0x18/0x55 [rt2x00usb]
[  140.260506]  [<ffffffff810b87b6>] check_object+0x5c/0x207
[  140.260506]  [<ffffffff810b9037>] __slab_free+0x193/0x2bf
[  140.260506]  [<ffffffffa0305080>] ? rt2x00usb_free_reg+0x18/0x55 [rt2x00usb]
[  140.260506]  [<ffffffff810ba49d>] kfree+0xcf/0xd9
[  140.260506]  [<ffffffffa0305080>] rt2x00usb_free_reg+0x18/0x55 [rt2x00usb]
[  140.260506]  [<ffffffffa03050e8>] rt2x00usb_disconnect+0x2b/0x58 [rt2x00usb]
[  140.260506]  [<ffffffffa00c88b4>] usb_unbind_interface+0x5d/0xed [usbcore]
[  140.260506]  [<ffffffff811c6914>] __device_release_driver+0x7a/0xc0
[  140.260506]  [<ffffffff811c69d5>] driver_detach+0x7b/0xa1
[  140.260506]  [<ffffffff811c5c80>] bus_remove_driver+0x86/0xb6
[  140.260506]  [<ffffffff811c6ed4>] driver_unregister+0x66/0x6e
[  140.260506]  [<ffffffffa00c86c9>] usb_deregister+0x98/0xa6 [usbcore]
[  140.260506]  [<ffffffffa030fbe4>] rt2800usb_exit+0x10/0x12 [rt2800usb]
[  140.260506]  [<ffffffff8106248f>] sys_delete_module+0x1cf/0x243
[  140.260506]  [<ffffffff81020062>] ? __assign_irq_vector+0xf8/0x1bd
[  140.260506]  [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
[  140.260506] FIX kmalloc-16: Restoring 0xffff8800bcdfa538-0xffff8800bcdfa53b=0xcc


