Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbZHDPHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbZHDPHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZHDPHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:07:20 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60231 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbZHDPHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=btGYuhE7kZ3VqoZLU22DzT29iCixrOd0Kdi02BBwSACYTCmEUoVsI+trat5OL11/Tf
         Wti19IyBQ7nCPIvfKFdI6Fq09BjKVEC2Sh7F1lMb+H4CsQ0MteWsj6PcV5Z7jK9vap8u
         wt9sc7ZUbA48VETsH8aUqOFXLxh5dwTrlLf5g=
MIME-Version: 1.0
In-Reply-To: <1240959723.1207.104.camel@rc-desk>
References: <c4e36d110904220333u37304c79k6ab528f92b5f3718@mail.gmail.com>
	 <20090422140107.GD3288@tuxdriver.com>
	 <c4e36d110904241218x209a4b76kf271f7288f1a33da@mail.gmail.com>
	 <c4e36d110904270059m3e43d6ccl18cc2ec6954e5649@mail.gmail.com>
	 <1240959723.1207.104.camel@rc-desk>
Date: Tue, 4 Aug 2009 17:07:16 +0200
Message-ID: <c4e36d110908040807s1778f392o941748fd2c373d4a@mail.gmail.com>
Subject: Re: regression IWl3945 - doesn't work with recent 2.6.30-rcX
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/29 reinette chatre <reinette.chatre@intel.com>:
> On Mon, 2009-04-27 at 00:59 -0700, Zdenek Kabelac wrote:
>> 2009/4/24 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> > 2009/4/22 John W. Linville <linville@tuxdriver.com>:
>> >> On Wed, Apr 22, 2009 at 12:33:03PM +0200, Zdenek Kabelac wrote:
>> >>> Hi
>> >>>
>> >>> I'm checking whether -rcX kernel could be usable on my
>> >>> T61/4GB/C2D/x86_64 - but wireless seems to be still out of
>> >>> functionality:
>> >>> I'm getting lots of weird trace-back messages and it looks like
>> >>> iwl3945 is not working at all.
>> >>> (attached messages from fresh build of -rc3 - but it never worked even in -rc1)
>> >>
>> >> Looks like this one did _not_ make -rc3:
>> >>
>> >> commit df833b1d73680f9f9dc72cbc3215edbbc6ab740d
>> >> Author: Reinette Chatre <reinette.chatre@intel.com>
>> >> Date:   Tue Apr 21 10:55:48 2009 -0700
>> >>
>> >>    iwlwifi: DMA fixes
>> >>
>> >>    A few issues wrt DMA were uncovered when using the driver with swiotlb.
>> >> ...
>> >>
>> >> It is in wireless-2.6 and should be in net-2.6 -- please try one of those kernels.
>> >
>> >
>> > I can confirm that current upstream linux commit
>> > 9f5a691253924fd033a58c6b1fed57bb0a4eccf4 works again with iwlwifi.
>> > and it already contains the patch you suggested to check.
>> >
>>
>>
>> While Wifi seems to be working well - I've noticed once attached long
>> INFO message during suspend.
>>
>> Zdenek
>>
>> -----------
>>
>> Linux version 2.6.30-rc3-00324-g8087eae (gcc version 4.4.0 20090414
>> (Red Hat 4.4.0-0.34) (GCC) ) #55 SMP Fri Apr 24 20:22:26 CEST 2009
>> Command line: ro root=/dev/sda5 selinux=0 no_console_suspend
>> ...
>> ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> virbr0: no IPv6 routers present
>> wlan0: authenticate with AP 00:11:d8:da:65:40
>> wlan0: authenticated
>> wlan0: associate with AP 00:11:d8:da:65:40
>> wlan0: RX AssocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=4)
>> wlan0: associated
>> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> wlan0: disassociating by local choice (reason=3)
>> audit(1240599276.009:18266): audit_enabled=0 old=1 auid=4294967295
>> ses=4294967295 res=1
>> wlan0: no IPv6 routers present
>> fuse init (API version 7.11)
>> wlan0: authenticate with AP 00:11:d8:da:65:40
>> wlan0: authenticated
>> wlan0: associate with AP 00:11:d8:da:65:40
>> wlan0: RX AssocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=4)
>> wlan0: associated
>> wlan0: no probe response from AP 00:11:d8:da:65:40 - disassociating
>> wlan0: deauthenticated (Reason: 7)
>> wlan0: authenticate with AP 00:11:d8:da:65:40
>> wlan0: authenticate with AP 00:11:d8:da:65:40
>> wlan0: authenticate with AP 00:11:d8:da:65:40
>> wlan0: authenticated
>> wlan0: associate with AP 00:11:d8:da:65:40
>> wlan0: RX ReassocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=4)
>> wlan0: associated
>>
>> ..........
>>
>> =========================================================
>> [ INFO: possible irq lock inversion dependency detected ]
>> 2.6.30-rc3-00324-g8087eae #55
>> ---------------------------------------------------------
>> swapper/0 just changed the state of lock:
>>  (&(&priv->scan_check)->timer){+.-...}, at: [<ffffffff80250d90>]
>> run_timer_softirq+0x120/0x2e0
>> but this lock was taken by another, HARDIRQ-safe lock in the past:
>>  (&priv->lock){-.-...}
>>
>> and interrupts could create inverse lock ordering between them.
>>
>>
>
> The locking used to protect scan_check is not consistent and is so
> because we overusing the priv->lock spinlock. scan_check is used in
> three places (iwl_rx_scan_complete_notif, iwl3945_bg_request_scan, and
> iwl3945_set_mode). In iwl_rx_scan_complete_notif the access is protected
> with priv->lock, while the other two use priv->mutex. The protection in
> iwl_rx_scan_complete_notif with priv->lock is not necessary ... but a
> significant effort is required to change this. We are starting to move
> in this direction. A workaround will be to acquire priv->lock in
> iwl3945_bg_request_scan and iwl3945_set_mode, but that will be ugly.
>
> We can leave this code as is in 2.6.30 because inverse lock ordering is
> not possible here as priv->mutex cannot be obtained in
> iwl_rx_scan_complete_notif path as it (the mutex) sleeps and this code
> path doesn't (it is run in a tasklet).
>

