Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYJ0S1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYJ0S1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYJ0S1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:27:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49330 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbYJ0S1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:27:08 -0400
Date: Mon, 27 Oct 2008 19:26:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/tracing/markers] new probes manager
Message-ID: <20081027182655.GA11494@elte.hu>
References: <48FFE5CB.2050608@cn.fujitsu.com> <20081027155832.GB17250@Krystal> <20081027163046.GA20692@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027163046.GA20692@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0017]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> > > 
> > > this patch use a new probes manager for marker.
> > > 
> > > the most important benefit of this patch is:
> > > 	1) smp_rmb() is removed from the critical path. as we know rmb()
> > > 	   is very expensive.
> > > 
> > 
> > Do you have performance measurements for this ? On x86 it's a nop,
> > AFAIK.
> 
> My statement above is inexact : x86_64 uses lfence for rmb(). But
> numbers would still be welcome.

yes, the statement that rmb() is very expensive looks dubious. It is 
absolutely cheap everywhere.

	Ingo
