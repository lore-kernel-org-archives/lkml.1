Return-Path: <linux-kernel-owner+w=401wt.eu-S1761118AbXKMURP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118AbXKMURP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXKMUQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:16:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40059 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755899AbXKMUQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:16:56 -0500
Date: Tue, 13 Nov 2007 12:15:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ananth@in.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>, hch@infradead.org,
       randy.dunlap@oracle.com,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       mathieu.desnoyers@polymtl.ca, davem@davemloft.net,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>
Subject: Re: [PATCH] Move kprobes examples to samples/ (resend)
Message-Id: <20071113121554.ee51b6c6.akpm@linux-foundation.org>
In-Reply-To: <20071113153924.GA25095@in.ibm.com>
References: <20071021123919.GA7648@in.ibm.com>
	<20071113040045.0440e575.akpm@linux-foundation.org>
	<20071113153924.GA25095@in.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 21:09:25 +0530 Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> On Tue, Nov 13, 2007 at 04:00:45AM -0800, Andrew Morton wrote:
> > On Sun, 21 Oct 2007 18:09:19 +0530 Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> > 
> > > Move kprobes examples from Documentation/kprobes.txt to under samples/.
> > > Patch originally by Randy Dunlap.
> > > 
> > > In addition, I have
> > > 
> > > o Updated the patch to apply on 2.6.23-mm1
> > > o Modified examples code to build on multiple architectures. Currently,
> > >   the examples code works for x86_64, x86_32 and powerpc
> > > o Cleaned up unneeded #includes
> > 
> > Could you please take a look at what's needed to get this working on sparc64?
> > 
> > samples/kprobes/kretprobe_example.c: In function `ret_handler':
> > samples/kprobes/kretprobe_example.c:19: error: implicit declaration of function `regs_return_value'
> > 
> > Thanks.
> 
> As Davem mentions, these are a fallout of sparc64 not having kretprobe
> support. As a followup to this mail, I am sending a couple of patches
> that should fix the issue (sparc64 cross compile works fine with the
> patches).
> 

Thanks.

> This patch depends on Mathieu Desnoyers' "Instrumentation menu removal"
> patchset (http://marc.info/?l=linux-kernel&m=119496432229633&w=2)

argh.  OK, I'll look at this later in the week.
