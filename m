Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbXLQQBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbXLQQBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbXLQQBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:01:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54835 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758998AbXLQQBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:01:42 -0500
Date: Mon, 17 Dec 2007 17:01:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: make pda's cpunumber and nodenumber unsigned
Message-ID: <20071217160127.GB30958@elte.hu>
References: <47610530.76E4.0078.0@novell.com> <20071217132619.GB1870@elte.hu> <476689AF.76E4.0078.0@novell.com> <20071217145317.GD16604@elte.hu> <20071217153445.GB7882@cvg.cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217153445.GB7882@cvg.cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Checkpatch still does complain about
> 	if (0) { T__ tmp__; tmp__ = (val)
> I'm not sure if we need this line at all.

that's a type-checking trick. It does not result in any generated code 
but gcc flags it with a build time warning if there's a type mismatch. 
So it's a checkpatch.pl false positive.

	Ingo
