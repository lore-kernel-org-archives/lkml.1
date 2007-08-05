Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbXHEWhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbXHEWhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 18:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbXHEWhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 18:37:04 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:52282 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbXHEWhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 18:37:02 -0400
Subject: Re: [BUG RT] WARNING: at kernel/sched.c:5071 2.6.23-rc1-rt7
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <20070805065646.GA515@elte.hu>
References: <1186290816.636.14.camel@localhost.localdomain>
	 <20070805065646.GA515@elte.hu>
Content-Type: text/plain
Date: Sun, 05 Aug 2007 18:36:46 -0400
Message-Id: <1186353406.13885.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-05 at 08:56 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> > P.S. I really found out that the system becomes VERY non-responsive 
> > when you run with both hard and softirqs as threads, but with 
> > PREEMPT_NONE ;-)
> 
> hm. That's not supposed to happen. Could there be some wakeup or softirq 
> processing problem?
> 
> 	Ingo

Well, it happened right after I installed the ath driver (from
http://svn.madwifi.org/trunk ).  But I've recompiled my system with
PREEMPT_RT and it works fine now.  I can investigate it later, but I
currently need this system working with a PREEMPT_RT kernel.

-- Steve


