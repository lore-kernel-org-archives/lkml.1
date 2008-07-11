Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYGKKWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYGKKWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYGKKV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:21:58 -0400
Received: from swm.pp.se ([212.247.200.143]:43973 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYGKKV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:21:58 -0400
Date: Fri, 11 Jul 2008 12:21:56 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Dave Chinner <david@fromorbit.com>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: xfs bug in 2.6.26-rc9
In-Reply-To: <20080711084248.GU29319@disturbed>
Message-ID: <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se>
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008, Dave Chinner wrote:

> That aside, what was the assert failure reported prior to the oops? i.e. 
> paste the lines in the log before the ---[ cut here ]--- line? One of 
> them will start with 'Assertion failed:', I think....

These ones?

Jul  8 04:44:56 via kernel: [554197.888008] Assertion failed: whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, line: 5879
Jul  9 03:25:21 via kernel: [42940.748007] Assertion failed: whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, line: 5879

I'll happily rebuild the kernel without the debug option and do xfs_check 
to weed out any possible logical problem with the volume, if you don't 
need any further information from the current state of my volume.

I should also say that this assert failue happened two nights in a row so 
I guess it's fairly reproducible (didn't happen on the 10th, and today, 
the 11th it seems to have panic:ed around 03:30 (I start the 
defragmentation via cron at 03:00) which I think is related.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
