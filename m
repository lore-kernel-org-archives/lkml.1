Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZBRPLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZBRPLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZBRPKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:10:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49973 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752203AbZBRPKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:10:49 -0500
Date: Wed, 18 Feb 2009 10:10:48 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <200902181605.18363.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0902181009410.3186-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009, Oliver Neukum wrote:

> But the transport and the driver may be in different subsystems, e.g.
> usb storage.

We would have to add a part of usb-storage into the SCSI subsystem, by 
creating a USB transport class.  Perhaps this class could be shared 
with Firewire/IEEE1394.

Alan Stern

