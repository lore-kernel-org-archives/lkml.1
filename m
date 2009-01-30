Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZA3M6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZA3M6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 07:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZA3M6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 07:58:22 -0500
Received: from brick.kernel.dk ([93.163.65.50]:18356 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbZA3M6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 07:58:22 -0500
Date: Fri, 30 Jan 2009 13:56:32 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -v3] use per cpu data for single cpu ipi calls
Message-ID: <20090130125632.GT30821@kernel.dk>
References: <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain> <1233253380.4495.123.camel@laptop> <alpine.LFD.2.00.0901291030510.3123@localhost.localdomain> <1233254680.4495.126.camel@laptop> <20090130112310.GI30821@kernel.dk> <1233318733.4495.174.camel@laptop> <20090130123858.GQ30821@kernel.dk> <1233319731.4495.177.camel@laptop> <20090130125540.GS30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130125540.GS30821@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30 2009, Jens Axboe wrote:
> Drop the .. and it should work. Don't ask me why :-)

On second thought, probably because XXX.. will mean from XXX to HEAD,
and HEAD doesn't include the edited part since it isn't committed.

-- 
Jens Axboe

