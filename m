Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYLLS5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYLLS5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYLLS4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:56:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49177 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbYLLS4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:56:39 -0500
Date: Fri, 12 Dec 2008 19:58:20 +0100
From: Pavel Machek <pavel@suse.cz>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Message-ID: <20081212185820.GF11974@elf.ucw.cz>
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com> <b637ec0b0811261145q3c7af010l1db0480d13b41715@mail.gmail.com> <492DAC81.4020803@s5r6.in-berlin.de> <200811270002.29537.rjw@sisk.pl> <b637ec0b0811270717t360ce5f9j3d48e8a007010b0e@mail.gmail.com> <b637ec0b0811271354l58fc6039m941ca37fb9173d5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b637ec0b0811271354l58fc6039m941ca37fb9173d5b@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-11-27 22:54:14, Fabio Comolli wrote:
> Hi
> 
> On Thu, Nov 27, 2008 at 4:17 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> > Hi
> >
> > On Thu, Nov 27, 2008 at 12:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> Actually, yes, Fabio, you can try to revert all of the "ACPI: EC:" commits
> >> applied after 2.6.27.4 and retest.
> >
> > Will do tonight. I see that there are some other "ACPI: EC:" commits
> > in 2.6.27.6 and 2.6.27.7.
> >
> > I'l just compile the ec.c file from 2.6.27.4 in 2.6.27.7 and test if
> > the three commits introduced in 2.6.27.5 wouldn't revert cleanly,
> >
> > By the way, my HD passed a "smartctl -t long" test without any problems.
> >
> 
> Reproduced with 2.6.27.7 with ec.c taken from 2.6.27.4 - after three
> minutes of freeze the laptop came back to normal as nothing had
> happened.

Is it possible to turn on printk timing, or something? If it is
desktop machine, is there chance to pull some data out of the machine
during resume (serial console, debug leds?).

Could you use Linus' RTC debugging hack, then hard reset machine after
1.5minute to see where it spends most of the time?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
