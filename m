Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZHKOLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZHKOLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZHKOLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:11:24 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:53579 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbZHKOLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:11:23 -0400
Date: Tue, 11 Aug 2009 09:04:08 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <gregkh@suse.de>
Cc: Martyn Welch <martyn.welch@gefanuc.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
Message-ID: <20090811070408.GA3251@braap.org>
References: <20090803205657.964064732@mini.kroah.org> <20090803210116.GC28430@kroah.com> <20090808232259.GA29303@braap.org> <20090809121715.GA3884@braap.org> <20090810162826.GA27912@suse.de> <20090810200526.GC3055@braap.org> <20090810210938.GB24623@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810210938.GB24623@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Aug 10, 2009 at 10:05:26PM +0200, Emilio G. Cota wrote:
> > Greg KH wrote:
> > > On Sun, Aug 09, 2009 at 02:17:16PM +0200, Emilio G. Cota wrote:
> > > > > Instead of using that we implemented a heretic IOCTL-based
> > > > > interface for user-space; at least with it you could create a
> > > > > driver (with no interrupt support) for a device in user-space.
> > > 
> > > Why not just use the UIO interface instead of creating
> > > yet-another-kernel/user-api?
> > > 
> > > Will that interface not work for what you want to use here?
> > 
> > Certainly. I didn't mean we'd like to see that merged. Currently
> > we make extensive use of IOCTLs because we are maintaining
> > kernel and user-space code for two platforms/OSes (ppc-lynx and
> > x86-linux), and not having access to lynx' source code doesn't
> > help. So IOCTLs are pretty much everywhere, much to my regret.
> 
> That does not mean we will accept adding new ioctls for the Linux
> drivers, so I fail to see the point of this :)

I showed it just to point out that the vmelinux.org interface was
not very useful--I never said I'd like to see these IOCTLs merged.

I do *not* want to see those IOCTLs anywhere outside of our code,
and never did. Sorry for the confusion; hope it's clear now.

E.
