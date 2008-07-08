Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYGHOLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYGHOLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYGHOLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:11:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33946 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752694AbYGHOLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:11:25 -0400
Date: Tue, 8 Jul 2008 10:11:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Indan Zupancic <indan@nul.nu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       USB development list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.27-rc7-git1: usb-storage breakage with non-functional disk
In-Reply-To: <14162.84.245.32.19.1215525216.squirrel@secure.samage.net>
Message-ID: <Pine.LNX.4.44L0.0807081008230.2135-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008, Indan Zupancic wrote:

> On Tue, July 8, 2008 15:00, Indan Zupancic wrote:
> > Any idea why my cardreader doesn't work in the first place though?
> 
> In case it's useful, an usbmon dump can be found at http://pastebin.org/49630
> This is the log of plugging in the thing and unplugging it again after it failed.
> Corresponding dmesg output with USB and usb-storage debugging enabled at
> http://pastebin.org/49631. This is on 2.6.26-rc9 with Alan's patch applied.

The logs reveal only that this doesn't seem to be a software- or 
firmware-related problem.  And it probably isn't a problem in the cable 
either, which leaves only the reader or its USB interface.

It might work better at full speed than at high speed (although you 
probably don't want to use it in a degraded mode).

Alan Stern

