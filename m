Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbYDMU54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbYDMU54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYDMU5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:57:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYDMU5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:57:48 -0400
Message-ID: <480272BD.9010404@zytor.com>
Date: Sun, 13 Apr 2008 13:53:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Erik Bosman <ejbosman@cs.vu.nl>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add prctl commands PR_GET_TSC and PR_SET_TSC
References: <Pine.GSO.4.56.0804111850060.16609@keg.few.vu.nl>	<87r6daw2ay.fsf@basil.nowhere.org>	<Pine.GSO.4.56.0804131126080.28138@keg.few.vu.nl> <87prstwvkr.fsf@basil.nowhere.org> <48025F1B.10701@zytor.com> <48027225.6000609@firstfloor.org>
In-Reply-To: <48027225.6000609@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I think what Erik is trying to do is to make it possible to disable as
>> many of these in the kernel as possible; I/O is easy, it's off by
>> default; RDTSC and RDPMC can be disabled in the kernel, and I think
>> even XSTORE can be disabled.
> 
> I'm a little sceptical it will work reliably, but we'll see.
> 
> There's also LSL (forgot that earlier). It is used by the vgetcpu()
> because it's faster than CPUID or RDTSCP. Kernel
> sets a magic segment up which has different limits for different CPUs.
> 

Yeah, that's unlikely to be found in code that isn't actively looking 
for it, though.

	-hpa
