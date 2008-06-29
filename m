Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYF2Vd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYF2Vd6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 17:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYF2Vds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 17:33:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:2314 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbYF2Vdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 17:33:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QZgNh5KjW5j8YUu915TVPHoyZhwXKBJCS8VADOHRIKfjUha2yjEOD9iAFJ/+KR1KD7
         LRtKLSyUYRTr63NhyQvVWCKaN2YTmv8cyOLOIUTLBOTGKxnEnXKSx35EHHyyYRbvu+7j
         QyRnOYKSUxQ0LDjTiJKL0le7JRvqu0YA4N5l4=
Message-ID: <6278d2220806291433j9bc9e71qce28a4b952b121c@mail.gmail.com>
Date: Sun, 29 Jun 2008 22:33:43 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Romano Giannetti" <romano@dea.icai.upcomillas.es>
Subject: Re: ALC883 recording troubles...
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>, "Takashi Iwai" <tiwai@suse.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1214760581.6998.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <6278d2220806271705v5bd5fec3l86c3560283063092@mail.gmail.com>
	 <19f34abd0806280311s115062e6vc6d0f304cb744934@mail.gmail.com>
	 <6278d2220806280329j2f77c52dp8fbae78420c136c1@mail.gmail.com>
	 <6278d2220806280529n70c6233dk1c5768df5d52acf@mail.gmail.com>
	 <19f34abd0806280539g4961392evb469d7c106c198c9@mail.gmail.com>
	 <6278d2220806280624iec3a67rf25789e98f81521@mail.gmail.com>
	 <1214760581.6998.4.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 6:29 PM, Romano Giannetti
<romano@dea.icai.upcomillas.es> wrote:
>
> On Sat, 2008-06-28 at 14:24 +0100, Daniel J Blueman wrote:
>> # ./hda-verb /dev/snd/hwC0D0 0x0e SET_AMP_GAIN_MUTE 0x7080
>> # ./hda-verb /dev/snd/hwC0D0 0x0f SET_AMP_GAIN_MUTE 0x7080
>> # ./hda-verb /dev/snd/hwC0D0 0x0f SET_AMP_GAIN_MUTE 0x7180
>> # ./hda-verb /dev/snd/hwC0D0 0x10 SET_AMP_GAIN_MUTE 0x7080
>> # ./hda-verb /dev/snd/hwC0D0 0x10 SET_AMP_GAIN_MUTE 0x7180
>> # ./hda-verb /dev/snd/hwC0D0 0x10 SET_AMP_GAIN_MUTE 0x7280
>> # ./hda-verb /dev/snd/hwC0D0 0x18 SET_AMP_GAIN_MUTE 0x7080
>> # ./hda-verb /dev/snd/hwC0D0 0x19 SET_AMP_GAIN_MUTE 0x7080
>> # ./hda-verb /dev/snd/hwC0D0 0x1a SET_AMP_GAIN_MUTE 0x7080
>
> I tried all this, to no avail. At some point input stopped recording
> sound, it has just offset, but I can't say which one was... if it's a
> useful data, I can retry it.
>
> And... I have almost never booted it, but I have a Vista installed in
> this laptop. If you explain me how to do (in windows I am a dumb user) I
> can try to search thing. What I know is that the sound in windows is
> quite louder, and that recording works better. There is a button with
> "offset correction" default on, if I remember correctly.

That'll be the software 'fix' the Realtek guys mentioned to Takashi.

It's clear the issue with the ALC268 is different than the ALC883
offset issue that I'm seeing, which seems to be a bug as ALSA isn't
muting the mixer inputs which aren't intended.

Daniel
-- 
Daniel J Blueman
