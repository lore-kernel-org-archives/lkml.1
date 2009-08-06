Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZHFUC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZHFUC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbZHFUC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:02:58 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:6059 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756512AbZHFUC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:02:57 -0400
X-IronPort-AV: E=Sophos;i="4.43,336,1246831200"; 
   d="scan'208";a="30867737"
Message-ID: <4A7B36FC.5010602@inria.fr>
Date: Thu, 06 Aug 2009 22:03:08 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix reading of perf.data file header
References: <20090623134749.GA6897@elte.hu> <4A40DFF5.7010207@inria.fr> <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr> <20090629192913.GA29295@elte.hu> <4A7B0C02.7060704@inria.fr> <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr> <20090806195924.GA22411@elte.hu>
In-Reply-To: <20090806195924.GA22411@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Brice Goglin <Brice.Goglin@inria.fr> wrote:
>
>   
>> $ /mnt/scratch/bgoglin/cpunode/linux-2.6.31/tools/perf/perf report -D |
>> grep _READ | sort -k5
>> 0x8bb8 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000001e0 494628
>> 0x8fc0 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000002e0 209113
>> 0x9698 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000004e0 307215
>> 0x9cf8 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000008e0 9203221
>> 0x8a08 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000001e0 9210788
>> 0x9020 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000002e0 302344
>> 0x9608 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000004e0 198705
>> 0x9d28 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000008e0 473471
>> [...]
>>
>> Now I know which thread actually reads from where.
>> Looks like we're good to go now! thanks a lot Peter!
>>
>> Tested-by: Brice Goglin <Brice.Goglin@inria.fr>
>>     
>
> Thanks Brice.
>
> It would be nice to add this as some "perf report -s/--stats" flag, 
> to not have to go via -D (which is a 'print debug output' kind of 
> ad-hoc thing and subject to format changes in the future).
>
> Would you be interested in sending a patch that adds that flag to 
> 'perf report', to print out these statistics entries (if any), in a 
> tabular form suitable for your purposes? Below is a past patch to 
> builtin-report.c that shows how to add new options.
>
>   

I'll see what I can do. I have been looking at the code tonight before
Peter fixed the last problem but I didn't manage to understand much of
the code so far. So thanks for the example patch :)

Brice

