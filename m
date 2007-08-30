Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbXH3L3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbXH3L3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 07:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXH3L3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 07:29:43 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:58014 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXH3L3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 07:29:42 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.22 oops kernel BUG at block/elevator.c:366!
Date: Thu, 30 Aug 2007 13:29:37 +0200
User-Agent: PLD Linux KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       "Ed Lin" <ed.lin@promise.com>
References: <200708291950.14513.arekm@maven.pl> <200708292011.47134.arekm@maven.pl> <20070829181648.GD7932@kernel.dk>
In-Reply-To: <20070829181648.GD7932@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <200708301329.37396.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 of August 2007, Jens Axboe wrote:
> On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > On Wednesday 29 of August 2007, Jens Axboe wrote:
> > > On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > > > On Wednesday 29 of August 2007, Jens Axboe wrote:
> > > > > On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > > > > > I guess I should sent these here since it looks like not scsi bug
> > > > > > anyway.
> > > > >
> > > > > It's stex, right? It seems to have some issues with multiple
> > > > > completions of commands, which craps out the block layer of course.
> > > >
> > > > Yes, stex. I'm staying with 2.6.19 in that case since it works fine
> > > > in that version.
> > > >
> > > > So scsi bug ... 8-)
> > >
> > > And you based that conclusion on what exactly?
> >
> > Isn't drivers/scsi/* handled by linux-scsi@? (that's what I mean)
>
> Yep indeed, I thought you meant that it was a scsi bug (and not an stex
> one). You could try and copy the 2.6.19 stex driver into 2.6.20 and see
> if that works, though.

Looks like this bug is known for months :-(

Ed Lin pointed to http://lkml.org/lkml/2007/1/23/268 with possible patch (that 
unfortunately serialises access to storage devices, well...)

There is also: http://bugzilla.kernel.org/show_bug.cgi?id=7842

I'm running 2.6.22 with that patch now, did huge (few hours) rsync that 
previously caused oopses and now everything works properly.

Can we get some form of this patch into Linus tree?

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
