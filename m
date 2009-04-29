Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZD2TIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZD2TIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbZD2TIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:08:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZD2TIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:08:02 -0400
Date: Wed, 29 Apr 2009 21:06:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       dada1@cosmosbay.com, benh@kernel.crashing.org, gallatin@myri.com,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       stable@kernel.org
Subject: Re: [tip:sched/urgent] sched: account system time properly
Message-ID: <20090429190628.GC13139@elte.hu>
References: <49F84BC1.7080602@cosmosbay.com> <tip-f5f293a4e3d0a0c52cec31de6762c95050156516@git.kernel.org> <20090429075818.5ca17efb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429075818.5ca17efb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 29 Apr 2009 13:09:19 GMT tip-bot for Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > Commit-ID:  f5f293a4e3d0a0c52cec31de6762c95050156516
> > Gitweb:     http://git.kernel.org/tip/f5f293a4e3d0a0c52cec31de6762c95050156516
> > Author:     Eric Dumazet <dada1@cosmosbay.com>
> > AuthorDate: Wed, 29 Apr 2009 14:44:49 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 29 Apr 2009 15:02:28 +0200
> > 
> > sched: account system time properly
> > 
> > ...
> > 
> > Reported-by: Andrew Gallatin <gallatin@myri.com>
> > Re-reported-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> > Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: rick.jones2@hp.com
> > Cc: brice@myri.com
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > LKML-Reference: <49F84BC1.7080602@cosmosbay.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> The regression was present in 2.6.29, so a -stable backport (and 
> cc!) is appropriate.

agreed, i've forwarded this info to stable@kernel.org.

	Ingo
