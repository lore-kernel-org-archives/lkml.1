Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZLBXhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZLBXhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZLBXhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:37:10 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59464 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbZLBXhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:37:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EbOvgw5RsP5bKvH96qneZw9TbeB6skZCDkxkGLhko6h31SHHyd/hX/jBWUEwLDTqgf
         Q4K4Mdk4uh2+3m5phndxUxDt8yJF1jhvFXQICQHPhjbIOnk4Kt61KIK2s88RZHb5JYB1
         npDR3mtcSq6N/nEGJxEU/0l6nEu6bDPpKUVxo=
MIME-Version: 1.0
In-Reply-To: <200912030019.07694.oliver@neukum.org>
References: <dd18b0c30912021434t4a247646q48f32c0d0e40faae@mail.gmail.com>
	 <200912030019.07694.oliver@neukum.org>
Date: Wed, 2 Dec 2009 15:37:15 -0800
Message-ID: <dd18b0c30912021537i6f778a9axc6698987985551df@mail.gmail.com>
Subject: Re: root hub lost power or was reset
From: Justin Mattock <justinmattock@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Linux-usb <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 2, 2009 at 3:19 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Mittwoch, 2. Dezember 2009 23:34:30 schrieb Justin Mattock:
>
>> for a bit I thought that this was also the cause of the delay
>> but the system wakes up as it should even with this happening to
>> usb.
>
> Perhaps something does an operation that needs to time out.
> Which drivers have you loaded when it works and when it doesn't work?

right now, the only module I removed(which was causing my s2ram pause)
is isight_firmware.ko.(need to look into why this is)
after that s2ram works good.

Now the usb issue, seems I see this every time I s2ram.
there is an external usb mouse, but makes no difference if it's connected,
or disconnected..still see the root hub lost power.
(maybe the machine is getting old: macbook pro 2yrs old)

heres lsmod:

Module                  Size  Used by
radeon                507706  2
ttm                    36164  1 radeon
drm_kms_helper         22484  1 radeon
drm                   149553  5 radeon,ttm,drm_kms_helper
i2c_algo_bit            4835  1 radeon
ipt_LOG                 5111  1
iptable_nat             4012  0
nf_nat                 15811  1 iptable_nat
xt_state                1394  1
nf_conntrack_ftp        6068  0
nf_conntrack_ipv4      11271  4 iptable_nat,nf_nat
nf_conntrack           60809  5
iptable_nat,nf_nat,xt_state,nf_conntrack_ftp,nf_conntrack_ipv4
nf_defrag_ipv4          1329  1 nf_conntrack_ipv4
iptable_filter          1697  1
ip_tables              10159  2 iptable_nat,iptable_filter
x_tables               13623  4 ipt_LOG,iptable_nat,xt_state,ip_tables
snd_hda_codec_idt      52390  1
firewire_ohci          20906  0
firewire_core          41362  1 firewire_ohci
snd_hda_intel          20949  1
snd_hda_codec          66439  2 snd_hda_codec_idt,snd_hda_intel
ohci1394               26076  0
snd_hwdep               5088  1 snd_hda_codec
ath9k                 289991  0
ieee1394               75265  1 ohci1394
evdev                   7969  4
snd_pcm                64635  2 snd_hda_intel,snd_hda_codec
sky2                   40051  0
button                  5779  0
video                  20415  0
thermal                14438  0
i2c_i801                7265  0
joydev                  8766  0
ac                      3489  0
battery                10367  0
ath                     8766  1 ath9k
snd_page_alloc          7125  2 snd_hda_intel,snd_pcm
uhci_hcd               18963  0
ehci_hcd               31519  0
coretemp                5006  0
acpi_cpufreq            7024  0
processor              38952  3 acpi_cpufreq
appletouch              8569  0
applesmc               25995  0


>
>> BTW: Is CONFIG_USB_PERSIST in the kernel anymore
>> with 2.6.32*?(I can't seem to find that option);
>
> It is always used and switched on by default.
>
>        Regards
>                Oliver
>

o.k. I didn't know it is set to on by default.


-- 
Justin P. Mattock
