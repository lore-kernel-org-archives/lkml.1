Return-Path: <linux-kernel-owner+w=401wt.eu-S1764125AbYA2Ob0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764125AbYA2Ob0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764054AbYA2ObP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:31:15 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8320 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764039AbYA2ObN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:31:13 -0500
Date: Tue, 29 Jan 2008 15:31:10 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
Message-ID: <20080129143109.GW15220@kernel.dk>
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801291531.39825.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008, Oliver Neukum wrote:
> Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
> > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > >> Greg KH wrote:
>  
> > > > No difference, still just a lot of resets.
> > > > 
> > > Where you able to figure out which usb storage transport is used?
> > > 
> > > in drivers/usb/storage/usb.c you have get_protocol() and get_transport()
> > > functions. I'm not sure if these get stored in sysfs perhaps. This will
> > > pinpoint better where to look. Let me research a bit. 
> > 
> > Did the quick'n easy and dumped it. Protocol is 'Transparent SCSI' and
> > transport is 'Bulk'
> 
> You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG
> That should tell the reason for the resets.

Sure, I'll do that. Will post the results tonight.

-- 
Jens Axboe

