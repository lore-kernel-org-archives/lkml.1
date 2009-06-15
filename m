Return-Path: <linux-kernel-owner+w=401wt.eu-S1765125AbZFOSv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765125AbZFOSv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZFOSvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:51:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46427 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZFOSvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:51:20 -0400
Date: Mon, 15 Jun 2009 20:50:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615185046.GJ11248@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <20090615182348.GC11248@elte.hu> <20090615183840.GA6520@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615183840.GA6520@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> I guess. However, having the ability to call module code in NMI 
> handler context [...]

I dont think we really want to execute module-provided code from NMI 
handlers. NMI context is pretty tricky to begin with. (Yes, i know 
it's possible via nmi notifiers or modular oprofile but it's a 
really bad practice IMHO.)

	Ingo
