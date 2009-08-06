Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbZHFS5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbZHFS5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbZHFS5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:57:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:59918 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbZHFS5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:57:48 -0400
Date: Thu, 6 Aug 2009 11:31:47 -0700
From: Greg KH <gregkh@suse.de>
To: David Dillow <dave@thedillows.org>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090806183147.GA28409@suse.de>
References: <20090805171513.GA10443@kroah.com>
 <20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
 <20090805182805.GA7534@kroah.com>
 <20090805185136.GA21442@kroah.com>
 <87ljlxhrnr.fsf@basil.nowhere.org>
 <1249575658.19886.8.camel@lap75545.ornl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249575658.19886.8.camel@lap75545.ornl.gov>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 12:20:58PM -0400, David Dillow wrote:
> On Thu, 2009-08-06 at 17:46 +0200, Andi Kleen wrote:
> > Greg KH <greg@kroah.com> writes:
> > >
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
> If you use mount by label or UUID, you still need udev (or other tools)
> in the initrd to find the right disk, correct?

Yes, you would.

> And for distros that want to support that, does this really reduce the
> amount of code in the initrd?

Yes it does, see the code in the Novell Moblin images for an example of
how to use devtmpfs with udev for how to do this.

thanks,

greg k-h
