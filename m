Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbZAKPgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbZAKPgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZAKPfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:35:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55923 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbZAKPfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:35:52 -0500
Date: Sun, 11 Jan 2009 16:35:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dieter Ries <clip2@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
Message-ID: <20090111153548.GB7401@elte.hu>
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496A107A.2090301@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Dieter Ries <clip2@gmx.de> wrote:

> Ingo Molnar schrieb:
> > * Dieter Ries <clip2@gmx.de> wrote:
> > 
> >> Hi,
> >>
> >> I just pulled 2.6.29-rc1, ran oldconfig with defaults and built it.
> >> When I try to boot it, that kind of works until init should start. Then
> >> nothing happens. I tried with init=/bin/bash, which sometimes works, and
> >> sometimes gets me a bash without the prompt flashing.
> >>
> >> I captured the output with netconsole, but I cannot see a problem there.
> >> It is attached.
> >>
> >> My config is also attached.
> >>
> >> The machine:
> >>
> >> Lenovo Thinkpad T60
> >> Core2Duo 2GHz
> >>
> >> Gentoo 64bit
> >>
> >> Everything worked fine with 83bc66f, which was my last pull.
> >>
> >> What else should I provide for debugging that?
> > 
> > hm, there's no 83bc66f in Linus's tree.
> 
> Sorry, thats because I applied Timo Hoenigs patch for the fingerprint
> reader. So the right commit where it worked is 6680598.
> 
> Before pulling today, I reverted that patch, to avoid conflicts, so I
> guess it should not matter.

in the 6680598..v2.6.29-rc1 window there's more than 3000 commits: there 
were libata and IDE changes, x86 changes, cpumask changes, ACPI changes 
and more. Any of those categories could produce such error symptoms as 
your box is showing.

Unless you can see some particular badness in the kernel messages 
(something that changed to the last working version) that narrows it down 
to some subsystem, i suspect this would have to be bisected ...

	Ingo
