Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZHFS5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZHFS5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZHFS5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:57:53 -0400
Received: from kroah.org ([198.145.64.141]:36157 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639AbZHFS5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:57:50 -0400
Date: Thu, 6 Aug 2009 11:36:53 -0700
From: Greg KH <greg@kroah.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090806183653.GC28433@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <20090805185136.GA21442@kroah.com>
 <87ljlxhrnr.fsf@basil.nowhere.org>
 <200908062006.16263.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908062006.16263.a1426z@gawab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 08:06:16PM +0300, Al Boldi wrote:
> Andi Kleen wrote:
> > Greg KH <greg@kroah.com> writes:
> > > It makes the userspace boot process much simpler and easier to maintain,
> > > as well as providing a way to handle rescue disks and images trivially,
> > > and it makes the kernel _less_ dependant on the early userspace bootup
> > > scripts.
> >
> > As a initrd less kernel user I can really only agree: getting rid
> > of the udev-in-initrd requirement would be a big step forward
> > in usability. Typically I always have to pre populate
> > a on disk /dev manually first to get my kernels to boot.
> 
> Oh good, I thought I was the only one doing that.
> 
> The reason I don't like udev is that it's just to slow; something like a 5-10s 
> delay on each boot.  No idea why it should be so slow, but it's probably 
> probing the kernel for all available devices at boot, when it could be much 
> quicker by probing for the device on access.

Like Kay stated, this sounds like a misconfiguration of your distro's
udev setup, as the ones I use (openSUSE and Gentoo) do not have this
problem at all.

Please work with your distro and the people on the
linux-hotplug@vger.kernel.org mailing list to help resolve this issue.

thanks,

greg k-h
