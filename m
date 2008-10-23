Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYJWPnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYJWPnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYJWPm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:42:56 -0400
Received: from kroah.org ([198.145.64.141]:58946 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752805AbYJWPmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:42:55 -0400
Date: Thu, 23 Oct 2008 08:37:33 -0700
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add c2 port support.
Message-ID: <20081023153733.GA4011@kroah.com>
References: <1224683240-15439-1-git-send-email-giometti@linux.it> <1224683240-15439-2-git-send-email-giometti@linux.it> <20081022174004.GB10587@kroah.com> <20081022111145.e5f3c632.akpm@linux-foundation.org> <20081022195245.GS4390@tekkaman> <20081022130150.00836eba.akpm@linux-foundation.org> <20081022204800.GT4390@tekkaman> <20081022135810.37c564f8.akpm@linux-foundation.org> <20081022210352.GA29754@kroah.com> <20081023073957.GU4390@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023073957.GU4390@tekkaman>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 09:39:57AM +0200, Rodolfo Giometti wrote:
> On Wed, Oct 22, 2008 at 02:03:52PM -0700, Greg KH wrote:
> 
> > > Why is that good?  We have hundreds and hundreds of drivers which use a
> > > device node interface and they work OK.
> > > 
> > > sysfs was never intended for use as the sole interface between device
> > > drivers and userspace.  Using it that way is somewhat unconventional. 
> > > At the very least I do think it needs more justification and
> > > explanation than we're being provded here.
> > 
> > For firmware download to devices, using sysfs is the "normal" interface
> > these days, that is what the firmware class is for.
> > 
> > Which reminds me, Rodolfo, why didn't you just use that interface for
> > your firmware downloading instead of rolling your own here?
> 
> Because I need also to know revision ID, device ID and other minor
> info from the microcontroller.

You can still use sysfs for that, no problems there.

> Also I can reset the microcontroller when I need it without
> downloading any new firmware.

And again, you can still use sysfs for that as well.  I was just
referring to the binary sysfs file that you use for the firmware
download, it would make more sense for you to use the standard kernel
firmware download interface instead of rolling your own here.

thanks,

greg k-h
