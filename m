Return-Path: <linux-kernel-owner+w=401wt.eu-S937152AbXG2VgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937152AbXG2VgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935705AbXG2Vfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:35:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:45078 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935779AbXG2Vfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=e0YVuVkdsvly3sFZy2ae/8nPj1H80i4FvOjEpm3NhdmN4PodZbiQCAgOdU25gi2udh0HvLeVPuNAt4UABsveiWQy8jZjjd6wAAH+GWtyZWBj2oyKVFb6w/uumcoK9P+fLoBkqM9vFH87TukUlXqhT+HhKvarFGDYFS0ogYB2y+g=
Subject: Re: [PATCH 2/2] Introduce CONFIG_SUSPEND
From: Richard Hughes <hughsient@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200707292336.55588.rjw@sisk.pl>
References: <200707251238.50218.lenb@kernel.org>
	 <200707292317.21419.rjw@sisk.pl> <20070729211824.GL16817@stusta.de>
	 <200707292336.55588.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 29 Jul 2007 22:30:40 +0100
Message-Id: <1185744640.2295.4.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-29 at 23:36 +0200, Rafael J. Wysocki wrote:
> On Sunday, 29 July 2007 23:18, Adrian Bunk wrote:
> > On Sun, Jul 29, 2007 at 11:17:20PM +0200, Rafael J. Wysocki wrote:
> > > On Sunday, 29 July 2007 22:40, Adrian Bunk wrote:
> > > > On Sun, Jul 29, 2007 at 02:38:05PM +0200, Rafael J. Wysocki wrote:
> > > > >...
> > > > > +config SUSPEND
> > > > > +	bool "Suspend"
> > > >              "Suspend to RAM"
> > > 
> > > Not only.  This also includes "standby".
> > 
> > Whatever it includes - please tell it to the user in the prompt.
> > 
> > Technical issues are important, but it's often forgotten how many 
> > problems people run into because the description of a kconfig option 
> > could have been better.
> 
> Sure.  Please see the updated patch I've just sent. :-)

So are you guys using:

"standby" = idle state, ~0.5 seconds
"suspend" = sleep to ram, ~10 seconds
"hibernate" = sleep to disk, ~30 seconds

If so - you rock. This is the common nomenclature I've been pushing for
a few months now in GNOME, KDE and general userspace. I've written up a
spec here:
http://cvs.gnome.org/viewcvs/*checkout*/gnome-power-manager/docs/sleep-names.html

Richard.


