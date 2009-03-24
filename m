Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZCXVko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZCXVko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZCXVkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:40:25 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:45646
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755484AbZCXVkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:40:23 -0400
X-BigFish: VPS-25(zz1432R98dR1805Mzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <49C95334.5040106@am.sony.com>
Date: Tue, 24 Mar 2009 14:40:04 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere>
In-Reply-To: <20090324213618.GC5975@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2009 21:40:05.0894 (UTC) FILETIME=[18A99260:01C9ACC9]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Yes, ie:
> 
> _Before jumping to the function entry hook, you must save
> the arguments for the traced function on the stack.
> On x86, its eax, edx and ecx.
> On arm, it will be r0-r3.
> Then you have to transmit the address of the traced function
> (it's on r14) and it's parent (must rely on fp for that).
> Then you call the entry hook and restore the old scratch/arg
> registers.
> 
> 
> _ On return hook it's pretty the same, (saving the scratch
> registers, especially the return value which should be on r0
> and r1 if I'm not wrong).
> But you'll have to get the original return address from the
> return handler and then put it on pc.
> 
> Well it's a very naive listing, there are sometimes some problems.
> For example on x86-64, I had to save even some non-scratch registers
> before calling the return hook, I still don't know why.

Thanks - this is very helpful.  I'll send patches around when
I get something going. Hopefully in the next week or two.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

