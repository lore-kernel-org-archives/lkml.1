Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbYFRLnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbYFRLnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYFRLnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:43:39 -0400
Received: from www.tglx.de ([62.245.132.106]:51301 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbYFRLnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:43:37 -0400
Date: Wed, 18 Jun 2008 13:40:57 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Erik Mouw <mouw@nl.linux.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Pierre Ossman <drzeus@drzeus.cx>,
       Eric BENARD <ebenard@free.fr>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Hans J. Koch" <hjk@linutronix.de>, Russell King <rmk@arm.linux.org.uk>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 0/7] mmc: at91_mci: rework to allow better transfer
Message-ID: <20080618114057.GE2226@local>
References: <483FE9E7.7020707@atmel.com> <20080609124623.5b6bda48@mjolnir.drzeus.cx> <484E4F61.7010007@atmel.com> <20080614182831.0360bd77@mjolnir.drzeus.cx> <4858DDC1.6080802@atmel.com> <20080618104723.GA6788@gateway.home> <20080618111607.GB6788@gateway.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618111607.GB6788@gateway.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 01:16:07PM +0200, Erik Mouw wrote:
> On Wed, Jun 18, 2008 at 12:47:23PM +0200, Erik Mouw wrote:
> > On Wed, Jun 18, 2008 at 12:04:49PM +0200, Nicolas Ferre wrote:
> > 
> > [...]
> > 
> > Could you all drop =?ISO-8859-1?Q?Hans-J=FCrgen_?= from the Cc list in
> > this thread? The address is invalid because it has no domain part and
> > hence causes quite some bounces on the list because some strict email
> > checkers reject invalid addresses in the Cc list.
> > 
> > I'm trying to figure out what went wrong, but in the mean time please
> > drop =?ISO-8859-1?Q?Hans-J=FCrgen_?= from the Cc list.
> 
> Found it, Mailman is to blame. On the linux-kernel mailing list, the
> address shows up ok: "=?ISO-8859-1?Q?Hans-J=FCrgen_?=
> =?ISO-8859-1?Q?Koch?= <hjk@linutronix.de>".
> 
> What probably happens: Mailman tries to check if the addresses in the
> To and CC fields are subscribed to the list (linux-arm-kernel). If that
> is the case and the subscriber enabled "prevent doubles", it won't send
> that particular subscriber the message. Of course, this should have
> been implemented by a simple strncmp() on the To and CC fields, but I
> guess Mailman first breaks up the To and CC fields, then does the
> "prevent double" check, and then reassembles the To and CC fields.
> Apparently there is an error in the break up or reassembly. Now how to
> fix this without breaking Mailman alltogether...
> 
> In the mean time, could you just use Hans-J?rgen's address
> (hjk@linutronix.de>) and not his name in the CC field?

I avoided the German umlaut in my name by using the abbreviation "Hans
J. Koch" on mailing lists. Unfortunately, I still have one mail client
that uses the full name. I'll fix that to avoid similar trouble.

On the other hand, I used that for quite a while now, and didn't have
problems. It shouldn't be too difficult to have these programs use UTF-8
(or any other charset) properly these days.

Thanks,
Hans

> 
> 
> Erik
> [linux-arm-kernel-owner #2]
> (thanks to David Woodhouse for helping to debug the problem)
> 
> -- 
> Erik Mouw -- mouw@nl.linux.org


