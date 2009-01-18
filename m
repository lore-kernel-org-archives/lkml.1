Return-Path: <linux-kernel-owner+w=401wt.eu-S933670AbZARQrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbZARQrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760680AbZARQmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:42:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36881 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760493AbZARQmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:42:54 -0500
Date: Sun, 18 Jan 2009 17:42:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] x86-64: Use absolute displacements for per-cpu
	accesses.
Message-ID: <20090118164246.GA28423@elte.hu>
References: <1232115396-26367-5-git-send-email-brgerst@gmail.com> <1232115396-26367-6-git-send-email-brgerst@gmail.com> <1232115396-26367-7-git-send-email-brgerst@gmail.com> <1232115396-26367-8-git-send-email-brgerst@gmail.com> <1232115396-26367-9-git-send-email-brgerst@gmail.com> <1232115396-26367-10-git-send-email-brgerst@gmail.com> <1232115396-26367-11-git-send-email-brgerst@gmail.com> <1232115396-26367-12-git-send-email-brgerst@gmail.com> <4972AE71.2030506@kernel.org> <73c1f2160901172036m4d7bb4f8i50b6a5185a63e95@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73c1f2160901172036m4d7bb4f8i50b6a5185a63e95@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2723]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brian Gerst <brgerst@gmail.com> wrote:

> On Sat, Jan 17, 2009 at 11:22 PM, Tejun Heo <tj@kernel.org> wrote:
> 
> > Hello, Brian.
> >
> > Brian Gerst wrote:
> > > Accessing memory through %gs should not use rip-relative addressing.
> > > Adding a P prefix for the argument tells gcc to not add (%rip) to
> > > the memory references.
> >
> > Nice catch.  I dind't know about the P prefix thing.  It also is used
> > in other places too.  Hmmm... I can't find anything about the P
> > argument prefix in the gcc info page (4.3).  Any ideas where I can
> > find some information about it?  It's a bit weird that it's not a
> > constraint prefix but an argument one.
> 
> The only place I could confirm that it works is in the gcc source 
> itself, and even there it's not well documented.

does %P support go back as far as gcc 3.2 (the earliest GCC we still 
support)?

	Ingo
