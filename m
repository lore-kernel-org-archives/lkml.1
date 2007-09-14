Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbXINIan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbXINIan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 04:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbXINIaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 04:30:35 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5728 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbXINIae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 04:30:34 -0400
Date: Fri, 14 Sep 2007 10:30:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: 2.6.23-rc4-mm1: git-block.patch broke pktcdvd
Message-ID: <20070914083025.GA25592@kernel.dk>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <46E5A6D1.3050704@free.fr> <46E9BEB1.3060504@free.fr> <20070913160554.ba812d76.akpm@linux-foundation.org> <20070914080020.GZ25592@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914080020.GZ25592@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14 2007, Jens Axboe wrote:
> On Thu, Sep 13 2007, Andrew Morton wrote:
> > On Fri, 14 Sep 2007 00:50:25 +0200
> > Laurent Riffard <laurent.riffard@free.fr> wrote:
> > 
> > > I dig through git-block.patch and the culprit seems to be commit
> > > c94f1c4ac87862675c8d70941973bc3a69aff5d8 "bio: use memset() in
> > > bio_init()".
> > 
> > I think I'll be dropping git-block.  There were a number of problems
> > in rc4-mm1 (for which I have a sprinkling of messy-looking patches
> > somewhere ahead of my current cursor) and nothing seems to have
> > happened in the git tree for a month or so.
> 
> Huh? It's not even two weeks old. And here we go again, git-block is
> getting dropped and you'll be complaining about lack of testing next.
> I'll update the branches today as discussed with Tomo, that should work
> fine.

Branches updated with the scsi host template addition and the qla sg
chaining fix.

-- 
Jens Axboe

