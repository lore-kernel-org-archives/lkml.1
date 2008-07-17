Return-Path: <linux-kernel-owner+w=401wt.eu-S1760399AbYGQSF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399AbYGQSF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbYGQSFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:05:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbYGQSFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:05:17 -0400
Message-ID: <487F89AE.9070007@redhat.com>
Date: Thu, 17 Jul 2008 14:04:30 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Rannaud <eric.rannaud@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: madvise(2) MADV_SEQUENTIAL behavior
References: <1216163022.3443.156.camel@zenigma>	<487E628A.3050207@redhat.com>	<1216252910.3443.247.camel@zenigma>	<200807171614.29594.nickpiggin@yahoo.com.au> <20080717102148.6bc52e94@cuia.bos.redhat.com>
In-Reply-To: <20080717102148.6bc52e94@cuia.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Thu, 17 Jul 2008 16:14:29 +1000
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>>> It might encourage user space applications to start using
>>> FADV_SEQUENTIAL or FADV_NOREUSE more often (as it would become
>>> worthwhile to do so), and if they do (especially cron jobs), the problem
>>> of the slow desktop in the morning would progressively solve itself.
>> The slow desktop in the morning should not happen even without such a
>> call, because the kernel should not throw out frequently used data (even
>> if it is not quite so recent) in favour of streaming data.
>>
>> OK, I figure it doesn't do such a good job now, which is sad, 
> 
> Do you have any tests in mind that we could use to decide
> whether the patch I posted Tuesday would do a decent job
> at protecting frequently used data from streaming data?
> 
> http://lkml.org/lkml/2008/7/15/465
> 

1) start up a memory-hogging Java app
2) run a full-system backup

If it works well, the Java app shouldn't slow down much.

-- Chris
