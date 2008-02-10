Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYBJVV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYBJVV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbYBJVVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:21:20 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:56006 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYBJVVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:21:19 -0500
Date: Sun, 10 Feb 2008 22:21:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080210212124.GA14739@uranus.ravnborg.org>
References: <20080205190600.GB11613@elf.ucw.cz> <200802082301.51582.rjw@sisk.pl> <20080208220834.GA1631@elf.ucw.cz> <200802090118.50418.rjw@sisk.pl> <47ACF488.7070502@zytor.com> <20080210211457.GJ15662@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210211457.GJ15662@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 10:14:57PM +0100, Pavel Machek wrote:
> On Fri 2008-02-08 16:32:08, H. Peter Anvin wrote:
> > Rafael J. Wysocki wrote:
> >>
> >> Consolidated patch is appended.  I'll test it tomorrow on x86-64.
> >>
> >> I'd like to add the cleaned up beeping code to it and perhaps try to push it
> >> for -mm testing without any further changes.  We can still do more cleanups in
> >> followup patches.
> >>
> >
> > The other thing to figure out is to what extent we can clean up the 
> > conditionals in the video mode code by refactoring.  All they really do 
> > here is save space by removing functionality not needed for wakeup, because 
> > I didn't know how much space was realistic.
> >
> > It's possible we can remove them altogether by having a dummy boot_params 
> > structure (4K).
> 
> I'd say that few #ifdefs are acceptable if we save 4K, but...
> 
> Sam... is there something that urgently needs fixing?

I will prepare some build system bits later.
So please use what you have today and I can always clean it up
when I have something better.

So for the bits I have competence in - no issues.

	Sam
