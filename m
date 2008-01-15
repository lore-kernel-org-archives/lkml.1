Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYAOXHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYAOXHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYAOXHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:07:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36122 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752548AbYAOXHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:07:07 -0500
Date: Wed, 16 Jan 2008 00:07:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Chinner <dgc@sgi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Al Boldi <a1426z@gawab.com>, Valerie Henson <val.henson@gmail.com>,
       Rik van Riel <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
	fsck)
Message-ID: <20080115230714.GC3573@elf.ucw.cz>
References: <200801090022.55589.a1426z@gawab.com> <200801090740.12989.a1426z@gawab.com> <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com> <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu> <20080113171916.GB4132@ucw.cz> <20080113174125.5f39ac64@lxorguk.ukuu.org.uk> <20080115201653.GA5639@elf.ucw.cz> <20080115214325.GN155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115214325.GN155407@sgi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > What are ext3 expectations of disk (is there doc somewhere)? For
> > > > example... if disk does not lie, but powerfail during write damages
> > > > the sector -- is ext3 still going to work properly?
> > > 
> > > Nope. However the few disks that did this rapidly got firmware updates
> > > because there are other OS's that can't cope.
> > > 
> > > > If disk does not lie, but powerfail during write may cause random
> > > > numbers to be returned on read -- can fsck handle that?
> > > 
> > > most of the time. and fsck knows about writing sectors to remove read
> > > errors in metadata blocks.
> > > 
> > > > What abou disk that kills 5 sectors around sector being written during
> > > > powerfail; can ext3 survive that?
> > > 
> > > generally. Note btw that for added fun there is nothing that guarantees
> > > the blocks around a block on the media are sequentially numbered. The
> > > usually are but you never know.
> > 
> > Ok, should something like this be added to the documentation?
> > 
> > It would be cool to be able to include few examples (modern SATA disks
> > support bariers so are safe, any IDE from 1989 is unsafe), but I do
> > not know enough about hw...
> 
> ext3 is not the only filesystem that will have trouble due to
> volatile write caches. We see problems often enough with XFS
> due to volatile write caches that it's in our FAQ:
> 
> http://oss.sgi.com/projects/xfs/faq.html#wcache

Nice FAQ, yep. Perhaps you should move parts of it to Documentation/ ,
and I could then make ext3 FAQ point to it?

I had write cache enabled on my main computer. Oops. I guess that
means we do need better documentation.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
