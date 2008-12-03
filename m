Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbYLCVMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbYLCVMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYLCVMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:12:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46210 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYLCVL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:11:59 -0500
Date: Wed, 3 Dec 2008 16:11:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org, arjan@infradead.org, dave@linux.vnet.ibm.com,
       containers@lists.osdl.org, ebiederm@xmission.com,
       sukadev@linux.vnet.ibm.com, serue@us.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: graph of a single function
In-Reply-To: <20081203130859.fcf5a51e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0812031611000.29045@gandalf.stny.rr.com>
References: <20081203203656.776893226@goodmis.org> <20081203203828.920111079@goodmis.org> <20081203130859.fcf5a51e.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Dec 2008, Andrew Morton wrote:

> On Wed, 03 Dec 2008 15:36:57 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +static struct seq_operations ftrace_graph_seq_ops = {
> > +	.start = g_start,
> > +	.next = g_next,
> > +	.stop = g_stop,
> > +	.show = g_show,
> > +};
> 
> This could be static I think.

s/static/const/

Damn damn damn damn!!!! I said to myself, I need to add const there and 
still forgot :-(

> 
> It's probably not worth even commenting on or fixing this sort
> of thing.  Just rely on someone(tm) doing periodic sweeps to
> fix them all up.

Still on my todo list for kernel/trace/*.c

-- Steve

