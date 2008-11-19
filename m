Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYKSJ2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYKSJ2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYKSJ1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:27:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54712 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbYKSJ1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:27:53 -0500
Date: Wed, 19 Nov 2008 10:27:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/7] Porting dynmaic ftrace to PowerPC
Message-ID: <20081119092723.GC22309@elte.hu>
References: <20081116212428.938752312@goodmis.org> <18720.42209.880409.297291@cargo.ozlabs.ibm.com> <alpine.DEB.1.10.0811171035530.2919@gandalf.stny.rr.com> <alpine.DEB.1.10.0811180853390.15003@gandalf.stny.rr.com> <18723.31762.522696.647294@cargo.ozlabs.ibm.com> <alpine.DEB.1.10.0811182150530.14914@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811182150530.14914@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 19 Nov 2008, Paul Mackerras wrote:
> 
> > Steven Rostedt writes:
> > 
> > > Can I add your Acked-by: to all these patches that I submitted? I'm going 
> > > to recommit them with a consistent subject (all lower case ppc), but I'm 
> > > not going to change the patches themselves.
> > > 
> > > Would you two be fine with that? Or at least one of you?
> > 
> > My preference would be for the patches to go through the powerpc tree
> > unless there is a good reason for them to go via another tree.
> 
> I have no problem with that. The only thing is that we have a lot of 
> pending work still in the linux-tip tree, which you may need to pull 
> in to get these patches working. Well, there's two or three commits 
> in the generic code that I know the PPC code is dependent on.
> 
> I could give you a list of commits in tip that need to go mainline 
> first before we can pull in the PPC changes. Then you could wait 
> till those changes make it into 29 and then you could push the PPC 
> modifications in from your tree.

note that this inserts a lot of (unnecessary) serialization and a 
window of non-testing - by all likelyhood this will delay ppc ftrace 
to v2.6.30 or later kernels.

	Ingo
