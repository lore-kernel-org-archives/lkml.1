Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbXFAW0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbXFAW0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbXFAWZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:25:46 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757600AbXFAWZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:25:45 -0400
Date: Fri, 1 Jun 2007 15:25:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-Id: <20070601152537.a04209ff.akpm@linux-foundation.org>
In-Reply-To: <20070601220117.GW20632@ca-server1.us.oracle.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070531231354.GR20632@ca-server1.us.oracle.com>
	<20070601010129.GA15878@wotan.suse.de>
	<20070601012440.GS20632@ca-server1.us.oracle.com>
	<20070601013402.GB28585@wotan.suse.de>
	<20070601014517.GT20632@ca-server1.us.oracle.com>
	<20070601015349.GC28585@wotan.suse.de>
	<20070601052039.GU20632@ca-server1.us.oracle.com>
	<20070601220117.GW20632@ca-server1.us.oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 15:01:18 -0700
Mark Fasheh <mark.fasheh@oracle.com> wrote:

> On Thu, May 31, 2007 at 10:20:39PM -0700, Mark Fasheh wrote:
> > Ok. So how about the attached patch? It's a bit different than discussed,
> > but I think it's much cleaner because it preserves the current behavior of
> > the callback and keeps that bit of page locking inside core code. Not tested
> > as of yet, but I can run it tommorrow.
> 
> Ok - this patch seems to check out fine in testing - no more deadlocking.
> 
> Andrew, if this is ok with you I'd really like to see that fix in -mm. Ocfs2
> shared write mmap will instantly deadlock without it.

ug, OK.  I get a ginormous reject when merging ocfs2 on Nick's stuff which
I've been largely ignoring thus far.

Perhaps I need to go back to staging Nick's stuff after the git trees.  I'll
take a look.
