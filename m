Return-Path: <linux-kernel-owner+w=401wt.eu-S1765512AbYDPOeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765512AbYDPOeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765361AbYDPOeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:34:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53286 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765339AbYDPOef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:34:35 -0400
Date: Wed, 16 Apr 2008 16:34:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [TEST PATCH] Test NMI kprobe modules
Message-ID: <20080416143408.GG24383@elte.hu>
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416134735.GA13399@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416134735.GA13399@Krystal>
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


* Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> +long debug_eip, debug_cs, debug_eflags, debug_extra, debug_extra2, debug_extra3, debug_extra4;
> +long debugo_eip, debugo_cs, debugo_eflags, debugo_extra, debugo_extra2, debugo_extra3, debugo_extra4;
> +EXPORT_SYMBOL(debug_eip);
> +EXPORT_SYMBOL(debug_cs);
> +EXPORT_SYMBOL(debug_eflags);
> +EXPORT_SYMBOL(debug_extra);
> +EXPORT_SYMBOL(debug_extra2);
> +EXPORT_SYMBOL(debug_extra3);
> +EXPORT_SYMBOL(debug_extra4);
> +EXPORT_SYMBOL(debugo_eip);
> +EXPORT_SYMBOL(debugo_cs);
> +EXPORT_SYMBOL(debugo_eflags);
> +EXPORT_SYMBOL(debugo_extra);
> +EXPORT_SYMBOL(debugo_extra2);
> +EXPORT_SYMBOL(debugo_extra3);
> +EXPORT_SYMBOL(debugo_extra4);

ok, while this is a test patch of yours, lets make one thing sure: all 
things hook-alike instrumentation _MUST_ and will stay stay GPL 
exported. It's all very internal, and there will be no automatic, 
programmable interface stability guarantees for any of the markers that 
kabi crap could come and shackle the kernel with ... (it will all be 
stable to SystemTap of course - but SystemTap is a kernel-internal 
entity in that regard)

	Ingo
