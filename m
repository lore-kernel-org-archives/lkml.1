Return-Path: <linux-kernel-owner+w=401wt.eu-S1762440AbXJYXyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762440AbXJYXyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbXJYXyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:54:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754818AbXJYXyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:54:01 -0400
Date: Thu, 25 Oct 2007 16:53:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 update
Message-Id: <20071025165358.c408314d.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710251643120.30120@woody.linux-foundation.org>
References: <E1Ii0UI-0007TW-IM@closure.thunk.org>
	<alpine.LFD.0.999.0710170857490.26902@woody.linux-foundation.org>
	<20071025163113.491a4461.akpm@linux-foundation.org>
	<alpine.LFD.0.999.0710251643120.30120@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 16:44:21 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 25 Oct 2007, Andrew Morton wrote:
> > 
> > There shouldn't have been conflicts here - if there were I wouldn't have
> > sent those patches.  Unless there were things in the ext4 pull which
> > weren't present in the ext4 quilt tree which I included in 2.6.23-mm1?
> 
> Well, you merge your patch-series by patching.
> 
> You should have noticed by now that GNU patch in particular will happily 
> apply a patch whether it conflicts or not. So it's entirely possible that 
> it didn't conflict for you, but applied cleanly and sanely.
> 

hrm, could be.  It would be strange for that to happen quietly with fuzz=1
and to still produce a compileable result.

But there weren't any patches in this git-merge which weren't in 2.6.23-mm1
so maybe something like that happened.  Or maybe that fact that this pull
only contained _some_ of the ext4 patches which were in -mm somehow affected
things.

Oh well, I should have sent the ext4 changes via Ted anyway.
