Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbYHSUPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbYHSUPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYHSUPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:15:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33457 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbYHSUPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:15:18 -0400
Date: Tue, 19 Aug 2008 16:15:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Eran Liberty <liberty@extricom.com>
cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
In-Reply-To: <48AAB7FF.4070502@extricom.com>
Message-ID: <alpine.DEB.1.10.0808191614380.4957@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <48A9BEA3.10906@extricom.com> <alpine.DEB.1.10.0808181439480.796@gandalf.stny.rr.com> <48AAB7FF.4070502@extricom.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 19 Aug 2008, Eran Liberty wrote:

> Steven Rostedt wrote:
> >   
> > > Testing tracer sched_switch: PASSED
> > > Testing tracer ftrace: PASSED
> > > Testing dynamic ftrace: PASSED

Do you have PREEMPT_TRACER enabled, or any other tracer for that matter?

-- Steve

> > > 
> > > Oops: Exception in kernel mode, sig: 11 [#1]
> > > Exsw1600
> > > Modules linked in:
> > > NIP: c00bbb20 LR: c00bbb20 CTR: 00000000
> > >     
> > 
