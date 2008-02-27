Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYB0NYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYB0NYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYB0NYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:24:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43770 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbYB0NYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:24:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Date: Wed, 27 Feb 2008 14:23:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Stefan Seyfried <seife@suse.de>
References: <20080225225820.GP2659@elf.ucw.cz> <20080226215641.GE10280@elf.ucw.cz> <20080227131227.GB28528@srcf.ucam.org>
In-Reply-To: <20080227131227.GB28528@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271423.12208.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 27 of February 2008, Matthew Garrett wrote:
> On Tue, Feb 26, 2008 at 10:56:41PM +0100, Pavel Machek wrote:
> 
> > Seems like pm-utils is just a thin wrapper around s2ram, at least in
> > version debian ships. It does not seem to have its own whitelist.
> 
> That's a Debian patch.
> 
> > ...so it is ready to use s2ram, but will fall back to
> > echo. Unfortunately, that will mean no video resume on _many_
> > machines.
> 
> See /usr/lib/pm-utils/sleep.d/99video .
> 
> > Pretty please, can we get s2ram for Fedora, so that video is restored
> > there?
> 
> Stefan told us at FOSDEM that s2ram was being deprecated in OpenSuse, so 
> I don't think this is the way to go.

Well, is that really correct?  Stefan??

He probably meant that the s2ram _whitelist_ is going to be deprecated, which
didn't mean s2ram altogether.

s2ram is pretty useful anyway, as it combines many mechanisms that allow us to
bring the video back to life from the user land, so you can use one binary
instead of a bunch of different programs with different command lines etc.

Thanks,
Rafael
