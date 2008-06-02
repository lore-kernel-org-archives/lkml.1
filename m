Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYFBJn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYFBJn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYFBJnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:43:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36714 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYFBJnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:43:21 -0400
Date: Mon, 2 Jun 2008 11:43:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, macro@ds2.pg.gda.pl
Subject: Re: i8259: fix final uglyness
Message-ID: <20080602094308.GD26242@elte.hu>
References: <20080520151528.GA1596@elf.ucw.cz> <20080520204750.GA31409@elte.hu> <20080521094402.GB12763@elf.ucw.cz> <alpine.LFD.1.10.0805222030050.3295@apollo.tec.linutronix.de> <20080522223232.GA1602@elf.ucw.cz> <alpine.LFD.1.10.0805271043220.3295@apollo.tec.linutronix.de> <20080527085541.GA1708@elf.ucw.cz> <alpine.LFD.1.10.0805271100450.3295@apollo.tec.linutronix.de> <20080528104257.GD5728@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528104257.GD5728@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> > > > > Introduce IRQx_VECTOR on 32-bit, so that #ifdef noise is kept 
> > > > > down. There should be no object code change.
> > > > 
> > > > thanks for doing this. The patch fails due to other changes in 
> > > > this area (especially the hw_irq.h unification). Can you please 
> > > > redo against:
> 
> Done.

applied to tip/x86/irq, thanks Pavel.

	Ingo
