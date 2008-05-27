Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbYE0PUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbYE0PUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYE0PU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:20:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:2463 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbYE0PUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:20:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mQhrPcVrhWL6FVx/M0h0Lf1VTpsu3ul78fIlcILqlJT2z7GQljilyecUuhhWyZcZzOogRoYRikqEl+A0ZEvaXleTGEGLygNsvr5mOIVuU5ETL9kMG8efVsdIwq8tJNiX4eSEjB9AWHFyKxMkgP/1o7PNVSgJy+gJ/g0WfiTYr3g=
Message-ID: <6101e8c40805270820r5984ceddmcc9ee1137e097b9e@mail.gmail.com>
Date: Tue, 27 May 2008 17:20:23 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: mrenzmann@otaku42.de, linux-kernel@vger.kernel.org
Subject: madwifi && v2.6.26-rc4
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

os: debian lenny
madwifi 0.9.3.3

CONFIG_ATHEROS=y
# CONFIG_ATHEROS_RATE_DEFAULT_AMRR is not set
# CONFIG_ATHEROS_RATE_DEFAULT_ONOE is not set
CONFIG_ATHEROS_RATE_DEFAULT_SAMPLE=y
CONFIG_ATHEROS_RATE_DEFAULT="sample"
# CONFIG_ATHEROS_RATE_AMRR is not set
# CONFIG_ATHEROS_RATE_ONOE is not set
CONFIG_ATHEROS_RATE_SAMPLE=y


linux-2.6 head on: 2548baa07ddf37ea8604e9627f042616d1cdc43e
lockdep enabled

CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y

=================================
[ INFO: inconsistent lock state ]
2.6.26-rc3-git8-00438-g61f522f #1
---------------------------------
inconsistent {in-softirq-W} -> {softirq-on-W} usage.
wpa_supplicant/2846 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&st->st_lock){-+..}, at: [<c039d4f0>] sta_iterate+0x38/0x99
{in-softirq-W} state was registered at:
  [<c0143d81>] __lock_acquire+0x361/0x10cb
  [<c0144b67>] lock_acquire+0x7c/0x96
  [<c039e488>] sta_add+0x49/0x48a
  [<c0505d44>] _spin_lock+0x2c/0x55
  [<c039e488>] sta_add+0x49/0x48a
  [<c039e43f>] sta_add+0x0/0x48a
  [<c039e488>] sta_add+0x49/0x48a
  [<c0142e39>] check_usage_forwards+0x19/0x42
  [<c014105b>] save_trace+0x37/0x91
  [<c039e43f>] sta_add+0x0/0x48a
  [<c0390b85>] ieee80211_add_scan+0x74/0x240
  [<c010b427>] save_stack_trace+0x28/0x43
  [<c0143c8c>] __lock_acquire+0x26c/0x10cb
  [<c017a045>] add_partial+0xe/0x53
  [<c038557a>] ieee80211_recv_mgmt+0x2585/0x483b
  [<c0505c57>] _spin_unlock+0x14/0x1c
  [<c014340d>] mark_held_locks+0x45/0x76
  [<c017c481>] kmem_cache_free+0x8f/0xb4
  [<c0143549>] trace_hardirqs_on+0x78/0x132
  [<c038b757>] ieee80211_hardstart+0x32/0x37c
  [<c038b757>] ieee80211_hardstart+0x32/0x37c
  [<c038b757>] ieee80211_hardstart+0x32/0x37c
  [<c0109075>] native_sched_clock+0x66/0xa1
  [<c0134b63>] __kernel_text_address+0x5/0xe
  [<c0358747>] ath_recv_mgmt+0x43/0x1c3
  [<c0143c8c>] __lock_acquire+0x26c/0x10cb
  [<c0358704>] ath_recv_mgmt+0x0/0x1c3
  [<c03821aa>] ieee80211_input+0xa34/0x17fb
  [<c0109075>] native_sched_clock+0x66/0xa1
  [<c0506295>] _spin_unlock_irqrestore+0x34/0x39
  [<c0382fb9>] ieee80211_input_all+0x48/0x84
  [<c035e3a7>] ath_rx_tasklet+0x7e5/0x817
  [<c034f46a>] skge_intr+0x143/0x465
  [<c0129dbc>] tasklet_action+0x2e/0xbf
  [<c0129ddb>] tasklet_action+0x4d/0xbf
  [<c01298bb>] __do_softirq+0x85/0xf9
  [<c0129985>] do_softirq+0x56/0x58
  [<c0129d21>] irq_exit+0x64/0x75
  [<c010658e>] do_IRQ+0x4a/0x94
  [<c01026b3>] default_idle+0x0/0x4c
  [<c010447c>] common_interrupt+0x24/0x34
  [<c01026b3>] default_idle+0x0/0x4c
  [<c0104486>] common_interrupt+0x2e/0x34
  [<c01026b3>] default_idle+0x0/0x4c
  [<c01026eb>] default_idle+0x38/0x4c
  [<c010260b>] cpu_idle+0x5d/0x9d
  [<ffffffff>] 0xffffffff
