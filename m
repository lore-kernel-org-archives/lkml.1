Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYBYHlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYBYHlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 02:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYBYHk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 02:40:58 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:29934 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752385AbYBYHk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 02:40:56 -0500
X-Trace: 676675454/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAFMAwkdRAVlC/2dsb2JhbACBVag1
Subject: Re: [PATCH] maple: fix device detection
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <paul.mundt@renesas.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <20080225053313.GA27064@renesas.com>
References: <1203863423.6474.27.camel@localhost.localdomain>
	 <1203889834.6474.35.camel@localhost.localdomain>
	 <1203892373.6299.2.camel@localhost.localdomain>
	 <20080225053313.GA27064@renesas.com>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 07:40:26 +0000
Message-Id: <1203925226.6364.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-25 at 14:33 +0900, Paul Mundt wrote:
> On Sun, Feb 24, 2008 at 10:32:53PM +0000, Adrian McMenamin wrote:
> > On Sun, 2008-02-24 at 21:50 +0000, Adrian McMenamin wrote:
> > > On Sun, 2008-02-24 at 14:30 +0000, Adrian McMenamin wrote:
> > > > The maple bus driver that went into the kernel mainline in
> > > > September 2007 contained some bugs which were revealed by the
> > > > update of the kobj code for the current release series.
> > > > Unfortunately those bugs also helped ensure maple devices were
> > > > properly detected. This patch (against the current git) now ensures
> > > > that devices are properly detected again.
> > > > 
> > > 
> > > Further testing has shown this has introduced another bug, this time
> > > limiting the effectiveness of subdevice detection. Please ignore this
> > > while I work on a fix.
> > > 
> > Sorry for the confusion, in fact there is nothing wrong with this code
> > (ie it should be applied), the error was in the driver for the Dreamcast
> > controller (the device, in general, into which the subdevices are
> > plugged in and out).
> > 
> > I will post a fix for that.
> > 
> > Sorry again.
> > 
> So what exactly is supposed to be applied here?

The patch at the start of this thread - ie
http://lkml.org/lkml/2008/2/24/125  - this should really go in now as it
fixes a problem with current code.

In addition there are two patch sets to add new device support:

http://lkml.org/lkml/2008/2/24/211    - maple controller

http://lkml.org/lkml/2008/2/24/121  (thread) - maple mouse

