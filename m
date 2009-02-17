Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZBQRqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZBQRqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZBQRqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:46:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:57872 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZBQRqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:46:33 -0500
Subject: Re: [PATCH] generic-smp: remove kmalloc()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1234892420.4744.158.camel@laptop>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.433430761@chello.nl> <1234885258.4744.153.camel@laptop>
	 <20090217172113.GA26459@redhat.com>  <1234892420.4744.158.camel@laptop>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 18:46:04 +0100
Message-Id: <1234892764.4744.159.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 18:40 +0100, Peter Zijlstra wrote:

> > What do you think?
> 
> While I would say, don't do that to your deadlock scenario, I do like
> the extra freedom this provides, so I'm inclined to go with this. Let me
> spin a new patch and build a kernel with it ;-)

Should we do the same for the _single case? It too can copy the csd data
into the stack and return before calling func.

