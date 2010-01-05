Return-Path: <linux-kernel-owner+w=401wt.eu-S932128Ab0AEUQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab0AEUQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774Ab0AEUQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:16:19 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54314 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab0AEUQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VO6SNZdAlDJVyev0g/o0qm3jcnCaZ5bNtTuijmO6o6Yau13FUbNXQjRJoMx39dr1XR
         EL2VIMSywDDReJnXQQxs/TWl25j6IWZK4c403zEuLVJUt7aE8TCsfDvxm/NvSvTzC1eF
         Kzd56vYSpd8ibRG+3ppVRX714DJZrnsK18Fj0=
MIME-Version: 1.0
In-Reply-To: <4B439A18.3030408@zytor.com>
References: <a44ae5cd1001051155s7204a182wefafbfc2bb2409e4@mail.gmail.com>
	 <4B439A18.3030408@zytor.com>
Date: Tue, 5 Jan 2010 15:16:15 -0500
Message-ID: <a44ae5cd1001051216g5f999caftc3b8b30a3e4b6af2@mail.gmail.com>
Subject: Re: 2.6.33-rc2-git6 -- Boot fails with "Destination address too 
	large." with recent kernels when compressed with bz2 or lzma (gzip works).
From: Miles Lane <miles.lane@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 2:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/05/2010 11:55 AM, Miles Lane wrote:
>> Hello,
>>
>> I can get a gzipped kernel to boot (I am running Ubuntu in a WUBI
>> FUSE-mounted EXT3 file system that is stored in a 16GB file on my
>> Windows NTFS partition).  But, when I try to compress the kernel with
>> lzma or bz2, the boot fails with "Destination address too large."
>>
>
> Known bug (it happens when your sh isn't bash on the compile host, and
> possibly some other tools).  It's being addressed.
>
>        -hpa
>

Yes, Ubuntu 10.04 (lucid) is using dash (/bin/sh -> dash)

dash                  0.5.5.1-2ubuntu3      POSIX-compliant shell
"The Debian Almquist Shell (dash) is a lightweight POSIX-compliant
shell derived from ash."

BTW, why is it that only changing the compression algorithm forces a
complete rebuild?  It seems like only the existing kernel should need
recompression.

GNU bash, version 4.1.0(1)-release (i486-pc-linux-gnu)

Linux ubuntu 2.6.32-9-generic #13-Ubuntu SMP Thu Dec 17 17:02:51 UTC
2009 i686 GNU/Linux

Gnu C                  4.4.3
Gnu make               3.81
binutils               2.20
util-linux             2.16
mount                  support
module-init-tools      3.11.1
e2fsprogs              1.41.9
reiserfsprogs          3.6.21
pcmciautils            014
PPP                    2.4.5
Linux C Library        2.10.2
Dynamic linker (ldd)   2.10.2
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.4
wireless-tools         29
Modules Loaded         aes_i586 aes_generic binfmt_misc ppdev
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm_oss snd_mixer_oss fbcon tileblit font bitblit softcursor
vga16fb vgastate snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi arc4 snd_seq_midi_event snd_seq snd_timer snd_seq_device
i915 ath9k drm_kms_helper mac80211 ath snd drm i2c_algo_bit cfg80211
intel_agp joydev psmouse serio_raw soundcore led_class agpgart
snd_page_alloc video output lp parport atl1e hid_logitech ff_memless
usbhid
