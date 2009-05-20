Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZETAnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZETAnC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 20:43:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZETAmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 20:42:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57460 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbZETAmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 20:42:53 -0400
Date: Tue, 19 May 2009 20:42:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
In-Reply-To: <20090520003314.GA8790@Krystal>
Message-ID: <alpine.DEB.2.00.0905192041150.7816@gandalf.stny.rr.com>
References: <cover.1242763826.git.jbaron@redhat.com> <20090519211704.GA3325@Krystal> <alpine.DEB.2.00.0905191826031.7816@gandalf.stny.rr.com> <20090520003314.GA8790@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 19 May 2009, Mathieu Desnoyers wrote:
> 
> Given the tradeoff is taste vs overhead, what do you think of the
> following proposal ?
> 
> trace(block_bio_complete, md->queue, bio);

I'm fine with this. It is extremely important that the trace point 
overhead is negligible when disabled. Otherwise, they serve no purpose.

-- Steve
