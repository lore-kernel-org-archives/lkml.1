Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYD2ON1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYD2ON1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYD2ONS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:13:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35297 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbYD2ONR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:13:17 -0400
Date: Tue, 29 Apr 2008 16:13:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] disable softlockup detection at boottime
Message-ID: <20080429141300.GA26461@elte.hu>
References: <20080423201613.GA8546@sgi.com> <20080428165544.GE18210@elte.hu> <20080428185252.GC1167@sgi.com> <20080429123522.GK31271@elte.hu> <20080429124426.GA20775@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429124426.GA20775@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0019]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> > ah, sorry. But ... perhaps using threshold -1 would be the most 
> > intuitive setting? (for 'infinite timeout' ==> softlockup detector 
> > turned off) That way it all becomes configurable as part of the 
> > threshold? No strong opinion though.
> 
> Having the ability to switch it off dynamically would be nice to have, 
> but will need a little work yet.  Any solution should also minimize 
> the amount of time spent in softlockup_tick.
> 
> Either '0' or '-1' seems OK to me, but if '-1' turns it off, do we 
> allow a value of '0'?.

i think <= 0 should be the condition for "off". That means both -1 and 0 
would be OK.

	Ingo
