Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbZEDQul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbZEDQul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZEDQuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:50:32 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:51181 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbZEDQub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:50:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=R2TsxNV14jy9DYHBzI8PC11LcfjBSozrg69RXh+8lyZdBrd0fziupd8hdrrPXNL9PK
         gY9skhJEQSMr/4ViUM1itda+EAw7pAI0mti2hUsLm5hk5VicWoNxT7IpX5bEIglAKJvP
         E6gONW0zWgFjP1g0D4imDNfFxpc03TfXRcyLI=
MIME-Version: 1.0
Date: Mon, 4 May 2009 12:50:31 -0400
Message-ID: <a44ae5cd0905040950l43a1cce1xb5f3aa494e420de2@mail.gmail.com>
Subject: 2.6.30-rc4-git1 -- [drm:i915_get_vblank_counter] *ERROR* trying to 
	get vblank count for disabled pipe 0
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see this error when I suspend my laptop.  As far as I can tell,
everything is working fine when it resumes.

# dmesg | grep -i drm
[    0.775429] [drm] Initialized drm 1.1.0 20060810
[   32.312209] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[ 1229.487441] [drm:i915_get_vblank_counter] *ERROR* trying to get
vblank count for disabled pipe 0

Linux ubuntu 2.6.30-rc4-git1 #5 SMP PREEMPT Mon May 4 12:01:41 EDT
2009 x86_64 GNU/Linux

Gnu C                  4.3.3
Gnu make               3.81
binutils               2.19.1
util-linux             2.14.2
mount                  support
module-init-tools      3.7-pre9
e2fsprogs              1.41.4
reiserfsprogs          3.6.19
pcmciautils            014
PPP                    2.4.5
Linux C Library        2.9
Dynamic linker (ldd)   2.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.14.1
Sh-utils               6.10
wireless-tools         29
Modules Loaded         cpufreq_ondemand i915 ipv6 snd_hda_codec_si3054
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
snd_mixer_oss snd_pcm pcmcia iwl3945 iwlcore snd_seq_dummy snd_seq_oss
iTCO_wdt iTCO_vendor_support rfkill tifm_7xx1 snd_seq_midi_event
tifm_core yenta_socket rsrc_nonstatic pcmcia_core mac80211 snd_seq
snd_timer snd_seq_device cfg80211 snd soundcore snd_page_alloc
rtc_cmos rtc_core rtc_lib intel_agp sd_mod sg ehci_hcd sr_mod cdrom
sky2 uhci_hcd
