Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZFDXKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZFDXKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 19:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZFDXKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 19:10:06 -0400
Received: from smtp4.netcologne.de ([194.8.194.137]:38105 "EHLO
	smtp4.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZFDXKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 19:10:05 -0400
X-Greylist: delayed 2030 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 19:10:04 EDT
From: Mathias Kretschmer <psoting@blx4.net>
Organization: BLX4
To: linux-kernel@vger.kernel.org
Subject: mISDN: WARNING: at kernel/softirq.c:124 local_bh_enable+0x8f/0xb0()
Date: Fri, 5 Jun 2009 00:07:12 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8; KDE/4.2.3; i686; ; )
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au> <20090603231152.GA18701@suse.de> <20090604232610.GA16053@intel.com>
In-Reply-To: <20090604232610.GA16053@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906050007.13507.psoting@blx4.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi *,

the following pops up from time to time when I place a call (might also 
happened on incoming calls). 

machine is an AMD K8 dual core running a x86_64 2.6.29.4-grsec kernel.

please, let me know if you need more details.

cheers,

Mathias

[88563.318126] ------------[ cut here ]------------
[88563.318129] WARNING: at kernel/softirq.c:124 local_bh_enable+0x8f/0xb0()
[88563.318130] Hardware name: empty
[88563.318132] Modules linked in: usbtouchscreen dvb_usb_cinergyT2 dummy 
bonding snd_emu10k1 snd_rawmidi snd_ac97_codec ath9k ac97_bus snd_pcm 
snd_page_alloc snd_util_mem forcedeth snd_hwdep
[88563.318141] Pid: 826, comm: mISDN_hfc-pci.1 Not tainted 2.6.29.4-grsec #13
[88563.318142] Call Trace:
[88563.318147]  [<ffffffff8025909a>] warn_slowpath+0xea/0x160
[88563.318149]  [<ffffffff8025ee0f>] local_bh_enable+0x8f/0xb0
[88563.318152]  [<ffffffff8065f284>] sk_filter+0x44/0xa0
[88563.318154]  [<ffffffff8064548d>] sock_queue_rcv_skb+0x5d/0x120
[88563.318156]  [<ffffffff8060410f>] mISDN_send+0x4f/0xa0
[88563.318159]  [<ffffffff8060790e>] l2up_create+0x7e/0x100
[88563.318161]  [<ffffffff8060b6e0>] l2_got_tei+0x0/0x90
[88563.318163]  [<ffffffff8060b722>] l2_got_tei+0x42/0x90
[88563.318164]  [<ffffffff80602d32>] mISDN_FsmEvent+0x82/0x100
[88563.318167]  [<ffffffff8060cb00>] tei_id_assign+0x0/0x120
[88563.318168]  [<ffffffff80602d32>] mISDN_FsmEvent+0x82/0x100
[88563.318170]  [<ffffffff8060e373>] mgr_send+0x4d3/0x660
[88563.318172]  [<ffffffff8061ac8e>] hfcpci_l2l1D+0x19e/0x2f0
[88563.318174]  [<ffffffff80606591>] mISDNStackd+0x431/0x680
[88563.318177]  [<ffffffff80270950>] autoremove_wake_function+0x0/0x30
[88563.318179]  [<ffffffff80606160>] mISDNStackd+0x0/0x680
[88563.318181]  [<ffffffff80270547>] kthread+0x47/0x80
[88563.318183]  [<ffffffff802226fa>] child_rip+0xa/0x20
[88563.318185]  [<ffffffff80270500>] kthread+0x0/0x80
[88563.318186]  [<ffffffff802226f0>] child_rip+0x0/0x20
[88563.318188] ---[ end trace 2a7bb9b2f669de5a ]---

