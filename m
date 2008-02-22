Return-Path: <linux-kernel-owner+w=401wt.eu-S935203AbYBVNqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203AbYBVNqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763021AbYBVNqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:46:23 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:61473 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762485AbYBVNqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:46:22 -0500
Date: Fri, 22 Feb 2008 08:46:16 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: gregory.haskins@gmail.com, Gregory Haskins <ghaskins@novell.com>,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       bill.huey@gmail.com, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 05/14] rearrange rt_spin_lock sleep
In-Reply-To: <20080222133541.GA8868@elte.hu>
Message-ID: <Pine.LNX.4.58.0802220845060.15391@gandalf.stny.rr.com>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
 <20080221152651.4804.4702.stgit@novell1.haskins.net> <47BECE30.8030100@gmail.com>
 <20080222133541.GA8868@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gregory,

I guess we should have just read Documentation/memory-barriers.text

Here's the snippet:


Any atomic operation that modifies some state in memory and returns
information
about the state (old or new) implies an SMP-conditional general memory
barrier
(smp_mb()) on each side of the actual operation (with the exception of
explicit lock operations, described later).  These include:

        xchg();
        cmpxchg();
        atomic_cmpxchg();
        atomic_inc_return();
        atomic_dec_return();
        atomic_add_return();
        atomic_sub_return();
        atomic_inc_and_test();
        atomic_dec_and_test();
        atomic_sub_and_test();
        atomic_add_negative();
        atomic_add_unless();
        test_and_set_bit();
        test_and_clear_bit();
        test_and_change_bit();


-- Steve

