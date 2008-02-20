Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbYBTW7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbYBTW7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbYBTW7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:59:06 -0500
Received: from verein.lst.de ([213.95.11.210]:48587 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbYBTW7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:59:05 -0500
Date: Wed, 20 Feb 2008 23:58:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       Theodore Tso <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu
Subject: Re: [PATCH 07/30] r/o bind mounts: stub functions
Message-ID: <20080220225804.GA5484@lst.de>
References: <20080215223721.9E0A088A@kernel> <20080215223730.90A85F4A@kernel> <20080216003219.GA26734@mit.edu> <1203122979.13230.3.camel@nimitz.home.sr71.net> <20080216010030.GC26734@mit.edu> <20080215171119.578bd302.akpm@linux-foundation.org> <20080216063129.GA8592@lst.de> <1203546352.29823.57.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203546352.29823.57.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 02:25:52PM -0800, Dave Hansen wrote:
> On Sat, 2008-02-16 at 07:31 +0100, Christoph Hellwig wrote:
> > once we put pieces in the first three patches would be useful aswell,
> > to easily catch additions in the next cycle that might be adding
> > NULL-vfsmount calls to dentry_open.
> 
> So, we want
> 
> 	"[PATCH 07/30] r/o bind mounts: stub functions"
> and 
> 	"[PATCH 03/30] check for null vfsmount in dentry_open()"

For that latter patch we'd need the reiserfs and hpps fixes.  But
I think it's too late now, let's just keep them in -mm for the
time beeing.
