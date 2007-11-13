Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXKMMEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXKMMEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbXKMMD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:03:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51158 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757664AbXKMMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:03:58 -0500
Date: Tue, 13 Nov 2007 04:00:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ananth@in.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>, hch@infradead.org,
       randy.dunlap@oracle.com,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       mathieu.desnoyers@polymtl.ca, davem@davemloft.net,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>
Subject: Re: [PATCH] Move kprobes examples to samples/ (resend)
Message-Id: <20071113040045.0440e575.akpm@linux-foundation.org>
In-Reply-To: <20071021123919.GA7648@in.ibm.com>
References: <20071021123919.GA7648@in.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 18:09:19 +0530 Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> Move kprobes examples from Documentation/kprobes.txt to under samples/.
> Patch originally by Randy Dunlap.
> 
> In addition, I have
> 
> o Updated the patch to apply on 2.6.23-mm1
> o Modified examples code to build on multiple architectures. Currently,
>   the examples code works for x86_64, x86_32 and powerpc
> o Cleaned up unneeded #includes

Could you please take a look at what's needed to get this working on sparc64?

samples/kprobes/kretprobe_example.c: In function `ret_handler':
samples/kprobes/kretprobe_example.c:19: error: implicit declaration of function `regs_return_value'

Thanks.
