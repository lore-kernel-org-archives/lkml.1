Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYKFJDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYKFJDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYKFJDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:03:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbYKFJDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:03:40 -0500
Date: Thu, 6 Nov 2008 10:03:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] x86: Don't allow nr_irqs > NR_IRQS
Message-ID: <20081106090329.GD4890@elte.hu>
References: <1225819102.3074.15.camel@achroite> <1225886687.3074.59.camel@achroite> <20081105191126.GA23548@localhost> <1225912531.3074.73.camel@achroite>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225912531.3074.73.camel@achroite>
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


* Ben Hutchings <bhutchings@solarflare.com> wrote:

> On Wed, 2008-11-05 at 22:11 +0300, Cyrill Gorcunov wrote:
> [...]
> > Ben I didn't manage to get a look over ACPI related changes
> > (ie to find the reason why the kernel is able to reveal 5 IO-APICs
> >  now
> [...]
> 
> I was mistaken; that *isn't* a recent change.  A default RHEL 5 
> kernel (based on 2.6.18) also finds 5 IOAPICs.

yes - it's simply a box with a lot of IO-APICs. That's not bad at all, 
it spreads out IRQ processing amongst devices.

	Ingo
