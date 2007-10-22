Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXJVVrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXJVVrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 17:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbXJVVrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 17:47:00 -0400
Received: from www.tglx.de ([62.245.132.106]:57169 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbXJVVq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 17:46:59 -0400
Date: Mon, 22 Oct 2007 23:46:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, matthew@wil.cx,
       ralf@linux-mips.org, adobriyan@gmail.com, viro@ftp.linux.org.uk,
       viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
In-Reply-To: <200710222334.45667.arnd@arndb.de>
Message-ID: <alpine.LFD.0.9999.0710222344580.3167@localhost.localdomain>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru> <alpine.LFD.0.999.0710221254550.30120@woody.linux-foundation.org> <20071022130223.f7d75c31.akpm@linux-foundation.org> <200710222334.45667.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1024360001-1193089581=:3167"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1024360001-1193089581=:3167
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT

On Mon, 22 Oct 2007, Arnd Bergmann wrote:

> On Monday 22 October 2007, Andrew Morton wrote:
> > It's almost always a bug to do spin_lock_irq() when local interrupts are
> > disabled.  However iirc when we've tried to add runtime debugging to catch
> > that, it triggered false-positives which made the idea unworkable.  I forget
> > where.
> 
> I tried this as well a few years ago, and I think I hit a few places in
> the early initialization, but nothing unfixable.

Hmm, lockdep checks this already. If it does not catch it, we need to fix it.

     tglx
--8323328-1024360001-1193089581=:3167--
