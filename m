Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbYBRLGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbYBRLGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbYBRLGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:06:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42279 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811AbYBRLGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:06:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch] suspend/resume self-test
Date: Mon, 18 Feb 2008 12:04:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080130131748.GA3796@elf.ucw.cz> <20080218095325.GA7198@elf.ucw.cz> <200802180240.47510.david-b@pacbell.net>
In-Reply-To: <200802180240.47510.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802181204.37666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of February 2008, David Brownell wrote:
> > >   - Includes a command line parameter, which needs work yet ... it
> > >     currently turns this test off, but it should also let the target
> > >     state be specified (and maybe even default to "no test").
> 
> I think "no test" should be the default;

Agreed.

> STR working sanely on x86 is unfortunately too much a surprise.

Well, out of 4 boxes I have, one doesn't resume from suspend, but this is the
one that's terminally broken otherwise. :-)

> Someone more active in PM testing should update that.
> 
> 
> > > Also includes some Kconfig tweaks to help reduce configuration bugs on
> > > x86, by avoiding the legacy RTC driver when the generic RTC framework
> > > is enabled ... those should become a separate patch.
> 
> That's already been split out in a separate patch, now in MM.
> Though it may deserve another tweak, forcing off *all* legacy
> RTC drivers if the new framework is enabled.

Yes, the legacy drivers shoule depend on !(new framework).

Thanks,
Rafael
