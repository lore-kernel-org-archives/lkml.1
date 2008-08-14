Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYHNBEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYHNBEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 21:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbYHNBEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 21:04:30 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:59755 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbYHNBEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 21:04:30 -0400
Message-ID: <48A38490.7090604@tlinx.org>
Date: Wed, 13 Aug 2008 18:04:16 -0700
From: Linda Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: xfs-oss <xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Lock debugging noise or real problem?
References: <48A093A7.40606@tlinx.org> <48A09CA9.9080705@sandeen.net> <48A0F686.2090700@tlinx.org> <48A0F9FC.1070805@sandeen.net> <48A20E9E.9090100@tlinx.org> <20080813005852.GW6119@disturbed> <48A35A99.1080300@tlinx.org> <20080814004101.GE6119@disturbed>
In-Reply-To: <20080814004101.GE6119@disturbed>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> I've asked the lockdep ppl to treat stuff like memory reclaim and
> the iprune_mutex specially because of this recursive calling nature
> of memory reclaim, but so far nothing has happened....
---
	So it's really a kernel bug, not an XFS bug...(?)


> FWIW, I think that recent changes have resulted in the xfs_fsr case
> (swap_extents) being annotated properly so that one should go
> away.
---
	If it was limited to xfs_fsr, that'd be tolerable -- but its
cropping up in random user-level-apps (imaps, sort, et al).



> Well, any debugging code is really designed for test and dev systems,
> not for production systems.....
---
	The lock-correctness code is described as a feature to provide
"provability".  It's not called "debugging" and I don't regard that as
"debugging" -- but something that any production system that wants
operational integrity over a minor 'speed hit', would "theoretically"
want.

	If it is "debug" code, it should be labeled as such -- but
code that can mathematically guarantee that parts of the kernel operate
correctly seems like a _reliability_ feature, not a debugging feature.

	Thanks for the insight -- very appreciated.

linda


