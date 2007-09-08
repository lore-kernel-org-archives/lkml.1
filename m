Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbXIHRtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbXIHRtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 13:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXIHRti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 13:49:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39304 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbXIHRth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 13:49:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46E2E099.9040402@s5r6.in-berlin.de>
Date: Sat, 08 Sep 2007 19:49:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Thorsten Leemhuis <fedora@leemhuis.info>
CC: Takashi Iwai <tiwai@suse.de>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Andrew Morton <akpm@linux-foundation.org>, roger@computer-surgery.co.uk,
       linux-kernel@vger.kernel.org, perex@suse.cz
Subject: Re: easy alsa patches for the stable kernel?
References: <20070822222902.GA28563@computer-surgery.co.uk>	<20070905083844.6637da1e.akpm@linux-foundation.org>	<s5hlkbl6qsn.wl%tiwai@suse.de>	<20070905091633.87cfaa81.akpm@linux-foundation.org>	<s5hhcm96oza.wl%tiwai@suse.de>	<1189091390.3212.3.camel@rukbat>	<s5hir6n6ck6.wl%tiwai@suse.de>	<1189115313.7275.5.camel@rukbat>	<1189153347.15955.5.camel@rukbat>	<s5h7in26aj3.wl%tiwai@suse.de>	<46E13E31.1050409@leemhuis.info>	<s5hy7fi4oou.wl%tiwai@suse.de>	<46E1A9AC.1050601@leemhuis.info> <s5hsl5qhwqa.wl%tiwai@suse.de> <46E24177.7070702@leemhuis.info>
In-Reply-To: <46E24177.7070702@leemhuis.info>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thorsten Leemhuis wrote:
> On 08.09.2007 01:38, Takashi Iwai wrote:
[backports to -stable]
>> Linux will suck really if one breaks so-called stable thing easily
>> without actually testing.  For stable stuff, "it should be good" isn't
>> enough.  It must be: "it IS good."

This applies (or should apply...) to everything that goes to Linus in
his pre -rc1 merge windows.  To post -rc1 submissions and even more so
to -stable submissions, additional criteria apply.

However, there are special kernel trees out there which accept
backports.  Linux distributors do backports, because they have the means
to do so.

> Linux IMHO will suck even more if crucial pieces of hardware does not
> work for people easily, because Linux won't get even used then and will
> frustrate people.
> 
> Don't get me wrong; I understand and agree mostly to the points you
> raised. But we nevertheless need to find a way to make todays hardware
> usable more quickly, as that hardware is often on the market only for
> some months or a year until the successor-model replaces it (which might
> need new drivers or workarounds) --

In the end there is but one solution to this:  Open specs.

> but it sometimes even for small
> alsa-fixes takes as many months to make it from the developers out to
> the kernel and from there to the distributions the user uses.
> 
> It works better in some areas of the kernels (SATA and Network drivers
> come to my mind) where patches make it quicker into the linus- and
> stable-kernels -- in parts that is due to better cooperation with the
> hardware-vendors, but it seems the sub-tree maintainers have a better
> patch-/workflow, which has a strong impact as well.

Feature additions to SATA and networking, e.g. support of additional
hardware, are not backported to -stable or merged post -rc1 either, I
presume.  Maybe they are better in getting stuff ready in time before
merge windows open --- I don't know, I don't watch these subsystems.
Maybe they have less trouble with closed or nonexisting specs...?
-- 
Stefan Richter
-=====-=-=== =--= -=---
http://arcgraph.de/sr/
