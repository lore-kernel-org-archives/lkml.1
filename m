Return-Path: <linux-kernel-owner+w=401wt.eu-S1751206AbZL1I0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbZL1I0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbZL1I0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:26:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53652 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZL1I0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:26:44 -0500
Date: Mon, 28 Dec 2009 09:26:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Myron Stowe <myron.stowe@hp.com>
Subject: Re: -tip: origin tree build failure
Message-ID: <20091228082632.GH28652@elte.hu>
References: <20091217075025.GA314@elte.hu>
 <alpine.LFD.2.00.0912261448100.4089@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912261448100.4089@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> ...
> > build failure on x86, for CONFIG_ACPI=n && CONFIG_IPMI_SI=y:
> > 
> >  drivers/char/ipmi/ipmi_si_intf.c:3208: error: 'ipmi_pnp_driver' undeclared (first use in this function)
> ...
> 
> > -#ifdef CONFIG_PNP
> > +#ifdef CONFIG_ACPI
> >  	pnp_register_driver(&ipmi_pnp_driver);
> >  #endif
> ...
> 
> Hi Ingo,
> As my tree inflicted this one and I don't see your patch upstream,
> I'll include your fix with my "for -rc2" push.

Thanks!

	Ingo
