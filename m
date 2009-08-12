Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbZHLE3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbZHLE3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 00:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZHLE3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 00:29:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:58471 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZHLE3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 00:29:00 -0400
Date: Tue, 11 Aug 2009 21:31:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: David Dillow <dave@thedillows.org>, Andi Kleen <andi@firstfloor.org>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090811213128.2f2a3093@infradead.org>
In-Reply-To: <20090812003433.GA25392@kroah.com>
References: <20090805182805.GA7534@kroah.com>
	<20090805185136.GA21442@kroah.com>
	<87ljlxhrnr.fsf@basil.nowhere.org>
	<1249575658.19886.8.camel@lap75545.ornl.gov>
	<20090806183147.GA28409@suse.de>
	<1249772876.22248.34.camel@obelisk.thedillows.org>
	<20090810153943.GB7652@kroah.com>
	<1250001374.22248.65.camel@obelisk.thedillows.org>
	<20090811145523.GD14368@basil.fritz.box>
	<1250036727.26788.7.camel@obelisk.thedillows.org>
	<20090812003433.GA25392@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 17:34:33 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, Aug 11, 2009 at 08:25:27PM -0400, David Dillow wrote:
> > On Tue, 2009-08-11 at 16:55 +0200, Andi Kleen wrote:
> > > > No, not really. It isn't hard to make a static /dev, or a
> > > > rescue initrd for the cases with dynamic device numbers.
> > > 
> > > There's a world between strictly controlled embedded and fully
> > > general distributions.
> > 
> > Sure, and I've acknowledged that. But it doesn't mean this needs a
> > kernel solution.
> > 
> > > I want a dynamic /dev, but a fast one that doesn't need initrd or
> > > slows down booting.
> > 
> > So use Eric/Arjan's program that does it in 60ms -- you get a
> > dynamic /dev, no initrd, fast boot, and no kernel changes required.
> 
> Their program only handles it for a reconstruction of /dev based on
> sysfs one time at boot.  It does not handle things that are added or
> discovered by the system after that, you need udev for that.
> 
> So it's a great hack for boot time stuff, but not a complete /dev
> management replacement 

yeah you want udev for that anyway for various reasons...
(not that udev is expensive per se, the expensive part of it is the exec
of modprobe a hundred times... beyond that udev seems pretty cheap to
me)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
