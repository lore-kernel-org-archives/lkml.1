Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbYGULFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbYGULFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYGULF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:05:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55568 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYGULF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:05:28 -0400
Date: Mon, 21 Jul 2008 13:05:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: improve double fault handling
Message-ID: <20080721110510.GC10782@elte.hu>
References: <4880A912.76E4.0078.0@novell.com> <4881263B.7060700@zytor.com> <48846B02.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48846B02.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> > This patch doesn't apply for me to the extent that I'm hesitant to 
> > fix it up manually.  Could you please refresh it against current 
> > -linus?
> 
> Make the double fault handler use CPU-specific stacks. Add some 
> abstraction to simplify future change of other exception handlers to 
> go through task gates. Add a new notification of the event through the 
> die notifier chain, also providing some environmental adjustments so 
> that various infrastructural things work independent of the fact that 
> the fault and the callbacks are running on other then the normal 
> kernel stack.

this still doesnt apply to latest -git. (or tip/master)

	Ingo
