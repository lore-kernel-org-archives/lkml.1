Return-Path: <linux-kernel-owner+w=401wt.eu-S932430AbZE3OK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbZE3OK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758907AbZE3OKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:10:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40434 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758124AbZE3OKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:10:21 -0400
Message-ID: <4A213DF9.2040207@redhat.com>
Date: Sat, 30 May 2009 10:08:57 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: pageexec@freemail.hu, "Larry H." <research@subreption.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page allocator
References: <20090522073436.GA3612@elte.hu>	 , <20090530054856.GG29711@oblivion.subreption.com>	 , <1243679973.6645.131.camel@laptop>	 <4A211BA8.8585.17B52182@pageexec.freemail.hu> <1243689707.6645.134.camel@laptop>
In-Reply-To: <1243689707.6645.134.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sat, 2009-05-30 at 13:42 +0200, pageexec@freemail.hu wrote:
>>> Why waste time on this?
>> e.g., when userland executes a syscall, it 'can run kernel code'. if that kernel
>> code (note: already exists, isn't provided by the attacker) gives unintended
>> kernel memory back to userland, there is a problem. that problem is addressed
>> in part by early sanitizing of freed data.
> 
> Right, so the whole point is to minimize the impact of actual bugs,
> right? So why not focus on fixing those actual bugs? Can we create tools
> to help us find such bugs faster? We use sparse for a lot of static
> checking, we create things like lockdep and kmemcheck to dynamically
> find trouble.
> 
> Can we instead of working around a problem, fix the actual problem?

Do you drive without seatbelts, because the real fix
is to stay out of accidents?

No software is bug free.

Let me repeat that: no software is bug free.

This means your security strategy cannot rely on
software being bug free.

This is why every security strategy is a "belt and
suspenders" thing, where:
1) code is audited to remove as many bugs as possible, and
2) the system is configured in such a way that the impact
    of the remaining bugs is limited

For example, if you check your own system you will find
that system daemons like bind and httpd run with limited
privileges.  This is done because, again, no software is
bug free and you want to limit the damage that can be done
after a bug is exploited.


-- 
All rights reversed.
