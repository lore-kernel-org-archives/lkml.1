Return-Path: <linux-kernel-owner+w=401wt.eu-S1751547AbZGaFdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbZGaFdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 01:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZGaFdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 01:33:43 -0400
Received: from fifo99.com ([67.223.236.141]:41031 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZGaFdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 01:33:43 -0400
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
From: Daniel Walker <dwalker@fifo99.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1248987409.3374.5.camel@localhost>
References: <200907291717.n6THHG6f001426@d06av06.portsmouth.uk.ibm.com>
	 <20090730125351.6f16e9ec@skybase> <1248958173.6046.32.camel@desktop>
	 <20090730150456.6c87b997@skybase>  <1248961750.6046.35.camel@desktop>
	 <1248974187.3331.6.camel@work-vm>  <1248977320.6046.66.camel@desktop>
	 <1248987409.3374.5.camel@localhost>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 22:33:50 -0700
Message-Id: <1249018430.6046.73.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 13:56 -0700, john stultz wrote:
> On Thu, 2009-07-30 at 11:08 -0700, Daniel Walker wrote:
> > On Thu, 2009-07-30 at 10:16 -0700, john stultz wrote:
> > > Clocksources as modules was one of the initial design goals I had way
> > > back. The benefit being that an older distro kernel could be made to
> > > support newer stranger hardware via a clocksource driver. While the
> > > hardware vendors have for the most part consolidated on HPET/ACPI PM
> > > which has mostly avoided the need, I still think its worth preserving.
> > 
> > If the PIT case is a real use case for unregister than we can keep it
> > around. If not, then that path just becomes unused and all unused code
> > is open for removal from my perspective.
> > 
> > If the case you describe above is a good one, then someone eventually
> > will add back the unregister path. Which should come with a good reason
> > and with an actual user of the code..
> 
> The case I describe above is one where the user of the code doesn't
> necessarily have the ability to add back the unregister path. 

I'm not sure I understand your example.. Your saying a situation where
the kernel can't modified and reloaded, and the hardware clocks aren't
fully implemented in code yet?

> Old distro kernels can be difficult to make changes to when new hardware
> is later released, so being able to just backport a module, compile and
> load it to get a unexpectedly strange new bit of hardware to work with
> an older distro kernel seems valuable enough to keep the code around to
> me.

You can just as easily back port the code as a built in, and reload the
kernel right? Why would it need to be a module?

Daniel

