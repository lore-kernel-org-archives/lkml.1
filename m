Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbYJVOiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbYJVOiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYJVOh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:37:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56728 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbYJVOh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:37:56 -0400
Date: Wed, 22 Oct 2008 16:37:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Re : [PATCH 2/2] fastboot: fix row order in bootgraph.pl
Message-ID: <20081022143741.GA3263@elte.hu>
References: <48F49C0F.7050705@tuffmail.co.uk> <48F49C53.1070103@tuffmail.co.uk> <c62985530810140701s50f3a1an8da5383f8eefa29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810140701s50f3a1an8da5383f8eefa29@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/10/14, Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> > When bootgraph.pl parses a file, it gives one row for each initcall's
> > pid.  But they are displayed in random (perl hash) order.  Let's
> > sort the pids by the start time of their first initcall instead.
> 
> Thanks. That's a good idea!
> 
> I can't test it yet but I will give you a feedback as soon as I can.

i've applied the two fix patches from Alan to tip/tracing/urgent:

 06d1cd2: tracing/fastboot: fix row order in bootgraph.pl
 2a813f8: tracing/fastboot: fix bootgraph.pl to run with "use strict"

Arjan, Steve, any objections?

	Ingo
