Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbXE3ODo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbXE3ODo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXE3OCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:02:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899AbXE3OCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:02:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Date: Wed, 30 May 2007 16:04:22 +0200
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org> <20070530124027.GA27942@srcf.ucam.org> <1180531067.24891.1.camel@nigel.suspend2.net>
In-Reply-To: <1180531067.24891.1.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705301604.23312.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 May 2007 15:17, Nigel Cunningham wrote:
> On Wed, 2007-05-30 at 13:40 +0100, Matthew Garrett wrote:
> > On Wed, May 30, 2007 at 01:49:21PM +0200, Pavel Machek wrote:
> > 
> > (Trimmed the Cc:s quite heavily - I think this has gone somewhere beyond 
> > the original point)
> > 
> > > Notice that we want to be able to suspend while hibernating -- for
> > > suspend to both behaviour. So drivers may _not_ rely on system being
> > > runnable.
> > 
> > So keep the driver layers read-only and unfreeze the processes after 
> > doing the atomic copy.
> 
> I know you probably won't care, but that's not an option for Suspend2 -
> I get the possibility of a full image by overwriting LRU pages that were
> saved prior to the atomic copy.

This generally is a problem, not only for suspend2. :-)

Once you've unfrozen the user land, we can't rely on the hibernation image any
more, because some tasks may cause the on-disk filesystems' state to change.

Greetings,
Rafael
