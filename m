Return-Path: <linux-kernel-owner+w=401wt.eu-S932170Ab0A1X4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab0A1X4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694Ab0A1X4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:56:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:44747 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab0A1X4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:56:40 -0500
Subject: Re: linux-next: add utrace tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle Moffett <kyle@moffetthome.net>, tytso@mit.edu,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>
References: <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
	 <20100122200129.GG22003@redhat.com>
	 <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
	 <20100122221348.GA4263@redhat.com>
	 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
	 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	 <20100123112333.GA15455@elte.hu> <20100123114729.GA7828@redhat.com>
	 <20100123194820.GM21263@thunk.org>
	 <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com>
	 <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 10:53:06 +1100
Message-ID: <1264722786.20211.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 08:52 -0800, Linus Torvalds wrote:
> 
> That said, I also suspect that people should still look seriously at 
> simply just improving ptrace. For example, I suspect that the biggest 
> problem with ptrace is really just the signalling, and that creating a
> new 
> extension for JUST THAT, and then having a model where you can choose
> - at 
> PTRACE_ATTACH time - how to wait for events would be a good thing.

like returning a fd to poll() on ? :-)

Cheers,
Ben.


