Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbYBJJ2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbYBJJ2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYBJJ1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:27:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57720 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbYBJJ1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:27:50 -0500
Date: Sun, 10 Feb 2008 10:27:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210092728.GA19252@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu> <20080210082408.GA10479@infradead.org> <20080210085735.GA13466@elte.hu> <20080210091123.GA19912@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210091123.GA19912@infradead.org>
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

> > i dont think so. Which ones do you mean? I just reviewed them and 
> > they are either already done, or moot (for kgdb complications that i 
> > objected to and removed from this kgdb-x86 tree).
> 
> The one I noticed quickly is the __ASSEMBLY__ removal from 
> asm-x86/kgdb.h. [...]

people might want to experiment with early debug code as well and 
include asm-x86/kgdb.h in assembly files. So i kept that, it's sensible. 

> [...]  I haven't looked at the serial bits because I don't think I'm 
> qualified to comment on those, but I'm also not seeing any replies to 
> any of his patches.  Especially the comments on the arch interface 
> seem like something that should be acted upon to me.

yeah - i also noticed that the serial subsystem is marked "orphaned" in 
the MAINTAINERS file:

 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
 L:      linux-serial@vger.kernel.org
 W:      http://serial.sourceforge.net
 S:      Orphan

and compared to the raw-lowlevel-serial-driver hackery that KGDB used to 
do this is a big step forward. Note that it's all dependent on 
CONFIG_KGDB.

	Ingo
