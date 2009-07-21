Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZGUKcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZGUKcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZGUKcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:32:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51277 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbZGUKcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:32:05 -0400
Date: Tue, 21 Jul 2009 12:31:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: tridge@samba.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090721103158.GG4133@elf.ucw.cz>
References: <19028.3736.892828.352905@samba.org> <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <1247066878.4159.153.camel@mulgrave.site> <20090708163736.0f98e7e0@lxorguk.ukuu.org.uk> <1247069202.4159.212.camel@mulgrave.site> <20090708171848.21633768@lxorguk.ukuu.org.uk> <873a96a23x.fsf@devron.myhome.or.jp> <87hbxhwv0j.fsf@devron.myhome.or.jp> <19045.14307.658887.752950@samba.org> <4A65875D.7030902@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A65875D.7030902@panasas.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >   - Similarly, there is a small chance that chkdsk on Windows will
> >     rename one file in a directory if they happen to have the same 11
> >     byte dummy values. The probability of this happening is
> >     approximately 80x lower than with the previous patch.
> > 
> 
> What if we had a user mode utility that does these short-names
> renames that a user can optionally run after umount? since it
> only writes the (random) short-names it's also safe.

Actually, why not having dosfsck creating _matching_ short names for
long names? As it only writes short names, it should be safe :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
