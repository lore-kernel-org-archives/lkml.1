Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZAFRIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZAFRIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZAFRHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:07:55 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:41026 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZAFRHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:07:54 -0500
Date: Tue, 6 Jan 2009 22:37:40 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: linville@tuxdriver.com, davem@davemloft.net
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: WARNING: at net/mac80211/rx.c:2234 __ieee80211_rx+0x7f/0x559
	[mac80211]()
Message-ID: <20090106170740.GD11588@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see this on current git. Not sure how to reproduce it, has happened on
two random occasions. At both times, I was not connected to a wireless
network, but to wired networks.

------------[ cut here ]------------
WARNING: at net/mac80211/rx.c:2234 __ieee80211_rx+0x7f/0x559
[mac80211]()
Hardware name: 2007CS3
Modules linked in: tun fuse radeon drm ipt_MASQUERADE iptable_nat nf_nat
bridge stp bnep sco l2cap bluetooth ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq
dm_multipath kvm_intel kvm uinput snd_hda_codec_analog snd_hda_intel
snd_hd
a_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
arc4 snd_seq_device ecb snd_pcm_oss ath5k mac80211 snd_mixer_oss
thinkpad_acpi snd_pcm rfkill hwmon snd_timer i2c_i801 snd iTCO_wdt
yenta_socket pcspkr joydev nsc_ircc i2c_core iTCO_vendor_support
rsrc_non
static cfg80211 soundcore irda snd_page_alloc video output crc_ccitt
[last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Not tainted 2.6.28 #5
Call Trace:
 [<c043180f>] warn_slowpath+0x76/0xad
 [<c04512d8>] ? __lock_acquire+0xb3b/0xb4a
 [<c044f3bd>] ? trace_hardirqs_off+0xb/0xd
 [<f80d4192>] __ieee80211_rx+0x7f/0x559 [mac80211]
 [<f80a19f4>] ath5k_tasklet_rx+0x4f7/0x53b [ath5k]
 [<c06f6edb>] ? _spin_unlock_irq+0x27/0x34
 [<c04360fc>] tasklet_action+0x84/0xef
 [<c0436802>] __do_softirq+0x9d/0x157
 [<c0436765>] ? __do_softirq+0x0/0x157
 <IRQ>  [<c0470e78>] ? handle_fasteoi_irq+0x0/0xb6
 [<c0436493>] ? irq_exit+0x49/0x85
 [<c04055df>] ? do_IRQ+0xf5/0x10b
 [<c04042ac>] ? common_interrupt+0x2c/0x34
 [<c045017e>] ? trace_hardirqs_on+0xb/0xd
 [<c045007b>] ? trace_hardirqs_on_caller+0x5c/0x154
 [<c058cf89>] ? acpi_idle_enter_bm+0x281/0x2d0
 [<c0665273>] ? cpuidle_idle_call+0x65/0x96
 [<c0402c96>] ? cpu_idle+0x84/0xae
 [<c06e2e1b>] ? rest_init+0x53/0x55
---[ end trace e5a3692e59279535 ]---

Thanks,
-- 
regards,
Dhaval
