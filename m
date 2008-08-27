Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYH0Tbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYH0Tbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 15:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYH0Tba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 15:31:30 -0400
Received: from ns.firmix.at ([62.141.48.66]:2858 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbYH0Tb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 15:31:29 -0400
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
From: Bernd Petrovitsch <bernd@firmix.at>
To: Jamie Lokier <jamie@shareable.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
In-Reply-To: <20080827175152.GA27491@shareable.org>
References: <20080826205916.GB11734@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	 <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
	 <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>
	 <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>
	 <1219827609.30209.29.camel@spike.firmix.at>
	 <f7848160808270556q54c36270ye6a465d2ca123cc@mail.gmail.com>
	 <1219843032.30209.51.camel@spike.firmix.at>
	 <20080827154805.GA25387@shareable.org>
	 <1219855121.30209.112.camel@spike.firmix.at>
	 <20080827175152.GA27491@shareable.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 27 Aug 2008 21:30:31 +0200
Message-Id: <1219865431.3475.3.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.345 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.345 required=5
X-Spam-Score: -2.345 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2008-08-27 at 18:51 +0100, Jamie Lokier wrote:
> Bernd Petrovitsch wrote:
[...]
> It is, but the idea that small embedded systems go through a 'all
> components are known, drivers are known, test and if it passes it's
> shippable' does not always apply.

Not always but often enough. And yes, there is ARM-based embedded
hardware with 1GB Flash-RAM and 128MB RAM.

> > > I'm seriously thinking of forwarding porting the 4 year old firmware
> > > from 2.4.26 to 2.6.current, just to get new drivers and capabilities.
> > 
> > That sounds reasonable (and I never meant maintaining the old system
> > infinitely.
> 
> Sounds reasonable, but it's vetoed for anticipated time and cost,

That is to be expected;-)

[....]
> > ACK. We avoid MMU-less hardware too - especially since there is enough
> > hardware with a MMU around.
> 
> I can't emphasise enough how much difference MMU makes to Linux userspace.
> 
> It's practically: MMU = standard Linux (with less RAM), have everything.
> No-MMU = lots of familiar 'Linux' things not available or break.

ACK. And tell that a customer that everything is more effort and more
risk and not just "simply cross-compile it as it runs on my desktop
too".

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

