Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbXH2SQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbXH2SQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXH2SQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:16:51 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18370 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbXH2SQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:16:51 -0400
Date: Wed, 29 Aug 2007 20:16:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22 oops kernel BUG at block/elevator.c:366!
Message-ID: <20070829181648.GD7932@kernel.dk>
References: <200708291950.14513.arekm@maven.pl> <200708292004.36426.arekm@maven.pl> <20070829180800.GC7932@kernel.dk> <200708292011.47134.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708292011.47134.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> On Wednesday 29 of August 2007, Jens Axboe wrote:
> > On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > > On Wednesday 29 of August 2007, Jens Axboe wrote:
> > > > On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > > > > I guess I should sent these here since it looks like not scsi bug
> > > > > anyway.
> > > >
> > > > It's stex, right? It seems to have some issues with multiple
> > > > completions of commands, which craps out the block layer of course.
> > >
> > > Yes, stex. I'm staying with 2.6.19 in that case since it works fine in
> > > that version.
> > >
> > > So scsi bug ... 8-)
> >
> > And you based that conclusion on what exactly?
> 
> Isn't drivers/scsi/* handled by linux-scsi@? (that's what I mean)

Yep indeed, I thought you meant that it was a scsi bug (and not an stex
one). You could try and copy the 2.6.19 stex driver into 2.6.20 and see
if that works, though.

-- 
Jens Axboe

