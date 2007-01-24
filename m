Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023AbXAXUKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbXAXUKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbXAXUKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:10:52 -0500
Received: from homer.mvista.com ([63.81.120.158]:33127 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbXAXUKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:10:51 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070124193822.GA28259@elte.hu>
References: <20070123211159.178138000@localhost.localdomain>
	 <1169604991.19471.95.camel@imap.mvista.com>
	 <20070124070701.GA17654@elte.hu>
	 <1169631016.19471.175.camel@imap.mvista.com>
	 <20070124095157.GA21346@elte.hu>
	 <1169634220.19471.197.camel@imap.mvista.com>
	 <1169637237.21181.164.camel@localhost.localdomain>
	 <1169654001.19471.231.camel@imap.mvista.com>
	 <20070124160046.GA24798@elte.hu>
	 <1169655076.19471.241.camel@imap.mvista.com>
	 <20070124193822.GA28259@elte.hu>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 12:09:32 -0800
Message-Id: <1169669372.19471.274.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 20:38 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > you are also misunderstanding the change. While the TSC is the only 
> > > unstable clocksource right now, the previous code tied the TSC to 
> > > the >pm-timer< clocksource. This change makes it generic, hence the 
> > > TSC can be verified by a hpet-only system (no pm-timer) as well. 
> > > Systems without a pm-timer and with a TSC are quite common. So it 
> > > solves a real problem.
> > 
> > Using my patch set a TSC specific watchdog could be created that isn't 
> > tied a another specific clock. [...]
> 
> in other words: Thomas was right with his approach and your criticism 
> against the generic code was unjustified. (I agree with the other points 
> of Thomas as well, so i'm going with his patchset for now.)

I think his approach was wrong that's why I'm resistant to his
implementation .. However, if he _demands_ to verify the TSC my patchset
provides the functionality to allow him to do it in a _clean_ manner
which meets the constraints that you and he have provided.

Daniel

