Return-Path: <linux-kernel-owner+w=401wt.eu-S1763939AbXKQSVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763939AbXKQSVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbXKQSU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:20:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56469 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756927AbXKQSU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:20:58 -0500
Date: Sat, 17 Nov 2007 10:19:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
Message-Id: <20071117101957.7562639d.akpm@linux-foundation.org>
In-Reply-To: <20071117180946.GA14055@elte.hu>
References: <473DA608.1020804@linux.vnet.ibm.com>
	<64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
	<20071117180946.GA14055@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007 19:09:46 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> 
> > Sadly lockdep does not work for me, as it gets turned off early:
> > [   39.851594] ---------------------------------
> > [   39.855963] inconsistent {softirq-on-W} -> {in-softirq-W} usage.
> > [   39.861981] swapper/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
> > [   39.866963]  (&n->list_lock){-+..}, at: [<ffffffff802935c1>]
> 
> hey, that means it found a bug - which is not sad at all :-)
> 

mutter.

Torsten, you could try CONFIG_SLAB=y, CONFIG_SLUB=n to see if you can make
some progress on the NFS problem.

