Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZALJQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZALJQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZALJPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:15:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:32167 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZALJPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:15:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HS/OQUNBm7Rp1WBLVZcOxucLE6ruinGLz84X4X/GQm5h5MBPy/O0UzJEJ90s/FjFKK
         gZ21TidHJRxklrWd0x6+pvvNtZtYoBONEk9RxI3oGTdFOSswccGnBCrK3s3PcLDAYlpm
         iZ2vUuCNMLQLAxCHOaqtcGuI4s3dg9fuQ1gms=
Message-ID: <8db1092f0901120115q510755d5oadd9ed11140a3423@mail.gmail.com>
Date: Mon, 12 Jan 2009 10:15:48 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
In-Reply-To: <200901120903.20371.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <8db1092f0901111215m5712caccvc0d2e5e7cb7e8f7@mail.gmail.com>
	 <c4e36d110901111459p6d02892fwce0d89c52e62385e@mail.gmail.com>
	 <200901120903.20371.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:

>
> Please check if unloading all of the USB controller modules before suspend
> helps.
>
> Thanks,
> Rafael
>

I try remowe usbhid, hid, ehci_hcd, uhci_hcd, psmouse (s2ram and
s2disk doesn't work), but I had problem with unloading usbcore:
ERROR: Module usbcore is in use

lsmod, after trying unload modules:
Module                  Size  Used by
i915                  139656  1
drm                   149888  2 i915
tun                    10820  0
acpi_cpufreq            7532  0
xt_tcpudp               2848  20
xt_limit                1956  1
xt_state                1888  3
iptable_nat             4832  0
nf_nat                 18324  1 iptable_nat
nf_conntrack_ipv4      13324  6 iptable_nat,nf_nat
nf_conntrack           66248  4 xt_state,iptable_nat,nf_nat,nf_conntrack_ipv4
nf_defrag_ipv4          1760  1 nf_conntrack_ipv4
iptable_filter          2496  1
ip_tables              11408  2 iptable_nat,iptable_filter
x_tables               15076  5
xt_tcpudp,xt_limit,xt_state,iptable_nat,ip_tables
ppdev                   7300  0
lp                      8708  0
aes_i586                7584  2
aes_generic            28160  1 aes_i586
cbc                     3264  2
dm_crypt               12356  1
dm_mod                 51716  5 dm_crypt
nvram                   7116  0
fuse                   54268  1
coretemp                5728  0
it87                   20080  0
hwmon_vid               2976  1 it87
loop                   14316  0
snd_hda_codec_realtek   188164  1
snd_hda_intel          23752  1
snd_hda_codec          59712  2 snd_hda_codec_realtek,snd_hda_intel
snd_pcm_oss            38560  0
snd_mixer_oss          14752  1 snd_pcm_oss
snd_pcm                74404  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_seq_dummy           2596  0
snd_seq_oss            30208  0
snd_seq_midi            6144  0
snd_rawmidi            21088  1 snd_seq_midi
snd_seq_midi_event      6880  2 snd_seq_oss,snd_seq_midi
snd_seq                49808  6
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              20680  2 snd_pcm,snd_seq
snd_seq_device          6860  5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
snd                    55588  13
snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
8139too                23488  0
soundcore               7232  1 snd
rtc_cmos               10380  0
8139cp                 18976  0
i2c_i801                8592  0
iTCO_wdt               10500  0
snd_page_alloc          8808  2 snd_hda_intel,snd_pcm
button                  5840  0
rtc_core               16668  1 rtc_cmos
rtc_lib                 2912  1 rtc_core
r8169                  31652  0
mii                     5344  3 8139too,8139cp,r8169
usbcore               146800  1
parport_pc             21636  1
parport                23424  3 ppdev,lp,parport_pc
evdev                   9472  2

How to force unload (safe) usbcore module?

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
