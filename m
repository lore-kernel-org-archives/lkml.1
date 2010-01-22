Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158Ab0AVHeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab0AVHeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 02:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048Ab0AVHeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 02:34:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51296 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab0AVHen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 02:34:43 -0500
Message-ID: <4B5954C6.6010102@zytor.com>
Date: Thu, 21 Jan 2010 23:33:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Haicheng Li <haicheng.li@linux.intel.com>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/srat_64.c: make node_possible_map include hotpluggable
 node
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com> <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com> <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com> <4B57C2DD.3050402@linux.intel.com> <alpine.DEB.2.00.1001202252320.22343@chino.kir.corp.google.com> <4B5802EF.6040603@linux.intel.com> <alpine.DEB.2.00.1001202344580.29982@chino.kir.corp.google.com> <4B581160.2090209@linux.intel.com> <alpine.DEB.2.00.1001211500290.31073@chino.kir.corp.google.com> <4B592437.9060508@linux.intel.com>
In-Reply-To: <4B592437.9060508@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 08:06 PM, Haicheng Li wrote:
> David Rientjes wrote:
>> You've already tested my patch that this thread was restarted with and it
>> works, so let's fix the bug.  Then, later, you can rename
> cpu_nodes_parsed
>> to no_mems_nodes, which I'd agree with.  You may even try to seperate the
>> hotpluggable nodes out into their own nodemask, but I trust that the x86
>> maintainers will be looking for some rationale behind that other than "it
>> may one day be useful."
> 
> David, you are misleading people to fix the BUG with a logically
> problematic patch. I don't want such fixing to possibly bother other
> people someday, please let's avoid it in review stage.
> 
>> getting _very_ late in the 2.6.33 release cycle.  Do you expect Ingo to
>> push your fix to Linus with the rationale that "maybe someday we'll use
>> this new nodemask even though it may be rc5 and nobody knows what we'd
>> ever use it for"?  Is that appropriate for -stable candidates as well?
> 
> Don't speak for any other people. Let maintainers themselves decide if
> my patch is ugly or acceptable. I don't want to argue with you anymore
> if you cannot find any true problem from my recent patch.
> 
> Below is my updated patch (in fact, it's v2 for the patch I sent out for
> review in http://lkml.org/lkml/2010/1/15/9).
> 

Okay... please calm down.  I just read through this thread from the top,
and had missed the fact that it had gotten so tense.

I have to say I agree with David Rientjes that we need the minimal patch
for upstream and stable.  If you need the additional bitmask in the
future it should be added later.

Haicheng, would you be willing to prepare a minimal patch so we can
close the issue in the release trees as quickly as possible?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

