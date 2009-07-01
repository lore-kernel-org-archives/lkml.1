Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbZGAKvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbZGAKvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZGAKvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:51:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47020 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbZGAKvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:51:06 -0400
Date: Wed, 1 Jul 2009 12:50:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Anton Blanchard <anton@samba.org>, a.p.zijlstra@chello.nl,
       paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/8] perf top: Move skip symbols to an array
Message-ID: <20090701105054.GA15071@elte.hu>
References: <20090630230043.464194676@samba.org> <20090630230140.904782938@samba.org> <20090701143154.29cc8e1d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701143154.29cc8e1d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> HI Anton,
> 
> On Wed, 01 Jul 2009 09:00:46 +1000 Anton Blanchard <anton@samba.org> wrote:
> >
> > +/* Tag samples to be skipped. */
> > +char *skip_symbols[] = {
> 
> "static const" ?

I fixed this. Too bad there's no GCC warning for that. (Sparse 
catches is but it is not enabled yet for perf.)

	Ingo
