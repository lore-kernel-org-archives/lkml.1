Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbYKSKim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbYKSKim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 05:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYKSKid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 05:38:33 -0500
Received: from ozlabs.org ([203.10.76.45]:53137 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbYKSKid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 05:38:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18723.60578.179210.736789@cargo.ozlabs.ibm.com>
Date: Wed, 19 Nov 2008 21:38:26 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/7] Porting dynmaic ftrace to PowerPC
In-Reply-To: <20081119092723.GC22309@elte.hu>
References: <20081116212428.938752312@goodmis.org>
	<18720.42209.880409.297291@cargo.ozlabs.ibm.com>
	<alpine.DEB.1.10.0811171035530.2919@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0811180853390.15003@gandalf.stny.rr.com>
	<18723.31762.522696.647294@cargo.ozlabs.ibm.com>
	<alpine.DEB.1.10.0811182150530.14914@gandalf.stny.rr.com>
	<20081119092723.GC22309@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 19 Nov 2008, Paul Mackerras wrote:
> > 
> > > Steven Rostedt writes:
> > > 
> > > > Can I add your Acked-by: to all these patches that I submitted? I'm going 
> > > > to recommit them with a consistent subject (all lower case ppc), but I'm 
> > > > not going to change the patches themselves.
> > > > 
> > > > Would you two be fine with that? Or at least one of you?
> > > 
> > > My preference would be for the patches to go through the powerpc tree
> > > unless there is a good reason for them to go via another tree.
> > 
> > I have no problem with that. The only thing is that we have a lot of 
> > pending work still in the linux-tip tree, which you may need to pull 
> > in to get these patches working. Well, there's two or three commits 
> > in the generic code that I know the PPC code is dependent on.
> > 
> > I could give you a list of commits in tip that need to go mainline 
> > first before we can pull in the PPC changes. Then you could wait 
> > till those changes make it into 29 and then you could push the PPC 
> > modifications in from your tree.
> 
> note that this inserts a lot of (unnecessary) serialization and a 
> window of non-testing - by all likelyhood this will delay ppc ftrace 
> to v2.6.30 or later kernels.

Well, note that I said "unless there is a good reason".  If it does
need to go via your tree, it can, though I don't see that it will get
much testing on powerpc there, and having it there will make it harder
to manage any conflicts with the other stuff I have queued up.

How much generic stuff that's not upstream do the powerpc ftrace
patches depend on?

Paul.
