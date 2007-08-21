Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbXHUKUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbXHUKUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXHUKUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:20:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52131 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbXHUKUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:20:40 -0400
Date: Tue, 21 Aug 2007 12:20:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821102023.GA24111@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <1187629438.8541.40.camel@localhost> <20070820180810.GA25160@elte.hu> <p73lkc5zl2m.fsf@bingen.suse.de> <20070821070922.GA16695@elte.hu> <20070821100717.GA692@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821100717.GA692@one.firstfloor.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.0.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2358]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Aug 21, 2007 at 09:09:22AM +0200, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > You should just be using idle notifiers instead instead of adding 
> > > more and more custom hooks (like NOHZ has already) x86-64 still 
> > > has them and there is a old patch around to add them to i386.
> > 
> > these are specially placed callbacks that we want to call from 
> > certain ACPI codepaths but not from all of them.
> 
> Because you believe TSC only stops in C2 and C3? That's not correct on 
> all systems.

i know there are some incredibly broken (but rare) boxes where the bios 
will report it only knows C1 and do C2? Is that the case you are 
referring to, or is there something else too?

	Ingo
