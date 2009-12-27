Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbZL1UHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbZL1UHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 15:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZL1UHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 15:07:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55282 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZL1UHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 15:07:12 -0500
Date: Sun, 27 Dec 2009 12:10:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Jeff Garzik <jeff@garzik.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.33-rc0 regression: 256MB CF card no longer recognized in
	PCMCIA slot
Message-ID: <20091227111027.GB1398@ucw.cz>
References: <20091219215459.GB9011@elf.ucw.cz> <4B2D54E7.9060508@garzik.org> <20091220095248.GC6029@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220095248.GC6029@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-20 10:52:48, Dominik Brodowski wrote:
> Hey,
> 
> On Sat, Dec 19, 2009 at 05:34:15PM -0500, Jeff Garzik wrote:
> > On 12/19/2009 04:55 PM, Pavel Machek wrote:
> > >Hi!
> > >
> > >Subject pretty much says it all... I do get some messages on the
> > >console, I'll try to gather them.
> > 
> > Which driver(s) no longer see it?  Do you think it's the PCMCIA
> > subsystem, IDE, libata or other?
> 
> My suspicion is that it might be kernel/resource.c -- Pavel, does this patch
> fix the issue you're seeing?

It seems fixed in -rc2, good.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
