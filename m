Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZBQAl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZBQAl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 19:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZBQAlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 19:41:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbZBQAlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 19:41:50 -0500
Date: Mon, 16 Feb 2009 16:40:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
In-Reply-To: <20090216164114.521787803@chello.nl>
Message-ID: <alpine.LFD.2.00.0902161636480.21686@localhost.localdomain>
References: <20090216163847.431174825@chello.nl> <20090216164114.521787803@chello.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Feb 2009, Peter Zijlstra wrote:
>
> Now that there is no strict need for kmalloc anymore, and nobody seems to
> rely it for the queueing behaviour, remove it.

Peter, I really hate this series.

Why?

In 1/4 you introduce that cfd RCU thing, and then in 2/4 you remove it 
again.

I realize that you seem to do that in order to do some incremental 
step-wise changes, but quite frankly, it just complicates the whole series 
and makes the patches much harder to read and follow.

Why don't you just combine patches 1&2? That split-up seems to just 
confuse things. At least it confuses me. Why does it happen?

		Linus
