Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYF1Mjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYF1Mjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYF1Mjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:39:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:24868 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYF1Mjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f3/vkSG73uGNIE2c3CHdpNLNbXE+G0qeLF9kC2EaoPD0Eigh0VsOICZcAeeiQ/GcRT
         nsYSE+KJBxeCVNKDvh2of9A7PH2pmQvsM7KfwqVbALyffYUb/Vpk5yCw0FY4Tryc/gbO
         sNPc+Byi2j8LZxtC15lgNmQ6ABeAwfce41fHU=
Message-ID: <19f34abd0806280539g4961392evb469d7c106c198c9@mail.gmail.com>
Date: Sat, 28 Jun 2008 14:39:32 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: ALC883 recording troubles...
Cc: "Takashi Iwai" <tiwai@suse.de>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220806280529n70c6233dk1c5768df5d52acf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <6278d2220806271705v5bd5fec3l86c3560283063092@mail.gmail.com>
	 <19f34abd0806280311s115062e6vc6d0f304cb744934@mail.gmail.com>
	 <6278d2220806280329j2f77c52dp8fbae78420c136c1@mail.gmail.com>
	 <6278d2220806280529n70c6233dk1c5768df5d52acf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 2:29 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> Using your dumped config and
> ftp://202.65.194.211/pc/audio/ALC268_DataSheet_1.3.pdf page 42, your
> front mic pin complex is at node 19h; the mixers connecting to it are
> at nodes 0Bh, 22h and 23h, all at the second input index, so one of
> these should work:
>
> # ./hda-verb /dev/snd/hwC0D0 0x0b SET_AMP_GAIN_MUTE 0x7280
> # ./hda-verb /dev/snd/hwC0D0 0x22 SET_AMP_GAIN_MUTE 0x7280
> # ./hda-verb /dev/snd/hwC0D0 0x23 SET_AMP_GAIN_MUTE 0x7280
>
> On my ALC883, we need to mute the first input instead, thus 0x7180.
> Can you see if the above helps you out?

Thanks for helping out!

Unfortunately, none of these commands (with either 0x7180 or 0x7280)
seems to make any difference at all. (I tried various combinations,
with reloading the driver in-between to undo the trial attempts.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