Hi

I'm not sure how it's related together - but this message I've got
today with 2.6.31-rc5.
Should I create a new report - or is it still the same not yet fixed issue ?

iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:03:00.0: Error setting new configuration (-110).
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:03:00.0: Error setting new configuration (-110).
iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
iwl3945 0000:03:00.0: Error setting new configuration (-110).
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
------------[ cut here ]------------
WARNING: at net/mac80211/scan.c:281
ieee80211_scan_completed+0xf1/0x4d0 [mac80211]()
Hardware name: 6464CTO
Modules linked in: oprofile fuse ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables bridge stp llc sunrpc autofs4 ipv6
nf_conntrack_ftp nf_conntrack binfmt_misc dm_mirror dm_region_hash
dm_log dm_mod kvm_intel kvm i915 drm i2c_algo_bit uinput
snd_hda_codec_analog arc4 ecb dvb_core cryptomgr videodev aead
v4l1_compat v4l2_compat_ioctl32 snd_hda_intel snd_hda_codec
snd_seq_oss pcompress crypto_blkcipher crypto_hash crypto_algapi btusb
snd_seq_midi_event snd_seq iwl3945 sdhci_pci iwlcore snd_seq_device
sdhci bluetooth mac80211 snd_pcm_oss mmc_core cfg80211 snd_mixer_oss
snd_pcm snd_timer i2c_i801 snd sr_mod i2c_core psmouse iTCO_wdt video
cdrom soundcore usbhid hid evdev thinkpad_acpi led_class serio_raw
iTCO_vendor_support intel_agp snd_page_alloc rtc_cmos rtc_core rtc_lib
rfkill e1000e backlight output nvram battery button ac uhci_hcd
ohci_hcd ehci_hcd usbcore [last unloaded: microcode]
Pid: 1007, comm: iwl3945 Tainted: G        W  2.6.31-rc5-00002-g43e068f #79
Call Trace:
 [<ffffffff8104c4eb>] warn_slowpath_common+0x7b/0xc0
 [<ffffffffa0232040>] ? iwl_bg_scan_completed+0x0/0x100 [iwlcore]
 [<ffffffff8104c544>] warn_slowpath_null+0x14/0x20
 [<ffffffffa01c88f1>] ieee80211_scan_completed+0xf1/0x4d0 [mac80211]
 [<ffffffff8105904a>] ? del_timer_sync+0x7a/0xa0
 [<ffffffff81058fd0>] ? del_timer_sync+0x0/0xa0
 [<ffffffffa0232040>] ? iwl_bg_scan_completed+0x0/0x100 [iwlcore]
 [<ffffffffa023208f>] iwl_bg_scan_completed+0x4f/0x100 [iwlcore]
 [<ffffffff810613d8>] worker_thread+0x1e8/0x3a0
 [<ffffffff81061386>] ? worker_thread+0x196/0x3a0
 [<ffffffff8137c11b>] ? thread_return+0x3e/0x703
 [<ffffffff81066d60>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff810611f0>] ? worker_thread+0x0/0x3a0
 [<ffffffff8106697e>] kthread+0x9e/0xb0
 [<ffffffff8100d1da>] child_rip+0xa/0x20
 [<ffffffff8100cb7c>] ? restore_args+0x0/0x30
 [<ffffffff810668e0>] ? kthread+0x0/0xb0
 [<ffffffff8100d1d0>] ? child_rip+0x0/0x20
---[ end trace 6ac8f069d92dd485 ]---

Zdenek
