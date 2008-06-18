Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbYFRQNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbYFRQNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYFRQM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:12:56 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:50437 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383AbYFRQMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:12:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADjQWEh5LG+u/2dsb2JhbACwXA
X-IronPort-AV: E=Sophos;i="4.27,666,1204464600"; 
   d="scan'208";a="129305555"
Date: Thu, 19 Jun 2008 02:12:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Marco Berizzi <pupilla@hotmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS: 2.6.26-rc6 link count mismatch for inode
Message-ID: <20080618161252.GV3700@disturbed>
Mail-Followup-To: Marco Berizzi <pupilla@hotmail.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <BAY103-DAV69C0718B7EDB534D9337FB2A90@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV69C0718B7EDB534D9337FB2A90@phx.gbl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 11:11:31AM +0200, Marco Berizzi wrote:
> Hi Folk,
> 
> I was tring to compile firefox 3.0rc3
> and while I was erasing a previous
> /tmp/mozilla tree, I started a new
> tar xjf mozilla-blabla.
> After a while linux 2.6.26-rc6 was
> unresponsive: I have unplugged the
> power cable. No problem at startup,
> but:

What are your mount options? Are you using barriers (what does XFS
output in dmesg when mounting the filesystem)?  I ask because I've
seen this sort of directory corruption before when using volatile
write caches and yanking the power....

i.e. the corruption could have been caused by the way you reset the
system, not because of the hang. Do you have any information on what
caused the hang?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
