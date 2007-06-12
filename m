Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbXFLXr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbXFLXr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXFLXrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:47:51 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39288 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbXFLXrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:47:51 -0400
Date: Tue, 12 Jun 2007 16:47:32 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cebbert@redhat.com, sandeen@redhat.com, maneesh@in.ibm.com,
       cs@tequila.co.jp
Subject: Re: [PATCHSET 2.6.22-rc4] sysfs: fix race conditions
Message-ID: <20070612234732.GA26286@kroah.com>
References: <20070611050107.GJ29122@htj.dyndns.org> <20070610231203.730d0aba.akpm@linux-foundation.org> <466CE88B.2050803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466CE88B.2050803@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 03:15:39PM +0900, Tejun Heo wrote:
> Andrew Morton wrote:
> >> This patchset contains three minimal backports of fixes in -mm.  With
> >> all patches in the patchset and sysfs-races.patch applied, kernel
> >> survived ~20 hours of stress test without any problem.
> > 
> > So these are being proposed for 2.6.22?
> 
> Yeap.
> 
> > I do wonder about Rafael's bug which he bisected down to
> > gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch.
> > 
> > If that won't be a problem in this patchset then I spose it's probably best
> > to go ahead with a 2.6.22 merge, but it's more a Greg thing than a me
> > thing.
> 
> I'm currently debugging that and it's irrelevant to these fixes.  The
> bug is introduced far after the fixes.
> 
> > I don't have a tree to merge these patches into, unless I drop all the
> > patches which are in Greg's tree.
> > 
> > Greg, can I leave it up to you to decide how we are to proceed here?
> 
> I can rebase all sysfs patches in -mm on top of linus#master + these
> fixes if necessary.

Ok, I've sent these to Linus, so if he takes them, can you rebase your
patches on top of this and resend the whole tree to me (or just the ones
that needed to be modified, if that's easier.)

thanks again for this fix, I really appreciate it.

greg k-h
