Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYHMPqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYHMPqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYHMPqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:46:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41046 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751116AbYHMPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:46:35 -0400
Date: Wed, 13 Aug 2008 11:46:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       <James.Bottomley@hansenpartnership.com>, <teheo@novell.com>
Subject: Re: Power management for SCSI
In-Reply-To: <200808131724.52461.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808131145160.2151-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Oliver Neukum wrote:

> Am Mittwoch 13 August 2008 16:59:23 schrieb Alan Stern:
> > This is a good question.  Most USB mass-storage devices do not act as a
> > true SCSI bus, but I believe there are a few non-standard ones that do
> > -- the USB device really contains a SCSI host and arbitrary SCSI
> 
> OK, but does it make sense to have SCSI autosuspend? Or should autosuspend
> operate on the bus the _host_ is connected to (usb, pci, ...)?

That's the situation we're in now.  Autosuspend operates on the USB 
bus, but it can't do anything with usb-storage because the child SCSI 
devices don't do a SCSI autosuspend.

Alan Stern

