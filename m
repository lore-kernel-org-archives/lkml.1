Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbYJ0Pdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbYJ0Pdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYJ0PdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:33:18 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49625 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbYJ0PdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:33:17 -0400
Subject: Re: usb hdd problems with 2.6.27.2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
       Luciano Rocha <luciano@eurotux.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0810271117530.4059-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0810271117530.4059-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 10:33:12 -0500
Message-Id: <1225121592.5146.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 11:25 -0400, Alan Stern wrote:
> On Mon, 27 Oct 2008, Douglas Gilbert wrote:
> > BTW a single disk in RAID 0 (seen on a HP E200 controller)
> > has a shortened capacity value seen in the midlevel on the
> > corresponding logical drive. That missing chunk is probably
> > where the RAID controller puts its control information.
> > Anyway, playing with the capacity value returned by READ
> > CAPACITY certainly has a precedent.
> 
> usb-storage isn't in the business of altering the data it gets from a 
> device.  It's just a transport.  That's why the sdev->fix_capacity flag 
> exists; we tell the upper layer that the data it gets is going to be 
> wrong and let the upper layer worry about fixing things up.

And you do this by setting US_FL_FIX_CAPACITY in unusual_devs.h

James


