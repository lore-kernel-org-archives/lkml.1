Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZCYVfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZCYVfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZCYVfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:35:07 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44864 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZCYVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:35:05 -0400
Message-ID: <49CAA384.60101@linux.vnet.ibm.com>
Date: Wed, 25 Mar 2009 14:35:00 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: record time running and
 time enabled for each counter
References: <18890.6578.728637.139402@cargo.ozlabs.ibm.com> <tip-03ced439c94d692363307eeb3abe0bbfa2d08a01@git.kernel.org>
In-Reply-To: <tip-03ced439c94d692363307eeb3abe0bbfa2d08a01@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul Mackerras wrote:
> Commit-ID:  03ced439c94d692363307eeb3abe0bbfa2d08a01
> Gitweb:     http://git.kernel.org/tip/03ced439c94d692363307eeb3abe0bbfa2d08a01
> Author:     Paul Mackerras <paulus@samba.org>
> AuthorDate: Wed, 25 Mar 2009 22:46:58 +1100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 25 Mar 2009 13:24:00 +0100
> 
> perf_counter: record time running and time enabled for each counter
[snip]
> These values can be supplied to userspace on a read from the counter.
> Userspace requests that they be supplied after the counter value by
> setting the PERF_FORMAT_TOTAL_TIME_ENABLED and/or
> PERF_FORMAT_TOTAL_TIME_RUNNING bits in the hw_event.read_format field
> when creating the counter.  (There is no way to change the read format
> after the counter is created, though it would be possible to add some
> way to do that.)

This change looks good to me, except:

How do I know which value comes first after the counter value if I have 
both PERF_FORMAT_TOTAL_TIME_ENABLED and PERF_FORMAT_TOTAL_TIME_RUNNING 
set?  Are they in the order of their enum values?  The order should be 
described somewhere.  Is there anything to keep a kernel code change 
from inadvertantly reversing the position of two values at some point in 
the future?

Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

