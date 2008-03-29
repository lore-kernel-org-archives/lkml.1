Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYC2E4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYC2E4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 00:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYC2E4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 00:56:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52644 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYC2E4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 00:56:37 -0400
Date: Sat, 29 Mar 2008 04:56:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] jbd/jbd2 NULL noise
Message-ID: <20080329045634.GM10722@ZenIV.linux.org.uk>
References: <E1JfRPa-0002U9-J5@ZenIV.linux.org.uk> <1206760526.6543.0.camel@brick> <20080329031843.GJ10722@ZenIV.linux.org.uk> <1206761196.6543.2.camel@brick> <20080329034228.GK10722@ZenIV.linux.org.uk> <20080329035431.GL10722@ZenIV.linux.org.uk> <1206763312.6543.4.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206763312.6543.4.camel@brick>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 09:01:52PM -0700, Harvey Harrison wrote:
> > > > I did, it went into -mm and on Mar 5 it was taken into the subsystem
> > 
> > Al, still morbidly curious about the akpm's scripts and aforementioned
> > message...
> 
> Not sure which tree, but received this on Feb 27:
> 
> 
> The patch titled
>      jbd2: sparse warnings in revoke.c, journal.c
> has been removed from the -mm tree.  Its filename was
>      jbd2-sparse-warnings-in-revokec-journalc.patch
> 
> This patch was dropped because it was merged into mainline or a
> subsystem tree
> 
> The current -mm tree may be found at
> http://userweb.kernel.org/~akpm/mmotm/

Ah...  jbd part of it is still there, jbd2 is *also* there, but it's got
ext4-mm- prefix to filename.  And looking at ext4.git, jbd2 side of that
stuff *is* merged, so what the hell is it doing in a separate file?
Looks like -mm has ext4 stuff not as a single patch (like it does for
many other git trees) but split into individual changesets for some
reason...

Anyway, as long as this stuff gets eventually merged...
