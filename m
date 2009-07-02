Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZGBQL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZGBQL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZGBQLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:11:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38380 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbZGBQLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:11:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jeremy Maitin-Shepard" <jeremy@jeremyms.com>
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by encrypting page cache
Date: Thu, 2 Jul 2009 18:12:00 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
References: <87hbxx0wcp.fsf@jeremyms.com> <200907020041.52198.rjw@sisk.pl> <87r5x0ypev.fsf@jeremyms.com>
In-Reply-To: <87r5x0ypev.fsf@jeremyms.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907021812.01147.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 July 2009, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > [snip]
> 
> > What is the particular attach scenario you'd like to prevent
> 
> The standard cold boot attack, which basically allows the attacker to
> obtain a copy of the data in RAM.  System is powered on.  RAM is
> optionally cooled.  RAM is then quickly removed from the original
> machine, placed in another machine, and copied.  See
> http://en.wikipedia.org/wiki/Cold_boot_attack
> 
> The wikipedia page links to this Youtube video that nicely demonstrates
> the attack:
> 
> http://www.youtube.com/watch?v=JDaicPIgn9U
> 
> The cooling helps to preserve the data for longer, but is not always
> even necessary.  Special hardware is not even needed.  Depending on
> whether the BIOS clears the memory during the POST, it might also be
> possible to do the attack on the same machine (i.e. without having to
> move the RAM into another machine) by rebooting it and booting from
> e.g. a CD-ROM or USB drive.
> 
> > [snip]
> 
> > There's one problem with this approach, which is that we're not sure if the
> > encrypted pages won't be written to by someone else.  TuxOnIce makes the
> > assumption that it won't, but that has yet to be demonstrated.
> 
> Yes, it certainly depends on that assumptions, but it is not necessarily
> a problem that it does.
> 
> There are really two parts to that assumption:
> 
> 1. Whether the current Linux kernel in a particular (or perhaps any)
>    configuration _does_ satisfy that assumption.

This hasn't been verified.

> 2. Whether Linux _should_ satisfy that assumption.  This is important
>    because if something comes along later that violates the assumption,
>    it would be nice to be able to consider that something a bug and fix
>    it.

This hasn't even been discussed.

> It is really the second part that is most important, though evaluating
> the extent to which the first part holds would help in determining the
> feasibility of the second part.

That depends on whether or not the TuxOnIce approach to hibernation is
implemented in the mainline kernel.  I'm still going to work on this, although
at the moment I'm working on some things that I regard as more urgent, but
since it's going to affect multiple subsystems, we'll need to discuss this.

The timing is not particularly good for that, though.

Best,
Rafael
