Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbYAFJjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbYAFJjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 04:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYAFJjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 04:39:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55741 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbYAFJjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 04:39:17 -0500
Date: Sun, 6 Jan 2008 10:38:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Message-ID: <20080106093853.GD26291@elte.hu>
References: <200801052042.56042.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801052042.56042.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Subject		: jiffies counter leaps in 2.6.24-rc3
> Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
> Date		: 2007-11-29 08:36
> References	: http://lkml.org/lkml/2007/11/24/53
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
> Handled-By	: Ingo Molnar <mingo@elte.hu>
> Patch		: http://lkml.org/lkml/2007/12/7/132

this holds a series of problems, we've applied everything we wanted to 
2.6.24 already we'll do the full stack of fixes for this in 2.6.25. 
(changing printk was deemed inappropriate so late in the -rc cycle) So 
perhaps mark this as WILL_FIX_LATER and unmark it as a regression? 
Stefano, do you agree? b43 works fine for you in the latest .24-rc 
kernel, correct?

	Ingo
