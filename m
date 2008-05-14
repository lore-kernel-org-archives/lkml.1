Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbYENVU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbYENVU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYENVUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:20:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYENVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:20:46 -0400
Message-ID: <482B56B9.8040703@zytor.com>
Date: Wed, 14 May 2008 14:16:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
References: <20080514174955.GA515@elte.hu>	<87fxsk7n7e.fsf@basil.nowhere.org> <20080514220034.51eae9e0@core> <482B5614.3060203@firstfloor.org>
In-Reply-To: <482B5614.3060203@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Alan Cox wrote:
>>> Most of the legacy users are unlikely to be latency problems,
>>> simply because only very few people (or nobody) still has that hardware
>>> and the code will never run.
>>>
>>> Also I wouldn't lose sleep over e.g. let ISDN continue using BKL forever.
>> Most 
> 
> Most?
> 
>> of the legacy users inflict that locking on other code - eg the ISN
>> use of the BKL directly impacts on the tty layer work.
> 
> So you just stick unlock_kernel()/lock_kernel() around the call
> to TTY (or similar to the entry points)
> 

... assuming that the ISDN code doesn't assume lock continuity across 
the TTY call.

	-hpa
