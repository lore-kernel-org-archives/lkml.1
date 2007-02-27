Return-Path: <linux-kernel-owner+w=401wt.eu-S932817AbXB0Gft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbXB0Gft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 01:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932851AbXB0Gft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 01:35:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60759 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932817AbXB0Gfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 01:35:48 -0500
Date: Tue, 27 Feb 2007 07:29:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mbligh@google.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI handler
Message-ID: <20070227062913.GC1259@elte.hu>
References: <20061126231833.GA22241@Krystal> <1164585589.16871.52.camel@localhost.localdomain> <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com> <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com> <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com> <20070227035456.GA15444@Krystal> <1172550161.5517.210.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172550161.5517.210.camel@imap.mvista.com>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> The pit clocksource could be dropped pretty easy with my clocksource 
> update patches, which I'm still working on but you could easily drop 
> clock sources that aren't atomic like the pit .. Also the pit is 
> generally undesirable, so it's not going to be missed.

that's totally unacceptable, and i'm amazed you are even suggesting it - 
often the PIT ends up being the most reliable hardware clock in a PC. 
Btw., what's wrong with the spinlock that is protecting PIT access? It 
expresses the non-atomic property of the PIT just fine.

	Ingo
