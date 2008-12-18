Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753378AbYLRMk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYLRMk0 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYLRMkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:40:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47314 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbYLRMkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:40:13 -0500
Date: Thu, 18 Dec 2008 13:39:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: TSC not updating after resume: Bug or Feature?
Message-ID: <20081218123924.GH25715@elte.hu>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <1229536210.30177.21.camel@localhost.localdomain> <1229592279.9487.133.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229592279.9487.133.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Rafael, would something like this explain why we had to revert Shaggy's 
> patch? His patch fixes the backward motion filter and I'm at an utter 
> loss why that would break suspend.

yes, i'd love to have this commit reinstated:

 5b7dba4: sched_clock: prevent scd->clock from moving backwards

and the bug triggered by hibernation fixed instead.

	Ingo
