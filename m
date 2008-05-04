Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYEDVJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYEDVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYEDVJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:09:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbYEDVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:09:21 -0400
Message-ID: <481E2516.7070600@zytor.com>
Date: Sun, 04 May 2008 14:05:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 0/2] Immediate Values - jump patching update
References: <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com> <20080428224438.GA6974@elte.hu> <48165866.5060403@zytor.com> <20080429014623.GA6284@Krystal> <481682D6.5010207@zytor.com> <20080429121839.GA29912@Krystal> <4817405D.2020400@zytor.com> <20080504145430.GA23137@Krystal>
In-Reply-To: <20080504145430.GA23137@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Following your own suggestion, why don't we fix gcc and make it
> interleave unlikely blocks less heavily with hot blocks ?
> 

Doing this with compiler support is definitely The Right Thing, so I 
think this is the best way.

>> Furthermore, modern CPUs often speculatively fetch *both* 
>> branches of a conditional.
>>
>> This is actually the biggest motivation for patching static branches.
> 
> Agreed. I'd like to find some info about which microarchitectures you
> have in mind. Intel Core 2 ?

Not sure about Core 2, although Core 2 definitely can track down the 
wrong branch on a mispredict.

> Let's fix gcc ! ;)

Sounds great :)

	-hpa

