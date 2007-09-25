Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXIYNJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXIYNJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 09:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXIYNJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 09:09:36 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:37458 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbXIYNJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 09:09:35 -0400
Message-ID: <46F90827.2060203@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2007 18:37:51 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <46F7B7FD.1000905@linux.vnet.ibm.com> <20070924094448.d08cf3a6.akpm@linux-foundation.org> <20070924185737.717b2650@twins> <46F7EEF3.7080902@linux.vnet.ibm.com> <20070924212058.76017e47@lappy> <20070925130544.3d74d04d@twins>
In-Reply-To: <20070925130544.3d74d04d@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 24 Sep 2007 21:20:58 +0200 Peter Zijlstra
> <a.p.zijlstra@chello.nl> wrote:
> 
>>>> Nope, and the stacktrace is utterly puzzling.
>>>>
>>>> /me goes read the lkml.org link
>>>>
>>>> Kamalesh Babulal: do you still get:
>>>>   BUG: spinlock bad magic on
>>>>
>>>> msgs?
>>>>
>>>> Because those I could reproduce using fsx, and I fixed all that.
>>> Hi Peter,
>>>
>>> I do not get BUG: spinlock bad magic messages any more, but the softlock message is
>>> thrown more than 30 time, while running the ltp runall.
>> It would be good to know what function on_each_cpu is executing, could
>> you try something like:
> 
> I've just completed 2 full ltp runs on a dual-core opteron machine but
> could not reproduce this problem.
> 
> Kamalesh, would it be possible for you to reproduce with that patch, so
> we can see what function is holding up the cpu?

Hi Peter,

After running the test with the patch you provided, i observed an oops message
which was at the top of the these soft lockup message and the oops is the same as 
the oops reported at http://lkml.org/lkml/2007/9/24/107.

And when i applied the patch for the oops proposed at 
http://lkml.org/lkml/2007/9/25/57 the oops as well as the soft lockup's are not seen.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
