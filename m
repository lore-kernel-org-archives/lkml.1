Return-Path: <linux-kernel-owner+w=401wt.eu-S1161020AbXAaUWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161020AbXAaUWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161027AbXAaUWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:22:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161020AbXAaUWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:22:09 -0500
Message-ID: <45C0FA11.1060303@redhat.com>
Date: Wed, 31 Jan 2007 15:20:33 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "Linda W." <lkml@tlinx.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux scheduler and "cache-mate" processors
References: <45B7F567.7020100@tlinx.org> <1170238640.2865.4.camel@laptopd505.fenrus.org>
In-Reply-To: <1170238640.2865.4.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> 1) does the scheduler know enough to try to spread tasks
>> equally over both the pairs to make best use of the 16MB total
>> cache? (i.e. given cpu bound processes "1" and "2", if they
>> are both on CPU "A", then the "C-D" cache remains unused, but
>> keeping "1" on "a" and "2" on "C" would tend to minimize
>> their caches being consumed by each other.
>>     
>
> yes this works just fine
>
>
>   
>> 2) Since either A&B both have access to the 8MB cache, then
>> if a process was running on "A", it seems it would have a
>> low migration cost to be scheduled on "B" -- i.e. shouldn't
>> the process, if it were migrated to "A"'s "cache-mate", "B",
>> be able to benefit by any previous caching done on "A"? 
>> If that's true, does the scheduler give preference, when
>> migrating a process, to a CPU's "cache-mate"? 
>>     
>
> afaik yes as well
>
>   
You do have to enable "Multi-core scheduler support" in the kernel
.config, though.

