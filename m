Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZDOSG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZDOSG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZDOSGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:06:48 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55018 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZDOSGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:06:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ke8eLnwEYbzswpJ4Im8V+/CON5YJenRNWt0xrIxhB0SBV5R6jZ1eXhUpstXTLKWnAY
         8wgc5XBDjXy+5g5TP/PLo678NZnIaceDET0d9ADKyudWmhnvqq29ojgda9mYXUKAobX5
         rSbcmabifw+pD4myOgEnpZfmVszlsq5rGitGM=
MIME-Version: 1.0
In-Reply-To: <s5h7i1m1021.wl%tiwai@suse.de>
References: <5a4c581d0904090732o4d50ede7jed7739bab6043cbe@mail.gmail.com>
	 <s5h4owr2tpd.wl%tiwai@suse.de>
	 <5a4c581d0904150634k6c2f4207s8396877719e38b84@mail.gmail.com>
	 <s5h7i1m1021.wl%tiwai@suse.de>
Date: Wed, 15 Apr 2009 20:06:44 +0200
Message-ID: <5a4c581d0904151106k6ea98746w97477ccb43918912@mail.gmail.com>
Subject: Re: No sound with 2.6.29-git5 vanilla through 2.6.30-rc1-git1 on 
	hda-intel (F10 kernel has sound)
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 4:08 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 15 Apr 2009 15:34:56 +0200,
> Alessandro Suardi wrote:
>>
>> On Tue, Apr 14, 2009 at 4:30 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Thu, 9 Apr 2009 16:32:48 +0200,
>> > Alessandro Suardi wrote:
>> >>
>> >> My cursed Dell E6400 is turning up more issues I recall ever seeing
>> >>  in my 13.5 years of Linuxing -- wireless is unsupported in vanilla,
>> >>  X/VT switching moans, MTRR still complains, microcode WARNs on
>> >>  boot - and the joys of 64-bit Firefox with gnash and IcedTea...
>> >>
>> >> And now, sound only works in Fedora 10 with the F10 kernel, that is:
>> >>
>> >> 2.6.27.21-170.2.56.fc10.x86_64
>> >>
>> >>  but not with any vanilla kernel I built. So it might be me, of course; but
>> >>  the ALSA modules seem the same in the two kernels - where applicable
>> >>  (recent kernels have a hda-intel-codec module that doesn't seem to be
>> >>  loaded in the F10 kernel).
>> >
>> > snd-hda-codec-* modules are loaded automatically from snd-hda-intel.
>> > Do you have snd-hda-codec-idt module?
>> > It's enabled via CONFIG_SND_HDA_CODEC_SIGMATEL=y.
>> >
>> >
>> > Takashi
>>
>> Thanks Takashi -
>>
>>   no, I haven't that one; am I supposed to set to Y all codecs under the
>>   SND_HDA_INTEL tab ? And if not, how do I guess which one[s] ?
>
> Unless you are sure that you have no matching codecs, it's better to
> say all Y, especially if you are using modules.

That's what I did, and *poof* my audio is back on 2.6.30-rc2 !

Thanks a lot,

--alessandro

 "Sun keeps rising in the west / I keep on waking fully confused"

   (The Replacements, "Within Your Reach")
