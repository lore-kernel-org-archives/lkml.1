Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZA3NAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZA3NAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 08:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZA3NAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 08:00:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:45544 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbZA3NAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:00:35 -0500
Subject: Re: [PATCH -v3] use per cpu data for single cpu ipi calls
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20090130125632.GT30821@kernel.dk>
References: <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
	 <1233253380.4495.123.camel@laptop>
	 <alpine.LFD.2.00.0901291030510.3123@localhost.localdomain>
	 <1233254680.4495.126.camel@laptop> <20090130112310.GI30821@kernel.dk>
	 <1233318733.4495.174.camel@laptop> <20090130123858.GQ30821@kernel.dk>
	 <1233319731.4495.177.camel@laptop> <20090130125540.GS30821@kernel.dk>
	 <20090130125632.GT30821@kernel.dk>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 14:00:16 +0100
Message-Id: <1233320416.4495.178.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 13:56 +0100, Jens Axboe wrote:
> On Fri, Jan 30 2009, Jens Axboe wrote:
> > Drop the .. and it should work. Don't ask me why :-)
> 
> On second thought, probably because XXX.. will mean from XXX to HEAD,
> and HEAD doesn't include the edited part since it isn't committed.

Ah, I guess that makes some sense. Let me do a v4 :-)

