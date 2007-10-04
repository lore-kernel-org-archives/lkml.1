Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbXJDQnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbXJDQnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759063AbXJDQnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:43:08 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:38552 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758AbXJDQnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:43:07 -0400
Date: Thu, 4 Oct 2007 18:43:04 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Peter Staubach <staubach@redhat.com>, nfsv4@linux-nfs.org,
       Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS
 client git tree...
Message-ID: <20071004184304.6e71ab6d@poseidon.drzeus.cx>
In-Reply-To: <1191506450.6685.17.camel@heimdal.trondhjem.org>
References: <1191454876.6726.32.camel@heimdal.trondhjem.org>
	<20071004085206.0a8e37b5@poseidon.drzeus.cx>
	<1191506450.6685.17.camel@heimdal.trondhjem.org>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 10:00:50 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Thu, 2007-10-04 at 08:52 +0200, Pierre Ossman wrote:
> > On Wed, 03 Oct 2007 19:41:16 -0400
> > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > 
> > > We also have the 64-bit inode support from RedHat/Peter Staubach.
> > > 
> > 
> > As has been pointed[1] out[2], this will cause regressions for
> > non-LFS applications (of which there are still lots and lots). This
> > change should be in feature-removal (the "feature" being removed is
> > legacy support for non-LFS applications using NFS servers that make
> > full use of the protocol) and preferably accompanied with
> > appropriate user space changes (e.g. compatibility option in glibc).
> > 
> > [1] https://bugzilla.redhat.com/show_bug.cgi?id=241348
> > [2] http://marc.info/?l=linux-nfs&m=118701088726477&w=2
> > 
> > Rgds
> 
> How about a boot/module parameter to turn it on or off?
> 

That would be perfect. It can even be in non-legacy mode by default,
just as long as you can go back to the old behaviour when/if you run
into a non-LFS application.

> I don't see any point in having a sysctl for something like this:
> either you have legacy applications or you don't. It is not something
> that you switch off as you go off to lunch.
> A compile parameter, OTOH, would be too restrictive since it would
> force distros to choose just one behaviour (which would mean they
> would have to choose the most conservative).
> 

Agreed.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
