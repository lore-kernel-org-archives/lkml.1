Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbYGRQqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbYGRQqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbYGRQqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:46:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38397 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYGRQqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:46:08 -0400
Date: Fri, 18 Jul 2008 18:45:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] SGI UV: TLB shootdown extended apic mode
Message-ID: <20080718164554.GD6875@elte.hu>
References: <E1KGJNb-0003qF-5E@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KGJNb-0003qF-5E@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> Set or clear the UV hub's extended apic mode based on the kernel's 
> setting. This cannot be done safely in the prom, as the kernel may set 
> the mode.
> 
> The kernel's setting of extended apic mode is indicated by global 
> "x2apic".
> 
> Diffed against 2.6.26-rc9 (Ingo's tip-latest)

applied to tip/x86/uv, thanks Cliff.

	Ingo
