Return-Path: <linux-kernel-owner+w=401wt.eu-S1751867AbZJXCgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbZJXCgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 22:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZJXCgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 22:36:45 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:40852 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZJXCgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 22:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=v1Octb+qkgmBPTvhQNYKNiE4KfjSmDgUZnAUSSb8PheT1pqXTh8z0M4DMxgQc5xFih
         xagzuIpnO3U3QSsyAzpIUM2KYp/qlJPL6pB57DnP49GzYfIolVP6hW1o3+dJZLeCq/6j
         6lapAqmbjFADfOIfhNlmRW+IEsGgkM8Dr7YS8=
Message-ID: <4AE2683D.4020000@gmail.com>
Date: Fri, 23 Oct 2009 22:36:45 -0400
From: Miles Lane <miles.lane@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: 2.6.32-rc5-git3 -- EIP is at cfg80211_conn_work+0x73/0xd6 [cfg80211]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me know if you need my .config

*pde = 00000000
Modules linked in: ipv6 af_packet iptable_filter snd_hda_codec_realtek ip_tables snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm ath9k rtc_cmos uvcvideo eeepc_laptop mac80211 snd_timer rtc_core hwmon videodev ath cfg80211 v4l1_compat rtc_lib rfkill snd_page_alloc rng_core battery ac led_class pci_hotplug processor fan sg sd_mod ehci_hcd atl1e uhci_hcd thermal

Pid: 10, comm: events/1 Not tainted (2.6.32-rc5-git3 #4) 1000HE
EIP: 0060:[<f858ac49>] EFLAGS: 00010246 CPU: 1
EIP is at cfg80211_conn_work+0x73/0xd6 [cfg80211]
EAX: 00000000 EBX: f71ae5e8 ECX: 00000000 EDX: c16754e4
ESI: ead9c0c4 EDI: ead9c000 EBP: f7136f34 ESP: f7136f20
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
  ead9c084 ead9c00c c2e09700 ead9c164 f7136f94 f7136fa0 c103d5f5 00000000
<0> 00000002 00000000 c103d5b3 f7136f88 f7146c50 f7146900 f7146900 c2e09724
<0> c2e0971c f858abd6 ead9c148 f7146900 c2e09700 00000000 f7146900 c1040721
  [<c103d5f5>] ? worker_thread+0x161/0x233
  [<c103d5b3>] ? worker_thread+0x11f/0x233
  [<f858abd6>] ? cfg80211_conn_work+0x0/0xd6 [cfg80211]
  [<c1040721>] ? autoremove_wake_function+0x0/0x2f
  [<c103d494>] ? worker_thread+0x0/0x233
  [<c1040527>] ? kthread+0x5f/0x64
  [<c10404c8>] ? kthread+0x0/0x64
  [<c1003e9f>] ? kernel_thread_helper+0x7/0x1a
---[ end trace b24f325f9540f193 ]---
