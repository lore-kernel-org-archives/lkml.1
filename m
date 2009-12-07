Return-Path: <linux-kernel-owner+w=401wt.eu-S965126AbZLGWfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965126AbZLGWfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934673AbZLGWf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:35:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44766 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934519AbZLGWf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:35:27 -0500
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: paulmck@linux.vnet.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [rfc] "fair" rw spinlocks
From: Andi Kleen <andi@firstfloor.org>
References: <20091130100041.GA29610@infradead.org>
	<alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>
	<20091130174638.GA9782@elte.hu>
	<alpine.LFD.2.00.0911302206370.24119@localhost.localdomain>
	<1259616429.26472.499.camel@laptop>
	<alpine.LFD.2.00.0911302300550.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301409560.2872@localhost.localdomain>
	<alpine.LFD.2.00.0911302328350.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301443110.2872@localhost.localdomain>
	<m1y6lg7q3n.fsf@fess.ebiederm.org>
	<20091207181816.GF6808@linux.vnet.ibm.com>
	<m1ocma1kz6.fsf@fess.ebiederm.org>
Date: Mon, 07 Dec 2009 23:35:28 +0100
In-Reply-To: <m1ocma1kz6.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Mon, 07 Dec 2009 14:24:13 -0800")
Message-ID: <87ws0y76q7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>>
>> Is it required that all of the processes see the signal before the
>> corresponding interrupt handler returns?  (My guess is "no", which
>> enables a trick or two, but thought I should ask.)
>
> Not that I recall.  I think it is just an I/O completed signal.

Wasn't there the sysrq SAK too? That one definitely would need
to be careful about synchronicity.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
