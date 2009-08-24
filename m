Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbZHXSjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbZHXSjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZHXSjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:39:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37614 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZHXSjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:39:07 -0400
Date: Mon, 24 Aug 2009 20:39:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Florian Weimer <fweimer@bfk.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com, tytso@mit.edu,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090824183902.GA28403@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82k50tjw7u.fsf@mid.bfk.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +Linux block-backed filesystems can only work correctly when several
> > +conditions are met in the block layer and below (disks, flash
> > +cards). Some of them are obvious ("data on media should not change
> > +randomly"), some are less so.
> 
> You should make clear that the file lists per-file-system rules and
> that some file sytems can recover from some of the error conditions.

Ok, I added "Not all filesystems require all of these
to be satisfied for safe operation" sentence there.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
