Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbYKMLMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbYKMLMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYKMLLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:11:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbYKMLLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:11:54 -0500
Date: Thu, 13 Nov 2008 12:11:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Nelson <markn@au1.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] genirq: __irq_set_trigger: change pr_warning to
	pr_debug
Message-ID: <20081113111136.GA27573@elte.hu>
References: <200811131730.11506.markn@au1.ibm.com> <20081113074300.GC1723@elte.hu> <200811132137.41863.markn@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811132137.41863.markn@au1.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Nelson <markn@au1.ibm.com> wrote:

> Commit 0c5d1eb77a8be917b638344a22afe1398236482b (genirq: record 
> trigger type) caused powerpc platforms that had no set_type() 
> function in their struct irq_chip to spew out warnings about "No 
> set_type function for IRQ...". This warning isn't necessarily 
> justified though because the generic powerpc platform code calls 
> set_irq_type() (which in turn calls __irq_set_trigger) with 
> information from the device tree to establish the interrupt 
> mappings, regardless of whether the PIC can actually set a type.
> 
> A platform's irq_chip might not have a set_type function for a 
> variety of reasons, for example: the platform may have the type 
> essentially hard-coded, or as in the case for Cell interrupts are 
> just messages past around that have no real concept of type, or the 
> platform could even have a virtual PIC as on the PS3.
> 
> Signed-off-by: Mark Nelson <markn@au1.ibm.com>
> ---
> Thanks Ingo! Much appreciated
> 
>  kernel/irq/manage.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to tip/irq/urgent, thanks Mark!

	Ingo
