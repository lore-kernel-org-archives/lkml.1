Return-Path: <linux-kernel-owner+w=401wt.eu-S935208AbYBWLZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935208AbYBWLZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYBWLZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:25:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45072 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765043AbYBWLZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:25:04 -0500
Date: Sat, 23 Feb 2008 12:24:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Michael Buesch <mb@bu3sch.de>, Alexey Zaytsev <zaytsev.a@protei.ru>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Message-ID: <20080223112436.GA31304@elte.hu>
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de> <47BF101F.30301@protei.ru> <200802221848.37902.mb@bu3sch.de> <20080223110751.GN23833@elte.hu> <84144f020802230318hec5fe97h84c797a56b0dd5db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020802230318hec5fe97h84c797a56b0dd5db@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Agreed. Alexey, did you identify a specific git commit that caused the 
> regression? Can we just revert that from 2.6.24? Michael, even if 
> _you're_ planning to remove bcm43xx we must not let it regress until 
> it's gone.

btw., if the best answer is: "do not enable b43 and bcm43xx at once in 
the .config because we messed up the dependencies and fixing it in 
2.6.24-stable is unfortunately too risky", then that's a perfectly fine 
answer for -stable. Then the fix would be to exclude each other in the 
Kconfig space (which is not risky). But just ignoring bugreports and 
NAK-ing a fix is not a valid answer.

	Ingo
