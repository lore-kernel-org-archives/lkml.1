Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZF3XVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZF3XVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760975AbZF3XVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:21:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760713AbZF3XV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:21:27 -0400
Date: Wed, 1 Jul 2009 01:21:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/8] perf top: Add ppc64 specific skip symbols and
	strip ppc64 . prefix
Message-ID: <20090630232118.GE17968@elte.hu>
References: <20090630230043.464194676@samba.org> <20090630230140.995643441@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630230140.995643441@samba.org>
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


* Anton Blanchard <anton@samba.org> wrote:

> Filter out some ppc64 specific idle loop functions and remove leading '.' on
> ppc64 text symbols.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Do we want to wrap them with #ifdef __PPC__ ?

>  	"enter_idle",
>  	"exit_idle",
>  	"mwait_idle",
> +	"ppc64_runlatch_off",
> +	"pseries_dedicated_idle_sleep",

We only want to wrap them into #ifdef __PPC__ if we do so for the 
x86 ones too.

I think it's fine as-is - the names should be pretty unique, right?

	Ingo
