Return-Path: <linux-kernel-owner+w=401wt.eu-S966420AbXFGXLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966420AbXFGXLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763030AbXFGXLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:11:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762068AbXFGXLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:11:32 -0400
Date: Thu, 7 Jun 2007 16:09:04 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Jones <pjones@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607230904.GA7344@suse.de>
References: <1181228660.3625.23.camel@lov.localdomain> <46682385.1060802@redhat.com> <20070607154342.GA16911@suse.de> <20070607085200.f8d6e2d3.akpm@linux-foundation.org> <20070607155953.GA17591@suse.de> <20070607090632.cfcf02e6.akpm@linux-foundation.org> <20070607161525.GA18363@suse.de> <20070607184805.GA28551@nostromo.devel.redhat.com> <20070607200102.GA21653@suse.de> <20070607233258.063f6cfa@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607233258.063f6cfa@the-village.bc.nu>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 11:32:58PM +0100, Alan Cox wrote:
> > Ah, but the installer doesn't matter until you do a Fedora 8 release,
> > right?  This is just for people who want to run their own kernel on an
> > already-set-up Fedora machine.
> 
> People can and do roll updated install images because you get systems
> that aren't supported by the released CD boot image. The installer/initrd
> etc shouldn't keep getting broken by these kind of changes, its about
> time that all the sysfs type breakage causing patches simply got
> rejected, like such patches would in every other subsystem.
> 
> Yes it might cause a little pain, yes someone might have to tweak sysfs a
> bit to keep compatibility and decouple the external and internal view a
> bit - Matthew and others pointed out this problem several years ago and
> predicted the current state of affairs, so its had a lot of time to get
> fixed.

If CONFIG_SYSFS_DEPRECATED everything should work just fine with all old
initrd scripts.  It's only if you enable that option (which is enabled
by default) that you need to ensure that your distro has the latest
functionality so that everything works properly.

So, we should be fine here.  The distros that are up to date, and the
users of them, can disable the option.  All others need to keep it on.

thanks,

greg k-h
