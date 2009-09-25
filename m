Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZIYIZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZIYIZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZIYIZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:25:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:38357 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbZIYIZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:25:37 -0400
Date: Fri, 25 Sep 2009 10:25:16 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Rusty Lynch <rusty.lynch@intel.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Vamsi Krishna S <vamsi_krishna@in.ibm.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nathan Sidwell <nathan@codesourcery.com>,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Anton Massoud <anton.massoud@ericsson.com>,
       Richard J Moore <richardj_moore@uk.ibm.com>
Subject: Re: Immediate values
Message-ID: <20090925102516.2ef02414@infradead.org>
In-Reply-To: <20090925073512.GA10346@Krystal>
References: <20090924191642.GA19225@elte.hu>
	<20090924193422.GB2533@elte.hu>
	<20090925085119.2b77ea04@infradead.org>
	<20090925073512.GA10346@Krystal>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 03:35:13 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Arjan van de Ven (arjan@infradead.org) wrote:
> > On Thu, 24 Sep 2009 21:34:22 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> [context for people CCed: see
> http://lkml.org/lkml/2009/9/24/262]
> 
> > > 
> > 
> > stopmachine is fine.
> > 
> > more aggressive tricks are rather dicey.
> > 
> > (cross modifying code that's being executed in ring 0 is ... not
> > something CPU designers had in mind)
> > 
> 
> Then, following your advice, kprobes should be re-designed to do a
> stop_machine around the int3 breakpoint insertion ? And gdb
> should be stopping all threads of a target process before inserting a
> breakpoint. Therefore, I do not seem to be the only one confused about
> Intel statement on this issue.

you are oversimplifying what you are trying to do, and overstating what
a ring 3 app and others do. 

But I'm not the one whom you'd need to convince, I don't design the
CPU. The people who do are extremely frowning on cross modifying code,
and Peter and I need to sit down with people who did many generations
of CPU to figure out if your scheme is actually safe. And on the AMD
side someone will need to do the same.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
