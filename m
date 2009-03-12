Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZCLDJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZCLDJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZCLDJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:09:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:51275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZCLDJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:09:29 -0400
Date: Thu, 12 Mar 2009 04:09:27 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jorge@dti2.net, ext-adrian.hunter@nokia.com, stable@kernel.org
Subject: Re: [patch] fs: avoid I_NEW inodes
Message-ID: <20090312030927.GA1893@wotan.suse.de>
References: <20090305064554.GA11916@wotan.suse.de> <20090305100000.GA29177@duck.suse.cz> <20090305101637.GB17815@wotan.suse.de> <20090305111226.GB29531@duck.suse.cz> <20090310134106.GA15977@wotan.suse.de> <20090310160321.GB1190@duck.suse.cz> <20090311032918.GE16561@wotan.suse.de> <20090311122420.GB24590@duck.suse.cz> <20090311125748.GA14144@wotan.suse.de> <20090311131915.14b8ac71.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311131915.14b8ac71.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 01:19:15PM -0700, Andrew Morton wrote:
> On Wed, 11 Mar 2009 13:57:48 +0100
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Wed, Mar 11, 2009 at 01:24:20PM +0100, Jan Kara wrote:
> > > On Wed 11-03-09 04:29:18, Nick Piggin wrote:
> > > > How about this?
> > >   Looks fine to me.
> > 
> > Thanks for the good review. Andrew, do you think you can apply this
> > on top of the previous patch? I'm undecided as to whether they should
> > go together or not. Probably the first one is a minimal fix that
> > doesn't alter behaviour as much, but things seem more robust after this
> > 2nd patch. I think both would probably be suitable for 2.6.29, being a
> > nasty bug, but it isn't a recent regression AFAIKS.
> > 
> 
> How's about we do fs-new-inode-i_state-corruption-fix.patch in 2.6.29
> and fs-avoid-i_new-inodes.patch in 2.6.30?  We could backport
> fs-avoid-i_new-inodes.patch into 2.6.29.x if needed.

Yes that's probably best.

