Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbYGNHtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbYGNHtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbYGNHs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:48:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:16008 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbYGNHsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:48:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Ypr7iyfuSS6y1LOn6TRIA6CL4adi0dC5C05Dj2jg/LK7kTd9ksMKBSImn5Ki+E2G0F
         j2VX2kDhzQOpqbytIvme0Kkcb9zsCKTU4ootk0i2Nije0cuPhlgpzM1lPtMtrXq+Rn6l
         EIcGTH1YNyZx3VtPeTA981JHo9PBOl/EIYvxg=
Date: Mon, 14 Jul 2008 15:50:10 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: mac80211 : WARN at net/mac80211/rate.h:153
Message-ID: <20080714075010.GA3559@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I get warnings when I run
dhcpcd wlan0
The driver using is ath5k

warnings like following:

------------[ cut here ]------------
WARNING: at net/mac80211/rate.h:153 rate_control_pid_rate_init+0x7a/0xa0 [mac80211]()
Modules linked in: radeon drm snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss rfcomm l2cap bluetooth vfat fuse snd_hda_intel ath5k mac80211 rtc_cmos rtc_core rtc_lib psmouse snd_pcm snd_timer snd_page_alloc snd_hwdep 3c59x intel_agp snd e100 cfg80211 i2c_i801 serio_raw mii soundcore agpgart thermal processor button thermal_sys evdev sg
Pid: 0, comm: swapper Tainted: G        W 2.6.26-smp #1
 [<c0127954>] warn_on_slowpath+0x54/0x70
 [<c0177000>] ? print_trailer+0xa0/0xf0
 [<c0177071>] ? check_bytes_and_report+0x21/0xc0
 [<c0177452>] ? check_object+0xe2/0x1e0
 [<c0178117>] ? __slab_alloc+0x3a7/0x4c0
 [<f8d6a196>] ? rate_control_pid_alloc_sta+0x16/0x50 [mac80211]
 [<f8d6a2ba>] rate_control_pid_rate_init+0x7a/0xa0 [mac80211]
 [<f8d4fcf7>] ieee80211_ibss_add_sta+0xc7/0x110 [mac80211]
 [<f8d5a377>] __ieee80211_rx_handle_packet+0x417/0x7b0 [mac80211]
 [<c0177071>] ? check_bytes_and_report+0x21/0xc0
 [<f8d5c845>] __ieee80211_rx+0x185/0x560 [mac80211]
 [<c0109769>] ? read_tsc+0x9/0x30
 [<f89199dc>] ? ath5k_hw_get_tsf64+0x4c/0x90 [ath5k]
 [<f89161e3>] ath5k_tasklet_rx+0xf3/0x710 [ath5k]
 [<c0141f1d>] ? clocksource_get_next+0x3d/0x50
 [<c01408ad>] ? update_wall_time+0x28d/0x800
 [<f8919712>] ? ath5k_hw_is_intr_pending+0x22/0x50 [ath5k]
 [<c012d019>] tasklet_action+0x49/0xb0
 [<c012cae6>] __do_softirq+0x76/0xf0
 [<c012cb9b>] do_softirq+0x3b/0x50
 [<c012cf5c>] irq_exit+0x5c/0x70
 [<c0106995>] do_IRQ+0x45/0x80
 [<c012cf55>] ? irq_exit+0x55/0x70
 [<c011288b>] ? smp_apic_timer_interrupt+0x5b/0x90
 [<c010a220>] ? mwait_idle+0x0/0x40
 [<c0104623>] common_interrupt+0x23/0x28
 [<c010a220>] ? mwait_idle+0x0/0x40
 [<c010a252>] ? mwait_idle+0x32/0x40
 [<c01026db>] cpu_idle+0x5b/0xc0
 [<c042054e>] rest_init+0x4e/0x60
 =======================
---[ end trace de545485c8f84982 ]---
