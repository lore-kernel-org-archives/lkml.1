Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZBRQje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZBRQje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZBRQjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:39:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33878 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751340AbZBRQjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:39:24 -0500
Date: Wed, 18 Feb 2009 11:39:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <200902181655.13876.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0902181135400.3186-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009, Oliver Neukum wrote:

> Am Wednesday 18 February 2009 16:10:48 schrieb Alan Stern:
> > On Wed, 18 Feb 2009, Oliver Neukum wrote:
> > 
> > > But the transport and the driver may be in different subsystems, e.g.
> > > usb storage.
> > 
> > We would have to add a part of usb-storage into the SCSI subsystem, by 
> > creating a USB transport class.  Perhaps this class could be shared 
> > with Firewire/IEEE1394.
> 
> That would be a specific solution. But the problem is generic. Take
> for example HID. Several drivers may share one transport, but the transport
> may be USB 2.0/3.0 or bluetooth.

In essence what you're saying is that we won't be able to do
link-suspend for HID until something like HID transport classes (or
something simpler, devoted specifically to runtime PM) is implemented.  
And likewise for other subsystems.  I can't argue with this conclusion.

Alan Stern

