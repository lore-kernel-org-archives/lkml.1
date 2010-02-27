Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967707Ab0B0CLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 21:11:11 -0500
Received: from smh1-gp.mediaserv.net ([213.188.172.31]:53254 "EHLO
	smhav-gp.mediaserv.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967250Ab0B0CLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 21:11:08 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 21:11:08 EST
From: werner@guyane.dyn-o-saur.com
Subject: 2.6.33 problems
To: linux-kernel@vger.kernel.org
X-Originating-IP: 127.0.0.1
X-Mailer: Usermin 1.360
Message-Id: <1267235038.26751@guyane.dyn-o-saur.com>
Date: Fri, 26 Feb 2010 22:43:58 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1267235038"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1267235038
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit






=======================
Feb 26 16:21:53 werner kernel: PERCPU: allocation failed, size=2048 align=8, failed to allocate new chunk
Feb 26 16:21:53 werner kernel: Pid: 5308, comm: modprobe Tainted: G         C 2.6.33 #1
Feb 26 16:21:53 werner kernel: Call Trace:
Feb 26 16:21:53 werner kernel:  [<c1c682ca>] ? printk+0x14/0x16
Feb 26 16:21:53 werner kernel:  [<c10bdfa3>] pcpu_alloc+0x6ba/0x73b
Feb 26 16:21:53 werner kernel:  [<c10bb0be>] ? get_slab+0x8/0x50
Feb 26 16:21:53 werner kernel:  [<c1b7283d>] ? neigh_parms_alloc+0x55/0xd1
Feb 26 16:21:53 werner kernel:  [<c10be047>] __alloc_percpu+0xf/0x14
Feb 26 16:21:53 werner kernel:  [<c1bb26cb>] snmp_mib_init+0x22/0x5a
Feb 26 16:21:53 werner kernel:  [<feb505af>] ipv6_add_dev+0x191/0x30b [ipv6]
Feb 26 16:21:53 werner kernel:  [<fd268000>] ? inet6_init+0x0/0x2a2 [ipv6]
Feb 26 16:21:53 werner kernel:  [<fd2682ec>] addrconf_init+0x3b/0x11b [ipv6]
Feb 26 16:21:53 werner kernel:  [<fd268195>] inet6_init+0x195/0x2a2 [ipv6]
Feb 26 16:21:53 werner kernel:  [<c1001143>] do_one_initcall+0x51/0x13f
Feb 26 16:21:53 werner kernel:  [<c1066570>] sys_init_module+0xac/0x1e0
Feb 26 16:21:53 werner kernel:  [<c1c6acec>] syscall_call+0x7/0xb
Feb 26 16:22:05 werner kdm_greet[5398]: Can't open default user face
Feb 26 16:23:22 werner named[5935]: /etc/named.conf:3: option 'multiple-cnames' is obsolete
Feb 26 16:23:22 werner kernel: PERCPU: allocation failed, size=2048 align=8, failed to allocate new chunk
Feb 26 16:23:22 werner kernel: Pid: 5940, comm: modprobe Tainted: G         C 2.6.33 #1
Feb 26 16:23:22 werner kernel: Call Trace:
Feb 26 16:23:22 werner kernel:  [<c1c682ca>] ? printk+0x14/0x16
Feb 26 16:23:22 werner kernel:  [<c10bdfa3>] pcpu_alloc+0x6ba/0x73b
Feb 26 16:23:22 werner kernel:  [<c10bb0be>] ? get_slab+0x8/0x50
Feb 26 16:23:22 werner kernel:  [<c1b7283d>] ? neigh_parms_alloc+0x55/0xd1
Feb 26 16:23:22 werner kernel:  [<c10be047>] __alloc_percpu+0xf/0x14
Feb 26 16:23:22 werner kernel:  [<c1bb26cb>] snmp_mib_init+0x22/0x5a
Feb 26 16:23:22 werner kernel:  [<feb505af>] ipv6_add_dev+0x191/0x30b [ipv6]
Feb 26 16:23:22 werner kernel:  [<f9195000>] ? inet6_init+0x0/0x2a2 [ipv6]
Feb 26 16:23:22 werner kernel:  [<f91952ec>] addrconf_init+0x3b/0x11b [ipv6]
Feb 26 16:23:22 werner kernel:  [<f9195195>] inet6_init+0x195/0x2a2 [ipv6]
Feb 26 16:23:22 werner kernel:  [<c1001143>] do_one_initcall+0x51/0x13f
Feb 26 16:23:22 werner kernel:  [<c1066570>] sys_init_module+0xac/0x1e0
Feb 26 16:23:22 werner kernel:  [<c1c6acec>] syscall_call+0x7/0xb

================
Feb 26 16:23:45 werner kernel: PERCPU: allocation failed, size=2048 align=8, failed to allocate new chunk
Feb 26 16:23:45 werner kernel: Pid: 6065, comm: modprobe Tainted: G         C 2.6.33 #1
Feb 26 16:23:45 werner kernel: Call Trace:
Feb 26 16:23:45 werner kernel:  [<c1c682ca>] ? printk+0x14/0x16
Feb 26 16:23:45 werner kernel:  [<c10bdfa3>] pcpu_alloc+0x6ba/0x73b
Feb 26 16:23:45 werner kernel:  [<c10bb0be>] ? get_slab+0x8/0x50
Feb 26 16:23:45 werner kernel:  [<c1b7283d>] ? neigh_parms_alloc+0x55/0xd1
Feb 26 16:23:45 werner kernel:  [<c10be047>] __alloc_percpu+0xf/0x14
Feb 26 16:23:45 werner kernel:  [<c1bb26cb>] snmp_mib_init+0x22/0x5a
Feb 26 16:23:45 werner kernel:  [<fed1b5af>] ipv6_add_dev+0x191/0x30b [ipv6]
Feb 26 16:23:45 werner kernel:  [<fd20a000>] ? inet6_init+0x0/0x2a2 [ipv6]
Feb 26 16:23:45 werner kernel:  [<fd20a2ec>] addrconf_init+0x3b/0x11b [ipv6]
Feb 26 16:23:45 werner kernel:  [<fd20a195>] inet6_init+0x195/0x2a2 [ipv6]
Feb 26 16:23:45 werner kernel:  [<c1001143>] do_one_initcall+0x51/0x13f
Feb 26 16:23:45 werner kernel:  [<c1066570>] sys_init_module+0xac/0x1e0
Feb 26 16:23:45 werner kernel:  [<c1c6acec>] syscall_call+0x7/0xb
Feb 26 16:23:45 werner kernel: BUG: unable to handle kernel paging request at feb748d4
Feb 26 16:23:45 werner kernel: IP: [<c1b68700>] unregister_pernet_operations+0x21/0x93
Feb 26 16:23:45 werner kernel: *pde = 36683067 *pte = 00000000 
Feb 26 16:23:45 werner kernel: Oops: 0002 [#1] PREEMPT SMP 
Feb 26 16:23:45 werner kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:0d.0/boot_vga
Feb 26 16:23:45 werner kernel: Modules linked in: ipv6(+) bnep rfcomm hidp l2cap bluetooth snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device rt2860sta(C) uvcvideo usbvideo lp snd_hda_codec_analog rtc_cmos rtc_core rtc_lib tpm_tis tpm rtl8187 tpm_bios mac80211 snd_hda_intel led_class snd_hda_codec k8temp hwmon snd_hwdep cfg80211 8139too snd_pcm rfkill snd_timer snd forcedeth soundcore snd_page_alloc i2c_nforce2
Feb 26 16:23:45 werner kernel: 
Feb 26 16:23:45 werner kernel: Pid: 6065, comm: modprobe Tainted: G         C 2.6.33 #1 M2N-VM DH/System Product Name
Feb 26 16:23:45 werner kernel: EIP: 0060:[<c1b68700>] EFLAGS: 00010246 CPU: 0
Feb 26 16:23:45 werner kernel: EIP is at unregister_pernet_operations+0x21/0x93
Feb 26 16:23:45 werner kernel: EAX: feb748d4 EBX: fed3f850 ECX: f29a3f58 EDX: fed3f8d4
Feb 26 16:23:45 werner kernel: ESI: fed3f850 EDI: fd20a000 EBP: f29a3f6c ESP: f29a3f58
Feb 26 16:23:45 werner kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Feb 26 16:23:45 werner kernel: Process modprobe (pid: 6065, ti=f29a2000 task=f296ef20 task.ti=f29a2000)
Feb 26 16:23:45 werner kernel: Stack:
Feb 26 16:23:45 werner kernel:  f29a3f58 f29a3f58 fed3f850 00000000 fd20a000 f29a3f78 c1b687c6 fffffff4
Feb 26 16:23:45 werner kernel: <0> f29a3f84 fd20a257 fed41834 f29a3f9c c1001143 00000000 fed41834 00000000
Feb 26 16:23:45 werner kernel: <0> 0805e188 f29a3fac c1066570 b7549008 0805e138 f29a2000 c1c6acec b7549008
Feb 26 16:23:45 werner kernel: Call Trace:
Feb 26 16:23:45 werner kernel:  [<fd20a000>] ? inet6_init+0x0/0x2a2 [ipv6]
Feb 26 16:23:45 werner kernel:  [<c1b687c6>] ? unregister_pernet_subsys+0x1c/0x29
Feb 26 16:23:45 werner kernel:  [<fd20a257>] ? inet6_init+0x257/0x2a2 [ipv6]
Feb 26 16:23:45 werner kernel:  [<c1001143>] ? do_one_initcall+0x51/0x13f
Feb 26 16:23:45 werner kernel:  [<c1066570>] ? sys_init_module+0xac/0x1e0
Feb 26 16:23:45 werner kernel:  [<c1c6acec>] ? syscall_call+0x7/0xb
Feb 26 16:23:45 werner kernel: Code: c2 75 e5 e8 78 0a 51 ff eb 97 55 89 e5 57 56 53 83 ec 08 e8 03 b2 49 ff 89 c6 8d 4d ec 89 4d ec 89 4d f0 8b 10 8b 40 04 89 42 04 <89> 10 c7 06 00 01 10 00 c7 46 04 00 02 20 00 a1 b8 b7 10 c2 8d 
Feb 26 16:23:45 werner kernel: EIP: [<c1b68700>] unregister_pernet_operations+0x21/0x93 SS:ESP 0068:f29a3f58
Feb 26 16:23:45 werner kernel: CR2: 00000000feb748d4
Feb 26 16:23:45 werner kernel: ---[ end trace dda352e53880a4df ]---

--bound1267235038--

