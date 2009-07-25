Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZGYWqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZGYWqE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 18:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZGYWqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 18:46:03 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39753 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZGYWqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 18:46:02 -0400
Date: Sat, 25 Jul 2009 18:35:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       acpi4asus-user@lists.sourceforge.net,
       Darren Salt <linux@youmustbejoking.demon.co.uk>,
       debian-eeepc-devel@lists.alioth.debian.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thiemo Nagel <thiemo.nagel@ph.tum.de>,
       Corentin Chary <corentin.chary@gmail.com>
Subject: Re: [Acpi4asus-user] [PATCH 2.6.31] rfkill: allow toggling soft
	state in sysfs again
Message-ID: <20090725223505.GA2729@tuxdriver.com>
References: <4A5716AA.5000903@ph.tum.de> <507E47A184%linux@youmustbejoking.demon.co.uk> <1247262952.26071.1.camel@johannes.local> <200907252256.44570.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200907252256.44570.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 10:56:43PM +0200, Rafael J. Wysocki wrote:
> On Friday 10 July 2009, Johannes Berg wrote:
> > On Fri, 2009-07-10 at 22:09 +0100, Darren Salt wrote:
> > > I demand that Johannes Berg may or may not have written...
> > > 
> > > > Apparently there actually _are_ tools that try to set this in sysfs even
> > > > though it wasn't supposed to be used this way without claiming first.
> > > 
> > > Then it should have been documented as such. I don't see anything about this
> > > in Documentation/rfkill.txt (as found in 2.6.30), other than a vague
> > > statement that "Kernel handles events", which isn't exactly helpful :-\
> > 
> > Oh, it's not just that rfkill was horrible, the documentation matched :)
> > All the SHOUTING in it about what you must and must not do but nothing
> > actually helpful :)
> > 
> > > > *shrug*, I don't like it, but whatever...
> > > 
> > > I do. It means that we have a nice simple text-based interface for use in
> > > scripts (for now), and a binary interface which is better suited to the likes
> > > of desktop applications.
> > 
> > Indeed, and as long as you expect to only use soft toggle... problem is
> > that you won't know whether it's soft-toggled or not while it's
> > hard-blocked (off)!
> > 
> > > > Please test & report.
> > > 
> > > With the patch applied, Bluetooth toggling is working again, so you get to
> > > add this:
> > > 
> > > Tested-By: Darren Salt <linux@youmustbejoking.demon.co.uk>
> > 
> > Ok, John, please pick up the patch.
> 
> Is there anything going on with the patch?
> 
> Surely it's not in -rc4.

commit f54c142725ad2ba33c3ee627873cb6966bf05447
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Fri Jul 10 21:41:39 2009 +0200

    rfkill: allow toggling soft state in sysfs again
    
    Apparently there actually _are_ tools that try to set
    this in sysfs even though it wasn't supposed to be used
    this way without claiming first. Guess what: now that
    I've cleaned it all up it doesn't matter and we can
    simply allow setting the soft-block state in sysfs.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Tested-By: Darren Salt <linux@youmustbejoking.demon.co.uk>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Didn't make -rc4, should be in -rc5.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
