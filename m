Return-Path: <linux-kernel-owner+w=401wt.eu-S932814AbYBVJJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbYBVJJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYBVJJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:09:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57435 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYBVJJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:09:15 -0500
Date: Fri, 22 Feb 2008 10:08:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Miklos Szeredi <miklos@szeredi.hu>,
       Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 ptrace: fix compat PTRACE_SETREGS
Message-ID: <20080222090843.GA327@elte.hu>
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <20080215184741.GB8810@c2.user-mode-linux.org> <E1JQ6bM-0005z4-Ac@pomaz-ex.szeredi.hu> <E1JRD9I-0004L9-6E@pomaz-ex.szeredi.hu> <E1JSF5r-0007vI-1v@pomaz-ex.szeredi.hu> <20080222043725.025A02701D5@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222043725.025A02701D5@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> Simple typo fix for regression introduced by the user_regset changes.

> -			ret = putreg(target, pos, *k++);
> +			ret = putreg32(target, pos, *k++);

> -			ret = putreg(target, pos, word);
> +			ret = putreg32(target, pos, word);

thanks, applied.

	Ingo
