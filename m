Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbYJJX2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbYJJX2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 19:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYJJX2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 19:28:44 -0400
Received: from kroah.org ([198.145.64.141]:44579 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752492AbYJJX2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 19:28:43 -0400
Date: Fri, 10 Oct 2008 16:25:22 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH -next] PM: Simplify the new suspend/hibernation
	framework for devices
Message-ID: <20081010232522.GB30814@kroah.com>
References: <200810060055.07601.rjw@sisk.pl> <200810110047.35993.rjw@sisk.pl> <20081010224343.GA30203@kroah.com> <200810110104.18707.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810110104.18707.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 01:04:17AM +0200, Rafael J. Wysocki wrote:
> On Saturday, 11 of October 2008, Greg KH wrote:
> > On Sat, Oct 11, 2008 at 12:47:34AM +0200, Rafael J. Wysocki wrote:
> > > On Friday, 10 of October 2008, Greg KH wrote:
> > > > On Mon, Oct 06, 2008 at 10:46:05PM +0200, Rafael J. Wysocki wrote:
> > > > > On Monday, 6 of October 2008, Rafael J. Wysocki wrote:
> > > > > > Hi Greg,
> > > > > > 
> > > > > > I promised at the KS that I would simplify the new suspend/hibernation
> > > > > > framework for devices to avoid the confusion with two types of PM
> > > > > > operations and pointers to PM operations from too many places.
> > > > > > 
> > > > > > The appended patch is intended for this purpose.  Unfortunately, I can't
> > > > > > split it into subsystem-related patches, because compilation would be broken
> > > > > > between them.
> > > > > > 
> > > > > > The patch applies to linux-next, but it's trivial to make it apply to the
> > > > > > mainline.  It's been compiled on x86 (both 32-bit and 64-bit) and tested
> > > > > > on hp nx6325, doesn't appear to break anything.
> > > > > 
> > > > > This one had a checkpatch.pl problem, sorry for that.  Updated patch is
> > > > > appended.
> > > > 
> > > > I've added this to my tree (Jesse, is this ok, as it does have a PCI
> > > > portion?)
> > > > 
> > > > But it's too late for .28, especially due to the -next tree not up and
> > > > running right now.  I'll let it bake in -mm and -next and it should go
> > > > into .29.
> > > > 
> > > > Is that ok?
> > > 
> > > Well, if anyone pushes anything depending on this framework for .27, that will
> > > become a !@#$%^&* mess (we've had this problem once already).
> > 
> > Do we have any drivers that depend on this framework in any tree?  Is
> > anyone needing this now?
> 
> Well, I thought that the Hannes' work would depend on it quite a bit. :-)

Hannes's work is still in my TO-APPLY mbox, only his cleanup patches are
in the tree and queued up for .28.  Now that your patch is in, his can
be based off of this, and all of them go into .29.

Sound good?

thanks,

greg k-h
