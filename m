Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343Ab0BZQcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:32:50 -0500
Received: from mga10.intel.com ([192.55.52.92]:30811 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965330Ab0BZQcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:32:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,546,1262592000"; 
   d="scan'208";a="776230471"
Date: Fri, 26 Feb 2010 08:32:31 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?iso-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device
 8087:0020
Message-ID: <20100226163231.GB4903@xanatos>
References: <20100226001621.GA6060@xanatos>
 <Pine.LNX.4.44L0.1002261111330.2029-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002261111330.2029-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 11:12:50AM -0500, Alan Stern wrote:
> On Thu, 25 Feb 2010, Sarah Sharp wrote:
> 
> > > at this point, rmmod xhci doesn't even work anymore, I get stuff during
> > > / around the rmmod like:
> > > 
> > > Feb 25 23:34:24 tonkachi kernel: [  230.133711] xhci_hcd 0000:02:00.0:
> > > remove, state 1
> > 
> > Aw, man, it looks like your xHCI disconnected from the bus.  Something
> > was seriously wrong with the hardware.
> 
> Why do you say that?  Isn't this exactly the sort of thing you expect 
> to see in the log when xhci-hcd is unloaded?

Yes, I forgot he was unloading the driver.  That's normal then.

Sarah Sharp
