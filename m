Return-Path: <linux-kernel-owner+w=401wt.eu-S1761556AbZFOOJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556AbZFOOJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761336AbZFOOJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:09:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbZFOOJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:09:37 -0400
Date: Mon, 15 Jun 2009 16:09:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: Re: linux-next: tip/perfcounters tree build warning
Message-ID: <20090615140916.GA29435@elte.hu>
References: <20090615165559.66c76c58.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615165559.66c76c58.sfr@canb.auug.org.au>
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

> Hi all,
> 
> Today's linux-next build (powerpc allyesconfig) produced this warning:
> 
> arch/powerpc/kernel/perf_counter.c: In function 'record_and_restart':
> arch/powerpc/kernel/perf_counter.c:1016: warning: unused variable 'addr'
> 
> Introduced by commit df1a132bf3d3508f863336c80a27806a2ac947e0
> ("perf_counter: Introduce struct for sample data").
> 
> I checked the tip/master branch and this is not fixed there.

Thanks Stephen for reporting this!

	Ingo
