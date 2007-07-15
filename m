Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbXGONuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbXGONuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 09:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbXGONtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 09:49:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36401 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbXGONtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 09:49:52 -0400
Date: Sun, 15 Jul 2007 22:47:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: mel@skynet.ie (Mel Gorman)
Cc: npiggin@suse.de, akpm@linux-foundation.org, kenchen@google.com,
       jschopp@austin.ibm.com, apw@shadowen.org, a.p.zijlstra@chello.nl,
       y-goto@jp.fujitsu.com, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add a movablecore= parameter for sizing ZONE_MOVABLE
Message-Id: <20070715224757.6432e977.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070714130207.GA15864@skynet.ie>
References: <20070710102043.GA20303@skynet.ie>
	<20070712122925.192a6601.akpm@linux-foundation.org>
	<20070712213241.GA7279@skynet.ie>
	<20070713155610.GD14125@skynet.ie>
	<20070714082807.GC1198@wotan.suse.de>
	<20070714130207.GA15864@skynet.ie>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 14:02:08 +0100
mel@skynet.ie (Mel Gorman) wrote:
> > What's the status of making it configurable? I didn't see something
> > in -mm for that yet?
> > 
> 
> I have a patch that makes it configurable but Kamezawa-san posted a very
> promising patch about making all zones configurable in a very clever way
> which is more general than what I did. He posted it as an RFC[1] and there
> was feedback from Andy Whitcroft on how it could be made better so it wouldn't
> have been picked up for -mm but something is in the pipeline.
> 
I'll post it when I can. against the newest -mm.

> I've tested his patch for zone movable and it worked as advertised so I
> intended to see post-merge window what else could be done with it clean-up
> wise. I am curious to see if it can also make ZONE_NORMAL configurable on
> machines that only have ZONE_DMA for example.
> 
I think it as an interesting idea, Hmm....

-Kame