irq event stamp: 781
hardirqs last  enabled at (781): [<c017c892>] __kmalloc+0x60/0xe8
hardirqs last disabled at (780): [<c017c868>] __kmalloc+0x36/0xe8
softirqs last  enabled at (710): [<c04d6c92>] packet_poll+0x5a/0x65
softirqs last disabled at (708): [<c0505d79>] _spin_lock_bh+0xc/0x5a

other info that might help us debug this:
2 locks held by wpa_supplicant/2846:
 #0:  (rtnl_mutex){--..}, at: [<c04f60dc>] wext_handle_ioctl+0x3e/0x3f9
 #1:  (&st->st_scanlock){--..}, at: [<c039d4d8>] sta_iterate+0x20/0x99

stack backtrace:
Pid: 2846, comm: wpa_supplicant Not tainted 2.6.26-rc3-git8-00438-g61f522f #1
 [<c0142116>] print_usage_bug+0x13c/0x146
 [<c014324d>] mark_lock+0x3eb/0x566
 [<c0143dc0>] __lock_acquire+0x3a0/0x10cb
 [<c039d4d8>] sta_iterate+0x20/0x99
 [<c0144b67>] lock_acquire+0x7c/0x96
 [<c039d4f0>] sta_iterate+0x38/0x99
 [<c0505d44>] _spin_lock+0x2c/0x55
 [<c039d4f0>] sta_iterate+0x38/0x99
 [<c039d4f0>] sta_iterate+0x38/0x99
 [<c0397ad9>] giwscan_cb+0x0/0x907
 [<c0397ad9>] giwscan_cb+0x0/0x907
 [<c039081f>] ieee80211_scan_iterate+0x18/0x1f
 [<c0392dc0>] ieee80211_ioctl_giwscan+0x50/0xa9
 [<c04f5ed6>] ioctl_standard_call+0x182/0x34a
 [<c04f60dc>] wext_handle_ioctl+0x3e/0x3f9
 [<c04f60dc>] wext_handle_ioctl+0x3e/0x3f9
 [<c04f63fd>] wext_handle_ioctl+0x35f/0x3f9
 [<c0392d70>] ieee80211_ioctl_giwscan+0x0/0xa9
 [<c0392d70>] ieee80211_ioctl_giwscan+0x0/0xa9
 [<c02a0af7>] inode_has_perm+0x48/0x70
 [<c042e3d1>] dev_ioctl+0x4b4/0x51f
 [<c0109075>] native_sched_clock+0x66/0xa1
 [<c0423661>] sock_ioctl+0x0/0x17f
 [<c018a8ff>] vfs_ioctl+0x1f/0x6d
 [<c018ab8b>] do_vfs_ioctl+0x23e/0x287
 [<c018ac2a>] sys_ioctl+0x56/0x64
 [<c0103a09>] sysenter_past_esp+0x6a/0xb1
 =======================


-- 
Thanks,
Oliver
