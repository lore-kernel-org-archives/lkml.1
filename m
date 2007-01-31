Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXAaLvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXAaLvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933091AbXAaLvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:51:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36216 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090AbXAaLvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:51:49 -0500
Date: Wed, 31 Jan 2007 12:49:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: [PATCH 13/23] timekeeping: move sysfs layer/drop API calls
Message-ID: <20070131114929.GC1847@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033807.107454281@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033807.107454281@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4704]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> This moves the timekeeping sysfs override layer into timekeeping.c and 
> removes the get_next_clocksource and select_clocksource functions, and 
> their component variables, since they are no longer used.

please do these two changes in at least two separate phases. Like for 
the timer.c code movement i'd not do the big code shuffling just now, 
and even if it's done, it should be a /pure/ movement, with all 
preparatory and post changes done in separate patches. That way the 
individual changes are much more reviewable.

	Ingo
