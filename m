Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZGYU4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZGYU4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 16:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZGYU4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 16:56:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55418 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZGYU4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:56:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>,
       John Linville <linville@tuxdriver.com>
Subject: Re: [Acpi4asus-user] [PATCH 2.6.31] rfkill: allow toggling soft state in sysfs again
Date: Sat, 25 Jul 2009 22:56:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: acpi4asus-user@lists.sourceforge.net,
       Darren Salt <linux@youmustbejoking.demon.co.uk>,
       debian-eeepc-devel@lists.alioth.debian.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thiemo Nagel <thiemo.nagel@ph.tum.de>,
       Corentin Chary <corentin.chary@gmail.com>
References: <4A5716AA.5000903@ph.tum.de> <507E47A184%linux@youmustbejoking.demon.co.uk> <1247262952.26071.1.camel@johannes.local>
In-Reply-To: <1247262952.26071.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252256.44570.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009, Johannes Berg wrote:
> On Fri, 2009-07-10 at 22:09 +0100, Darren Salt wrote:
> > I demand that Johannes Berg may or may not have written...
> > 
> > > Apparently there actually _are_ tools that try to set this in sysfs even
> > > though it wasn't supposed to be used this way without claiming first.
> > 
> > Then it should have been documented as such. I don't see anything about this
> > in Documentation/rfkill.txt (as found in 2.6.30), other than a vague
> > statement that "Kernel handles events", which isn't exactly helpful :-\
> 
> Oh, it's not just that rfkill was horrible, the documentation matched :)
> All the SHOUTING in it about what you must and must not do but nothing
> actually helpful :)
> 
> > > *shrug*, I don't like it, but whatever...
> > 
> > I do. It means that we have a nice simple text-based interface for use in
> > scripts (for now), and a binary interface which is better suited to the likes
> > of desktop applications.
> 
> Indeed, and as long as you expect to only use soft toggle... problem is
> that you won't know whether it's soft-toggled or not while it's
> hard-blocked (off)!
> 
> > > Please test & report.
> > 
> > With the patch applied, Bluetooth toggling is working again, so you get to
> > add this:
> > 
> > Tested-By: Darren Salt <linux@youmustbejoking.demon.co.uk>
> 
> Ok, John, please pick up the patch.

Is there anything going on with the patch?

Surely it's not in -rc4.

Rafael
