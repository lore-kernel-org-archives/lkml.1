Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbYBARkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbYBARkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYBARk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:40:27 -0500
Received: from mail.suse.de ([195.135.220.2]:40934 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbYBARkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:40:25 -0500
Date: Fri, 1 Feb 2008 09:29:52 -0800
From: Greg KH <gregkh@suse.de>
To: Gilles Espinasse <g.esp@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080201172952.GA32679@suse.de>
References: <1201877107.47a3307340b38@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201877107.47a3307340b38@imp.free.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 03:45:07PM +0100, Gilles Espinasse wrote:
> >FYI, this is a patch that will be sent out in the next round to Linus
> >for inclusion in 2.6.25.
> >
> >If anyone has any objections about it, please let me know.
> >
> ..
> > There are no known closed source USB drivers in the wild, so this
> > patch should cause no problems.
> 
> There is the unicorn usb adsl modem driver (STM unicorn chip).
> http://www.bewan.com/bewan/drivers/A1012-A1006-A904-A888-A983-0.9.3.tgz
> There is some sources and a binary blob to be linked.
> 
> The only things I know from the binary blob is that sources should be 150 000
> lines of C++.

Wow, larger than all the in-kernel USB drivers, and the USB core
combined.  That's an impressive display of horrible code :)

> Driver compile with gcc-3 but not with gcc-4 (because of the binary blob).

So they aren't even being used by modern distros, so there's not much to
worry about here...

thanks for the info.

greg k-h
