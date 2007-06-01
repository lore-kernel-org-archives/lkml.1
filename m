Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbXFAWrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbXFAWrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXFAWrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:47:42 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbXFAWrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:47:41 -0400
Date: Fri, 1 Jun 2007 15:47:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-Id: <20070601154735.197b663f.akpm@linux-foundation.org>
In-Reply-To: <20070601223302.GY20632@ca-server1.us.oracle.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070531231354.GR20632@ca-server1.us.oracle.com>
	<20070601010129.GA15878@wotan.suse.de>
	<20070601012440.GS20632@ca-server1.us.oracle.com>
	<20070601013402.GB28585@wotan.suse.de>
	<20070601014517.GT20632@ca-server1.us.oracle.com>
	<20070601015349.GC28585@wotan.suse.de>
	<20070601052039.GU20632@ca-server1.us.oracle.com>
	<20070601220117.GW20632@ca-server1.us.oracle.com>
	<20070601152537.a04209ff.akpm@linux-foundation.org>
	<20070601223302.GY20632@ca-server1.us.oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 15:33:02 -0700
Mark Fasheh <mark.fasheh@oracle.com> wrote:

> On Fri, Jun 01, 2007 at 03:25:37PM -0700, Andrew Morton wrote:
> > > Andrew, if this is ok with you I'd really like to see that fix in -mm. Ocfs2
> > > shared write mmap will instantly deadlock without it.
> > 
> > ug, OK.  I get a ginormous reject when merging ocfs2 on Nick's stuff which
> > I've been largely ignoring thus far.
> 
> Huh, I'm a bit confused... I created this patch on top of 2.6.22-rc3-mm1
> which most certainly contains a merge of git-ocfs2.patch and the series
> which at least contains
> mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch.

Right.  I did a lot of tricksy work for rc3-mm1 to merge git-ocfs2 on top
of Nick's stuff.  Then I repulled your tree and lost it all.  This is
because I was dumb and I fixed rc3-mm1's git-ocfs.patch rather than doing a
separate fix-rejects-in-git-ocfs2.patch.

This is all unique-to-akpm stuff which you don't need to worry about ;)

> So, which of Nick's patches are we talking about here?
> 
> Btw, I know you tend to handle rejects yourself, but if it's a major PITA
> I'd be happy to help out. Boy, I'm hoping I didn't just ask for a load of
> trouble there :)

Is OK - I'll move Nick's patches back to behind the git trees and it'll all come
good.

