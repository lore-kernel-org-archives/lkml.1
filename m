Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbYBCW1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbYBCW1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYBCW1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:27:16 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60631 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbYBCW1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:27:16 -0500
Date: Sun, 3 Feb 2008 23:27:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: wakeup code translated to .c
Message-ID: <20080203222719.GB6456@uranus.ravnborg.org>
References: <20080130120111.GB22820@elf.ucw.cz> <200802031857.02422.rjw@sisk.pl> <20080203181648.GA1629@elf.ucw.cz> <20080203184931.GA2648@uranus.ravnborg.org> <20080203222407.GC2799@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203222407.GC2799@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 11:24:07PM +0100, Pavel Machek wrote:
> On Sun 2008-02-03 19:49:31, Sam Ravnborg wrote:
> > On Sun, Feb 03, 2008 at 07:16:48PM +0100, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > This version works on 32-bit, and builds on 64-bit (but I'm pretty
> > > > > sure it does not work. 32-bit code probably needs to go into rm/....)
> > > > > 
> > > > 
> > > > Do you have an updated version or is this the latest one?
> > > 
> > > I'm glad you ask ;-). Here's reasonably-recent version (I have
> > > slightly cleaner one, but it got obscured by 2.6.24-git merge), I
> > > eventually got it to work on 64-bit, by reusing trampoline.S code.
> > > 
> > > 								Pavel
> > > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > Hi PAvel.
> > 
> > Before you submit this for real we need me to take a deper
> > look into your Makefiles.
> 
> Ok, lets get this right.
> 
> > We do not want this duplication between boot and acpi.
> > And the way you deal with code sharing from boot/ is not
> > OK either.
> 
> Well, current version has one copy in .c, then two duplicate .S
> version, based on older code.... so few duplicate Makefiles do not
> seem like huge deal.
It is more the single files that just include another .c file.

Can you drop me an updated patch sometime Monday - I already lost
the inital mail and I guess you continue your updates.

	Sam
