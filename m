Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZCYVXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZCYVXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZCYVW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:22:56 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60616 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754842AbZCYVWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:22:55 -0400
Subject: Re: Linux 2.6.29
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <49CA9324.6010407@redhat.com>
References: <20090324093245.GA22483@elte.hu>
	 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	 <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu>
	 <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>
	 <20090324184549.GE32307@mit.edu>
	 <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>
	 <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk>
	 <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk>
	 <49CA8ADA.3040709@redhat.com> <49CA9114.3040205@garzik.org>
	 <49CA9324.6010407@redhat.com>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 21:22:50 +0000
Message-Id: <1238016170.3281.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 16:25 -0400, Ric Wheeler wrote:
> Jeff Garzik wrote:
> > Ric Wheeler wrote:> And, as I am sure that you do know, to add insult 
> > to injury, FLUSH_CACHE
> >> is per device (not file system).
> >>
> >> When you issue an fsync() on a disk with multiple partitions, you 
> >> will flush the data for all of its partitions from the write cache....
> >
> > SCSI'S SYNCHRONIZE CACHE command already accepts an (LBA, length) 
> > pair.  We could make use of that.
> >
> > And I bet we could convince T13 to add FLUSH CACHE RANGE, if we could 
> > demonstrate clear benefit.
> >
> >     Jeff
> 
> How well supported is this in SCSI?  Can we try it out with a commodity 
> SAS drive?

What do you mean by well supported?  The way the SCSI standard is
written, a device can do a complete cache flush when a range flush is
requested and still be fully standards compliant.  There's no easy way
to tell if it does a complete cache flush every time other than by
taking the firmware apart (or asking the manufacturer).

James


