Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYBJRCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYBJRCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYBJRCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:02:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbYBJRCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:02:36 -0500
Date: Sun, 10 Feb 2008 18:02:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210170209.GE7088@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu> <20080210082408.GA10479@infradead.org> <20080210085735.GA13466@elte.hu> <20080210091123.GA19912@infradead.org> <20080210092728.GA19252@elte.hu> <20080210093450.GA3754@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210093450.GA3754@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Feb 10, 2008 at 10:27:28AM +0100, Ingo Molnar wrote:
> > > The one I noticed quickly is the __ASSEMBLY__ removal from 
> > > asm-x86/kgdb.h. [...]
> > 
> > people might want to experiment with early debug code as well and 
> > include asm-x86/kgdb.h in assembly files. So i kept that, it's 
> > sensible.
> 
> But asm-x86/kgdb.h doesn't have anythign people invoking kgdb might 
> need, it's just the arch interface to the kgdb core.  Nor does it 
> compile even with the ifdef as it already contains a C enum.

good point - i fixed this. (by following your suggestion of removing the 
_ASSEMBLY_)

	Ingo
