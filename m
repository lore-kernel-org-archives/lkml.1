Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZFHNFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZFHNFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZFHNFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:05:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57697 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZFHNFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:05:21 -0400
Date: Mon, 8 Jun 2009 15:05:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
	Rearrange core suspend code)
Message-ID: <20090608130509.GA3272@elte.hu>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <200906072347.00580.rjw@sisk.pl> <20090608065419.GA13568@elte.hu> <200906081330.50045.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906081330.50045.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Monday 08 June 2009, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > +config PM_RUNTIME
> > > +	bool "Run-time PM core functionality"
> > > +	depends on PM
> > > +	---help---
> > > +	  Enable functionality allowing I/O devices to be put into energy-saving
> > > +	  (low power) states at run time (or autosuspended) after a specified
> > > +	  period of inactivity and woken up in response to a hardware-generated
> > > +	  wake-up event or a driver's request.
> > > +
> > > +	  Hardware support is generally required for this functionality to work
> > > +	  and the bus type drivers of the buses the devices are on are
> > > +	  responsibile for the actual handling of the autosuspend requests and
> > > +	  wake-up events.
> > 
> > Halleluya! :-)
> 
> I guess this means you like the general idea. ;-)
> 
> Well, we've been discussing it for quite a while and since more 
> and more people are interested, I'm giving it a high priority.

Cool. I think that if within a few years we could achieve that every 
default distro (both on desktops and on servers) triggers PM 
functionality runtime on common hardware, we'd both have lower power 
consumption in general, and we'd have more robust suspend-resume 
code as well.

It would also be far more debuggable if the various suspend/resume 
bits were triggered and used independently and runtime, allowing 
bugs to be 'spread out'. Right now if they fail they fail in a very 
hard to debug spot (in the s2ram/s2disk codepaths), which makes 
their hacking rather challenging. (which i'm sure you are well aware 
of ;-)

So yes, i like the idea, a lot.

	Ingo
