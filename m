Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZCCR3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZCCR3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 12:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZCCR3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 12:29:45 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52570 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbZCCR3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 12:29:45 -0500
Message-ID: <49AD6904.6060903@us.ibm.com>
Date: Tue, 03 Mar 2009 09:29:40 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "lkml," <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [TIP][RFC 3/7] futex: futex_lock_pi_atomic()
References: <49AC73A9.4040804@us.ibm.com>  <49AC761C.907@us.ibm.com> <1236085438.5330.4336.camel@laptop>
In-Reply-To: <1236085438.5330.4336.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

Hi Peter,

Thanks for taking a look.

> On Mon, 2009-03-02 at 16:13 -0800, Darren Hart wrote:
>> + * Returns:
>> + * - 0 on success (futex_q is setup and FUTEX_WAITERS bit is set on the futex)
>> + * - 1 on a successful atomic acquisition of the lock
>> + * - A negative error code on failure
> 
> That utterly confused me for a while.

Sorry about that, guess my doc-fu needs some work.

> 
> Maybe something like:
> 
>  0 - ready to wait
>  1 - acquired the lock
> 
>  <0 - error

Sure thing, I've updated the patch and my git tree:

http://git.kernel.org/?p=linux/kernel/git/dvhart/linux-2.6-tip-hacks.git;a=shortlog;h=requeue-pi-dev

Note, this is a development branch and I continuously update it, 
replacing patches, etc.


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
