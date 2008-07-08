Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYGHHVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYGHHVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYGHHU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:20:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44409 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYGHHU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:20:56 -0400
Date: Tue, 8 Jul 2008 09:21:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080708072152.GD1761@elf.ucw.cz>
References: <20080623160052.GA7616@ldl.fc.hp.com> <20080627191458.GA10872@ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net> <20080707160658.GB1794@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-07-07 17:37:18, Altobelli, David wrote:
> Pavel Machek wrote:
> > Hi!
> >
> >>>> A driver for the HP iLO/iLO2 management processor, which allows
> >>>> userspace programs to query the management processor. Programs can
> >>>> open a channel to the device (/dev/hpilo/dXccbN), and use this to
> >>>> send/receive queries.
> >>>
> >>> What kind of queries? Is there documentation somewhere?
> >>
> >> Generally, it can get data out of the management processor - things
> >> like basic iLO configuration (users, nic, etc), handle SNMP traffic,
> >> flashing iLO, and some others.
> >>
> >> Unfortunately, there isn't yet any available documenation.
> >
> > Ok, I guess we should have documentation "what does it do" and "what
> > protocol does it speak" before we can think about merging.
> 
> I really hope that isn't the case.

Telling us "what does it do" seems like good start.

> However, I do think there is value in merging the driver without docs.
> Having drivers in tree is often stated as a goal, because of the obvious
> security and API/ABI disadvantages to out of tree drivers.

You know, we'd prefer to have kernel<->user ABI documented. With this
driver... we don't.

What does /dev/hpilo/* do? Beep speakers? Control fans? Launch atomic
bombs? What will happen on cat /bin/bash > /dev/hpilo/dXccbN? Does
that depend on concrete machine? Is it acceptable for this
functionality not to be abstracted out? (Kernel should provide hw
abstraction, right?)

> If this can't be merged, then we continue to ship an out of tree driver,
> which no one (us, distros, customers) likes.  We pester our partners to
> support this driver, or include it, or what have you.  We get slowly
> out of date, and bugs creep in, or our package breaks on upstream kernels.
> To me, it seems like merging the driver is the better path.

Docs for kernel<->user ABI does not seem like too much to ask.

If you wrote a driver, I don't think it is unreasonable for me to ask
"how to use that driver".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
