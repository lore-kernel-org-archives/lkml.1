Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbZC0UF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbZC0UF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZC0UFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:05:13 -0400
Received: from THUNK.ORG ([69.25.196.29]:55932 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbZC0UFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:05:11 -0400
Date: Fri, 27 Mar 2009 16:04:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: aaron@assonance.org
Cc: Gene Heskett <gene.heskett@verizon.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327200452.GB6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, aaron@assonance.org,
	Gene Heskett <gene.heskett@verizon.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090327112438.GQ6239@mit.edu> <alpine.LFD.2.00.0903271058060.3994@localhost.localdomain> <20090327190339.GW6239@mit.edu> <200903271519.10921.gene.heskett@verizon.net> <20090327194836.GZ6239@mit.edu> <727e50150903271301l36cff340l33e813bf6f77b4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <727e50150903271301l36cff340l33e813bf6f77b4b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 04:01:50PM -0400, Aaron Cohen wrote:
> > And of course, if you want *all* of ext4's benefits, including the
> > full factor of 6-8 improvement in fsck times, then you will be best
> > served by creating a new ext4 filesystem from scratch and doing a
> > backup/reformat/restore pass.
> >
> >
> Does a newly create ext4 partition have all the various goodies enabled that
> I'd want, or do I also need to tune2fs some parameters to get an "optimal"
> setup?

A newly created ext4 partition created with e2fsprogs 1.41.x will have
all of the various goodies enabled.  Note that some of what "goodies"
are enabled are controlled by the mke2fs.conf file, which some
distribution packages treat as a config file, so you need to make sure
it is appropriately updated when you update e2fsprogs.

						- Ted
