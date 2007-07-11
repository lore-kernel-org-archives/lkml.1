Return-Path: <linux-kernel-owner+w=401wt.eu-S934466AbXGKVH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934466AbXGKVH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934334AbXGKVGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:06:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51813 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934330AbXGKVGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:06:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 23:14:15 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Miklos Szeredi <miklos@szeredi.hu>, a1426z@gawab.com, jeremy@goop.org,
       pavel@ucw.cz, nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <87644rcc7a.fsf@jbms.ath.cx> <46954212.7060105@rtr.ca>
In-Reply-To: <46954212.7060105@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707112314.16500.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 July 2007 22:48, Mark Lord wrote:
> Jeremy Maitin-Shepard wrote:
> >>
> > I'll certainly admit the kexec idea is vaporware currently, but it does
> > differ in a significant way from freezer-based approaches, such that I
> > don't think it should be referred to as just another implementation of a
> > freezer.  Specifically, it doesn't require that the "old kernel" be in a
> > "consistent" state to a greater extent than suspend to ram; it is the
> > case that all of the devices must be quiesced or shut down to some
> > extent, but doing this without races and deadlocks (and without the
> > freezer) is certainly very, very similar to what needs to be done for
> > suspend to ram, which will need to be solved anyway.  Unlike the
> > existing hibernate approaches, however, it will not be necessary to use
> > any of the driver infrastructure once switched to the "save image"
> > kernel, and thus it will not matter what locks are held, for instance.
> 
> I really doubt that kexec(a special kernel) is going to solve anything here.
> The new kernel will have to initialize, probe for devices, etc.
> Which will take time.
> Which will slow down hibernate to an unacceptable degree.
> Right now, it (TuxOnIce) is *very* fast.
> Adding 10 seconds or so for reprobing/resetting/reiniting devices
> is not going to be useful.
> And modifying all of the drivers to *not* do their usual probe sequence
> sounds rather intrusive and is likely also a non-starter here.
> 
> Or is it?

Well, we're going to change what the drivers do during hibernation
for other reasons, so it may well be non-issue.  Still, we can only speculate
until it's done.

Which is why I think that the present discussion is premature.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
