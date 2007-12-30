Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbXL3OTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbXL3OTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXL3OTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:19:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34229 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbXL3OTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:19:05 -0500
Date: Sun, 30 Dec 2007 15:18:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       tglx@linutronix.de, mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 05/10] x86_64: Use generic percpu
Message-ID: <20071230141829.GA28415@elte.hu>
References: <20071228001046.854702000@sgi.com> <20071228001047.556634000@sgi.com> <200712281354.52453.ak@suse.de> <47757311.5050503@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47757311.5050503@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> > Also for such changes .text size comparisons before/after are a good 
> > idea.
> 
> x86_64-defconfig:
> 
> pre-percpu                          post-percpu
>       159373 .init.text                       +3 .init.text
>      1411137 .rodata                          +8 .rodata
>      3629056 .text                           +48 .text
>      7057383 Total                           +59 Total

ok, that looks like really minimal impact, so i'm in favor of merging 
this into arch/x86 - and the unification it does later on is nice too.

to get more test feedback: what would be the best way to get this tested 
in x86.git in a standalone way? Can i just pick up these 10 patches and 
remove all the non-x86 arch changes, and expect it to work - or are the 
other percpu preparatory/cleanup patches in -mm needed too?

	Ingo
