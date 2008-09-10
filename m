Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbYIJUql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbYIJUql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYIJUqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:46:34 -0400
Received: from filter2.host.bg ([87.120.40.156]:32784 "EHLO filter2.host.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYIJUqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:46:33 -0400
X-Greylist: delayed 653 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2008 16:46:33 EDT
Message-ID: <48C82F78.5050509@saturnosoft.biz>
Date: Wed, 10 Sep 2008 23:35:04 +0300
From: Todor Gyumyushev <todor@saturnosoft.biz>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel bug
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux macmini 2.6.26.3 #7 SMP Wed Sep 10 00:54:37 EEST 2008 x86_64 GNU/Linux

Gnu C                  4.3.1
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.41.0
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
wireless-tools         29
Modules Loaded         i915 drm hci_usb rfcomm l2cap vboxdrv pktcdvd 
nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs wlan_ccmp fan ac battery 
loop usblp snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm wlan_scan_sta 
sg rng_core tpm_infineon snd_timer ath_rate_sample snd_page_alloc 
snd_hwdep ath_pci iTCO_wdt thermal ohci1394 sr_mod snd evdev wlan 
iTCO_vendor_support tpm sky2 processor cdrom ieee1394 soundcore ehci_hcd 
uhci_hcd thermal_sys tpm_bios ath_hal button intel_agp hwmon


kernel BUG at drivers/char/random.c:728!
invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in: i915 drm hci_usb rfcomm l2cap vboxdrv pktcdvd nfsd 
lockd nfs_acl auth_rpcgss sunrpc exportfs wlan_ccmp fan ac battery loop 
usblp snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm wlan_scan_sta sg 
rng_core tpm_infineon snd_timer ath_rate_sample snd_page_alloc snd_hwdep 
ath_pci iTCO_wdt thermal ohci1394 sr_mod snd evdev wlan 
iTCO_vendor_support tpm sky2 processor cdrom ieee1394 soundcore ehci_hcd 
uhci_hcd thermal_sys tpm_bios ath_hal(P) button intel_agp hwmon
Pid: 9038, comm: VirtualBox Tainted: P          2.6.26.3 #7
RIP: 0010:[<ffffffff8036adc5>]  [<ffffffff8036adc5>] account+0x115/0x120
RSP: 0018:ffff810060ac5e88  EFLAGS: 00010206
RAX: 0000000000000400 RBX: ffffffff8055a760 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffffffff8055a760
RBP: 0000000000000000 R08: 000000000000001f R09: ffff810060ac5ea8
R10: 0000000000111fa4 R11: 000000000000001a R12: 0000000000001000
R13: 0000000000000000 R14: ffffffff8055a760 R15: 0000000000000000
FS:  00007ffa4c57e6f0(0000) GS:ffffffff80571000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffa480ca251 CR3: 0000000060897000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process VirtualBox (pid: 9038, threadinfo ffff810060ac4000, task 
ffff81006bb6b0f0)
Stack:  a1a2560907f2eb38 0000000000001000 0000000000001000 0000000000000000
 00007ffa4c583000 ffffffff8055a760 0000000000000000 ffffffff8036b361
 0000000000000001 0000000000000000 00000007ffa4c583 ffff810060975300
Call Trace:
 [<ffffffff8036b361>] extract_entropy_user+0x31/0xe0
 [<ffffffff8028fe08>] vfs_read+0xc8/0x170
 [<ffffffff8028ffb3>] sys_read+0x53/0xa0
 [<ffffffff8020b71b>] system_call_after_swapgs+0x7b/0x80


Code: 48 39 f8 0f 87 7d ff ff ff 0f 1f 44 00 00 4a 8d 04 e5 00 00 00 00 
29 c1 89 4b 30 e9 69 ff ff ff 66 0f 1f 44 00 00 45 31 e4 eb 9b <0f> 0b 
eb fe 0f 1f 80 00 00 00 00 41 57 49 89 f7 41 56 41 55 41
RIP  [<ffffffff8036adc5>] account+0x115/0x120
 RSP <ffff810060ac5e88>
---[ end trace d407014deb702b60 ]---

