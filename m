Return-Path: <linux-kernel-owner+w=401wt.eu-S1765743AbXEYVIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765743AbXEYVIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbXEYVIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:08:45 -0400
Received: from smtpa3.netcabo.pt ([212.113.174.18]:40202 "EHLO
	exch01smtp02.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756325AbXEYVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:08:44 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 17:08:44 EDT
Message-ID: <46574DE4.2080900@rncbc.org>
Date: Fri, 25 May 2007 21:58:12 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: 2.6.21-rt2..8 troubles
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org> <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu>
In-Reply-To: <20070401183928.GB27614@elte.hu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2007 20:59:26.0630 (UTC) FILETIME=[9464AC60:01C79F0F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo et al.

It's been quite a while, since last time I've complained about the -rt
kernel patch series. This time I'm afraid I have a nasty specialty I've
been trying to figure out and isolate but to no definitive results.

Fact is, since 2.6.21-rt2 and still on latest -rt8, that I'm facing
troubled behavior while running on a Core2 T7200 laptop (SMP). Somehow,
soon or later, the whole system starts crawling to death. It just slows
down to some kind of Big Freeze, with no evidence over the console
whatsoever, so that I'm ultimately left with a brick on my hands.

This behavior is consistent and occurs every time after a while. It
surely does not occur on 2.6.21-rt1 and earlier. Even stranger, it does
not occur on another but older P4@3.3Ghz desktop (HT/SMP) where a very
identical system image is deployed (openSUSE 10.2 i386, gcc 4.1.2, KDE
3.5.7)

I wish I could give you more details, but the fact is I don't know where
to look. The machine just freezes silently, again and again, with all
kernels from -rt2 to -rt8 inclusive, with no traceable evidence, at
least to my knowledge. The only symptom that I can come about is that,
from some moment on and ever since, the system cannot start any new
process anymore, or otherwise takes forever to realize and launch any
new started process thread.

A sample dmesg output:
   http://www.rncbc.org/datahub/dmesg-2.6.21-rt5.0
The corresponding .config:
   http://www.rncbc.org/datahub/config-2.6.21-rt5.0

Again, there's no logged evidence of the problem, which is as nasty as
repeatable after each boot. Unfortunately, it's not quite
deterministically reproducible, this behavior of turning into an
unresponsive brick ;) It's just a matter of time, or so I think. That's
why I have no clues.

Is there anything I can do better to help myself figuring out this
issue? As this is a  modern laptop such things like a serial console are
unavailable, but it would be nice to track things up over netconsole
perhaps?

I just need some bright and nice directions now ;) Hope someone finds
this worth of attention too. Meanwhile, I'll be happy with 2.6.21-rt1 :)

Cheers.
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org

