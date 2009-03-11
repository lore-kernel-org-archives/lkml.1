Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZCKGEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZCKGEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 02:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZCKGDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 02:03:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:58997 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbZCKGDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 02:03:51 -0400
Message-ID: <49B75425.1050804@kernel.org>
Date: Wed, 11 Mar 2009 15:03:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, lethal@linux-sh.org,
       rmk@arm.linux.org.uk, starvik@axis.com, ralf@linux-mips.org,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090310.035915.149277356.davem@davemloft.net>
In-Reply-To: <20090310.035915.149277356.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Mar 2009 06:02:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

David Miller wrote:
> The one thing sparc64 does is calculate the base of the per-cpu
> area using a base (contained in a fixed global register) a shift.
> 
>>From arch/sparc/include/asm/percpu_64.h
> 
> register unsigned long __local_per_cpu_offset asm("g5");
> extern unsigned long __per_cpu_base;
> extern unsigned long __per_cpu_shift;
> #define __per_cpu_offset(__cpu) \
> 	(__per_cpu_base + ((unsigned long)(__cpu) << __per_cpu_shift))
> #define per_cpu_offset(x) (__per_cpu_offset(x))
> #define __my_cpu_offset __local_per_cpu_offset
> 
> I hope this won't cause problems for what you're trying to accomplish.

It won't at all.  I'll be converting the remaining three once the
default conversion is settled and I'm getting my very first sun
workstation this weekend, so no worries.  :-)

Thanks.

-- 
tejun
