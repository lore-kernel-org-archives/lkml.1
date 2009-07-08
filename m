Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZGHNB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZGHNB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZGHNBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:01:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZGHNBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:01:20 -0400
Date: Wed, 8 Jul 2009 06:00:56 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Dave Jones <davej@redhat.com>, Peter Jones <pjones@redhat.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
Message-ID: <20090708130056.GA19543@suse.de>
References: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com>
 <20090623144221.GA29593@suse.de>
 <b6a2187b0906230829k308cb875r7362f184bccb1d6d@mail.gmail.com>
 <20090623153928.GA32604@suse.de>
 <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com>
 <ac3eb2510907080403h14e5597eu3dee309456eab17e@mail.gmail.com>
 <21d7e9970907080420h41375e36q1efacb9f3555b9de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970907080420h41375e36q1efacb9f3555b9de@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 09:20:04PM +1000, Dave Airlie wrote:
> On Wed, Jul 8, 2009 at 9:03 PM, Kay Sievers<kay.sievers@vrfy.org> wrote:
> > On Wed, Jul 8, 2009 at 12:54, Dave Airlie<airlied@gmail.com> wrote:
> >
> >> Okay can we revert this for a better reason? it seems to have unhidden a race
> >> condition on booting some of my machines. I've booted some other machines
> >> with the same USB disk and the same kernel fine.
> >
> > Are you sure? USBFS is for userspace USB drivers, booting from
> > usb-storage devices should be fully handled by the kernel.
> >
> 
> Yes, changing just this option means the difference between a bootable
> and stuck in initrd system. maybe Peter knows if our initrd does something
> otherwise I suspect we have a race that usbfs was hiding.

Like Kay stated, this sounds very strange, I'd like to find out the root
cause of this before reverting the config option.  Nothing at startup
should be using/needing usbfs that I can think of.

thanks,

greg k-h
