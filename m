Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbXKMPkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbXKMPkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbXKMPjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:39:54 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:37363 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbXKMPjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:39:53 -0500
Date: Tue, 13 Nov 2007 21:09:25 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, hch@infradead.org,
       randy.dunlap@oracle.com,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       mathieu.desnoyers@polymtl.ca, davem@davemloft.net,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>
Subject: Re: [PATCH] Move kprobes examples to samples/ (resend)
Message-ID: <20071113153924.GA25095@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20071021123919.GA7648@in.ibm.com> <20071113040045.0440e575.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113040045.0440e575.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 04:00:45AM -0800, Andrew Morton wrote:
> On Sun, 21 Oct 2007 18:09:19 +0530 Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > Move kprobes examples from Documentation/kprobes.txt to under samples/.
> > Patch originally by Randy Dunlap.
> > 
> > In addition, I have
> > 
> > o Updated the patch to apply on 2.6.23-mm1
> > o Modified examples code to build on multiple architectures. Currently,
> >   the examples code works for x86_64, x86_32 and powerpc
> > o Cleaned up unneeded #includes
> 
> Could you please take a look at what's needed to get this working on sparc64?
> 
> samples/kprobes/kretprobe_example.c: In function `ret_handler':
> samples/kprobes/kretprobe_example.c:19: error: implicit declaration of function `regs_return_value'
> 
> Thanks.

As Davem mentions, these are a fallout of sparc64 not having kretprobe
support. As a followup to this mail, I am sending a couple of patches
that should fix the issue (sparc64 cross compile works fine with the
patches).

Ananth
