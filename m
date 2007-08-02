Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbXHBCsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbXHBCsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 22:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXHBCsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 22:48:06 -0400
Received: from waste.org ([66.93.16.53]:56967 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbXHBCsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 22:48:04 -0400
Date: Wed, 1 Aug 2007 21:48:12 -0500
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 11/26] tmpfs white-out support
Message-ID: <20070802024812.GN11166@waste.org>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.160845468@weierstrass.suse.de> <Pine.LNX.4.64.0708011559340.19454@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011559340.19454@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 04:13:46PM +0100, Hugh Dickins wrote:
> On Mon, 30 Jul 2007, Jan Blunck wrote:
> 
> > Introduce white-out support to tmpfs.
> > 
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > ---
> >  include/linux/shmem_fs.h |    1 
> >  mm/shmem.c               |   54 +++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 55 insertions(+)
> 
> I see there's debate about whether this (and its fellows) give the
> right semantic to whiteouts; and I've not begun to think about that.
> 
> But as a patch to tmpfs for what you're trying to do, it looks just
> about fine.  I say "just about" because the reference counting looks
> right, but I wouldn't dare say that it _is_ right without testing.
> 
> And I'd probably want to add a minor adjustment, so that a mount with
> nr_inodes=1000 could still support exactly 1000 inodes, despite your
> allocating one for the whiteout (usually never used) at mount time.
> But that can follow along later, no problem.

Also, you might want to make sure whiteouts work with ramfs, which
replaces tmpfs when tmpfs is disabled.

-- 
Mathematics is the supreme nostalgia of our time.
