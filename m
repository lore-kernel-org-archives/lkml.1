Return-Path: <linux-kernel-owner+w=401wt.eu-S1762822AbYESPbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762822AbYESPbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761606AbYESPa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:30:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40103 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761483AbYESPa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:30:57 -0400
Date: Mon, 19 May 2008 17:30:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tip build broken on sparc64...
Message-ID: <20080519153042.GB2000@elte.hu>
References: <20080516.130758.138657725.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516.130758.138657725.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0014]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> It's this pteval_t stuff, probably breaks just about every
> other platforms as well.
> 
> Please fix this, because I'd like to work on some ftrace
> optimizations on sparc64, and do some testing of ftrace
> in general.
> 
> mm/mmap.c: In function 'vm_get_page_prot_preserve':
> mm/mmap.c:86: error: 'pteval_t' undeclared (first use in this function)
> mm/mmap.c:86: error: (Each undeclared identifier is reported only once
> mm/mmap.c:86: error: for each function it appears in.)
> mm/mmap.c:86: error: expected ';' before 'newprotval'
> mm/mmap.c:88: error: 'newprotval' undeclared (first use in this function)

ok, will take care of it now.

	Ingo
