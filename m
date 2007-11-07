Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbXKGUAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbXKGUAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 15:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXKGUAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 15:00:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43055 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753535AbXKGUAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 15:00:42 -0500
Date: Wed, 7 Nov 2007 15:00:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
In-Reply-To: <1194464182.2303.44.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0711071459510.6432-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Kay Sievers wrote:

> It would remove another implicit "magic" from the core, which is good.

Yes.

> Otherwise we will need to introduce a kobject_orphan(), to disassociate
> an object from its parent, which would be kind of weird, just to break
> out of the default core logic.
> 
> I would expect this patch to have an effect only at the pretty complex
> refcounting users of the driver core, which are SCSI and USB, and I
> expect the people involved are good prepared now, to fix such possible
> bugs, should they show up. :)

The person who has to be convinced is Greg.  :-)

Alan Stern

