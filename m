Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbYFOXeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbYFOXeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 19:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbYFOXdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 19:33:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755160AbYFOXdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 19:33:45 -0400
Date: Sun, 15 Jun 2008 16:33:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE fixes
In-Reply-To: <200806152149.11267.bzolnier@gmail.com>
Message-ID: <alpine.LFD.1.10.0806151630380.2949@woody.linux-foundation.org>
References: <200806152149.11267.bzolnier@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Jun 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> Linus, please pull from:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

That repo seems incomplete.

It *looks* like it has all the new objects, but its 
objects/info/alternates is corrupt:

	[torvalds@hera ide-2.6.git]$ cat objects/info/alternates 
	/home/dump/git/linux-2.6.git/.git/objects

and there is no such thing as "/home/dump/git/linux-2.6.git/"

So you seem to have screwed up the alternates file (you probably have 
something like that alternates file on your own machine?), and then 
rsync'ed it to master.kernel.org or something like that?

		Linus
