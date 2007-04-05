Return-Path: <linux-kernel-owner+w=401wt.eu-S1946055AbXDEHv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946055AbXDEHv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 03:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946057AbXDEHv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 03:51:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55564 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946055AbXDEHv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 03:51:57 -0400
Date: Thu, 5 Apr 2007 09:51:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       johnstul@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm tree
Message-ID: <20070405075101.GA14199@elte.hu>
References: <20070404203647.GA12563@elte.hu> <1175719489.15973.66.camel@imap.mvista.com> <20070404211514.GA18600@elte.hu> <1175722246.15973.78.camel@imap.mvista.com> <20070404213404.GA21742@elte.hu> <1175723954.15973.96.camel@imap.mvista.com> <46143941.7050702@goop.org> <1175731253.15973.106.camel@imap.mvista.com> <461440C9.8040902@goop.org> <1175733279.15973.116.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175733279.15973.116.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> [...] Adding a list initializer doesn't change anything..

Daniel, you are still in denial. OF COURSE it changes something: it adds 
a line of code to a driver, where that line was not needed before. 
That's against the fundamental task of a driver model: TO KEEP THINGS 
SIMPLE. Yes, this concept includes single-line changes as well.

yes, a single line might not sound much, but it's exactly one line more 
than necessary.

	Ingo
