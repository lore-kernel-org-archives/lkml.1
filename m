Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYBXWfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYBXWfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 17:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYBXWfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 17:35:08 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:7723 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750864AbYBXWfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 17:35:05 -0500
X-Trace: 687583291/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAKZ/wUdRAVlC/2dsb2JhbACBVagg
Subject: Re: [PATCH] maple: fix device detection
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Greg KH <greg@kroah.com>
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <1203889834.6474.35.camel@localhost.localdomain>
References: <1203863423.6474.27.camel@localhost.localdomain>
	 <1203889834.6474.35.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 22:32:53 +0000
Message-Id: <1203892373.6299.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-24 at 21:50 +0000, Adrian McMenamin wrote:
> On Sun, 2008-02-24 at 14:30 +0000, Adrian McMenamin wrote:
> > The maple bus driver that went into the kernel mainline in September 2007 contained some bugs which were revealed by the update of the kobj code for the current release series. Unfortunately those bugs also helped ensure maple devices were properly detected. This patch (against the current git) now ensures that devices are properly detected again.
> > 
> 
> Further testing has shown this has introduced another bug, this time
> limiting the effectiveness of subdevice detection. Please ignore this
> while I work on a fix.
> 
Sorry for the confusion, in fact there is nothing wrong with this code
(ie it should be applied), the error was in the driver for the Dreamcast
controller (the device, in general, into which the subdevices are
plugged in and out).

I will post a fix for that.

Sorry again.

