Return-Path: <linux-kernel-owner+w=401wt.eu-S1763791AbYBAMrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763791AbYBAMrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbYBAMrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:47:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60323 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbYBAMrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:47:40 -0500
Date: Fri, 1 Feb 2008 13:47:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during
	suspend/hibernation on x86-64 (bisected)
Message-ID: <20080201124702.GA31321@elte.hu>
References: <200801272229.48955.rjw@sisk.pl> <200801280226.22013.rjw@sisk.pl> <1201795128.32654.22.camel@lappy> <200801312154.33754.rjw@sisk.pl> <1201867497.32654.49.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201867497.32654.49.camel@lappy>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> The below fixes it for me..
> 
> ---
>  - restore the old wakeup mechanism
>  - fix break usage in do_each_thread() { } while_eac_thread().
>  - fix the hotplug switch stmt, a fall-through case was broken.

thanks Peter, i've picked your fix up. I hope this solves the problem 
for Rafael too.

	Ingo
