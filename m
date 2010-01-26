Return-Path: <linux-kernel-owner+w=401wt.eu-S1752200Ab0AZDEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab0AZDEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514Ab0AZDED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:04:03 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36202 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab0AZDEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:04:01 -0500
Date: Tue, 26 Jan 2010 12:03:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] ftrace: unify arch_syscall_addr() implementations
Message-ID: <20100126030338.GC2739@linux-sh.org>
References: <1264167826-20913-1-git-send-email-vapier@gentoo.org> <1264170977.31321.382.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264170977.31321.382.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 09:36:17AM -0500, Steven Rostedt wrote:
> [ Added Heiko Carstens and Paul Mundt to Cc ]
> 
> On Fri, 2010-01-22 at 08:43 -0500, Mike Frysinger wrote:
> > also, does the arch_syscall_addr() even really need to be weak ?  or can
> > we assume that everyone is going to be sane and do it the same way ...
> > 
> >  Documentation/trace/ftrace-design.txt |    6 +++++-
> >  arch/s390/kernel/ftrace.c             |   10 ----------
> >  arch/sh/kernel/ftrace.c               |    9 ---------
> >  arch/sparc/kernel/ftrace.c            |   11 -----------
> >  arch/x86/kernel/ftrace.c              |   10 ----------
> >  include/linux/ftrace.h                |    6 ++++++
> >  kernel/trace/trace_syscalls.c         |    6 +++++
> 
> Actually for this patch to be accepted, we need to get the acks from the
> maintainers of s390, sh, and sparc since it touches their code. Doesn't
> matter if it is just removing duplicate code. Still need their acks.
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
