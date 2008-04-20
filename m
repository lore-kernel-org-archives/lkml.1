Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbYDTCgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbYDTCgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 22:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYDTCgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 22:36:18 -0400
Received: from sandeen.net ([209.173.210.139]:13152 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbYDTCgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 22:36:17 -0400
Message-ID: <480AAC20.4050604@sandeen.net>
Date: Sat, 19 Apr 2008 21:36:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org>	<20080418142934.38ce6bf4.akpm@linux-foundation.org>	<20080419142329.GA5339@elte.hu>	<20080419145948.GA4528@lintop> <20080419110034.34b70bd5@laptopd505.fenrus.org>
In-Reply-To: <20080419110034.34b70bd5@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

> On the flipside the arguments tend to be
> 1) certain stackings of components still runs the risk of overflowing
> 2) I want to run ndiswrapper
> 3) general, unspecified uneasyness.
> 
> For 1), we need to know which they are, and then solve them, because even on x86-64 with 8k stacks
> they can be a problem (just because the stack frames are bigger, although not quite double, there).

Except, apparently, not, at least in my experience.

Ask the xfs guys if they see stack overflows on x86_64, or on x86.

I've personally never seen common stack problems with xfs on x86_64, but
it's very common on x86.  I don't have a great answer for why, but
that's my anecdotal evidence.

> I've not seen any recent reports, I'll try to extend the kerneloops.org client to collect the
> "stack is getting low" warning to be able to see how much this really happens.

That sounds like a very good thing to collect, and maybe if I re-send a
"clearly state stack overflows at oops time" patch you can easily keep tabs.

Thanks,

-Eric
