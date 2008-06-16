Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbYFPAFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbYFPAFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 20:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYFPAFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 20:05:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbYFPAE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 20:04:27 -0400
Date: Sun, 15 Jun 2008 17:04:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE fixes
In-Reply-To: <alpine.LFD.1.10.0806151630380.2949@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806151702400.2949@woody.linux-foundation.org>
References: <200806152149.11267.bzolnier@gmail.com> <alpine.LFD.1.10.0806151630380.2949@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Jun 2008, Linus Torvalds wrote:
> 
> It *looks* like it has all the new objects, but its 
> objects/info/alternates is corrupt:
> 
> 	[torvalds@hera ide-2.6.git]$ cat objects/info/alternates 
> 	/home/dump/git/linux-2.6.git/.git/objects
> 
> and there is no such thing as "/home/dump/git/linux-2.6.git/"

Ok, I did the pull by just copying the objects to a local repo, and 
setting the alternates file correctly. So it worked this time, but please 
double-check your alternates next time,

		Linus
