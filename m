Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYBPGwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYBPGwY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 01:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbYBPGwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 01:52:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40198 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbYBPGwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 01:52:10 -0500
Date: Fri, 15 Feb 2008 22:46:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Theodore Tso <tytso@MIT.EDU>, haveblue@us.ibm.com,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu
Subject: Re: [PATCH 07/30] r/o bind mounts: stub functions
Message-Id: <20080215224608.fb5d11b7.akpm@linux-foundation.org>
In-Reply-To: <20080216063129.GA8592@lst.de>
References: <20080215223721.9E0A088A@kernel>
	<20080215223730.90A85F4A@kernel>
	<20080216003219.GA26734@mit.edu>
	<1203122979.13230.3.camel@nimitz.home.sr71.net>
	<20080216010030.GC26734@mit.edu>
	<20080215171119.578bd302.akpm@linux-foundation.org>
	<20080216063129.GA8592@lst.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 07:31:29 +0100 Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Feb 15, 2008 at 05:11:19PM -0800, Andrew Morton wrote:
> > > It would be nice if an initial patch which introduces the new
> > > functionality you need for r/o bind mounts could get introduced into
> > > mainline *first*, and then people could add patches that call
> > > mnt_want_write(), et. al into their trees gradually.
> > 
> > Yes, I expect that merging a handful of do-nothing mnt_foo_write()
> > functions into mainline right now would ease life.
> > 
> > > otherwise akpm gets grumpy
> > 
> > itym "less than usually cheery"
> 
> Haha,
> 
> once we put pieces in the first three patches would be useful aswell,
> to easily catch additions in the next cycle that might be adding
> NULL-vfsmount calls to dentry_open.

hrm, well, how about putting up a complete and suitably-changelogged patch
series for Linus to look at?  That's be a Dave thing I guess.

I wasn't overawed by the initial patch - why not make those stubs inlined
to truly add zero cost??


