Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYJPTBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYJPTBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYJPTBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:01:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38439 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbYJPTBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:01:19 -0400
Date: Thu, 16 Oct 2008 15:01:06 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       linuxppc-dev@ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] ftrace: fixes for PPC
Message-ID: <20081016150106.6ddf7e46@zod.rchland.ibm.com>
In-Reply-To: <alpine.DEB.1.10.0810161444050.11042@gandalf.stny.rr.com>
References: <20080906050602.409299112@goodmis.org>
	<20080906120346.GA30964@elte.hu>
	<20081016181452.GA29739@yoda.jdub.homelinux.org>
	<alpine.DEB.1.10.0810161421530.11042@gandalf.stny.rr.com>
	<20081016183529.GB29739@yoda.jdub.homelinux.org>
	<alpine.DEB.1.10.0810161444050.11042@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 14:45:15 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 16 Oct 2008, Josh Boyer wrote:
> > 
> > Well, that's why I asked.  You sent 2 patches out over a month ago that
> > don't appear to have shown up in any Linus or PowerPC tree.
> 
> Oh, the patches I sent on here, are not to solve this issue. It was 
> actually solving issues in linux-tip itself.

Totally confused as to what linux-tip is, but ok.

> I'm still looking into the cause for ftrace not to boot on PPC.

There were issues with -pg and some other compile flag on PPC at one
point.  I think you worked that out with Ben, but I don't recall.

Anyway, if you want a tester let me know.  It seems 2.6.27.1 should be
fine since FTRACE was disabled, but for .28-rc1 it would be cool if it
worked :).

josh
