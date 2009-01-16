Return-Path: <linux-kernel-owner+w=401wt.eu-S1765485AbZAPBq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765485AbZAPBq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZAPBqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:46:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65024 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbZAPBql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:46:41 -0500
Date: Thu, 15 Jan 2009 20:46:38 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: fix trace_output
In-Reply-To: <20090115174008.935e0391.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901152046000.18861@gandalf.stny.rr.com>
References: <20090116004050.273665842@goodmis.org> <20090116004121.039250781@goodmis.org> <20090115174008.935e0391.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Jan 2009, Andrew Morton wrote:
> > 
> > diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> > index df0c25c..4e3ad36 100644
> > --- a/kernel/trace/trace_output.c
> > +++ b/kernel/trace/trace_output.c
> > @@ -440,9 +440,9 @@ trace_fn_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
> >  
> >  	trace_assign_type(field, entry);
> >  
> > -	if (trace_seq_printf(s, "%x %x\n",
> > -			     field->ip,
> > -			     field->parent_ip))
> > +	if (!trace_seq_printf(s, "%x %x\n",
> 
> "%lx %lx", surely?
> 
> If trace_seq_printf() had the attribute(printf) thing, it would have warned.

Who needs automation when we have an akpm ;-)

Will update.

Thanks,

-- Steve

