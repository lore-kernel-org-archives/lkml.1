Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbZEFDmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbZEFDmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 23:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZEFDmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 23:42:07 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:60302 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZEFDmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 23:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=kO2Nia3c7UuILheMJiTMAJGnD6NIGDGlDuzE9pAzbuFj54B1kwB+Apy7YLhz8iy5W/
         RyYP9TR6+sz8ZwGNRj3w8KHIeAnOxPL7v3mSEpB0X+SVyi59hkPZ9NhtfKK095z7ib+Y
         4Bm/pr1kMsia9O8Bu1lELKB0mE/2g1LnRR8ZQ=
MIME-Version: 1.0
Date: Tue, 5 May 2009 23:42:03 -0400
Message-ID: <a44ae5cd0905052042g3106ddb6ua18a667fb3c5c725@mail.gmail.com>
Subject: 2.6.30-rc4-git1 -- LOCKUP -- Intelfb with kernel mode setting is 
	locking up my system when Xorg starts.
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see no stack trace.  The keyboard locks up and I do not get an OOPS message.
I will send a second message with my .config, since I recall that
sometimes the inline .config info will trigger vger's spam filter.

xserver-common                             2:1.6.0-0ubuntu14
xserver-xorg                               1:7.4~5ubuntu18
xserver-xorg-video-fbdev                   1:0.4.0-3
xserver-xorg-video-intel                   2:2.6.3-0ubuntu9
xserver-xorg-video-vesa                    1:2.0.0-1ubuntu6

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: Gateway 2000 Device 0366
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d8100000 (32-bit, non-prefetchable) [size=512K]
	Region 1: I/O ports at 1800 [size=8]
	Region 2: Memory at c0000000 (32-bit, prefetchable) [size=256M]
	Region 3: Memory at d8200000 (32-bit, non-prefetchable) [size=256K]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: Gateway 2000 Device 0366
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at d8180000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Linux ubuntu 2.6.30-rc4-git2 #23 SMP PREEMPT Tue May 5 21:32:28 EDT
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
Modules Loaded         cpufreq_ondemand i915 drm i2c_algo_bit bridge
stp rfcomm llc bnep sco l2cap bluetooth ipv6 snd_hda_codec_si3054
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
snd_mixer_oss snd_pcm iwl3945 iwlcore snd_seq_dummy snd_seq_oss
snd_seq_midi_event pcmcia rfkill snd_seq tifm_7xx1 snd_timer iTCO_wdt
iTCO_vendor_support yenta_socket rsrc_nonstatic tifm_core mac80211
snd_seq_device pcmcia_core snd cfg80211 soundcore snd_page_alloc
rtc_cmos intel_agp sg sd_mod sr_mod cdrom ehci_hcd uhci_hcd sky2
