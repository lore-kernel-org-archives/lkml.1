Return-Path: <linux-kernel-owner+w=401wt.eu-S966703AbXG3Q1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966703AbXG3Q1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965052AbXG3QUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:20:45 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:44276
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939674AbXG3QUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:20:43 -0400
Date: Mon, 30 Jul 2007 09:19:02 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Ingo Molnar <mingo@elte.hu>
cc: John <darknessenvelops@gmail.com>, Kasper Sandberg <lkml@metanurb.dk>,
       ck@vds.kolivas.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
In-Reply-To: <20070730114649.GB19186@elte.hu>
Message-ID: <Pine.LNX.4.64.0707300914160.11330@asgard.lang.hm>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu>
 <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com>
 <20070729204716.GB1578@elte.hu> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
 <20070730114649.GB19186@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007, Ingo Molnar wrote:

> * John <darknessenvelops@gmail.com> wrote:
>
>> On 7/29/07, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>>
>>> * John <darknessenvelops@gmail.com> wrote:
>>>
>>>> Ingo-
>>>>
>>>> Why not perform the same test using the native linux Q3 client to
>>>> compare numbers to wine? [...]
>>>
>>> I regularly test native Linux games on CFS, and they all behave well.
>>> While waiting for more detailed data from Kasper i was looking for
>>> atypical stuff in Kasper's description about what his workload involves,
>>> and what looked a bit atypical was that Kasper's workload also involved
>>> gaming under Wine:
>>
>> I understand that, I was just wondering if the FPS scales the same
>> natively vs. Wine as I typically only run native games.  [...]
>
> people are regularly testing 3D smoothness, and they find CFS good
> enough:
>
>   http://bhhdoa.org.au/pipermail/ck/2007-June/007816.html
>
> and that matches my experience as well (as limited as it may be). In
> general my impression is that CFS and SD are roughly on par when it
> comes to 3D smoothness.
<SNIP>
> i have no numbers now, other than the trivial native 'ppracer' game
> where SD and CFS have roughly the same framerate under load:
>
>     SD           CFS
<SNIP>
> which i'd have expected, ppracer is quite CPU-intense on my test-system,
> and the fairness model of SD and CFS is similar for CPU-bound tasks.
>
> But ... numbers from _me_ are suspect by definition, i wrote a good
> chunk of the CFS code :-) So it would be much more interesting if others
> provided more numbers.
>
> Would you be interested in trying CFS and doing some numers perhaps? It
> requires some work: you have to start up your favorite game in a way
> that gives a reliable framerate number. (many games allow the display of
> FPS in-game) In Quake3 i simply started the game and did not move the
> player - that is something easy to reproduce.

the one report that I saw said that the FPS numbers were overall the same, 
but what the reporter was seeing was that CFS was doing it in bursts of 
activity while SD was smoother. this wasn't enough to show up in the fps 
numbers being reported, but was enough to be unreasonable for gameing.

IIRC Linus responded with thoughts on granularity and the fact that 
changing from Hz 1000 to Hz 100 will increase the timeslices in CFS by 
10x (which could be enough to trigger this sort of issue)

David Lang
