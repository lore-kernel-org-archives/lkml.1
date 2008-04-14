Return-Path: <linux-kernel-owner+w=401wt.eu-S1752410AbYDNJCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbYDNJCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYDNJC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:02:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35945 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbYDNJC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:02:26 -0400
Date: Mon, 14 Apr 2008 11:02:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86 git tree broken (bisected)
Message-ID: <20080414090204.GH19865@elte.hu>
References: <200804102159.14563.rjw@sisk.pl> <86802c440804130124l2b0cb199x4d75f2df68f93fa4@mail.gmail.com> <86802c440804130141uf7d5553s2e1b9eb43877d399@mail.gmail.com> <200804131814.13629.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804131814.13629.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > >  Please boot kernel with "debug"...
> > >
> > >  I want to verify if you can get
> > >
> > >  "
> > >  Aperture conflicts with PCI mapping.
> > >  "
> > >
> > >  in your boot log...
> > >
> > 
> > then with this patch for io allocation overlapping...
> 
> The kernel works correctly with this patch applied.

thanks guys - i've applied the fix/workaround.

	Ingo
