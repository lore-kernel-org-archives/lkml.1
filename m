Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYJJWnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYJJWnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYJJWni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:43:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54666 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbYJJWnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:43:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH -next] PM: Simplify the new suspend/hibernation framework for devices
Date: Sat, 11 Oct 2008 00:47:34 +0200
User-Agent: KMail/1.9.9
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Hannes Reinecke <hare@suse.de>
References: <200810060055.07601.rjw@sisk.pl> <200810062246.06654.rjw@sisk.pl> <20081010215242.GB21890@kroah.com>
In-Reply-To: <20081010215242.GB21890@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810110047.35993.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 10 of October 2008, Greg KH wrote:
> On Mon, Oct 06, 2008 at 10:46:05PM +0200, Rafael J. Wysocki wrote:
> > On Monday, 6 of October 2008, Rafael J. Wysocki wrote:
> > > Hi Greg,
> > > 
> > > I promised at the KS that I would simplify the new suspend/hibernation
> > > framework for devices to avoid the confusion with two types of PM
> > > operations and pointers to PM operations from too many places.
> > > 
> > > The appended patch is intended for this purpose.  Unfortunately, I can't
> > > split it into subsystem-related patches, because compilation would be broken
> > > between them.
> > > 
> > > The patch applies to linux-next, but it's trivial to make it apply to the
> > > mainline.  It's been compiled on x86 (both 32-bit and 64-bit) and tested
> > > on hp nx6325, doesn't appear to break anything.
> > 
> > This one had a checkpatch.pl problem, sorry for that.  Updated patch is
> > appended.
> 
> I've added this to my tree (Jesse, is this ok, as it does have a PCI
> portion?)
> 
> But it's too late for .28, especially due to the -next tree not up and
> running right now.  I'll let it bake in -mm and -next and it should go
> into .29.
> 
> Is that ok?

Well, if anyone pushes anything depending on this framework for .27, that will
become a !@#$%^&* mess (we've had this problem once already).

Other than that, fine by me.

Thanks,
Rafael
