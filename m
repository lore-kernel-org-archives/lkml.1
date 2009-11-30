Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbZK3OFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbZK3OFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZK3OFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:05:14 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56544 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZK3OFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:05:13 -0500
Date: Mon, 30 Nov 2009 19:35:14 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091130140514.GD18879@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20091130120345.GA18879@linux.vnet.ibm.com> <1259582952.20516.209.camel@laptop> <20091130123257.GB18879@linux.vnet.ibm.com> <1259584907.20516.246.camel@laptop> <20091130131928.GC18879@linux.vnet.ibm.com> <1259588232.20516.307.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259588232.20516.307.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > I guess Christoph, Roland and Frank would be able to explain in a better
> > fashion the rational and advantages of this stub over convential gdb.
> 
> Hmm,. wouldn't it make much more sense to extend the current kgdb stub
> to include userspace debugging, providing an all-in-one solution?

I see two limitations but I guess there could be ways to get over it.
1. gdb requiring file that needs to be debugged. I always
thought it can either be a user program or a vmlinux file. gdb makes
most of the information(i.e registers) from the remote protocol to
display the backtrace, variable values and the like by reading this
file. 

2.  Also I am not sure if gdb has a way to tell the remote to switch the
context and provide information(registers) pertaining to the user mode/
kernel mode.

There could be other limitations too that I may not be aware.
> 
> I think it would be much more powerful to be able to observe the full
> software stack and not be limited by this user<->kernel barrier.
> 
> (Provided the user has sufficient privileges of course).

In this implementation, the current user can debug his/her own
processes. May be if we can debug both the context from same gdb then we
might have to place restrictions.. 

--
Thanks and Regards
Srikar
> 
