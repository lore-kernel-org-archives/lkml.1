Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbYEOR0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbYEOR0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYEORZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:25:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:47648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYEORZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:25:58 -0400
Date: Thu, 15 May 2008 10:25:18 -0700
From: Greg KH <gregkh@suse.de>
To: "Randy.Dunlap" <rdunlap@xenotime.net>, stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.25.4
Message-ID: <20080515172518.GA23810@suse.de>
References: <20080515150721.GA8420@kroah.com> <Pine.LNX.4.64.0805150942070.7254@shark.he.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805150942070.7254@shark.he.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 09:43:04AM -0700, Randy.Dunlap wrote:
> On Thu, 15 May 2008, Greg Kroah-Hartman wrote:
> 
> > We (the -stable team) are announcing the release of the 2.6.25.4 kernel.
> > 
> > It contains a bunch of bug fixes, and one security update, so all users
> > of the 2.6.25 series are encouraged to upgrade.
> 
> Build errors on i386 and x86_64 allyesconfig:
> 
> drivers/usb/host/ohci-sm501.c:242: error: 'hcd' undeclared (first use in this function)
> drivers/usb/host/ohci-sm501.c:242: error: (Each undeclared identifier is reported only once
> drivers/usb/host/ohci-sm501.c:242: error: for each function it appears in.)
> make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1

Alan, this is due to your OHCI patch :(

Care to send me a fix for this?

thanks,

greg k-h
