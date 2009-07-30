Return-Path: <linux-kernel-owner+w=401wt.eu-S1751333AbZG3NtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbZG3NtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbZG3NtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:49:07 -0400
Received: from fifo99.com ([67.223.236.141]:44545 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZG3NtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:49:06 -0400
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
From: Daniel Walker <dwalker@fifo99.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20090730150456.6c87b997@skybase>
References: <200907291717.n6THHG6f001426@d06av06.portsmouth.uk.ibm.com>
	 <20090730125351.6f16e9ec@skybase> <1248958173.6046.32.camel@desktop>
	 <20090730150456.6c87b997@skybase>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 06:49:10 -0700
Message-Id: <1248961750.6046.35.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 15:04 +0200, Martin Schwidefsky wrote:
> On Thu, 30 Jul 2009 05:49:33 -0700
> Daniel Walker <dwalker@fifo99.com> wrote:
> 
> > On Thu, 2009-07-30 at 12:53 +0200, Martin Schwidefsky wrote:
> > 
> > > > I'm not sure allowing that type of override a good idea tho .. I don't
> > > > think it's considered a usable clock when the rating goes to zero.
> > > 
> > > Override as the root user -> your foot, no? The whole override stuff is
> > > there for the case that the clocksource selection picked a broken clock
> > > and you want to force the system into a semi-working state. Ideally the
> > > whole override would go away, but that is probably wishful thinking..
> > 
> > I would agree if the system doesn't crash as a result, if it just starts
> > to operate funny then that's maybe acceptable. If you keep the change
> > rating function, you could potentially remove the unregister path..
> 
> Why shouldn't it be possible to have a clocksource as a module? I think
> that the unregister path should stay. To really make it work we'd need
> a function to force the system out of the one-shot mode though.

Because I don't think there is a sane reason to allow it. It should be
more like if someone has a need for it, then let them add back the
unregister path and explain why they need it.

Daniel

