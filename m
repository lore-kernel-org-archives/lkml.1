Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535Ab0AWBgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab0AWBgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 20:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944Ab0AWBgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 20:36:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59264
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248Ab0AWBgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 20:36:10 -0500
Date: Fri, 22 Jan 2010 17:36:18 -0800 (PST)
Message-Id: <20100122.173618.90816303.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: vapier@gentoo.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       mingo@redhat.com, brueckner@linux.vnet.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org
Subject: Re: [PATCH] ftrace: unify arch_syscall_addr() implementations
From: David Miller <davem@davemloft.net>
In-Reply-To: <1264170977.31321.382.camel@gandalf.stny.rr.com>
References: <1264167826-20913-1-git-send-email-vapier@gentoo.org>
	<1264170977.31321.382.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 22 Jan 2010 09:36:17 -0500

> [ Added Heiko Carstens and Paul Mundt to Cc ]
> 
> On Fri, 2010-01-22 at 08:43 -0500, Mike Frysinger wrote:
>> also, does the arch_syscall_addr() even really need to be weak ?  or can
>> we assume that everyone is going to be sane and do it the same way ...
>> 
>>  Documentation/trace/ftrace-design.txt |    6 +++++-
>>  arch/s390/kernel/ftrace.c             |   10 ----------
>>  arch/sh/kernel/ftrace.c               |    9 ---------
>>  arch/sparc/kernel/ftrace.c            |   11 -----------
>>  arch/x86/kernel/ftrace.c              |   10 ----------
>>  include/linux/ftrace.h                |    6 ++++++
>>  kernel/trace/trace_syscalls.c         |    6 +++++
> 
> Actually for this patch to be accepted, we need to get the acks from the
> maintainers of s390, sh, and sparc since it touches their code. Doesn't
> matter if it is just removing duplicate code. Still need their acks.

Acked-by: David S. Miller <davem@davemloft.net>
