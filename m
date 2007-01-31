Return-Path: <linux-kernel-owner+w=401wt.eu-S1030441AbXAaReX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030441AbXAaReX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030443AbXAaReW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:34:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38634 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030441AbXAaReW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:34:22 -0500
Date: Wed, 31 Jan 2007 18:33:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 23/23] clocksource tsc: add verify routine
Message-ID: <20070131173308.GG4468@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033810.319576375@mvista.com> <20070131124300.GG1847@elte.hu> <1170262956.9781.117.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170262956.9781.117.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > firstly, it allows a circular verification dependency in 
> > highres+dyntick mode between the jiffies and tsc clocksources.
> 
> In the current implementation, it's only happens if the only clocks 
> that exist are "tsc" and "jiffies" which makes verification impossible 
> anyway .. It's unlikely, but it is possible , the fix is not that 
> complex.

yes, the fix is not that complex and it already exists: Thomas' 
clocksource-add-verification-watchdog-helper.patch. You said before that 
Thomas' code was unnecessarily generic, but your version contained at 
least one bug, despite having had review feedback about precisely that 
issue.

	Ingo
