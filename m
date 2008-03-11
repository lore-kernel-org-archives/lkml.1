Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYCKI25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYCKI25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYCKI2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:28:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46907 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYCKI2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:28:49 -0400
Date: Tue, 11 Mar 2008 09:28:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
Message-ID: <20080311082815.GA25110@elte.hu>
References: <200803110014.52985.rjw@sisk.pl> <47D5D4E7.1060900@garzik.org> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <20080310200021.ef5b186e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310200021.ef5b186e.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > There's a newer patch in
> > 
> > 	http://lkml.org/lkml/2008/3/10/343
> > 
> > which I think should replace the 2008/3/10/91 one, but which needs 
> > testing.
> > 
> > Jeff, does that one ("keep rd->online and cpu_online_map in sync") fix the 
> > problem for you?
> > 
> > (Andrew - I saw you say that the older patch fixed things for you, does 
> > the newer one - on its own - also do so?)
> > 
> 
> Yes, it does.

great. I've picked it up too and will push it through the test-grind.

	Ingo
