Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863Ab0ASVTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0ASVTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763Ab0ASVSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:18:47 -0500
Received: from kroah.org ([198.145.64.141]:53502 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab0ASVSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:18:21 -0500
Date: Tue, 19 Jan 2010 13:11:17 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Linus <torvalds@linux-foundation.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: origin tree build warning
Message-ID: <20100119211117.GE10928@kroah.com>
References: <20100118150501.f6aa79e3.sfr@canb.auug.org.au>
 <20100118151401.dd8a9ef2.sfr@canb.auug.org.au>
 <6CADD16F56BC954D8E28F3836FA7ED7112A9CD50F8@shzsmsx501.ccr.corp.intel.com>
 <20100118164039.8da6403e.sfr@canb.auug.org.au>
 <20100119111226.c9405ac7.sfr@canb.auug.org.au>
 <20100119210514.GD10928@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119210514.GD10928@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 01:05:14PM -0800, Greg KH wrote:
> On Tue, Jan 19, 2010 at 11:12:26AM +1100, Stephen Rothwell wrote:
> > Hi Fengguang,
> > 
> > On Mon, 18 Jan 2010 16:40:39 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > On Mon, 18 Jan 2010 12:29:52 +0800 "Wu, Fengguang" <fengguang.wu@intel.com> wrote:
> > > >
> > > > On Mon, 18 Jan 2010 15:05:01 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > > >
> > > > > > It actually looks like commit c29af9636 ("sysdev: Pass attribute in
> > > > > > sysdev_class attributes show/store") referred to in the changelog for the
> > > > > > above commit has not yet been applied to Linus' tree?
> > > > >
> > > > > Commit c29af9636 ("sysdev: Pass attribute in sysdev_class attributes
> > > > > show/store") does appear in linux-next since next-20100111 (in the
> > > > > driver-core quilt series - therefore intended for 2.6.34) (it will have a
> > > > > different SHA1 today)
> > > > 
> > > > So let's queue 8ff410daa009c (sysdev: fix prototype for memory_sysdev_class show/store functions)
> > > > in driver-core and delay it to 2.6.34?
> > > 
> > > Then it would need to be reverted from Linus' tree.
> > 
> > I have reverted commit 8ff410daa009c for today.  It looks like Greg
> > already has the alternate patches queued in the driver-core tree to take
> > care of this problem when it arises.
> > 
> > So, Greg, can you ask Linus to revert 8ff410daa009c (sysdev: fix
> > prototype for memory_sysdev_class show/store functions), please?  Or
> > should I?  Or should we hope he notices these emails? :-)
> 
> No, I think the patch in Linus's tree is correct, so I have fixed up my
> tree now.

Ick, no, you are correct, Wu's patch shouldn't have been sent to Linus
yet.  I'll revert it, and then keep the fixes that were in my tree,
which should make everything safe for the .34 merge.

thanks,

greg k-h
