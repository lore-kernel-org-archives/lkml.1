Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbYHWRMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbYHWRMP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 13:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYHWRL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 13:11:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55329 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYHWRL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 13:11:58 -0400
Date: Sat, 23 Aug 2008 19:11:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtc: fix deadlock
Message-ID: <20080823171139.GA13144@elte.hu>
References: <200808230948.m7N9mUc1016360@harpo.it.uu.se> <20080823160151.GB27974@elte.hu> <18608.16826.607428.203994@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18608.16826.607428.203994@harpo.it.uu.se>
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


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> Thanks for the patch, I'll give it a try ASAP.
> 
> The sporadic nature of the bug means that it will probably take a 
> couple of days of testing and dozens of reboots w/o problems before 
> I'm confident to say that the problem's been fixed.

btw., i've seen that lockup too on a testbox - but havent been able to 
track it down yet. You went further and presented the bug on a plate by 
tracking it down to the loop in get_rtc_time() - so now we can both test 
the fix and see whether the lockups are gone.

	Ingo
