Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYDRDQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYDRDQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 23:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbYDRDPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 23:15:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45211 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbYDRDPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 23:15:40 -0400
Date: Thu, 17 Apr 2008 20:21:46 -0700
From: Greg KH <greg@kroah.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH mm] sysfs: add /sys/dev/usb to handle
	CONFIG_USB_DEVICE_CLASS=y
Message-ID: <20080418032146.GA8754@kroah.com>
References: <1208484663.12570.5.camel@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208484663.12570.5.camel@dwillia2-linux.ch.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 07:11:03PM -0700, Dan Williams wrote:
> The deprecated config option CONFIG_USB_DEVICE_CLASS causes class devices
> with duplicate major:minor numbers to be registered.  In effect they
> represent a usb specific address space for major:minor numbers so add 'usb'
> as a directory along side 'block' and 'char'.

Hm, no they do not, they are not a new address space, we are just
reusing them as the other user wasn't using them, and the code is
deprecated and will be removed eventually.  Neither of these char
devices are really hooked up to anything within the kernel, so it
doesn't matter yet.

I wonder how many other duplicates we have floating around...

thanks,

greg k-h
