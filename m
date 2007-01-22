Return-Path: <linux-kernel-owner+w=401wt.eu-S932138AbXAVUYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbXAVUYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXAVUYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:24:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:52126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbXAVUYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:24:36 -0500
Date: Mon, 22 Jan 2007 12:23:44 -0800
From: Greg KH <gregkh@suse.de>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [GIT PATCH] USB fixes for 2.6.20-rc5
Message-ID: <20070122202344.GA10579@suse.de>
References: <20070122200746.GA9936@kroah.com> <1169496904.27023.11.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169496904.27023.11.camel@violet>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 22, 2007 at 09:15:04PM +0100, Marcel Holtmann wrote:
> Hi Greg,
> 
> > They include a small number of fixes for some USB bugs, and some new
> > device ids, all of the details are below.  I've also disabled the USB
> > multithreaded probe option, as it broke a number of people's machines.
> 
> what about the two pending patches to make device_move() working as
> expected. The current implementation is broken and basically useless.

I don't feel comfortable adding them to the 2.6.20 kernel at this late
period, for a variety of reasons.  I really want them to be tested out
in the -mm tree and then in the full -rc series due to the fact that
they are non-trivial, and touch the driver core code that everyone uses,
not just that function.

Also, it's a new feature (reparent back to the original parent), not
necessarily a bugfix.

And yes, I realize that the functions don't work fully right now, but as
long as you don't want to re-parent the devices, they should work,
right?

thanks,

greg k-h
