Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbZANXP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbZANXP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 18:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbZANXPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 18:15:49 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:36580 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbZANXPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 18:15:48 -0500
Date: Thu, 15 Jan 2009 00:15:46 +0100
To: linux-kernel@vger.kernel.org
Subject: 2.6.29-rc1-wl gives WARNING on ich8lan
Message-ID: <20090114231546.GI1457@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

(please cc)

2.6.29-rc1-wl (wireless testing) gives me:

[  367.804080] WARNING: at drivers/net/e1000e/ich8lan.c:412 e1000_acquire_swflag_ich8lan+0x35/0xcc()
[  367.804085] Hardware name: VGN-Z11VN_B
[  367.804088] e1000e mutex contention. Owned by pid 3781
[  367.804092] Modules linked in: binfmt_misc rfcomm l2cap kvm isofs zlib_inflate fuse dm_crypt dm_mod firewire_sbp2 loop arc4 iwlagn iwlcore rfkill joydev firewire_ohci mac80211 firewire_core crc_itu_t cfg80211 btusb sony_laptop tpm_infineon video backlight
[  367.804143] Pid: 8, comm: events/1 Not tainted 2.6.29-rc1-wl #1
[  367.804148] Call Trace:
[  367.804158]  [<ffffffff80236441>] warn_slowpath+0xd8/0x112
[  367.804169]  [<ffffffff8051152f>] _spin_unlock_irqrestore+0x31/0x3d
[  367.804178]  [<ffffffff802324f9>] try_to_wake_up+0x168/0x17a
[  367.804186]  [<ffffffff8023250b>] default_wake_function+0x0/0x9
[  367.804196]  [<ffffffff80323438>] delay_tsc+0x0/0xc8
[  367.804204]  [<ffffffff8022c48d>] dequeue_entity+0xf/0x102
[  367.804211]  [<ffffffff803a12a4>] e1000_acquire_swflag_ich8lan+0x35/0xcc
[  367.804219]  [<ffffffff803a5c0b>] e1000e_read_phy_reg_bm+0x39/0xbe
[  367.804227]  [<ffffffff803a5ee7>] e1000e_phy_has_link_generic+0x50/0xcc
[  367.804234]  [<ffffffff8022c48d>] dequeue_entity+0xf/0x102
[  367.804242]  [<ffffffff803ad593>] e1000_watchdog_task+0x0/0x6ef
[  367.804249]  [<ffffffff803a4d25>] e1000e_check_for_copper_link+0x24/0x86
[  367.804257]  [<ffffffff8023f05e>] lock_timer_base+0x26/0x4b
[  367.804265]  [<ffffffff803aa186>] e1000_has_link+0x40/0xc1
[  367.804272]  [<ffffffff803ad5ca>] e1000_watchdog_task+0x37/0x6ef
[  367.804280]  [<ffffffff803ad593>] e1000_watchdog_task+0x0/0x6ef
[  367.804289]  [<ffffffff80245058>] run_workqueue+0x87/0x122
[  367.804296]  [<ffffffff802451cb>] worker_thread+0xd8/0xe7
[  367.804304]  [<ffffffff802487a8>] autoremove_wake_function+0x0/0x2e
[  367.804311]  [<ffffffff802450f3>] worker_thread+0x0/0xe7
[  367.804318]  [<ffffffff802450f3>] worker_thread+0x0/0xe7
[  367.804324]  [<ffffffff8024848f>] kthread+0x47/0x73
[  367.804332]  [<ffffffff8020c6aa>] child_rip+0xa/0x20
[  367.804338]  [<ffffffff80248448>] kthread+0x0/0x73
[  367.804344]  [<ffffffff8020c6a0>] child_rip+0x0/0x20
[  367.804349] ---[ end trace 608ec83548aefe5d ]---

Should I be concerned?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
BARSTIBLEY
A humorous device such as a china horse or small naked porcelain
infant which jocular hosts use of piss water into your Scotch with.
			--- Douglas Adams, The Meaning of Liff
