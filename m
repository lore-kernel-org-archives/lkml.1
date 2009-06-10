Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbZFJTLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbZFJTLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZFJTLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:11:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbZFJTLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:11:48 -0400
Date: Wed, 10 Jun 2009 15:11:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Frysinger <vapier.adi@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ftrace: document basic ftracer/ftracer graph needs
In-Reply-To: <8bd0f97a0906101207s3eb36ccbp7baa631a941b9b0f@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0906101511070.30552@gandalf.stny.rr.com>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org>  <1244623722-6325-2-git-send-email-vapier@gentoo.org> <alpine.DEB.2.00.0906101303560.30552@gandalf.stny.rr.com>  <8bd0f97a0906101131m2fc21f75uc174631150897e5e@mail.gmail.com> 
 <alpine.DEB.2.00.0906101441410.30552@gandalf.stny.rr.com> <8bd0f97a0906101207s3eb36ccbp7baa631a941b9b0f@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Mike Frysinger wrote:

> On Wed, Jun 10, 2009 at 14:45, Steven Rostedt wrote:
> > On Wed, 10 Jun 2009, Mike Frysinger wrote:
> >> there should be at least tips in each HAVE_XXX as to where to look for
> >> implementation details.
> >
> > That can be opening a can of worms.
> 
> no it isnt:
> config HAVE_FUNCTION_TRACER
>     bool
>     help
>       Please see Documentation/trace/ftrace-implementation.txt

I'm fine with that, I was thing something else.

> 
> > Really, the focus of the documentation in Kconfig is about why things must
> > be selected, not how to implement the code to add that selection.
> 
> except that some of these defines come from the exact implementation details.
> 
> > If there's a HAVE_XXX in Kconfig that I want to see how to implement it, I
> > go off and do 'grep -r XXX Documentation'.
> 
> i look for the source of the define because ive given up on the
> Documentation actually being relevant

And you think documentation in Kconfig will be updated??

-- Steve

