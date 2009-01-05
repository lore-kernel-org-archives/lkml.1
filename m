Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZAEL33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZAEL33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZAEL3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:29:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:23306 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZAEL3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:29:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f/TO+FMZ6wLfyrArotwIeSFEVEY0xKIYDD4diYUrgYyS1fa3OD7x2xeb9b1FxYSq3q
         2GCmLw0/9zyyLvUM3tpvsrJWx9cS7el1m2xD6GUFoRgaToAudhSxf2XdyfoWGjjjj3ON
         Xsp/QFI+tKeg2rdk/HPF2qW18YOlW4BWMh2NU=
Message-ID: <f7848160901050329pfecace2g536869d605b7c277@mail.gmail.com>
Date: Mon, 5 Jan 2009 06:29:17 -0500
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: Lock up - probably ALSA related
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s5h1vvi9jg4.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f7848160901041858n5c6ac1ddvd7ed0db90a677835@mail.gmail.com>
	 <s5h1vvi9jg4.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2009 at 4:43 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Sun, 4 Jan 2009 21:58:21 -0500,
> Parag Warudkar wrote:
>>
>> After installing today's git my laptop has started to partially lock
>> up while listening to audio.  This laptop was previously running
>> distro kernel 2.6 (2.6.27.9-159.fc10.i686) without any trouble.
>
> Which audio hardware?  Does it happen with 2.6.28 kernel, too?
>

Hello,

Hardware is snd-hda-intel. This is a second generation Macbook Pro, no
special options in use.

[parag@fedora ~]$ dmesg|grep ALSA
ALSA sound/pci/hda/hda_codec.c:3419: autoconfig: line_outs=1
(0xc/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3423:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3427:    hp_outs=1 (0xa/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3428:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:3436:    inputs: mic=0xb, fmic=0x0,
line=0xf, fline=0x0, cd=0x0, aux=0x0
ALSA sound/pci/hda/patch_sigmatel.c:2908: stac92xx: dac_nids=1
(0x3/0x0/0x0/0x0/0x0)

[parag@fedora ~]$ cat /proc/asound/devices
  2:        : timer
  3:        : sequencer
  4: [ 0- 1]: digital audio playback
  5: [ 0- 1]: digital audio capture
  6: [ 0- 0]: digital audio playback
  7: [ 0- 0]: digital audio capture
  8: [ 0- 0]: hardware dependent
  9: [ 0]   : control

[parag@fedora ~]$ cat /proc/asound/cards
 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xd8400000 irq 22

I think if I remember correctly it happened on 2.6.28 - but I need to
test out once again to make sure.

Thanks

Parag
