Return-Path: <linux-kernel-owner+w=401wt.eu-S1031145AbXDYPw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031145AbXDYPw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161764AbXDYPwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:52:25 -0400
Received: from mx33.mail.ru ([194.67.23.194]:27352 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031108AbXDYPvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:51:14 -0400
Date: Wed, 25 Apr 2007 19:48:20 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: [PATCH 0/7] Battery class, external power framework, ds2760 battery
Message-ID: <20070425154820.GA27300@zarina>
Reply-To: cbou@mail.ru
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I believe most battery issues elaborated and settled, and battery
class has grown up for the -mm merge. Also, I hope that current
battery stuff will make everyone happy at some grade.

This patchset accumulated ideas and suggestions from reviews by
David Brownell, Evgeniy Polyakov, Greg KH, Henrique de Moraes Holschuh,
Ian Molton, Matt Reimer, Matthew Garrett, Ondrej Zajicek,
Paul Sokolovsky, Pavel Machek, Randy Dunlap, Russell King and
Shem Multinymous.

Thanks for the time you spent reviewing these patches!

On Tue, Apr 24, 2007 at 10:41:08PM +0200, Pavel Machek wrote:
> > > > Signed-off-by: Anton Vorontsov <cbou@mail.ru>
> > >
> > > Yes please. Generic battery support is badly needed.
> >
> > I'm glad you like it, thanks for the review!
> >
> > Also I've done some code split. It removes all #ifdefs from battery.c,
> > and also separates core from sysfs and leds.
> >
> > If there will no objections, I'll send this version when patch window
> > will opened.
>
> Actually, you probably want to add some changelogs, and send it to
> akpm _now_. He'll merge it to -mm tree, and hopefully send it upstream
> in the next window. Merging directly to linus is for bigger projects
> with git trees etc.

Andrew, would you please merge these patches into -mm? They're against
today's Linus git tree.

I hope it isn't too late for the merge. If it is, please tell me when I
should come back.

References:
http://lkml.org/lkml/2007/4/11/392
http://lkml.org/lkml/2007/4/11/393
http://lkml.org/lkml/2007/4/11/397
http://lkml.org/lkml/2007/4/11/398
http://lkml.org/lkml/2007/4/20/154

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
