Return-Path: <linux-kernel-owner+w=401wt.eu-S932720AbZAGWju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbZAGWju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762951AbZAGWhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:37:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56420 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbZAGWhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:37:38 -0500
Date: Wed, 7 Jan 2009 23:37:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, snakebyte@gmx.de, josh@freedesktop.org,
       dipankar@in.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       kamalesh@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH -tip] Fix bug in rcutorture system-shutdown code
Message-ID: <20090107223722.GA3167@elte.hu>
References: <20090107223048.GA19903@linux.vnet.ibm.com> <20090107223538.GC27629@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107223538.GC27629@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> hm, doesnt apply to latest tip/master:
> 
> 4 out of 11 hunks FAILED -- rejects in file kernel/rcutorture.c
> 
> probably due to:
> 
>  c59ab97: rcu: fix rcutorture bug
> 
> which was an earlier fix i picked up. (already upstream)

ok, got your v2 patch - applied it to tip/core/urgent:

  c9d557c: rcu: fix bug in rcutorture system-shutdown code

thanks Paul!

	Ingo
