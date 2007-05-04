Return-Path: <linux-kernel-owner+w=401wt.eu-S1031438AbXEDRIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031438AbXEDRIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031441AbXEDRIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:08:35 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:45674 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031438AbXEDRId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:08:33 -0400
Message-ID: <463B687D.1020600@interia.pl>
Date: Fri, 04 May 2007 19:08:13 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Dave Jones <davej@codemonkey.org.uk>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EMID: bbb6cacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
Hello all
> 
> I found that setting the cpufreq governor to ondemand making the box 
> lock up solid in 2.6.20.2 and 2.6.21 after a few seconds.
> [...]

I can't explain this. Some motherboards are running fine, some don't.
I'm running longhaul too. It is working fine. No lockups at all. 
So far I heard only about one Epia which had problems with longhaul. 
It was almost like my Epia but older.
What is possible:
- some chipsets revisions are broken and aren't blocking DMA,
- special setup is required, some versions of BIOS are doing 
necessary things, some don't,
- some chipsets revisions are broken and drivers are not aware. At 
the beginning Unichrome driver was causing lockups on my machine, but 
Openchrome was fine. Longhaul may trigger, somehow, other hardware bug. 

Anyway I don't belive in Longhaul anymore. It is working for me. It is 
working for others. And it isn't working for others. VIA isn't supporting 
this driver. Support came only from Centaur and Dave Jones. If special 
setup is required for north/southbridge then it is necessary to have 
documentation. I will not receive it from VIA.

I'm asking about advice. Make it BROKEN again? Add "big fat warning" and 
"enable" option? I know that this is Dave Jones decision, but I would like 
to heard what people are thinking, becuse I've been messing a lot with 
this driver.

Btw. I've been writting many times: if You want to use ondemand with 
Longhaul You don't need cpufreq at all. It is just one another cool 
gadget for You. Longhaul wasn't designed to change frequency often. 
It has big latency and requires so much preparation that it isn't worth 
if You don't need to save power or cool down CPU. 

Sorry for bad English
Rafał


----------------------------------------------------------------------
NIE KUPUJ!!!
...zanim nie porownasz cen >> http://link.interia.pl/f1a5e



