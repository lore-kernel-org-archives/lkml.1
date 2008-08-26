Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYHZVNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYHZVNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYHZVN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:13:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:57793 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYHZVN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:13:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,273,1217833200"; 
   d="scan'208";a="432426170"
Message-ID: <48B471F7.1080907@linux.intel.com>
Date: Tue, 26 Aug 2008 23:13:27 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Len Brown <len.brown@intel.com>,
       Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/4] mutex: add mutex_lock_timeout()
References: <1219777186-4787-1-git-send-email-dwalker@mvista.com>	 <48B45A48.6080604@linux.intel.com> <1219780298.3797.24.camel@dhcp32.mvista.com>
In-Reply-To: <1219780298.3797.24.camel@dhcp32.mvista.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> However what you can do is to ask Len again when he's back. Ultimately
>> it is his decision and he might decide that he can deal with AML lockdep
>> issues longer term.
> 
> For instance these changes could go into linux-next until the 2.6.29
> merge window .. Len should be back by then, and we should have a much
> better idea what kind of problems may exist, if any..

Sorry I'm not convinced that linux-next testing can resolve that.
It doesn't really have enough hardware/tester coverage. Also linux-next
is really only for stuff that is going to be merged, and from
my current perspective it's not.

>> Don't think it makes all that much sense to resubmit the completion
>> patch though. It's unrelated to the other patches anyways (not sure
>> why you mix them together)
> 
> It's all related .. 

I don't think it is. You keep claiming that but it's just not true.
You have not so far brought up a single argument why the semaphores
should be changed to completions.

-Andi
