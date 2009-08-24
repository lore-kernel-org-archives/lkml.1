Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZHXSo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZHXSo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZHXSo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:44:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51077 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZHXSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:44:26 -0400
Date: Mon, 24 Aug 2009 20:44:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com, tytso@mit.edu,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090824184421.GC28403@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <87f94c370908240621n32ea310sd24196084c42107a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87f94c370908240621n32ea310sd24196084c42107a@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +Either whole sector is correctly written or nothing is written during
> > +powerfail.
> > +
> > +       Because RAM tends to fail faster than rest of system during
> > +       powerfail, special hw killing DMA transfers may be necessary;
> > +       otherwise, disks may write garbage during powerfail.
> > +       This may be quite common on generic PC machines.
> > +
> > +       Note that atomic write is very hard to guarantee for RAID-4/5/6,
> > +       because it needs to write both changed data, and parity, to
> > +       different disks. (But it will only really show up in degraded mode).
> > +       UPS for RAID array should help.
> 
> Can someone clarify if this is true in raid-6 with just a single disk
> failure?  I don't see why it would be.
> 
> And if not can the above text be changed to reflect raid 4/5 with a
> single disk failure and raid 6 with a double disk failure are the
> modes that have atomicity problems.

I don't know enough about raid-6, but... I said "degraded mode" above,
and you can read it as double failure in raid-6 case ;-). I'll prefer
to avoid too many details here.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
