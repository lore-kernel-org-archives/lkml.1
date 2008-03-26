Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbYCZP7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbYCZP7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759341AbYCZP7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:59:40 -0400
Received: from relay2.sgi.com ([192.48.171.30]:46329 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759228AbYCZP7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:59:39 -0400
Message-ID: <47EA72E9.4060307@sgi.com>
Date: Wed, 26 Mar 2008 08:59:37 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] NR_CPUS: increase maximum NR_CPUS to 4096
References: <20080326014137.934171000@polaris-admin.engr.sgi.com> <20080326061925.GC18301@elte.hu>
In-Reply-To: <20080326061925.GC18301@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Increases the limit of NR_CPUS to 4096 and introduces a boolean called 
>> "MAXSMP" which when set (e.g. "allyesconfig") will set NR_CPUS = 4096 
>> and NODES_SHIFT = 9 (512).
>>
>> I've been running this config (4k NR_CPUS, 512 Max Nodes) on an AMD 
>> box with 2 dual-cores and 4gb memory.  I've also successfully booted 
>> it in a simulated 2cpus/1Gb environment.
> 
> cool!
> 
> this depends on the cpumask changes to work correctly (i.e. to boot at 
> all), right?
> 
> 	Ingo


Yes, it overflows the stack quite quickly without the cpumask changes.
I didn't do any testing to see what's the minimal set of changes.

Thanks,
Mike
