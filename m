Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYFJOwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYFJOwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYFJOwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:52:22 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33363 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbYFJOwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:52:21 -0400
Subject: Re: [Bug #10614] WARNING: at include/linux/blkdev.h:431
	blk_queue_init_tags+0x110/0x11f()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "J.A." =?ISO-8859-1?Q?Magall=F3n?= <jamagallon@ono.com>
In-Reply-To: <20080610074215.GC20851@kernel.dk>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dCRO4tbfLzK.A.XbF.I6vSIB@albercik> <20080610025848.GD19404@wotan.suse.de>
	 <20080610074215.GC20851@kernel.dk>
Content-Type: text/plain; charset=utf8
Date: Tue, 10 Jun 2008 09:52:16 -0500
Message-Id: <1213109536.3627.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 09:42 +0200, Jens Axboe wrote:
> On Tue, Jun 10 2008, Nick Piggin wrote:
> > On Sat, Jun 07, 2008 at 10:42:56PM +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.25.  Please verify if it still should be listed.
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10614
> > > Subject		: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x110/0x11f()
> > > Submitter	: J.A. Magallón <jamagallon@ono.com>
> > > Date		: 2008-05-01 02:50 (38 days old)
> > > References	: http://lkml.org/lkml/2008/4/30/614
> > > Handled-By	: Nick Piggin <npiggin@suse.de>
> > > 		  Jens Axboe <jens.axboe@oracle.com>
> > 
> > Did Jens fix this up, or...?
> > 
> > I don't think it was ever a problem, just a false positive by the
> > over eager warning code (still, obviously the warning should be
> > silenced). J.A., how is the latest git tree going for you?
> 
> It's not a real problem, but the WARN() is annoying of course. I think
> James had a patch queued up for the SCSI side, apparently it's not
> merged yet? CC'ing James.

Um ... why are you cc'ing me?  Tomo suggested a fix, but you applied
your own so I didn't apply his:

commit aa94b5371f6f898558d9fa5690cc6e4bf917a572
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Wed May 7 09:27:43 2008 +0200

    block: adjust tagging function queue bit locking

Since the date of the fix is after the date of the report, just have the
reporter reverify with a later kernel.

James


