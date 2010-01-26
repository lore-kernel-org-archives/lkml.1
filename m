Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535Ab0AZXVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0AZXVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177Ab0AZXV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:21:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab0AZXV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:21:28 -0500
From: Tom Tromey <tromey@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle Moffett <kyle@moffetthome.net>, "Frank Ch. Eigler" <fche@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
References: <20100121013822.28781960.sfr@canb.auug.org.au>
	<20100122005147.GD22003@redhat.com>
	<20100121170541.7425ff10.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
	<20100122182827.GA13185@redhat.com>
	<20100122200129.GG22003@redhat.com>
	<alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
	<20100122221348.GA4263@redhat.com>
	<alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
	<alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	<f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	<alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
	<m33a1tnbd9.fsf@fleche.redhat.com>
	<alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
Reply-To: Tom Tromey <tromey@redhat.com>
X-Attribution: Tom
Date: Tue, 26 Jan 2010 16:20:22 -0700
In-Reply-To: <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain> (Linus
	Torvalds's message of "Mon, 25 Jan 2010 13:41:57 -0800 (PST)")
Message-ID: <m3636oh2rt.fsf@fleche.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:

Tom> * Support "displaced stepping" in the kernel; I think this would improve
Tom> performance when debugging in non-stop mode.

Linus> Don't we already do that at least on x86?

I don't know.  If it does, and gdb does not yet use that, then that
would be worth changing.

Linus> Or maybe I'm not understanding what displaced stepping means to you.

In non-stop mode (where you can stop one thread but leave the others
running), gdb wants to have the breakpoints always inserted.  So,
something must emulate the displaced instruction.

Tom
