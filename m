Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbXEZKyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbXEZKyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 06:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXEZKyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 06:54:25 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41950 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbXEZKyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 06:54:24 -0400
Date: Sat, 26 May 2007 12:51:48 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Takashi Iwai <tiwai@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Uwe Bugla <uwe.bugla@gmx.de>,
       linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>
Subject: Re: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
In-Reply-To: <s5h1wh4si5l.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.61.0705261248150.7344@yvahk01.tjqt.qr>
References: <20070524200052.234330@gmx.net> <20070524130921.8dbd3777.akpm@linux-foundation.org>
 <s5hiragopsx.wl%tiwai@suse.de> <20070525102806.77ee9c0c.akpm@linux-foundation.org>
 <s5h1wh4si5l.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 25 2007 23:33, Takashi Iwai wrote:
>
>Yeah, I'll check it again if reposted.  Jan, could you split ALSA
>portins at the next time?

How much split? This time, I made four out of it.

>This will make testing and merging much
>easier for me...
>
>But, above all, I'm not convinced much by that patch, especially
>because it introduces new kconfigs just for menuconfig.
>For example, CONFIG_SND_PCI_DRIVERS doesn't appear in any Makefiles.

Neither is/was CONFIG_DVB IIRC. The world does not stop turning just
because there are now extra options. If you want the functionality
of menuconfigs without introducing some variable to store their state,
well, I think that's going to be a bigger kconf patch. (Just think of
compatibility of the .config format.)


	Jan
-- 
