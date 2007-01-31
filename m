Return-Path: <linux-kernel-owner+w=401wt.eu-S1030374AbXAaRYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030374AbXAaRYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030430AbXAaRYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:24:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58382 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030374AbXAaRYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:24:00 -0500
Date: Wed, 31 Jan 2007 18:22:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 09/23] clocksource: add block notifier
Message-ID: <20070131172207.GF4468@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033805.815147778@mvista.com> <20070131101710.GB22377@elte.hu> <1170257152.9781.36.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170257152.9781.36.camel@imap.mvista.com>
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

> > secondly, CLOCKSOURCE_NOTIFY_REGISTER is only used by the core 
> > clocksource code and no register-notifier interface is exposed: this 
> > makes the whole thing an expensive NOP.
> 
> I don't know what you mean when you say "no register-notifier 
> interface is exposed" .. The timekeeping code doesn't use this 
> notification , but it really should. [...]

what i say is that there's no public interface exposed of this notifier
(and even if there was, there isnt any user of it) and there's only a
single notifier used internally: this means that this thing is an
expensive function call.

	Ingo
