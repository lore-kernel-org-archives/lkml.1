Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbXFYIa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbXFYIa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 04:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXFYIaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 04:30:18 -0400
Received: from [157.181.151.9] ([157.181.151.9]:42382 "EHLO mx2.mail.elte.hu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751093AbXFYIaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 04:30:16 -0400
Date: Mon, 25 Jun 2007 10:26:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch, 2.6.22-rc6] fix nmi_watchdog=2 bootup hang
Message-ID: <20070625082652.GA3870@elte.hu>
References: <20070605093958.GA26135@elte.hu> <20070605094246.GA27135@elte.hu> <20070605094555.GA28097@elte.hu> <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu> <20070610181016.GA15979@atjola.homenet> <20070618121122.GA14375@elte.hu> <20070625061819.GA21874@elte.hu> <20070625065956.GA31725@elte.hu> <20070625080521.GA24333@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625080521.GA24333@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> the winner is ...
> 
>  f8822f42019eceed19cc6c0f985a489e17796ed8 is first bad commit
>  commit f8822f42019eceed19cc6c0f985a489e17796ed8
>  Author: Jeremy Fitzhardinge <jeremy@goop.org>
>  Date:   Wed May 2 19:27:14 2007 +0200
> 
>     [PATCH] i386: PARAVIRT: Consistently wrap paravirt ops callsites to make them patchable

and of course i'm happy to test any patch that is simpler than the 
brutal revert i sent.

	Ingo
