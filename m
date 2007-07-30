Return-Path: <linux-kernel-owner+w=401wt.eu-S967875AbXG3TF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967875AbXG3TF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967139AbXG3TFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:05:11 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:38814
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967415AbXG3TFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:05:09 -0400
Date: Mon, 30 Jul 2007 12:03:56 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Ingo Molnar <mingo@elte.hu>
cc: John <darknessenvelops@gmail.com>, Kasper Sandberg <lkml@metanurb.dk>,
       ck@vds.kolivas.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
In-Reply-To: <20070730190147.GC20901@elte.hu>
Message-ID: <Pine.LNX.4.64.0707301202260.12232@asgard.lang.hm>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu>
 <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com>
 <20070729204716.GB1578@elte.hu> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
 <20070730114649.GB19186@elte.hu> <Pine.LNX.4.64.0707300914160.11330@asgard.lang.hm>
 <20070730190147.GC20901@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007, Ingo Molnar wrote:

> * david@lang.hm <david@lang.hm> wrote:
>
>>> Would you be interested in trying CFS and doing some numers perhaps?
>>> It requires some work: you have to start up your favorite game in a
>>> way that gives a reliable framerate number. (many games allow the
>>> display of FPS in-game) In Quake3 i simply started the game and did
>>> not move the player - that is something easy to reproduce.
>>
>> the one report that I saw said that the FPS numbers were overall the
>> same, but what the reporter was seeing was that CFS was doing it in
>> bursts of activity while SD was smoother. [...]
>
> which report is that, precisely? I'm not aware of any such report past
> CFS v14 or so.
>
>> IIRC Linus responded with thoughts on granularity and the fact that
>> changing from Hz 1000 to Hz 100 will increase the timeslices in CFS by
>> 10x (which could be enough to trigger this sort of issue)
>
> ah, you mean Kasper Sandberg's report? That turned out to be based on an
> older CFS version, not v2.6.23-rc1. Kasper said he'll redo his tests,
> and if there's still any regression left we'll fix it.

probably. I delete lkml messages pretty agressivly so I don't have them 
around to refer to.

David Lang
