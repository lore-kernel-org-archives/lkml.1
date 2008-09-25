Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYIYWJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYIYWJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYIYWJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:09:30 -0400
Received: from [198.145.64.141] ([198.145.64.141]:35193 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753225AbYIYWJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:09:30 -0400
Date: Thu, 25 Sep 2008 15:06:35 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] PM: use pm_op methods for device types
Message-ID: <20080925220635.GA12175@kroah.com>
References: <Pine.LNX.4.44L0.0809251704580.2181-100000@iolanthe.rowland.org> <200809252327.03305.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809252327.03305.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 11:27:02PM +0200, Rafael J. Wysocki wrote:
> On Thursday, 25 of September 2008, Alan Stern wrote:
> > This patch (as1141) adds code to use the device type's pm_op methods,
> > if they are defined.  It fixes a regression in the USB PM code; the
> > various suspend and resume methods are defined in the device type
> > rather than in the bus, because USB devices have to be handled
> > differently from USB interfaces.  Without the patch, those methods
> > never get called.
> > 
> > The patch also fixes a couple of spelling errors.
> 
> Hm, these changes are not needed in the current mainline, so there's a patch
> in -next that removes the code added by this patch.
> 
> It might be better to find that patch and drop it instead, IMO.

I agree, I think we would have seen more bugs if mainline can't suspend
with a USB device attached, right?

confused,

greg k-h
