Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbZGBVtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbZGBVtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZGBVti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:49:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60379 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZGBVth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:49:37 -0400
Date: Thu, 2 Jul 2009 23:49:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702214933.GE1485@ucw.cz>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu> <20090701151727.38928bd9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701151727.38928bd9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Ultimately, though, requiring that every single possible device be
> > tested is probably not reasonable, so the best way to do this testing
> > is the way do most of our testing; we do basic due diligence, but then
> > we merge it into mainline and let our huge user community try it out.
> > If there are regressions we can work through those issues if and when
> > they arise.
> 
> From the funnies we've had in the past with FAT my gut impression is
> there are only a few implementations out there. Psion seems to have their
> own but most of the rest behave remarkably similarly which makes me
> suspect they all licensed a tiny number of implementations (DRDOS one
> perhaps ?). If we can keep most of those devices mounted 8.3 we nicely
> sidestep the issue anyway.

I'm pretty sure there's more. There's stuff such as 'make your own mp3
player with pic and few more circuits'. I'd actually expect many mp3
players to be affected by this; many are really cheap & nasty.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
