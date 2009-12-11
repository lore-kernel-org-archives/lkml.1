Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZLKNkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZLKNkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbZLKNkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:40:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809AbZLKNkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:40:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091210001308.247025548@linutronix.de>
References: <20091210001308.247025548@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/9] Fix various __task_cred related invalid RCU assumptions
Date: Fri, 11 Dec 2009 13:39:06 +0000
Message-ID: <13056.1260538746@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> While auditing the read_lock(&tasklist_lock) sites for a possible
> conversion to rcu-read_lock() I stumbled over an unprotected user of
> __task_cred in kernel/sys.c

I'm sure last time I looked, spinlock primitives implied RCU read locks.
Maybe I was mistaken or maybe it's changed.  Whatever, good catch, Thomas!

Thanks,
David
