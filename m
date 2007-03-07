Return-Path: <linux-kernel-owner+w=401wt.eu-S965605AbXCGUJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965605AbXCGUJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965597AbXCGUJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:09:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54290 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965605AbXCGUJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:09:14 -0500
Date: Wed, 7 Mar 2007 12:09:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mws <mws@twisted-brains.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: irq nobody cared issue on 2.6.2x
In-Reply-To: <200703072048.49637.mws@twisted-brains.org>
Message-ID: <Pine.LNX.4.64.0703071204290.5963@woody.linux-foundation.org>
References: <200703072048.49637.mws@twisted-brains.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Mws wrote:
>
> if you would be so kind to provide me some infos,
> 
> how i would be able to track the problem down _and_ maybe how to fix it.

The first step is to figure out as exactly as possible _when_ it started 
happening.

> please find two snippets of dmesg after booting 2.6.21-rc3-git 
> (2.6.20-1 has got the same results) 

So is 2.6.19 good? 2.6.20-rc1? -rc2?

If you're a git user (or even just marginally interested in learning), the 
best thing to do is to find some good kernel (the more recent, the better, 
but the keyword is *some* kernel that works well), and a bad kernel (the 
older the better, just to avoid unnecessary work, but again, you can just 
take the most recent too), and then just use "git bisect".

If you bisect it down to one particular commit, that will help us a lot, 
but even if you only bisect it down by booting a handful of kernels (say, 
5-6), it will already have cut things down a lot, and probably more easily 
and efficiently than if you just downloaded daily snapshots and tried to 
narrow it down that way.

		Linus
