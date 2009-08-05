Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbZHESwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbZHESwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZHESwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:52:35 -0400
Received: from kroah.org ([198.145.64.141]:58480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbZHESwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:52:34 -0400
Date: Wed, 5 Aug 2009 11:51:36 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090805185136.GA21442@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
 <20090805182805.GA7534@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805182805.GA7534@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 11:28:05AM -0700, Greg KH wrote:
> On Wed, Aug 05, 2009 at 07:20:37PM +0100, Alan Cox wrote:
> > On Wed, 5 Aug 2009 10:15:13 -0700
> > Greg KH <greg@kroah.com> wrote:
> > 
> > > Here's the devtmpfs patch again.  For .32 it's a simple and clean patch.
> > 
> > You seem to have reposted it rather than anyone addressing any of the
> > complaints people made about ?
> > 
> > To quote Christoph
> > 
> > > What tree did you find with devtmpfs in it?  It was pretty clearly
> > > rejected when it came up.
> 
> That's not anything to address, what do you want me to say, "maple"?  :)
> 
> > and Arjan (who is doing about the fastest Linux boot anyone has and has
> > better data than anyone else)
> 
> We did this work based on Arjan's work.  It solves a problem that Moblin
> has as well, which is why Novell is using it for their Moblin-based
> images they are shipping.  It makes things go faster, with a simpler
> userspace codepath, and we have the numbers as have been previously
> posted.

And to expound on this a bit, it's not just about fast boot, although
this is a great benefit of this patch.

It makes the userspace boot process much simpler and easier to maintain,
as well as providing a way to handle rescue disks and images trivially,
and it makes the kernel _less_ dependant on the early userspace bootup
scripts.

And then there's the great reason Kay previously stated, "if sysfs has
all the names, numbers, and device properties, why would we need complex
userspace to have the nodes?"

thanks,

greg k-h
