Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZI0IaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZI0IaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZI0IaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:30:17 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:56052 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZI0IaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nf+T/Llf+5cL6mg+QH8iGDdA61XsK0Xnt3P/R4zvD3f3H1AoBd0hoWLWrtq/UZaLQ6
         JYKRGQMEMVH32jEnbwqls9cQ8pjRDwRb2lQZ3fyNCmTOjOjiLikHF+nBHnV+1flip7mh
         yqetGsU/PW6K5IVaJ02DzPq+2JX46BbeVE+v8=
MIME-Version: 1.0
In-Reply-To: <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
	 <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
Date: Sun, 27 Sep 2009 16:30:17 +0800
Message-ID: <2674af740909270130h359a5d23taa7e8b63e6a18a4d@mail.gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
	hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
	__sysdev_resume+0xc3/0xe0()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de
Content-Type: multipart/mixed; boundary=001636e1f995b515bd04748afd7e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636e1f995b515bd04748afd7e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 27, 2009 at 4:27 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Sun, Sep 27, 2009 at 4:05 PM, Maciej Rutecki
> <maciej.rutecki@gmail.com> wrote:
>> Kernel: 2.6.31-git17
>>
>> During suspend to disk & resume I got it in dmesg:
>>
>> [ =C2=A0587.940010] ------------[ cut here ]------------
>> [ =C2=A0587.940010] WARNING: at kernel/hrtimer.c:648 hres_timers_resume+=
0x40/0x50()
>> [ =C2=A0587.940010] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
>> [ =C2=A0587.940010] hres_timers_resume() called with IRQs enabled!
>> [ =C2=A0587.940010] Modules linked in: btusb i915 drm_kms_helper drm
>> i2c_algo_bit i2c_core sco bnep rfcomm l2cap crc16 bluetooth xt_tcpudp
>> xt_limit xt_state iptable_filter nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 ip_tables x_tables aes_i586 aes_generic cbc dm_crypt
>> dm_snapshot dm_mirror dm_region_hash dm_log dm_mod hp_wmi fuse sbp2
>> loop snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel
>> snd_hda_codec arc4 snd_pcm_oss snd_mixer_oss snd_pcm ecb snd_seq_dummy
>> snd_seq_oss snd_seq_midi iwl3945 iwlcore snd_rawmidi
>> snd_seq_midi_event snd_seq firmware_class pcmcia snd_timer
>> snd_seq_device mac80211 b44 snd rtc_cmos video led_class ohci1394
>> uhci_hcd yenta_socket intel_agp ssb soundcore rsrc_nonstatic backlight
>> rtc_core ehci_hcd cfg80211 agpgart rtc_lib pcmcia_core mii
>> snd_page_alloc ieee1394 rfkill sg output psmouse fan button ac usbcore
>> battery serio_raw evdev
>> [ =C2=A0587.940010] Pid: 4761, comm: pm-hibernate Not tainted 2.6.31-git=
17 #1
>> [ =C2=A0587.940010] Call Trace:
>> [ =C2=A0587.940010] =C2=A0[<c015b340>] ? hres_timers_resume+0x40/0x50
>> [ =C2=A0587.940010] =C2=A0[<c015b340>] ? hres_timers_resume+0x40/0x50
>> [ =C2=A0587.940010] =C2=A0[<c013c3a1>] warn_slowpath_common+0x71/0xc0
>> [ =C2=A0587.940010] =C2=A0[<c015b340>] ? hres_timers_resume+0x40/0x50
>> [ =C2=A0587.940010] =C2=A0[<c013c43b>] warn_slowpath_fmt+0x2b/0x30
>> [ =C2=A0587.940010] =C2=A0[<c015b340>] hres_timers_resume+0x40/0x50
>> [ =C2=A0587.940010] =C2=A0[<c015f9b7>] timekeeping_resume+0x1a7/0x1c0
>> [ =C2=A0587.940010] =C2=A0[<c030f3fc>] __sysdev_resume+0x1c/0xe0
>> [ =C2=A0587.940010] =C2=A0[<c030f50f>] sysdev_resume+0x4f/0xc0
>> [ =C2=A0587.940010] =C2=A0[<c0176909>] ? hibernate_nvs_restore+0x19/0x60
>> [ =C2=A0587.940010] =C2=A0[<c0172ac1>] hibernation_snapshot+0x1d1/0x210
>> [ =C2=A0587.940010] =C2=A0[<c0171b54>] ? freeze_processes+0x44/0xa0
>> [ =C2=A0587.940010] =C2=A0[<c0172bef>] hibernate+0xef/0x190
>> [ =C2=A0587.940010] =C2=A0[<c0171590>] ? state_store+0x0/0xc0
>> [ =C2=A0587.940010] =C2=A0[<c017163b>] state_store+0xab/0xc0
>> [ =C2=A0587.940010] =C2=A0[<c0171590>] ? state_store+0x0/0xc0
>> [ =C2=A0587.940010] =C2=A0[<c0285e04>] kobj_attr_store+0x24/0x30
>> [ =C2=A0587.940010] =C2=A0[<c0223d82>] sysfs_write_file+0xa2/0x100
>> [ =C2=A0587.940010] =C2=A0[<c01d880c>] vfs_write+0x9c/0x150
>> [ =C2=A0587.940010] =C2=A0[<c0223ce0>] ? sysfs_write_file+0x0/0x100
>> [ =C2=A0587.940010] =C2=A0[<c01d8982>] sys_write+0x42/0x70
>> [ =C2=A0587.940010] =C2=A0[<c0102f04>] sysenter_do_call+0x12/0x22
>> [ =C2=A0587.940010] ---[ end trace d928cdf192623f0f ]---
>> [ =C2=A0587.940010] ------------[ cut here ]------------
>> [ =C2=A0587.940010] WARNING: at drivers/base/sys.c:353 __sysdev_resume+0=
xc3/0xe0()
>> [ =C2=A0587.940010] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
>> [ =C2=A0587.940010] Interrupts enabled after timekeeping_resume+0x0/0x1c=
0
>> [ =C2=A0587.940010] Modules linked in: btusb i915 drm_kms_helper drm
>> i2c_algo_bit i2c_core sco bnep rfcomm l2cap crc16 bluetooth xt_tcpudp
>> xt_limit xt_state iptable_filter nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 ip_tables x_tables aes_i586 aes_generic cbc dm_crypt
>> dm_snapshot dm_mirror dm_region_hash dm_log dm_mod hp_wmi fuse sbp2
>> loop snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel
>> snd_hda_codec arc4 snd_pcm_oss snd_mixer_oss snd_pcm ecb snd_seq_dummy
>> snd_seq_oss snd_seq_midi iwl3945 iwlcore snd_rawmidi
>> snd_seq_midi_event snd_seq firmware_class pcmcia snd_timer
>> snd_seq_device mac80211 b44 snd rtc_cmos video led_class ohci1394
>> uhci_hcd yenta_socket intel_agp ssb soundcore rsrc_nonstatic backlight
>> rtc_core ehci_hcd cfg80211 agpgart rtc_lib pcmcia_core mii
>> snd_page_alloc ieee1394 rfkill sg output psmouse fan button ac usbcore
>> battery serio_raw evdev
>> [ =C2=A0587.940010] Pid: 4761, comm: pm-hibernate Tainted: G =C2=A0 =C2=
=A0 =C2=A0 =C2=A0W
>> 2.6.31-git17 #1
>> [ =C2=A0587.940010] Call Trace:
>> [ =C2=A0587.940010] =C2=A0[<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
>> [ =C2=A0587.940010] =C2=A0[<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
>> [ =C2=A0587.940010] =C2=A0[<c013c3a1>] warn_slowpath_common+0x71/0xc0
>> [ =C2=A0587.940010] =C2=A0[<c030f4a3>] ? __sysdev_resume+0xc3/0xe0
>> [ =C2=A0587.940010] =C2=A0[<c013c43b>] warn_slowpath_fmt+0x2b/0x30
>> [ =C2=A0587.940010] =C2=A0[<c030f4a3>] __sysdev_resume+0xc3/0xe0
>> [ =C2=A0587.940010] =C2=A0[<c015f810>] ? timekeeping_resume+0x0/0x1c0
>> [ =C2=A0587.940010] =C2=A0[<c030f50f>] sysdev_resume+0x4f/0xc0
>> [ =C2=A0587.940010] =C2=A0[<c0176909>] ? hibernate_nvs_restore+0x19/0x60
>> [ =C2=A0587.940010] =C2=A0[<c0172ac1>] hibernation_snapshot+0x1d1/0x210
>> [ =C2=A0587.940010] =C2=A0[<c0171b54>] ? freeze_processes+0x44/0xa0
>> [ =C2=A0587.940010] =C2=A0[<c0172bef>] hibernate+0xef/0x190
>> [ =C2=A0587.940010] =C2=A0[<c0171590>] ? state_store+0x0/0xc0
>> [ =C2=A0587.940010] =C2=A0[<c017163b>] state_store+0xab/0xc0
>> [ =C2=A0587.940010] =C2=A0[<c0171590>] ? state_store+0x0/0xc0
>> [ =C2=A0587.940010] =C2=A0[<c0285e04>] kobj_attr_store+0x24/0x30
>> [ =C2=A0587.940010] =C2=A0[<c0223d82>] sysfs_write_file+0xa2/0x100
>> [ =C2=A0587.940010] =C2=A0[<c01d880c>] vfs_write+0x9c/0x150
>> [ =C2=A0587.940010] =C2=A0[<c0223ce0>] ? sysfs_write_file+0x0/0x100
>> [ =C2=A0587.940010] =C2=A0[<c01d8982>] sys_write+0x42/0x70
>> [ =C2=A0587.940010] =C2=A0[<c0102f04>] sysenter_do_call+0x12/0x22
>> [ =C2=A0587.940010] ---[ end trace d928cdf192623f10 ]---
>>
>>
>> After resume system seems works OK.
>>
>
> Does the below patch work?
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index fb0f46f..b39b828 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -573,7 +573,8 @@ static int timekeeping_resume(struct sys_device *dev)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0clocksource_resume();
>
> - =C2=A0 =C2=A0 =C2=A0 write_seqlock_irqsave(&xtime_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 local_irq_save(flags);
> + =C2=A0 =C2=A0 =C2=A0 write_seqlock(&xtime_locks);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (timespec_compare(&ts, &timekeeping_suspend=
_time) > 0) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ts =3D timespec_su=
b(ts, timekeeping_suspend_time);
> @@ -586,7 +587,7 @@ static int timekeeping_resume(struct sys_device *dev)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0timekeeper.clock->cycle_last =3D timekeeper.cl=
ock->read(timekeeper.clock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0timekeeper.ntp_error =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0timekeeping_suspended =3D 0;
> - =C2=A0 =C2=A0 =C2=A0 write_sequnlock_irqrestore(&xtime_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 write_sequnlock(&xtime_locks);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0touch_softlockup_watchdog();
>
> @@ -594,6 +595,7 @@ static int timekeeping_resume(struct sys_device *dev)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Resume hrtimers */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0hres_timers_resume();
> + =C2=A0 =C2=A0 =C2=A0 local_irq_restore(flags);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
>

Oops, TABLE is corrupted. Please use the attachment.

Thanks,
Yong

>
>> Dmesg, config, /proc/interrupts:
>> http://unixy.pl/maciek/download/kernel/2.6.31-git17/gumis/
>>
>> Regards
>> --
>> Maciej Rutecki
>> http://www.maciek.unixy.pl
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>>
>

--001636e1f995b515bd04748afd7e
Content-Type: text/x-patch; charset=US-ASCII; name="a.patch"
Content-Disposition: attachment; filename="a.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g03j5daq0

ZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL3RpbWVrZWVwaW5nLmMgYi9rZXJuZWwvdGltZS90aW1l
a2VlcGluZy5jCmluZGV4IGZiMGY0NmYuLmIzOWI4MjggMTAwNjQ0Ci0tLSBhL2tlcm5lbC90aW1l
L3RpbWVrZWVwaW5nLmMKKysrIGIva2VybmVsL3RpbWUvdGltZWtlZXBpbmcuYwpAQCAtNTczLDcg
KzU3Myw4IEBAIHN0YXRpYyBpbnQgdGltZWtlZXBpbmdfcmVzdW1lKHN0cnVjdCBzeXNfZGV2aWNl
ICpkZXYpCiAKIAljbG9ja3NvdXJjZV9yZXN1bWUoKTsKIAotCXdyaXRlX3NlcWxvY2tfaXJxc2F2
ZSgmeHRpbWVfbG9jaywgZmxhZ3MpOworCWxvY2FsX2lycV9zYXZlKGZsYWdzKTsKKwl3cml0ZV9z
ZXFsb2NrKCZ4dGltZV9sb2Nrcyk7CiAKIAlpZiAodGltZXNwZWNfY29tcGFyZSgmdHMsICZ0aW1l
a2VlcGluZ19zdXNwZW5kX3RpbWUpID4gMCkgewogCQl0cyA9IHRpbWVzcGVjX3N1Yih0cywgdGlt
ZWtlZXBpbmdfc3VzcGVuZF90aW1lKTsKQEAgLTU4Niw3ICs1ODcsNyBAQCBzdGF0aWMgaW50IHRp
bWVrZWVwaW5nX3Jlc3VtZShzdHJ1Y3Qgc3lzX2RldmljZSAqZGV2KQogCXRpbWVrZWVwZXIuY2xv
Y2stPmN5Y2xlX2xhc3QgPSB0aW1la2VlcGVyLmNsb2NrLT5yZWFkKHRpbWVrZWVwZXIuY2xvY2sp
OwogCXRpbWVrZWVwZXIubnRwX2Vycm9yID0gMDsKIAl0aW1la2VlcGluZ19zdXNwZW5kZWQgPSAw
OwotCXdyaXRlX3NlcXVubG9ja19pcnFyZXN0b3JlKCZ4dGltZV9sb2NrLCBmbGFncyk7CisJd3Jp
dGVfc2VxdW5sb2NrKCZ4dGltZV9sb2Nrcyk7CiAKIAl0b3VjaF9zb2Z0bG9ja3VwX3dhdGNoZG9n
KCk7CiAKQEAgLTU5NCw2ICs1OTUsNyBAQCBzdGF0aWMgaW50IHRpbWVrZWVwaW5nX3Jlc3VtZShz
dHJ1Y3Qgc3lzX2RldmljZSAqZGV2KQogCiAJLyogUmVzdW1lIGhydGltZXJzICovCiAJaHJlc190
aW1lcnNfcmVzdW1lKCk7CisJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOwogCiAJcmV0dXJuIDA7
CiB9Cg==
--001636e1f995b515bd04748afd7e--
