Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0BXRaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 12:30:17 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:37720 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273Ab0BXRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:30:13 -0500
Message-ID: <4B85620A.7000901@us.ibm.com>
Date: Wed, 24 Feb 2010 09:29:46 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [RFC patch] introduce sys_membarrier(): process-wide memory barrier
 (v9)
References: <20100212224606.GA30280@Krystal> <4B82CF1A.3010501@nortel.com> <20100222212321.GA2573@Krystal> <20100224091052.GY9738@laptop>
In-Reply-To: <20100224091052.GY9738@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> When writing multiprocessor scalable software, threads should often be
> avoided. They share so much state that it is easy to run into
> scalability issues in the kernel. So yes it would be really nice to
> have userspace RCU available in a process-shared mode.

A bit off topic, but I'm interested in what you feel some of these 
scalability issues are. Is it mostly bouncing this shared context from 
one CPU to the next and the related cache effects, or is there something 
more you are referring to?

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
