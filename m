Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbYJTNoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbYJTNoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYJTNn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:43:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37647 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbYJTNn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:43:58 -0400
Date: Mon, 20 Oct 2008 15:43:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] lockstat: contend with points
Message-ID: <20081020134330.GD32363@elte.hu>
References: <1224231505.28131.71.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224231505.28131.71.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0163]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: lockstat: contend with points
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Oct 16 23:17:09 CEST 2008
> 
> We currently only provide points that have to wait on contention, also
> lists the points we have to wait for.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  Documentation/lockstat.txt |   50 ++++++++++++++++++++++++++++-----------------
>  include/linux/lockdep.h    |   13 ++++++++---
>  kernel/lockdep.c           |   33 ++++++++++++++++++-----------
>  kernel/lockdep_proc.c      |   21 +++++++++++++++++-
>  kernel/mutex.c             |    2 -
>  5 files changed, 82 insertions(+), 37 deletions(-)

nice! Applied to tip/core/locking, thanks Peter.

	Ingo
