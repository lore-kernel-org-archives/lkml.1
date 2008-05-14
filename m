Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYENVOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYENVOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYENVOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:14:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33184 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYENVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:14:01 -0400
Message-ID: <482B5614.3060203@firstfloor.org>
Date: Wed, 14 May 2008 23:13:56 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
References: <20080514174955.GA515@elte.hu>	<87fxsk7n7e.fsf@basil.nowhere.org> <20080514220034.51eae9e0@core>
In-Reply-To: <20080514220034.51eae9e0@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Most of the legacy users are unlikely to be latency problems,
>> simply because only very few people (or nobody) still has that hardware
>> and the code will never run.
>>
>> Also I wouldn't lose sleep over e.g. let ISDN continue using BKL forever.
> 
> Most 

Most?

>of the legacy users inflict that locking on other code - eg the ISN
> use of the BKL directly impacts on the tty layer work.

So you just stick unlock_kernel()/lock_kernel() around the call
to TTY (or similar to the entry points)

-Andi




