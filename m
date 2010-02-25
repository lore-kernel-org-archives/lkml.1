Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab0BYTxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:53:20 -0500
Received: from mga12.intel.com ([143.182.124.36]:64029 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933028Ab0BYTxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:53:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,541,1262592000"; 
   d="scan'208";a="248183643"
Date: Thu, 25 Feb 2010 11:52:49 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?iso-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device
 8087:0020
Message-ID: <20100225195249.GA5245@xanatos>
References: <20100225190452.GA4184@xanatos>
 <Pine.LNX.4.44L0.1002251430470.1686-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002251430470.1686-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 02:36:02PM -0500, Alan Stern wrote:
> On Thu, 25 Feb 2010, Sarah Sharp wrote:
> 
> > > > now, I unplug the USB DVD drive:
> > > > 
> > > > Feb 25 17:35:38 tonkachi kernel: [  276.374282] xhci_hcd 0000:02:00.0:
> > > > WARN: transfer error on endpoint
> > > > Feb 25 17:35:39 tonkachi kernel: [  276.728151] xhci_hcd 0000:02:00.0:
> > > > WARN: transfer error on endpoint
> > > > Feb 25 17:35:39 tonkachi kernel: [  276.728819] xhci_hcd 0000:02:00.0:
> > > > WARN: transfer error on endpoint
> 
> Shouldn't there be some messages here about "USB disconnect"?  This 
> suggests there's something wrong with the root hub.

True.  I can't tell exactly what's going on without
CONFIG_USB_XHCI_HCD_DEBUGGING.  It's possible the xHCI host never
notified the driver of the disconnect, or there's a bug in the xHCI hub
emulation code.

Sarah Sharp
