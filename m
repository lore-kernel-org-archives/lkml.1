Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZBTB2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZBTB2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZBTB1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:27:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:45818 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbZBTB1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:27:51 -0500
Message-ID: <499E070E.3090304@kernel.org>
Date: Fri, 20 Feb 2009 10:27:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH 08/10] vmalloc: add un/map_kernel_range_noflush()
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-9-git-send-email-tj@kernel.org> <200902192317.28696.nickpiggin@yahoo.com.au>
In-Reply-To: <200902192317.28696.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Feb 2009 01:27:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wednesday 18 February 2009 23:04:34 Tejun Heo wrote:
>> Impact: two more public map/unmap functions
>>
>> Implement map_kernel_range_noflush() and unmap_kernel_range_noflush().
>> These functions respectively map and unmap address range in kernel VM
>> area but doesn't do any vcache or tlb flushing.  These will be used by
>> new percpu allocator.
> 
> Hmm... I have no real issues with this, although the caller is going
> to have to be very careful not to introduce bugs (which I'm sure you
> were ;)).
> 
> Maybe can you add comments specifying the minimum of which flushes
> are required and when, to scare people away from using them?

Yeap, will add comments.

Thanks.

-- 
tejun
