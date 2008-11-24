Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbYKXJFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbYKXJFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYKXJEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:04:25 -0500
Received: from www.tglx.de ([62.245.132.106]:44701 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYKXJEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:04:23 -0500
Date: Mon, 24 Nov 2008 10:04:12 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>, John Ogness <jogness@linutronix.de>,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: [PATCH RFC] UIO: Pass information about ioports to userspace
Message-ID: <20081124090412.GA3086@local>
References: <20081123121419.GA3087@local> <20081124014122.GB14143@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081124014122.GB14143@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 05:41:22PM -0800, Greg KH wrote:
> On Sun, Nov 23, 2008 at 01:14:20PM +0100, Hans J. Koch wrote:
> > Devices sometimes have memory where all or parts of it can not be mapped to
> > userspace. But it might still be possible to access this memory from
> > userspace by other means. An example are PCI cards that advertise not only
> > mappable memory but also ioport ranges. On x86 architectures, these can be
> > accessed with ioperm, iopl, inb, outb, and friends. Mike Frysinger (CCed)
> > reported a similar problem on Blackfin arch where it doesn't seem to be easy
> > to mmap non-cached memory but it can still be accessed from userspace.
> > 
> > This patch allows kernel drivers to pass information about such ports to
> > userspace. Similar to the existing mem[] array, it adds a port[] array to
> > struct uio_info. Each port range is described by start, size, and porttype.
> 
> Looks good, but I think you also forgot the documentation update :)

Not forgotten, just delayed :-)
We had other changes lately that need documentation update as well. Big patch
will come Real Soon Now...

thanks,
Hans
