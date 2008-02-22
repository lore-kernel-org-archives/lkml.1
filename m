Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbYBVFBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbYBVFBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 00:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYBVFB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 00:01:27 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53388 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYBVFB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 00:01:26 -0500
Message-ID: <47BE571E.4000802@garzik.org>
Date: Fri, 22 Feb 2008 00:01:18 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Lachlan McIlroy <lachlan@sgi.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc3
References: <20080222044209.AD5C558C4C0F@chook.melbourne.sgi.com>
In-Reply-To: <20080222044209.AD5C558C4C0F@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lachlan McIlroy wrote:
>     Remove empty file fs/xfs/Makefile-linux-2.6.

Already in the upstream kernel...


> commit 1803f3389b7ac9ed33ea561b3b94e22e2864a95d
> Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
> Date:   Wed Feb 20 19:55:09 2008 -0800
> 
>     Remove empty file remnants that were left in the tree by mistake
>     
>     Noted by various people (Sam, Jeff, Roland..)
>     
>     Commit 58b7983d15a422d9616bdc4e245d5c31dfaefbe2 intended to remove the
>     xfs "Makefile-linux-2.6" file, but it was mistakenly still left in the
>     tree as a empty file, and would cause git to correctly complain about a
>     tracked file being removed after a "make distclean" (which removes empty
>     files as garbage).
>     
>     And the asm-x86/desc_64.h file was supposed to be removed by commit
>     c81c6ca45a69478c7877b729af1942d2b80ef582, but instead stayed around
>     containing just a single newline.
>     
>     Get rid of them both properly.
>     
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
