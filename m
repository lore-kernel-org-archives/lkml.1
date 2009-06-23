Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbZFWPnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbZFWPnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZFWPnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:43:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:48897 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbZFWPnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:43:41 -0400
Date: Tue, 23 Jun 2009 08:39:28 -0700
From: Greg KH <gregkh@suse.de>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
Message-ID: <20090623153928.GA32604@suse.de>
References: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com> <20090623144221.GA29593@suse.de> <b6a2187b0906230829k308cb875r7362f184bccb1d6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0906230829k308cb875r7362f184bccb1d6d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 11:29:50PM +0800, Jeff Chua wrote:
> On Tue, Jun 23, 2009 at 10:42 PM, Greg KH<gregkh@suse.de> wrote:
> > On Tue, Jun 23, 2009 at 01:11:51PM +0800, Jeff Chua wrote:
> >> commit cc71329b3b89b4a5be849b617f2c4f151f0b9213 moved USB_DEVICEFS to
> >> be embedded and marked it as depreciated. Can this be reverted? This
> >> breaks vmware and those systems not using udev.
> 
> > vmware now works properly with this fix, and has for over a year or so.
> 
> vmware is working, but can't detect USB devices.

Odd, what version of vmware are you using?

> > What distro does not use udev or mdev or something like it already and
> > also does not use an updated libusb?
> > We need some specifics here please.
> 
> I'm not using it and have been fine without it all these while, so
> don't see any gain moving to udev or perhaps it's time to consider ...

If you are running your own custom distro/install, then you should be
able to select CONFIG_EMBEDDED and then USB_DEVICEFS just fine on your
own.  But note, that you don't sound like the "normal" user at all :)

thanks,

greg k-h
