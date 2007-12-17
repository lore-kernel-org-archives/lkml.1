Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbXLQNhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbXLQNhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbXLQNhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:37:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55088 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbXLQNhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:37:45 -0500
Date: Mon, 17 Dec 2007 14:37:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: adjust enable_NMI_through_LVT0()
Message-ID: <20071217133725.GG1870@elte.hu>
References: <47611368.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47611368.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Its previous use in a call to on_each_cpu() was pointless, as at the 
> time that code gets executed only one CPU is online. Further, the 
> function can be __cpuinit, and for this to work without 
> CONFIG_HOTPLUG_CPU setup_nmi() must also get an attribute (this one 
> can even be __init; on 64-bits check_timer() also was lacking that 
> attribute).

thanks, applied.

	Ingo
