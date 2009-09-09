Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbZIIIKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbZIIIKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZIIIKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:10:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZIIIKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:10:49 -0400
Date: Wed, 9 Sep 2009 10:10:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, swetland@google.com
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090909081045.GA28615@elf.ucw.cz>
References: <20090903041429.GA29875@kroah.com> <20090906052819.GE1324@ucw.cz> <20090907201205.23173985@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907201205.23173985@caramujo.chehab.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-09-07 20:12:05, Mauro Carvalho Chehab wrote:
> Em Sun, 6 Sep 2009 07:28:19 +0200
> Pavel Machek <pavel@ucw.cz> escreveu:
> 
> > Hi!
> > 
> > > 	  Note, Pavel has been adding some of the Dream hardware
> > > 	  drivers, which are separate from the core Android drivers.  I
> > > 	  have no objection to those, but they should work to get merged
> > > 	  to their "correct" places in the tree in another release or
> > > 	  so.
> > 
> > Well, some of those drivers should be moderately easy (touchscreen),
> > but some (camera) will take longer than that. For example camera --
> > contains _lots_ of code, and uses obsolete v4l api.
> 
> The usage of the obsolete V4L API is a problem since we aren't accepting any
> drivers with the old API for a long time, doing large efforts to convert the
> few remaining ones to V4L2 API.

Understood.

> This probably means also that they are not using the current V4L framework. Are
> they already somewhere at the staging tree?

It will appear in drivers/staging/dream/camera in 2.6.32 or so. It
should be in -next by now.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
