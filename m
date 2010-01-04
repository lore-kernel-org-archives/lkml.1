Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143Ab0ADXVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0ADXVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619Ab0ADXVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:21:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab0ADXVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:21:34 -0500
Message-ID: <4B4277B0.1080506@redhat.com>
Date: Mon, 04 Jan 2010 18:20:16 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/8] Speculative pagefault -v3
References: <20100104182429.833180340@chello.nl>	 <4B42606F.3000906@redhat.com> <1262641573.6408.434.camel@laptop>
In-Reply-To: <1262641573.6408.434.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 04:46 PM, Peter Zijlstra wrote:
> On Mon, 2010-01-04 at 16:41 -0500, Rik van Riel wrote:
>> On 01/04/2010 01:24 PM, Peter Zijlstra wrote:
>>> Patch series implementing speculative page faults for x86.
>>
>> Fun, but why do we need this?
>
> People were once again concerned with mmap_sem contention on threaded
> apps on large machines. Kame-san posted some patches, but I felt they
> weren't quite crazy enough ;-)

In that case, I assume that somebody else (maybe Kame-san or
Christoph) will end up posting a benchmark that shows how
these patches help.

-- 
All rights reversed.
