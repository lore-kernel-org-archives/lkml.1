Return-Path: <linux-kernel-owner+w=401wt.eu-S933897AbZINU0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbZINU0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933829AbZINU0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:26:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33987 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733AbZINU0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:26:03 -0400
Date: Mon, 14 Sep 2009 22:25:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pierre Ossman <pierre-list@ossman.eu>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Christoph Hellwig <hch@lst.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Message-ID: <20090914202558.GA10398@elf.ucw.cz>
References: <20090907125130.GA1595@ucw.cz> <87ljko5k3v.fsf@devron.myhome.or.jp> <20090910192354.GD23356@elf.ucw.cz> <87bplim1ce.fsf@devron.myhome.or.jp> <20090911200922.GF8137@elf.ucw.cz> <c4e36d110909111414n716a06b1mdd0cd741230595b5@mail.gmail.com> <20090911213204.GC25544@elf.ucw.cz> <c4e36d110909111445nb6592cfue01543f5d04c2cda@mail.gmail.com> <20090911215117.GA11441@elf.ucw.cz> <20090914220510.5558d215@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914220510.5558d215@mjolnir.ossman.eu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-09-14 22:05:10, Pierre Ossman wrote:
> On Fri, 11 Sep 2009 23:51:17 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > On Fri 2009-09-11 23:45:01, Zdenek Kabelac wrote:
> > > 
> > > Well system could check basic card ids if they match after resume - if
> > > some users wants to crash his card by randomly swapping it during
> > > suspend/resume - I'd have no problem with that....
> > 
> > Well, I do have small problem with that :-).
> > 
> > Anyway, patch for rechecking IDs would probably be accepted, but
> > that's not how it works now.
> 
> It _does_ check the card id when you have UNSAFE_RESUME selected. It
> doesn't just hook up whatever card you happen to have in the slot with
> your old block device. I may have a lot of opponents when it comes
> to my suspend design choices, but I'm not completely crazy. ;)

:-) Ok, ok. Patch checking filesystem timestamps would be welcome in
that case ;-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
