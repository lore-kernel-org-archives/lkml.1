Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYFRQQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYFRQQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYFRQQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:16:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYFRQQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:16:25 -0400
Date: Wed, 18 Jun 2008 12:16:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi-suse@firstfloor.org>,
       Clark Williams <clark.williams@gmail.com>,
       Marin Mitov <mitov@issp.bas.bg>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
In-Reply-To: <200806182242.49245.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.58.0806181215120.29622@gandalf.stny.rr.com>
References: <200805252108.25011.mitov@issp.bas.bg> <1213791416.16944.222.camel@twins>
 <4858C68C.BA47.005A.0@novell.com> <200806182242.49245.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jun 2008, Nick Piggin wrote:

> There are _some_ cases where it can be used, but nobody has been
> able to come up with compelling uses really. I don't think this
> case is helped very much either because the logic in there using
> preempt-disable is fine, isn't it?
>
> Except that it should also have a cond_resched in it. Seems like
> an ideal place to put cond_resched because it is not a fastpath.
>

Does it really need a cond_resched? preempt_enable when it goes to zero
will already check to see if it should schedule.

-- Steve

