Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbYA1QQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbYA1QQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbYA1QQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:16:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43686 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYA1QQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:16:31 -0500
Date: Mon, 28 Jan 2008 08:13:05 -0800
From: Greg KH <greg@kroah.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080128161305.GB8790@kroah.com>
References: <20080125180232.GA4613@kroah.com> <479DB203.2050809@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479DB203.2050809@panasas.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 12:44:19PM +0200, Boaz Harrosh wrote:
> On Fri, Jan 25 2008 at 20:02 +0200, Greg KH <greg@kroah.com> wrote:
> > FYI, this is a patch that will be sent out in the next round to Linus
> > for inclusion in 2.6.25.
> > 
> > If anyone has any objections about it, please let me know.
> 
> What about ndiswrapper and its windows binaries
> are they covered through ndiswrapper by GPL?
> (Unfortunately I use them, but less and less)

Sorry, but no, they are not going to work, due to the way that
ndiswrapper is marked by the kernel module loader.

Again, you should be getting a kernel warning every time you try to use
a USB function today.

What USB drivers for wireless devices are not yet supported by Linux
becides the Marvell-based ones (which some of us are actively working
on...)?

thanks,

greg k-h
