Return-Path: <linux-kernel-owner+w=401wt.eu-S932609AbZE3Oti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbZE3Oti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbZE3Otb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:49:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49118 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758119AbZE3Ota (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:49:30 -0400
Message-ID: <4A214752.7000303@redhat.com>
Date: Sat, 30 May 2009 10:48:50 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, pageexec@freemail.hu,
       "Larry H." <research@subreption.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page allocator
References: <20090522073436.GA3612@elte.hu>	 <20090530054856.GG29711@oblivion.subreption.com>	 <1243679973.6645.131.camel@laptop>	 <4A211BA8.8585.17B52182@pageexec.freemail.hu>	 <1243689707.6645.134.camel@laptop>	 <20090530153023.45600fd2@lxorguk.ukuu.org.uk> <1243694737.6645.142.camel@laptop>
In-Reply-To: <1243694737.6645.142.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sat, 2009-05-30 at 15:30 +0100, Alan Cox wrote:
>>> Right, so the whole point is to minimize the impact of actual bugs,
>>> right? So why not focus on fixing those actual bugs? Can we create tools
>>> to help us find such bugs faster? We use sparse for a lot of static
>>> checking, we create things like lockdep and kmemcheck to dynamically
>>> find trouble.
>>>
>>> Can we instead of working around a problem, fix the actual problem?
>> Why do cars have crashworthiness and seatbelts ? Why not fix the actual
>> problem (driving errors) ? I mean lets face it they make the vehicle
>> heavier, less fuel efficient, less fun and more annoying to use.
> 
> We can't find every crash bug either, yet we still ship the kernel and
> people actually use it too.
> 
> What makes these security bugs so much more important than all the other
> ones?

The fact that we can do something about them.

-- 
All rights reversed.
