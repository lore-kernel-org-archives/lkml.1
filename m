Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZK0UWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZK0UWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 15:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZK0UWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 15:22:40 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44938 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZK0UWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 15:22:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bvg9ACmVgA7L3WuBAM2ZwCBdm/OE2+F+WNXqcvxiFa3seXRdXrfherz7j+6V3cwFNa
         oF2yxoKwI7u6mDDSdsVei163/i4jeU2y8gZGFyFhjUq7de0QbprF+GS4xlbN9E+a/ZvW
         4mr8UEIB6+9ds5W9pd155wXF6gGjvxrVjsCEA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0911271438340.3429@localhost>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.o1.bUdALB@chimera>
	 <8db1092f0911162204i36dbd472w1d2c88411e151acb@mail.gmail.com>
	 <200911172319.49198.rjw@sisk.pl>
	 <alpine.LFD.2.00.0911271438340.3429@localhost>
Date: Fri, 27 Nov 2009 21:22:43 +0100
Message-ID: <8db1092f0911271222x615b49eci4d8970c608df971@mail.gmail.com>
Subject: Re: [Bug #14352] WARNING: at net/mac80211/scan.c:267
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       johannes@sipsolutions.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/27 Sebastian Ott <sebott@linux.vnet.ibm.com>:
>
> On Tue, 17 Nov 2009, Rafael J. Wysocki wrote:
>
>> On Tuesday 17 November 2009, Maciej Rutecki wrote:
>> > 2009/11/16 Rafael J. Wysocki <rjw@sisk.pl>:
>> > > This message has been generated automatically as a part of a report
>> > > of recent regressions.
>> > >
>> > > The following bug entry is on the current list of known regressions
>> > > from 2.6.31.  Please verify if it still should be listed and let me know
>> > > (either way).
>> > >
>> > >
>> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14352
>> > > Subject         : WARNING: at net/mac80211/scan.c:267
>> > > Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
>> > > Date            : 2009-10-08 00:30 (40 days old)
>> > > References      : http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089#c7
>> > >
>> > >
>> >
>> > In 2.6.32-rc7 problem seems be fixed.
>>
>> Thanks, closing.
>
> looks like this one is still present in rc8:
>

I also observed once again this warning in -rc8. From syslog:
Nov 26 19:04:21 gumis kernel: [43497.192073] ------------[ cut here
]------------
Nov 26 19:04:21 gumis kernel: [43497.192102] WARNING: at
net/mac80211/scan.c:267 ieee80211_scan_completed+0x299/0
x2b0 [mac80211]()
Nov 26 19:04:21 gumis kernel: [43497.192110] Hardware name: HP Compaq
nx6310 (EY501ES#AKD)
Nov 26 19:04:21 gumis kernel: [43497.192115] Modules linked in:
xt_tcpudp xt_limit xt_state iptable_filter nf_con
ntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables i915
drm_kms_helper drm i2c_algo_bit i2c_core sco bnep
 rfcomm l2cap crc16 vboxnetadp vboxnetflt vboxdrv fuse hp_wmi sbp2
loop aes_i586 aes_generic cbc dm_crypt dm_mod
snd_hda_codec_si3054 snd_hda_codec_analog arc4 ecb snd_hda_intel
snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
snd_seq iwl3945(-) snd_timer iwlcore firmwa
re_class snd_seq_device mac80211 btusb led_class snd pcmcia b44
bluetooth soundcore video cfg80211 yenta_socket i
ntel_agp ssb backlight rtc_cmos rsrc_nonstatic ohci1394 uhci_hcd
psmouse ehci_hcd rtc_core snd_page_alloc rfkill
serio_raw evdev ieee1394 agpgart rtc_lib mii pcmcia_core usbcore sg
output ac battery fan button
Nov 26 19:04:21 gumis kernel: [43497.192284] Pid: 4153, comm: rmmod
Tainted: G        W  2.6.32-rc8 #1
Nov 26 19:04:21 gumis kernel: [43497.192291] Call Trace:
Nov 26 19:04:21 gumis kernel: [43497.192305]  [<c03ec85c>] ? printk+0x1d/0x21
Nov 26 19:04:21 gumis kernel: [43497.192323]  [<f8645a69>] ?
ieee80211_scan_completed+0x299/0x2b0 [mac80211]
Nov 26 19:04:21 gumis kernel: [43497.192335]  [<c013c521>]
warn_slowpath_common+0x71/0xc0
Nov 26 19:04:21 gumis kernel: [43497.192353]  [<f8645a69>] ?
ieee80211_scan_completed+0x299/0x2b0 [mac80211]
Nov 26 19:04:21 gumis kernel: [43497.192363]  [<c013c58a>]
warn_slowpath_null+0x1a/0x20
Nov 26 19:04:21 gumis kernel: [43497.192380]  [<f8645a69>]
ieee80211_scan_completed+0x299/0x2b0 [mac80211]
Nov 26 19:04:21 gumis kernel: [43497.192396]  [<f8645ac9>]
ieee80211_scan_cancel+0x49/0x80 [mac80211]
Nov 26 19:04:21 gumis kernel: [43497.192414]  [<f864ddc7>]
ieee80211_stop+0x587/0x590 [mac80211]
Nov 26 19:04:21 gumis kernel: [43497.192425]  [<c03ef0d2>] ?
_spin_unlock_bh+0x12/0x20
Nov 26 19:04:21 gumis kernel: [43497.192439]  [<c0378f0b>] dev_close+0x6b/0xc0
Nov 26 19:04:21 gumis kernel: [43497.192449]  [<c0378fa6>]
rollback_registered+0x46/0x290
Nov 26 19:04:21 gumis kernel: [43497.192458]  [<c01d13d1>] ?
add_partial+0x21/0x70
Nov 26 19:04:21 gumis kernel: [43497.192468]  [<c037920e>]
unregister_netdevice+0x1e/0x70
Nov 26 19:04:21 gumis kernel: [43497.192477]  [<c03ee0e9>] ?
mutex_lock+0x19/0x40
Nov 26 19:04:21 gumis kernel: [43497.192496]  [<f864d384>]
ieee80211_remove_interfaces+0x74/0xb0 [mac80211]
Nov 26 19:04:21 gumis kernel: [43497.192506]  [<c03ee0e9>] ?
mutex_lock+0x19/0x40
Nov 26 19:04:21 gumis kernel: [43497.192523]  [<f8642090>]
ieee80211_unregister_hw+0x40/0xe0 [mac80211]
Nov 26 19:04:21 gumis kernel: [43497.192537]  [<f8689540>]
iwl3945_pci_remove+0x70/0x5dd [iwl3945]
Nov 26 19:04:21 gumis kernel: [43497.192549]  [<c015bb05>] ?
notifier_call_chain+0x35/0x70
Nov 26 19:04:21 gumis kernel: [43497.192563]  [<c029edfe>]
pci_device_remove+0x1e/0x40
Nov 26 19:04:21 gumis kernel: [43497.192573]  [<c0312166>]
__device_release_driver+0x56/0xa0
Nov 26 19:04:21 gumis kernel: [43497.192581]  [<c0312237>]
driver_detach+0x87/0x90
Nov 26 19:04:21 gumis kernel: [43497.192594]  [<c03113a3>]
bus_remove_driver+0x63/0xb0
Nov 26 19:04:21 gumis kernel: [43497.192604]  [<c03127b9>]
driver_unregister+0x49/0x80
Nov 26 19:04:21 gumis kernel: [43497.192614]  [<c02253d2>] ?
sysfs_remove_file+0x12/0x20
Nov 26 19:04:21 gumis kernel: [43497.192625]  [<c029f045>]
pci_unregister_driver+0x35/0xa0
Nov 26 19:04:21 gumis kernel: [43497.192640]  [<f8689abf>]
iwl3945_exit+0x12/0x19 [iwl3945]
Nov 26 19:04:21 gumis kernel: [43497.192651]  [<c016e952>]
sys_delete_module+0x162/0x210
Nov 26 19:04:21 gumis kernel: [43497.192661]  [<c01c573c>] ?
do_munmap+0x21c/0x270
Nov 26 19:04:21 gumis kernel: [43497.192671]  [<c0122176>] ?
do_page_fault+0x176/0x2f0
Nov 26 19:04:21 gumis kernel: [43497.192682]  [<c0102f04>]
sysenter_do_call+0x12/0x22
Nov 26 19:04:21 gumis kernel: [43497.192689] ---[ end trace
3daa09d98d92597c ]---


Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
