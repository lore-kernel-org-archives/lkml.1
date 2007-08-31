Return-Path: <linux-kernel-owner+w=401wt.eu-S1763238AbXHaFMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763238AbXHaFMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbXHaFMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:12:10 -0400
Received: from canuck.infradead.org ([209.217.80.40]:56367 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974AbXHaFMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:12:09 -0400
Date: Thu, 30 Aug 2007 22:10:12 -0700
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Oliver Neukum <oneukum@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Dave Jones <davej@redhat.com>, Michael Krufky <mkrufky@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [stable] [patch 25/28] USB: cdc-acm: fix sysfs attribute
	registration bug
Message-ID: <20070831051012.GA5650@kroah.com>
References: <20070824154906.GA19239@kroah.com> <Pine.LNX.4.44L0.0708241349240.3862-100000@iolanthe.rowland.org> <20070824180423.GA5458@suse.de> <46D60255.2000606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D60255.2000606@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 07:33:41PM -0400, Chuck Ebbert wrote:
> On 08/24/2007 02:04 PM, Greg KH wrote:
> >> I don't understand.  The history for stable/linux-2.6.22.y.git at
> >> http://git.kernel.org shows that the commit for my patch, labelled
> >>
> >> 	6b30a4e1c357410a78d7bcb831743b0e99bab4ad,
> >>
> >> includes both hunks.  And patch-2.6.22.5.bz2 includes both as well.  
> >> Something's fishy.
> > 
> 
> 
> *sigh*
> 
> The stable-queue tree does not match what got released for 2.6.22.5.
> 
> $ pwd
> /home/me/git/stable-queue
> $ grep cdc releases/2.6.22.5/*
> $ 
> 
> $ bzcat patch-2.6.22.5.bz2 | grep cdc
> index acdc3be..e2b9ca4 100644
> diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c

That is because the cdc-acm patch went into an earlier .22.y release,
look at the git tree to see that.  It was not in the 2.6.22.5 release.

thanks,

greg k-h
