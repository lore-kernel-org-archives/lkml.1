Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYFJHm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYFJHm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 03:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYFJHmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 03:42:18 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4231 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYFJHmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 03:42:17 -0400
Date: Tue, 10 Jun 2008 09:42:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       James.Bottomley@HansenPartnership.com
Subject: Re: [Bug #10614] WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x110/0x11f()
Message-ID: <20080610074215.GC20851@kernel.dk>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.XbF.I6vSIB@albercik> <20080610025848.GD19404@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080610025848.GD19404@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10 2008, Nick Piggin wrote:
> On Sat, Jun 07, 2008 at 10:42:56PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10614
> > Subject		: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x110/0x11f()
> > Submitter	: J.A. Magallón <jamagallon@ono.com>
> > Date		: 2008-05-01 02:50 (38 days old)
> > References	: http://lkml.org/lkml/2008/4/30/614
> > Handled-By	: Nick Piggin <npiggin@suse.de>
> > 		  Jens Axboe <jens.axboe@oracle.com>
> 
> Did Jens fix this up, or...?
> 
> I don't think it was ever a problem, just a false positive by the
> over eager warning code (still, obviously the warning should be
> silenced). J.A., how is the latest git tree going for you?

It's not a real problem, but the WARN() is annoying of course. I think
James had a patch queued up for the SCSI side, apparently it's not
merged yet? CC'ing James.

-- 
Jens Axboe

