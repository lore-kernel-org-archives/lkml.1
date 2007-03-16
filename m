Return-Path: <linux-kernel-owner+w=401wt.eu-S965402AbXCPQLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402AbXCPQLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965417AbXCPQLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:11:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60378 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965402AbXCPQLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:11:40 -0400
Date: Fri, 16 Mar 2007 17:11:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zilvinas Valinskas <zilvinas@wilibox.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>
Subject: Re: LOCKDEP warning if CONFIG_DETECT_SOFTLOCKUP=y
Message-ID: <20070316161100.GA9413@elte.hu>
References: <1174056925.17967.15.camel@zv.wilibox.com> <1174061105.17967.24.camel@zv.wilibox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174061105.17967.24.camel@zv.wilibox.com>
User-Agent: Mutt/1.4.2.2i
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


* Zilvinas Valinskas <zilvinas@wilibox.com> wrote:

> Hello Ingo,
> 
> I think I've found a solution for a problem. Is this sane thing to do 
> ? At least lockdep is happy now, does not complain anymore. It seems 
> that ->pi_lock was not register with lockdep correctly (something 
> about classes ... 8).

nice fix! This is a real bug that affects v2.6.21 (and v2.6.20) too.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
