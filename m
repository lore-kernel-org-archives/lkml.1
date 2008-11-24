Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbYKXBpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbYKXBpm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 20:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYKXBpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 20:45:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:35759 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYKXBpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 20:45:12 -0500
Date: Sun, 23 Nov 2008 17:41:22 -0800
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
       John Ogness <jogness@linutronix.de>,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: [PATCH RFC] UIO: Pass information about ioports to userspace
Message-ID: <20081124014122.GB14143@suse.de>
References: <20081123121419.GA3087@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123121419.GA3087@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 01:14:20PM +0100, Hans J. Koch wrote:
> Devices sometimes have memory where all or parts of it can not be mapped to
> userspace. But it might still be possible to access this memory from
> userspace by other means. An example are PCI cards that advertise not only
> mappable memory but also ioport ranges. On x86 architectures, these can be
> accessed with ioperm, iopl, inb, outb, and friends. Mike Frysinger (CCed)
> reported a similar problem on Blackfin arch where it doesn't seem to be easy
> to mmap non-cached memory but it can still be accessed from userspace.
> 
> This patch allows kernel drivers to pass information about such ports to
> userspace. Similar to the existing mem[] array, it adds a port[] array to
> struct uio_info. Each port range is described by start, size, and porttype.

Looks good, but I think you also forgot the documentation update :)

thanks,

greg k-h
