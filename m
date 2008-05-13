Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbYEMUGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbYEMUGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbYEMUGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:06:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53670 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757327AbYEMUGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:06:21 -0400
Date: Tue, 13 May 2008 16:06:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25
In-Reply-To: <20080512110450.GA6399@ics.muni.cz>
Message-ID: <Pine.LNX.4.44L0.0805131554370.2563-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008, Lukas Hejtmanek wrote:

> On Fri, May 09, 2008 at 02:47:45PM -0400, Alan Stern wrote:
> > On Fri, 9 May 2008, Greg KH wrote:
> > 
> > > Can you just boot the box and then plug it into the dock and show the
> > > log file for that?
> > 
> > If you can, use a kernel that has CONFIG_USB_DEBUG turned on.
> 
> I did. The dmesg is attached to the bug:
> http://bugzilla.kernel.org/show_bug.cgi?id=10630

It looks as though the dock's USB hub may not be working right.

Just as a test, can you try applying gregkh-04-usb-2.6.26-rc2.patch 
(it applies to 2.6.26-rc2, obviously) from

	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/

and attaching the dmesg log from that?  It contains extra debugging not 
present in the vanilla kernel -- make sure that you keep 
CONFIG_USB_DEBUG enabled.

Alan Stern

