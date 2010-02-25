Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab0BYSJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:09:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54968 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195Ab0BYSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:08:59 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=CnwW8vW4s0VK1dusUhsA:9 a=_eVUYWHN81EhtQgdjae6_49AZrYA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC patch] introduce sys_membarrier(): process-wide memory
 barrier (v9)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nick Piggin <npiggin@suse.de>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
In-Reply-To: <20100225175121.GA6658@Krystal>
References: <20100212224606.GA30280@Krystal> <4B82CF1A.3010501@nortel.com>
	 <20100222212321.GA2573@Krystal> <20100224091052.GY9738@laptop>
	 <20100224152251.GA16295@Krystal> <20100225053310.GA9738@laptop>
	 <20100225165301.GF24052@Krystal>
	 <1267118726.6328.20.camel@gandalf.stny.rr.com>
	 <20100225175121.GA6658@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Feb 2010 13:08:51 -0500
Message-ID: <1267121331.6328.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 12:51 -0500, Mathieu Desnoyers wrote:

> But... either way we chose, we can extend the system call flags and parameters
> as needed, so I think it really should not be part of this initial
> implementation.

I agree here too.

If you have two different tasks doing lockless RCU or what not on shared
memory, it's best to stick with the mb() on the reader side. Yeah, it
makes the performance go down, but heck, I'm really worried about the
crazy complexity that wound need to go into the kernel to prevent this.

-- Steve


