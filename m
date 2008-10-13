Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYJMHXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYJMHXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 03:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbYJMHWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 03:22:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57195 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYJMHWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 03:22:53 -0400
Date: Mon, 13 Oct 2008 09:22:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: async function call test users
Message-ID: <20081013072241.GB15346@elte.hu>
References: <20081012194427.2e21c22e@infradead.org> <20081012194511.64cdd9e4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081012194511.64cdd9e4@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0601]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> not for merge! Just for "show that it works"

please propagate something like this into tests/ and create a series of 
unit tests like the lockdep self-tests that prints out a series of 
WARN()n if it doesnt work or so. It's useful for you too when you are 
hacking on it.

Plus an anti-NIH suggestion: you could reuse much of the syslets series 
i did - sans the ugly syscall ABI bits. The submit/completion bits were 
pretty mature.

	Ingo
