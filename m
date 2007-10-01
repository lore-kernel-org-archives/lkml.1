Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbXJAPDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbXJAPDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXJAPDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:03:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56255 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754895AbXJAPDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:03:10 -0400
Date: Mon, 1 Oct 2007 08:02:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tim Shimmin <tes@sgi.com>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.23 - revert a commit
In-Reply-To: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com>
Message-ID: <alpine.LFD.0.999.0710010753500.3579@woody.linux-foundation.org>
References: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Oct 2007, Tim Shimmin wrote:
> 
> Lachlan's description:
>     This fix is for a problem that has been in XFS since day one.
>     [XFS] Avoid replaying inode buffer initialisation log items if on-disk version is newer.
	...

Why wasn't this in the commit logs? Now it just says it was reverted, with 
no actual reasoning *why*. And it apparently wasn't so obvious that no 
such reasoning is needed.

Gah. I ended up amending the commit and updating it with the comment.

		Linus
