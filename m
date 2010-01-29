Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937Ab0A2SPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0A2SPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502Ab0A2SPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:15:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab0A2SPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:15:23 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tom Tromey <tromey@redhat.com>, Kyle Moffett <kyle@moffetthome.net>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
References: <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
	<m33a1tnbd9.fsf@fleche.redhat.com>
	<alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
	<m3636oh2rt.fsf@fleche.redhat.com>
	<alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
	<1264575134.4283.1983.camel@laptop> <20100127085442.GA28422@elte.hu>
	<1264643539.5068.62.camel@localhost.localdomain>
	<20100128085502.GA7713@elte.hu>
	<1264726768.4933.50.camel@localhost.localdomain>
	<20100129073907.GF14636@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 29 Jan 2010 13:13:47 -0500
In-Reply-To: <20100129073907.GF14636@elte.hu> (Ingo Molnar's message of "Fri, 29 Jan 2010 08:39:07 +0100")
Message-ID: <y0mr5p893tw.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> [...] So, to sum it up: utrace XOL, which is rather complex already,
> needs even more complexity (which is not yet implemented) than the
> much simpler common-case emulator approach i outlined, just to break
> even with the performance of the much simpler approach. [...]

Is it an uncontroversial claim that emulation of CISC instructions
should perform better than their native execution, followed by an int3
(as in the simplest working scheme) or boosting (as done by kprobes)?
>From my experience with simulators, "simple" software emulation of
cpus can be hundreds of times slower or worse than native execution.

- FChE
