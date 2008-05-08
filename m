Return-Path: <linux-kernel-owner+w=401wt.eu-S933196AbYEHSxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbYEHSxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761288AbYEHSxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:53:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:29859 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008AbYEHSx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:53:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=fLVlS6UU3EEA2KnSPdGAWP1pauvak21ilLio2bJZSYBkyim29Z8jyMOAy1HFb7hhJIukvna3HQ7i1XHgqtjlXDKV2Js7+MGe4i5kmfVO6zuulun5i9okspXWUYpRMo8Pddw2VY2Cpe4IZ1y4CqZsRHRAjZbPoJzU5ngGDiQscbs=
Message-ID: <48234B0B.8040602@gmail.com>
Date: Thu, 08 May 2008 20:48:43 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Takashi Iwai <tiwai@suse.de>, Vefa Bicakci <bicave@superonline.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bisected Regression] snd-intel-hda no longer produces sound
 on Toshiba Satellite A100
References: <481CD1B9.3020601@superonline.com> <s5h7ieaa7at.wl%tiwai@suse.de> <200805082046.30742.rjw@sisk.pl>
In-Reply-To: <200805082046.30742.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki pisze:
> On Sunday, 4 of May 2008, Takashi Iwai wrote:
>> At Sat, 03 May 2008 23:57:29 +0300,
>> Vefa Bicakci wrote:
>>> Hello,
>>>
>>> I am using Debian Sid on a Toshiba Satellite A100 series laptop.
>>> This laptop has an Intel HDA sound card. It uses the Realtec codecs.
>>> After modprobe'ing snd-intel-hda, the following appears in dmesg:
>>> "hda_codec: Unknown model for ALC861, trying auto-probe from BIOS..."
>>>
>>> The sound output used to work fine with 2.6.24.x and 2.6.25. In an
>>> unrelated move, I decided to give 2.6.25-gitX series a try; however,
>>> I was very sad to notice that sound output became disabled. Programs
>>> such as ogg123 or Amarok seem to play, but there is no sound output,
>>> only silence. I have checked multiple times that no new mixer settings
>>> appeared because of a possible snd-hda-intel update...
>>>
>>> I bisected the differences between 2.6.25 and HEAD (as of 28th of
>>> April) to find the problematic git commit. The git commit with the
>>> following ID and description disables the sound output completely:
>>>
>>> --- 8< ---
>>> commit f6c7e5461e9046445d50c5c7a9a4587824239623
>>> [ALSA] hda-codec - Fix auto-configuration of Realtek codecs
>>> --- >8 ---
>>>
>>> I believe that this is an important regression, and I would like
>>> to debug this problem. Trying out patches is no problem for me.
>> This is a known issue and should have been already fixed on sound
>> tree.  Try to pull the following git tree (for-linus branch):
>>     git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 for-linus
> 
> Has the fix already reached the Linus' tree?
> 

Yes, it has.

-Jacek
