Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbYCUNdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbYCUNdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYCUNdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:33:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:41044 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbYCUNda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:33:30 -0400
Message-ID: <47E3B924.3000304@colorfullife.com>
Date: Fri, 21 Mar 2008 14:33:24 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Scalability requirements for sysv ipc
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>
In-Reply-To: <47E3ADE3.4030304@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey wrote:
> Manfred Spraul wrote:
>>
>> A microbenchmark on a single-cpu system doesn't help much (except 
>> that 2.6.25 is around factor 2 slower for sysv msg ping-pong between 
>> two tasks compared to the numbers I remember from older kernels....)
>>
>
> If I remember well, at that time I had used ctxbench and I wrote some 
> other small scripts.
> And the results I had were around 2 or 3% slowdown, but I have to 
> confirm that by checking in my archives.
>
Do you have access to multi-core systems? The "best case" for the rcu 
code would be
- 8 or 16 cores
- one instance of ctxbench running on each core, bound to that core.

I'd expect a significant slowdown. The big question is if it matters.

--
    Manfred
