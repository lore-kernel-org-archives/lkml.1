Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbYJJV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbYJJV4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760363AbYJJV4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:56:01 -0400
Received: from kroah.org ([198.145.64.141]:53124 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759469AbYJJV4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:56:00 -0400
Date: Fri, 10 Oct 2008 14:52:42 -0700
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
Message-ID: <20081010215242.GB21890@kroah.com>
References: <200810060055.07601.rjw@sisk.pl> <200810062246.06654.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810062246.06654.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 10:46:05PM +0200, Rafael J. Wysocki wrote:
> On Monday, 6 of October 2008, Rafael J. Wysocki wrote:
> > Hi Greg,
> > 
> > I promised at the KS that I would simplify the new suspend/hibernation
> > framework for devices to avoid the confusion with two types of PM
> > operations and pointers to PM operations from too many places.
> > 
> > The appended patch is intended for this purpose.  Unfortunately, I can't
> > split it into subsystem-related patches, because compilation would be broken
> > between them.
> > 
> > The patch applies to linux-next, but it's trivial to make it apply to the
> > mainline.  It's been compiled on x86 (both 32-bit and 64-bit) and tested
> > on hp nx6325, doesn't appear to break anything.
> 
> This one had a checkpatch.pl problem, sorry for that.  Updated patch is
> appended.

I've added this to my tree (Jesse, is this ok, as it does have a PCI
portion?)

But it's too late for .28, especially due to the -next tree not up and
running right now.  I'll let it bake in -mm and -next and it should go
into .29.

Is that ok?

thanks,

greg k-h
