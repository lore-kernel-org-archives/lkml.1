Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbYANUri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbYANUri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYANUr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:47:28 -0500
Received: from mailout06.sul.t-online.de ([194.25.134.19]:55493 "EHLO
	mailout06.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYANUr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:47:27 -0500
Message-ID: <478BCA42.1090503@t-online.de>
Date: Mon, 14 Jan 2008 21:46:58 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc7, intel audio: alsa doesn't say a beep
References: <4782833D.3010600@t-online.de>	<s5h3at8rd9c.wl%tiwai@suse.de>	<4783AC7C.50900@t-online.de>	<s5h63y42oy6.wl%tiwai@suse.de>	<478463A6.2070106@t-online.de>	<s5h8x2zo3ox.wl%tiwai@suse.de>	<47852A41.9020903@t-online.de>	<s5hr6gpajux.wl%tiwai@suse.de>	<4786960D.2040500@t-online.de>	<s5hprw8g8m7.wl%tiwai@suse.de>	<4787E5D0.7000405@t-online.de> <s5h8x2u2cwf.wl%tiwai@suse.de>
In-Reply-To: <s5h8x2u2cwf.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: EXBq3rZGohrqkiQ4dwV1gSLMi76OBdbSo463WnuWMIRB1MpxsLwHChduGT5CCl8Qk4
X-TOI-MSGID: 6c57b0b6-da9c-4bde-8f3b-1528d62d1799
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Takashi-san,

Takashi Iwai wrote:
> 
> The "regression" was your original problem, no sound on rc7, which was
> fixed by reverting the patch.  Now I'd like to know that my new patch
> doesn't break after reverting the broken patch.
> 

Seems that there was some misunderstanding: I thought your patch
for sigmatel.c was supposed to fix the "missing sound" problem,
too.

> In short, try my patch on the latest Linus git tree.  Check whether
> the sound still works.
> 

It does.

rc7 plus the big "clean-up" patch for sigmatel.c plus hda_intel.c
taken from rc6 worked, too. Seems that I missed to mention it in a
previous EMail.

> 
> It's simply a delay.  Basically Ingo's patch changed msleep() to
> udelay() to reduce *unneeded* delays.  The function waits until the
> all pending commands are processed.  The delay is simply to reduce the
> system load.  And, now, changing this delay causes a problem
> surprisingly.
> 

I am glad to help, but could you please do me a favour? If I am
supposed to try some new version, then please create a complete(!)
patch using rc7 on kernel.org as the base, and send it as an
attachment using a unique filename. Very likely you have a much
better overview about the most recent kernel changes, but some
statements like "new patch" or "Ingo's patch" don't mean very much
to me. The "reverted" patch is a new patch, too, and AFAIK Ingo
reverted it, so maybe you can imagine that this is highly confusing.

 >> AFAICS I did use the mm branch. The command to grab the sources was
 >>
 >> git-clone git://git.kernel.org/pub/scm/linux/kernel/git/perex/alsa.git mm
 >>
 >> Is this correct?
 >
 > No.  You'd better to clone Linus git tree, then pull from alsa.git mm
 > branch.
 >
 >   % git-clone $LINUS/linux-2.6.git
 >   % cd linux-2.6
 >   % git-pull $ALSA/alsa.git mm
 >

AFAICS there shouldn't be a difference to my one-liner, unless Linus'
and Alsa's git trees are out of sync. Is this correct? Sorry, I am
more familiar with ClearCase and Accurev than with Git.


Regards

Harri

