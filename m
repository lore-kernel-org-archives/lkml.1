Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZLKOBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZLKOBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZLKOB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:01:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZLKOB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:01:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091210004703.308396881@linutronix.de>
References: <20091210004703.308396881@linutronix.de> <20091210001308.247025548@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Vegard Nossum <vegardno@ifi.uio.no>
Subject: Re: [patch 8/9] Documentation: Fix invalid rcu assumptions
Date: Fri, 11 Dec 2009 14:00:24 +0000
Message-ID: <13688.1260540024@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> -197          * we use RCU protection here
> +196          * caller must be holding the RCU readlocke

You mean "readlock" I suspect.

Otherwise, feel free to add:

Acked-by: David Howells <dhowells@redhat.com>
