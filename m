Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbZCLPJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbZCLPJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbZCLPJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:09:21 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36472 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbZCLPJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:09:21 -0400
Message-ID: <49B9259B.4030308@us.ibm.com>
Date: Thu, 12 Mar 2009 08:09:15 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 6/6] futex: cleanup fault logic
References: <20090312075349.9856.83687.stgit@Aeon> <20090312075612.9856.48612.stgit@Aeon> <1236852922.5090.121.camel@laptop>
In-Reply-To: <1236852922.5090.121.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-03-12 at 00:56 -0700, Darren Hart wrote:
>> Older versions of the futex code held the mmap_sem which had to be
>> dropped in order to call get_user(), so a two-pronged fault handling
>> mechanism was employed to handle faults of the atomic operations.  The
>> mmap_sem is no longer held, so get_user() should be adequate.  This patch
>> greatly simplifies the logic and improves legibility.
> 
> Thanks!

And I should have added a credit to Peter to helping me untangle it all 
and decide how to proceed with this patch.  Thanks Peter.


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
