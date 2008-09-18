Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYIRKQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYIRKQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 06:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYIRKPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 06:15:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54768 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbYIRKPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 06:15:50 -0400
Date: Thu, 18 Sep 2008 12:15:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: make mm/gup.c more virtualization friendly
Message-ID: <20080918101525.GA20967@elte.hu>
References: <48D142E1.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D142E1.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Since pte_flags() is much cheaper than pte_val() in some virtualized
> environments (namely, Xen), use the former whereever possible.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Nick Piggin <npiggin@suse.de>

applied to tip/x86/core, thanks Jan.

	Ingo
