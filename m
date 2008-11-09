Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYKICSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYKICSr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 21:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYKICSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 21:18:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:35819 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbYKICSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 21:18:37 -0500
Subject: Re: [PATCH 1/1] irq: Maintain user set affinity
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Andrew Morton <akpm@osdl.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <86802c440811081601w2be45e55hc400095137831b85@mail.gmail.com>
References: <Pine.LNX.4.64.0811041030520.25054@blarg.am.freescale.net>
	 <86802c440811081412u6d54beaam143801ce83225f40@mail.gmail.com>
	 <1226182645.13603.90.camel@pasglop>
	 <86802c440811081601w2be45e55hc400095137831b85@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 09 Nov 2008 13:17:39 +1100
Message-Id: <1226197059.13603.92.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> for MSI, affinity is set two times.
> 
> also in dynamic_irq_init is setting with
> #ifdef CONFIG_SMP
>         cpus_setall(desc->affinity);
> #endif
> 
> it seems should use irq_default_affinity instead of CPU_MASK_ALL directly there.

That sounds more like it.

Cheers,
Ben.


