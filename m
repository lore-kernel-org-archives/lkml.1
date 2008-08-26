Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYHZJ7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYHZJ7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYHZJ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:59:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38751 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYHZJ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:59:03 -0400
Date: Tue, 26 Aug 2008 11:43:55 +0200
From: Pavel Machek <pavel@suse.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       teheo@novell.com, stefanr@s5r6.in-berlin.de, Martin.Leisner@xerox.com
Subject: Re: autosuspend for SCSI devices
Message-ID: <20080826094355.GA30062@elf.ucw.cz>
References: <20080822105626.GA9475@elf.ucw.cz> <200808222252.52947.rjw@sisk.pl> <20080825081901.GA32128@elf.ucw.cz> <200808251055.45582.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808251055.45582.oneukum@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-08-25 10:55:44, Oliver Neukum wrote:
> Am Montag 25 August 2008 10:19:01 schrieb Pavel Machek:
> > From: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Add support for autosuspend/autoresume of the SCSI devices. Lowlevel
> > driver can use it to spin the disk down... and it is neccessary step
> > for powering down the controllers.
> > 
> > Spinning down the disk is useful - saves ~0.5W here, and it is last
> > major thing we can do to save power on some small machines like
> > Kohjinsha subnotebooks.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> Hi,
> 
> firstly, it doesn't consider error handling before suspending.

What problems do you see with error handling? This patch does not
touch the error handling, and I do not think it needs to touch it.

> Secondly, it is simply not true that in SCSI suspending the disks
> is always necessary before suspending the controller.

Ok, will fix the changelog... but it is still true at least for USB
controllers.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
