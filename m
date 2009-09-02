Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZIBU4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZIBU4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 16:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZIBU4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 16:56:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52364 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbZIBU4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 16:56:14 -0400
Date: Wed, 2 Sep 2009 22:55:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Theodore Tso <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
       Ric Wheeler <rwheeler@redhat.com>, Rob Landley <rob@landley.net>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Message-ID: <20090902205558.GB2398@elf.ucw.cz>
References: <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.01.0908300152490.5744@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0908300152490.5744@bogon.housecafe.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-08-30 02:01:10, Christian Kujau wrote:
> On Sun, 30 Aug 2009 at 09:51, Pavel Machek wrote:
> > > give system administrators.  It's better than the fear-mongering
> > > patches you had proposed earlier, but what would be better *still* is
> > > telling people why running with degraded RAID arrays is bad, and to
> > > give them further tips about how to use RAID arrays safely.
> > 
> > Maybe this belongs to Doc*/filesystems, and more detailed RAID
> > description should go to md description?
> 
> Why should this be placed in *kernel* documentation anyway? The "dangers 
> of RAID", the hints that "backups are a good idea" - isn't that something 
> for howtos for sysadmins? No end-user will ever look into

The fact that two kernel subsystems (MD RAID, journaling filesystems)
do not work well together is surprising and should be documented near
the source.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
