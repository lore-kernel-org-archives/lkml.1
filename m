Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYBFVZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYBFVZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbYBFVZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:25:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40068 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYBFVZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:25:41 -0500
Date: Wed, 6 Feb 2008 13:23:54 -0800
From: Greg KH <greg@kroah.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080206212354.GB5239@kroah.com>
References: <20080125180232.GA4613@kroah.com> <9e4733910802061243h2757d41fwe0813adacc86a0ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910802061243h2757d41fwe0813adacc86a0ee@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 03:43:26PM -0500, Jon Smirl wrote:
> There a company that is providing a common API for writting Windows
> and Linux drivers. Last time I was using a Macraigor JTAG it was based
> on this proprietary dual platform driver.
> 
> http://www.macraigor.com/cgi_bin/counters/unicounter.pl?name=counters/ocd_cmdr_linux&deliver=http://www.macraigor.biz/gnu/mcgr-hwsupport-4.8-0.i386.rpm
> 
> The dual platform driver was from Jungo.
> http://www.jungo.com/
> 
> WinDriver? USB for Linux automates and simplifies the development of
> user-mode Linux device drivers and hardware control applications for
> USB peripheral devices. No Linux kernel knowledge or kernel level
> programming required.

Yes, I know all about Jungo, and have never heard anything good about
them from either the Windows developers I know, or anyone who has tried
to get their stuff working on Linux using their framework.

I would not recommend their stuff at all, it's much easier to just write
a native Linux and Windows driver instead.  Especially with the new
Windows Driver Framework, which helps those developers out a lot more
these days.

thanks,

greg k-h
