Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZIHHTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZIHHTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 03:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZIHHTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 03:19:07 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:43392 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690AbZIHHTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 03:19:06 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-14.arcor-online.net 7A1EB28B16C
Message-ID: <4AA6056A.4020106@arcor.de>
Date: Tue, 08 Sep 2009 10:19:06 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu>	<h81v7t$p6e$1@ger.gmane.org> <20090907074039.1b6bc1ac@infradead.org>
In-Reply-To: <20090907074039.1b6bc1ac@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2009 05:40 PM, Arjan van de Ven wrote:
> On Mon, 07 Sep 2009 06:38:36 +0300
> Nikos Chantziaras<realnc@arcor.de>  wrote:
>
>> On 09/06/2009 11:59 PM, Ingo Molnar wrote:
>>> [...]
>>> Also, i'd like to outline that i agree with the general goals
>>> described by you in the BFS announcement - small desktop systems
>>> matter more than large systems. We find it critically important
>>> that the mainline Linux scheduler performs well on those systems
>>> too - and if you (or anyone else) can reproduce suboptimal behavior
>>> please let the scheduler folks know so that we can fix/improve it.
>>
>> BFS improved behavior of many applications on my Intel Core 2 box in
>> a way that can't be benchmarked.  Examples:
>
> Have you tried to see if latencytop catches such latencies ?

I've just tried it.

I start latencytop and then mplayer on a video that doesn't max out the 
CPU (needs about 20-30% of a single core (out of 2 available)).  Then, 
while the video is playing, I press Alt+Tab repeatedly which makes the 
desktop compositor kick-in and stay active (it lays out all windows as a 
"flip-switch", similar to the Microsoft Vista Aero alt+tab effect). 
Repeatedly pressing alt+tab results in the compositor (in this case KDE 
4.3.1) keep doing processing.  With the mainline scheduler, mplayer 
starts dropping frames and skip sound like crazy for the whole duration 
of this exercise.

latencytop has this to say:

   http://foss.math.aegean.gr/~realnc/pics/latop1.png

Though I don't really understand what this tool is trying to tell me, I 
hope someone does.
