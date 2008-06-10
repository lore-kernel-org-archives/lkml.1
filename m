Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbYFJEYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbYFJEYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 00:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYFJEYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 00:24:46 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:34373 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbYFJEYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 00:24:45 -0400
Message-ID: <484E0200.6060107@linux.vnet.ibm.com>
Date: Tue, 10 Jun 2008 09:54:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: 2.6.26-rc5-mm1 -- WARNING: at kernel/res_counter.c:49 res_counter_uncharge_locked+0x5a/0x96()
References: <a44ae5cd0806091521h25b55967k249d7e5b34679322@mail.gmail.com>
In-Reply-To: <a44ae5cd0806091521h25b55967k249d7e5b34679322@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> kernel: WARNING: at kernel/res_counter.c:49
> res_counter_uncharge_locked+0x5a/0x96()
> kernel: Modules linked in: cpufreq_ondemand cpufreq_conservative sbs
> sbshc battery ac sbp2 arc4 snd_intel8x0 snd_ac97_codec ac97_bus
> snd_pcm_oss snd_mixer_oss ecb crypto_blkcipher cryptomgr snd_pcm
> crypto_algapi snd_seq_dummy rtc b43 snd_seq_oss snd_seq_midi_event
> mac80211 cfg80211 led_class snd_seq ohci1394 ieee1394 snd_timer
> snd_seq_device snd shpchp pci_hotplug soundcore snd_page_alloc
> i2c_nforce2 i2c_core button thermal processor fan
> kernel: Pid: 4168, comm: expr Tainted: G        W 2.6.26-rc5-mm1 #2
> kernel:  [mac80211:warn_on_slowpath+0x95/0x5c6] warn_on_slowpath+0x95/0xf1
> kernel:  [__slab_free+0x268/0x7ff] ? __slab_free+0x268/0x7ff
> kernel:  [processor:trace_hardirqs_on+0x27/0xde1c] ? trace_hardirqs_on+0x27/0x37
> kernel:  [free_hot_cold_page+0x454/0x4c3] ? free_hot_cold_page+0x454/0x4c3
> kernel:  [paravirt_get_lazy_mode+0x1c/0x37] ? paravirt_get_lazy_mode+0x1c/0x37
> kernel:  [unmap_vmas+0x984/0xd55] ? unmap_vmas+0x984/0xd55
> kernel:  [res_counter_uncharge+0x26/0x6b] ? res_counter_uncharge+0x26/0x6b
> kernel:  [res_counter_uncharge_locked+0x5a/0x96]
> res_counter_uncharge_locked+0x5a/0x96
> kernel:  [res_counter_uncharge+0x40/0x6b] res_counter_uncharge+0x40/0x6b
> kernel:  [memrlimit_cgroup_uncharge_as+0x47/0x57]
> memrlimit_cgroup_uncharge_as+0x47/0x57
> kernel:  [unmap_region+0x14e/0x29e] unmap_region+0x14e/0x29e
> kernel:  [do_munmap+0x339/0x41d] do_munmap+0x339/0x41d
> kernel:  [sys_munmap+0x76/0xa1] sys_munmap+0x76/0xa1
> kernel:  [sysenter_past_esp+0x78/0xc5] sysenter_past_esp+0x78/0xc5
> kernel:  =======================
> kernel: ---[ end trace c305141495cb1ca4 ]---
> 

Hi,

Could you please see if the patch at

http://lkml.org/lkml/2008/6/9/274

fixes your problem


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
