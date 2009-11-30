Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZK3MmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZK3MmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZK3MmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:42:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55174 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZK3MmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:42:02 -0500
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <20091130123257.GB18879@linux.vnet.ibm.com>
References: <20091130120345.GA18879@linux.vnet.ibm.com>
	 <1259582952.20516.209.camel@laptop>
	 <20091130123257.GB18879@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 13:41:47 +0100
Message-ID: <1259584907.20516.246.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 18:02 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2009-11-30 13:09:12]:
> 
> > On Mon, 2009-11-30 at 17:33 +0530, Srikar Dronamraju wrote:
> > > This patch implements an in-kernel gdb stub.
> > > It provides an interface between gdb and Linux Kernel by implementing
> > > the remote serial protocol.  This gdbstub uses utrace infrastructure.
> > > This patch provides register set access, signal mapping, process event
> > > handling, input/output operations.
> > > 
> > > /proc/<pid>/gdb was chosen as file for gdb to interact with the
> > > process through remote serial protocol. 
> > > 
> > > Hence users would have to use "target remote /proc/<pid>/gdb" command
> > > on gdb prompt to start using this infrastructure.
> > > 
> > > For Breakpointing support, gdbstub needs User space breakpointing
> > > layer and uprobes layer which will be posted later.
> > 
> > How does this compare to kgdb and related efforts?
> 
> This is a In-kernel gdbstub to debug user space programs. 
> This stub doesnt help in debugging kernel.
> 
> Hence I am not sure how to compare kgdb gdbstub with this gdbstub.
> Can you please provide more pointers on what you were referring to?

Well, not even that much was clear from your changelog, so I wasn't
really sure wtf I was looking at. All it says was an in-kernel gdb stub,
what other than to debug the kernel would you need in-kernel stubs for?

So now my question is, what do you need an in-kernel stub to debug
userspace for?

In general, tell me about this patch thing, what does it do, why does it
do it, and how does it improve on the current situation.

Your changelog doesn't address any of those things, so wth are we
supposed to think?

