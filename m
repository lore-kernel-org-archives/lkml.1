Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZBRPz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZBRPz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZBRPxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:53:39 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:33064 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbZBRPxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:53:32 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFD] Automatic suspend
Date: Wed, 18 Feb 2009 16:55:11 +0100
User-Agent: KMail/1.9.10
Cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
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
References: <Pine.LNX.4.44L0.0902181009410.3186-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902181009410.3186-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181655.13876.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 18 February 2009 16:10:48 schrieb Alan Stern:
> On Wed, 18 Feb 2009, Oliver Neukum wrote:
> 
> > But the transport and the driver may be in different subsystems, e.g.
> > usb storage.
> 
> We would have to add a part of usb-storage into the SCSI subsystem, by 
> creating a USB transport class.  Perhaps this class could be shared 
> with Firewire/IEEE1394.

That would be a specific solution. But the problem is generic. Take
for example HID. Several drivers may share one transport, but the transport
may be USB 2.0/3.0 or bluetooth.

	Regards
		Oliver


