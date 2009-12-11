Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbZLKNxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbZLKNxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758244AbZLKNxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:53:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855AbZLKNxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:53:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091210004703.187264393@linutronix.de>
References: <20091210004703.187264393@linutronix.de> <20091210001308.247025548@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [patch 5/9] security: Use get_task_cred() in keyctl_session_to_parent()
Date: Fri, 11 Dec 2009 13:52:43 +0000
Message-ID: <13415.1260539563@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> Strictly this is not necessary today, but according to Paul McKenney
> it's not guaranteed that irq disabled regions will prevent RCU
> progress. That's a property of the current implementation. In
> preempt-rt this assumption is not true anymore.
> 
> Use get_task_cred() to make this future proof.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David Howells <dhowells@redhat.com>
