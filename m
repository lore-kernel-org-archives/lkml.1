Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbXD2UDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbXD2UDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbXD2UDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:03:39 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:2840 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbXD2UDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:03:38 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: Best nice level for X with SD
Date: Sun, 29 Apr 2007 22:03:34 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <200704241552.52552.Martin@lichtvoll.de> <200704262211.53393.Martin@lichtvoll.de> <200704271011.21340.Martin@lichtvoll.de> (sfid-20070427_101601_340096_0740B834)
In-Reply-To: <200704271011.21340.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704292203.34783.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 27 April 2007 schrieb Martin Steigerwald:
> Am Freitag 27 April 2007 schrieb Con Kolivas:
> > Clearly there are some serious regressions for audio playback with
> > CFS. This is incredible effort to go to with CFS.
>
> Hi Con!
>
> Well, at least on my two ThinkPads T42 and T23.
>
> I perceive sd-0.46 as more mature as CFSv6. And if asked to include one
> of them in the kernel *right now* or *soonish*, I would probably choose
> sd-0.46 and give Ingo a bit more time.

Hi!

I tried cfs-v7 where Ingo fixed a 'big bug' he found while looking at the 
debug data I provided to him.

Well, its rocking now on both my Amarok machine, the T23, and the T42. 
Absolutely smooth music playback, no matter what. No freezes anymore 
whatsoever.

Even when stress testing with my usual naive user tests, having make-kpkg 
linux_image running, starting tons of apps and solid moving Amarok window 
like mad - that was on my T23.  On my T42 I repeated that Kaffeine test, 
playing a video with it, while moving the window like mad, no complete 
freezes anymore...

Congrats, Ingo! cfs-v7 is rocking now ;-).


Tested on 2.6.21.1 with sws2 2.2.9.13, dynticks and CONFIG_HZ=300 as the 
older kernels I tested with.

That is without X renicing just like I run sd-0.46 as well.

Now it seems that I have *two* schedulers to choose from. ;-) I am 
satisfied with both sd-0.46 and cfs-v7 now.

Actually cfs-v7 feels a bit smoother for me now. Thats nothing concrete at 
the moment, nothing I can get a hold of it.  cfs-v7 just feels a bit 
smoother to me.

Will do some longer term testing with cfs-v7 now.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
