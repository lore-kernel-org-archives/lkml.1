Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbYCWWtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbYCWWtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 18:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbYCWWtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 18:49:35 -0400
Received: from mail1.ugh.no ([80.239.42.168]:43231 "EHLO mail1.ugh.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755983AbYCWWte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 18:49:34 -0400
Message-ID: <47E6DE7C.1050903@tomt.net>
Date: Sun, 23 Mar 2008 23:49:32 +0100
From: Andre Tomt <andre@tomt.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       mranostay@embeddedalley.com
Subject: Re: 2.6.25-git regression with snd-hda-intel on Dell XPS M1330, no
 analog sound
References: <47E40684.2030608@tomt.net> <s5hwsnuzp1c.wl%tiwai@suse.de>
In-Reply-To: <s5hwsnuzp1c.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Fri, 21 Mar 2008 20:03:32 +0100,
> Andre Tomt wrote:
>> [Rafael & Matthew: this is a resend - original was sent to wrong 
>> linux-kernel address. Also updated, so just ignore the earlier emails.]
>>
>> With 2.6.25-git I lost sound on my Dell XPS M1330 laptop. There seems to 
>> be two issues at hand here: 1. Analog output is listed, but emits no 
>> sound (just silence), and 2. Digital out device is missing.
>>
>> Issue #1 is bisected in this thread. #2 is still work in progress, and 
>> will be posted as a separate thread.
> 
> Please try my ALSA git tree
> 	git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
> One patch (removing master hack from headphone pin) would fix your
> problem.  At least, I have some reports that the latest ALSA tree
> works.  If it still doesn't work, give the alsa-info.sh output (the
> script is found in www.alsa-project.org "Debug" section).

Yep. Analog out is working with sound-2.6.git. Thanks. What is the 
commit id of the removing master hack commit?

> If the issue #2 is about HDMI, I'm afraid it won't work until Nvidia
> video driver supports the HDMI audio output.

I must admit I never tested it in Linux, and testing it now using 2.6.24 
I cannot get it to work either. In the windows drivers the port is 
simply labeled as a spdif output on the same codec, but I have no idea 
on how this is put together..
