Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbZIHINx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbZIHINx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZIHINw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:13:52 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:38151 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753400AbZIHINv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:13:51 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net 0215E2C2F1E
Message-ID: <4AA6123F.7020704@arcor.de>
Date: Tue, 08 Sep 2009 11:13:51 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Pietikainen <pp@ee.oulu.fi>, Michael Buesch <mb@bu3sch.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu> <200909072051.13748.mb@bu3sch.de> <20090907205701.GA8590@elte.hu> <20090907232415.GA17182@ee.oulu.fi> <20090908080427.GA7070@elte.hu>
In-Reply-To: <20090908080427.GA7070@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 11:04 AM, Ingo Molnar wrote:
>
> * Pekka Pietikainen<pp@ee.oulu.fi>  wrote:
>
>> On Mon, Sep 07, 2009 at 10:57:01PM +0200, Ingo Molnar wrote:
>>>>> Could you profile it please? Also, what's the context-switch rate?
>>>>
>>>> As far as I can tell, the broadcom mips architecture does not have
>>>> profiling support. It does only have some proprietary profiling
>>>> registers that nobody wrote kernel support for, yet.
>>> Well, what does 'vmstat 1' show - how many context switches are
>>> there per second on the iperf server? In theory if it's a truly
>>> saturated box, there shouldnt be many - just a single iperf task
>>
>> Yay, finally something that's measurable in this thread \o/
>
> My initial posting in this thread contains 6 separate types of
> measurements, rather extensive ones. Out of those, 4 measurements
> were latency oriented, two were throughput oriented. Plenty of data,
> plenty of results, and very good reproducability.

None of which involve latency-prone GUI applications running on cheap 
commodity hardware though.  I listed examples where mainline seems to 
behave sub-optimal and ways to reproduce them but this doesn't seem to 
be an area of interest.
