Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbYBJJVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbYBJJVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYBJJUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:20:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50404 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbYBJJUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:20:44 -0500
Date: Sun, 10 Feb 2008 10:20:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210092023.GA18451@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu> <20080210082132.GA9878@elte.hu> <20080210082624.GB10479@infradead.org> <20080210090817.GA15409@elte.hu> <20080210091757.GA17341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210091757.GA17341@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Anyway, to resolve this i've turning them into non-docbook, 
> > descriptive comments. Please submit any docbook patch to 
> > arch/x86/kernel/kgdb.c to x86.git if you'd like more documentation. 
> 
> no need for that btw, i just added the docbook entries to 
> arch/x86/kernel/kgdb.c myself and fixed all of kgdb.h. Tree is at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git
> 
> tip 2e3ebf25b0bd8646e517806073e1991be1fec8a2. Shortlog, diffstat and 
> the full patch can be found below, with all relevant review feedback 
> addressed. Builds, boots and works fine on x86.

here's gdb test-output from this 2e3ebf25b0bd kernel:

(gdb) target remote /dev/ttyS0
Remote debugging using /dev/ttyS0
0x00000046 in ?? ()
(gdb) i r
eax            0x11     17
ecx            0x0      0
edx            0xf4f4   62708
ebx            0x0      0
esp            0x80d09400       0x80d09400
ebp            0xfffe37a7       0xfffe37a7
esi            0x809162d0       -2137955632
edi            0xffffffff       -1
eip            0x46     0x46
eflags         0x0      [ ]
cs             0x80d093e4       -2133814300
ss             0xffffffff       -1
ds             0x3fa6fe18       1067908632
es             0xffff8100       -32512
fs             0x3fa6fe18       1067908632
gs             0xffff8100       -32512
(gdb)

	Ingo
