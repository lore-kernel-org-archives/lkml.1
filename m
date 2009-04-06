Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZDFPLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZDFPLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZDFPK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:10:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49497 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbZDFPK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:10:56 -0400
Date: Mon, 6 Apr 2009 17:10:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Message-ID: <20090406151054.GD5178@kernel.dk>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06 2009, Linus Torvalds wrote:
> 
> 
> On Mon, 6 Apr 2009, Jens Axboe wrote:
> > 
> > This is a set of patches that I worked on today in the hopes
> > of furthering the latency goals and at least fixing some of
> > the write regression with fwrite + fsync that current -git
> > is suffering from.
> 
> Goodie. Let's just do this. After all, right now we would otherwise have 
> to revert the other changes as being a regression, and I absolutely _love_ 
> the fact that we're actually finally getting somewhere on this fsync 
> latency issue that has been with us for so long.

Agree, it's been nagging for some time...

> Jens - I can just apply this queue (I want to test it out anyway), or if 
> you prefer I can pull from you. Just tell me.

Whatever you want, if you want to pull instead of manually applying,
it's:

git://git.kernel.dk/linux-2.6-block.git blk-latency

-- 
Jens Axboe

