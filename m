Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZGCISE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZGCISE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZGCIRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:17:50 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:62634 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZGCIRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:17:49 -0400
Message-ID: <4A4DBE83.2020803@linux.vnet.ibm.com>
Date: Fri, 03 Jul 2009 10:17:07 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] gcov causes vread_tsc to increment kernel memory
References: <alpine.DEB.2.00.0907011245230.22887@gandalf.stny.rr.com> <4A4CA0D5.6010103@linux.vnet.ibm.com> <20090703071315.GE32687@elte.hu>
In-Reply-To: <20090703071315.GE32687@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> 
>> Also seeing as function tracer and gcov work on a similar basis 
>> and require similar files to be excluded from profiling, it would 
>> be nice if we wouldn't need to mark those files separately. [...]
> 
> One of the general things i pointed out during review is that 
> there's a fair amount of overlap between tracing/instrumentation and 
> the gcov support patches and now for a change Andrew has merged 
> incomplete stuff upstream prematurely ;-)

Yes there is overlap between ftrace and gcov and I will help in finding
and merging those bits, but as I also pointed out during review, there
are also fundamental differences.

By including the gcov infrastructure upstream now, we can incrementally
improve its integration with any similar mechanism _while_ people are
improving their test cases and identifying more bugs based on code
coverage measurements.


