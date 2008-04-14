Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbYDNInb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbYDNInb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbYDNInW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:43:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34435 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784AbYDNInV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:43:21 -0400
Date: Mon, 14 Apr 2008 10:42:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Erik Bosman <ejbosman@cs.vu.nl>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
Message-ID: <20080414084236.GE19865@elte.hu>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl> <20080412124947.146865e4@laptopd505.fenrus.org> <48012002.8030701@zytor.com> <Pine.GSO.4.56.0804132320260.6537@keg.few.vu.nl> <48028305.8040104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48028305.8040104@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

>> This is on a core 2 duo E6300.
>
> OK, so it sounds like there is no measurable difference.  Good.

yep - that would be expected, as the patch only touches the 
switch_to_xtra() path so it does not actually modify any fastpath.

any effect would be random code alignment changes, or perhaps some CPU 
internal inefficiency when running with TSCs disabled (which would be 
weird but still possible).

	Ingo
