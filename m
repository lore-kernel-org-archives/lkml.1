Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbXFTOBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbXFTOBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbXFTOBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:01:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56407 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753094AbXFTOBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:01:41 -0400
Date: Wed, 20 Jun 2007 10:01:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mattia Dongili <malattia@linux.it>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] can't suspend on vaio sz (rc4 and rc5 are ok)
 [was Re: 2.6.22-rc4-mm2]
In-Reply-To: <20070620052222.GA4452@inferi.kami.home>
Message-ID: <Pine.LNX.4.44L0.0706200959090.3311-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Mattia Dongili wrote:

> On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> 
> Hello,
> on this vaio sz72b I can't suspend if usb-storage is loaded. Bisecting
> is becoming troublesome as different sets have slightly different
> problems.
> At one point (with the GREGKH usb stuff built) I had the kernel
> reporting it cannot stop the usb-storage thread so I guess that
> something later in the series made things worse (freezable workqueues?).
> 
> Clues?

The usb-storage thread is supposed to be unfreezable.  Recent changes 
may have messed up the code that checks for which threads need to be 
frozen and which don't.

Alan Stern

