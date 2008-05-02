Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYEBEKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYEBEKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 00:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbYEBEJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 00:09:49 -0400
Received: from ozlabs.org ([203.10.76.45]:57827 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbYEBEJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 00:09:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18458.37891.268060.691285@cargo.ozlabs.ibm.com>
Date: Fri, 2 May 2008 14:09:39 +1000
From: Paul Mackerras <paulus@samba.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
In-Reply-To: <1209697815.2946.156.camel@vader.jdub.homelinux.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080501003125.GM29330@cs181133002.pp.htv.fi>
	<20080430000338.50548884@infradead.org>
	<20080501113038.GW29330@cs181133002.pp.htv.fi>
	<20080430072013.7c3b30b1@infradead.org>
	<20080501132159.GC29330@cs181133002.pp.htv.fi>
	<18458.30641.838156.434563@cargo.ozlabs.ibm.com>
	<1209697815.2946.156.camel@vader.jdub.homelinux.org>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer writes:

> On Fri, 2008-05-02 at 12:08 +1000, Paul Mackerras wrote:
> > Adrian Bunk writes:
> > 
> > > "Kernel oops while running kernbench and tbench on powerpc" took more 
> > > than 2 months to get resolved, and we ship 2.6.25 with this regression.
> > 
> > That was a very subtle bug that only showed up on one particular
> > powerpc machine.  I was not able to replicate it on any of the powerpc
> > machines I have here.  Nevertheless, we found it and we have a fix for
> > it.  I think that's an example of the process working. :)
> 
> Was it even a regression in the classical sense of the word?  Seemed
> more of a latent bug that was simply never triggered before.

That's right.  The bug has been there basically forever (i.e. since
before 2.6.12-rc2 ;) and no-one has been able to trigger it reliably
before.

Paul.
