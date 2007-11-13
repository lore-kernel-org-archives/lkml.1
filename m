Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbXKMMDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbXKMMDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbXKMMDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:03:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57089
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753426AbXKMMDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:03:43 -0500
Date: Tue, 13 Nov 2007 04:03:42 -0800 (PST)
Message-Id: <20071113.040342.178304306.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: ananth@in.ibm.com, linux-kernel@vger.kernel.org, hch@infradead.org,
       randy.dunlap@oracle.com, anil.s.keshavamurthy@intel.com,
       mathieu.desnoyers@polymtl.ca, prasanna@in.ibm.com
Subject: Re: [PATCH] Move kprobes examples to samples/ (resend)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071113040045.0440e575.akpm@linux-foundation.org>
References: <20071021123919.GA7648@in.ibm.com>
	<20071113040045.0440e575.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Nov 2007 04:00:45 -0800

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

kretprobes support most likely, it's on my todo list to implement
but it will take a while since I'm busy fixing networking bugs
but I can stop doing that if you like.

:-)
