Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbZKWSU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbZKWSU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZKWSU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:20:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55387 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753758AbZKWSU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:20:26 -0500
Date: Mon, 23 Nov 2009 13:20:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jan Kara <jack@suse.cz>
cc: tmhikaru@gmail.com, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
       <linux-scsi@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
In-Reply-To: <20091123160914.GG15679@duck.suse.cz>
Message-ID: <Pine.LNX.4.44L0.0911231319060.2958-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Jan Kara wrote:

> On Mon 23-11-09 10:06:03, Alan Stern wrote:
> > On Mon, 23 Nov 2009, Jan Kara wrote:
> > 
> > >   Yeah, from what you write, it looks like USB enclosure is at fault (or it
> > > could still be your USB controller but I doubt it).  It's still a bit
> > > bothering that the error reported by the drive was not properly propagated
> > > up to VFS. Either it's some block layer retry/ignore magic that I missed or
> > > we ignore errors from block layer in some place.
> > 
> > Is there any interest in tracking this down?  It's not hard to find out
> > what low-level errors are being reported and to generate them on demand
> > with an emulated USB disk drive.
>   Well, if you could provide me with the patch, I could try to track down
> why the errors aren't propagated... It would be interesting because if it's
> not some retry logic in block layer, it's a bug in VFS ;).

I can't provide a patch without first knowing what the errors are.  The 
way to find out is to use usbmon.  See Documentation/usb/usbmon.txt for 
instructions.

Alan Stern

