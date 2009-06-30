Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbZF3X1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbZF3X1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZF3X1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:27:41 -0400
Received: from ozlabs.org ([203.10.76.45]:38515 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbZF3X1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:27:41 -0400
Date: Wed, 1 Jul 2009 09:26:03 +1000
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/8] perf top: Add ppc64 specific skip symbols and
	strip ppc64 . prefix
Message-ID: <20090630232603.GG3563@kryten>
References: <20090630230043.464194676@samba.org> <20090630230140.995643441@samba.org> <20090630232118.GE17968@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630232118.GE17968@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

> > Do we want to wrap them with #ifdef __PPC__ ?
> 
> >  	"enter_idle",
> >  	"exit_idle",
> >  	"mwait_idle",
> > +	"ppc64_runlatch_off",
> > +	"pseries_dedicated_idle_sleep",
> 
> We only want to wrap them into #ifdef __PPC__ if we do so for the 
> x86 ones too.
> 
> I think it's fine as-is - the names should be pretty unique, right?

I agree, we can start wrapping them if things get out of hand.

Anton
