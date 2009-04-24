Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbZDXIiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZDXIiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZDXIiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:38:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59756 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbZDXIiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:38:06 -0400
Date: Fri, 24 Apr 2009 10:36:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
Message-ID: <20090424083648.GK24912@elte.hu>
References: <alpine.DEB.2.00.0904222200350.24310@gandalf.stny.rr.com> <20090423082031.GA599@elte.hu> <alpine.DEB.2.00.0904230935060.24310@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231019001.24293@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231101030.24293@gandalf.stny.rr.com> <49F09C35.1080006@goop.org> <20090423172138.GR3036@sequoia.sous-sol.org> <20090423180238.GS3036@sequoia.sous-sol.org> <alpine.DEB.2.00.0904231432170.24293@gandalf.stny.rr.com> <20090423184344.GT3036@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423184344.GT3036@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > I bet it does, but I'm currently reviewing if we need the raw there. I may 
> > take your patch instead.
> 
> OK, saves a whopping 200 bytes on my .config too ;-)
> 
>    text	   data	    bss	    dec	    hex	filename
> 8041385	1816009	1822720	11680114	 b23972	vmlinux.orig
> 
>    text	   data	    bss	    dec	    hex	filename
> 8041181	1816009	1822720	11679910	 b238a6	vmlinux

This really demonstrates the cost of paravirt :-/

Please lets not forget this patch - it makes sense regardless of 
whether it works around the bug i reported.

	Ingo
