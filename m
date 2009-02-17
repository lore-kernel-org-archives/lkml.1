Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZBQWQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZBQWQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZBQWQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:16:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39651 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbZBQWQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:16:04 -0500
Subject: Re: [PATCH -v4] generic-ipi: remove kmalloc()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090217220925.GB13189@redhat.com>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.433430761@chello.nl> <1234885258.4744.153.camel@laptop>
	 <20090217172113.GA26459@redhat.com> <1234892420.4744.158.camel@laptop>
	 <1234898958.4744.225.camel@laptop> <20090217200247.GA8158@redhat.com>
	 <1234901512.4744.230.camel@laptop> <1234901777.4744.233.camel@laptop>
	 <1234903781.4744.235.camel@laptop>  <20090217220925.GB13189@redhat.com>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 23:15:25 +0100
Message-Id: <1234908925.4744.242.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 23:09 +0100, Oleg Nesterov wrote:

> I guess you should re-send your previous patch in any case,

Just send -v5 with 3 patches that form a full series against -tip.

> 		} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
> 	-               struct call_single_data *data;
> 	+               struct call_single_data *data = {
> 	+                       .flags = 0,
> 	+               };
> 
> this looks a bit suspicious ;)

Hehe, yes, I lost a refresh thereabouts. Should be fixed in the latest.

