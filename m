Return-Path: <linux-kernel-owner+w=401wt.eu-S1762595AbYBPGdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762595AbYBPGdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 01:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYBPGdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 01:33:00 -0500
Received: from verein.lst.de ([213.95.11.210]:55456 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbYBPGc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 01:32:59 -0500
Date: Sat, 16 Feb 2008 07:31:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Tso <tytso@MIT.EDU>, haveblue@us.ibm.com,
       linux-kernel@vger.kernel.org, hch@lst.de, miklos@szeredi.hu
Subject: Re: [PATCH 07/30] r/o bind mounts: stub functions
Message-ID: <20080216063129.GA8592@lst.de>
References: <20080215223721.9E0A088A@kernel> <20080215223730.90A85F4A@kernel> <20080216003219.GA26734@mit.edu> <1203122979.13230.3.camel@nimitz.home.sr71.net> <20080216010030.GC26734@mit.edu> <20080215171119.578bd302.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215171119.578bd302.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 05:11:19PM -0800, Andrew Morton wrote:
> > It would be nice if an initial patch which introduces the new
> > functionality you need for r/o bind mounts could get introduced into
> > mainline *first*, and then people could add patches that call
> > mnt_want_write(), et. al into their trees gradually.
> 
> Yes, I expect that merging a handful of do-nothing mnt_foo_write()
> functions into mainline right now would ease life.
> 
> > otherwise akpm gets grumpy
> 
> itym "less than usually cheery"

Haha,

once we put pieces in the first three patches would be useful aswell,
to easily catch additions in the next cycle that might be adding
NULL-vfsmount calls to dentry_open.
