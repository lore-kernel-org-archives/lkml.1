Return-Path: <linux-kernel-owner+w=401wt.eu-S932841AbYJKSNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbYJKSNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 14:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932673AbYJKSNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 14:13:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932678AbYJKSNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 14:13:38 -0400
Date: Sat, 11 Oct 2008 11:12:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull, take 2] x86 updates for v2.6.28, phase #4, x2apic,
 unify-cpu-detect
In-Reply-To: <20081010175613.GA20112@elte.hu>
Message-ID: <alpine.LFD.2.00.0810111108060.3402@nehalem.linux-foundation.org>
References: <20081010000408.GA5970@elte.hu> <20081010175613.GA20112@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, Ingo Molnar wrote:
> 
> Please pull the latest x86-v28-for-linus-phase4-B git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase4-B

This is broken.

I get an absolute metric shitload of:

	include/asm/dma-mapping.h:309:2: error: #endif without #if

errors, and I suspect it's because of some broken merge resolution that 
you didn't even test and then fixed in some later branch.

I double-checked: it's already broken in your tree, it's not from my 
merge (ie commit 0d4ab8b5aa74f6be4d022dcf5e27845b7c290294 is already 
showing that bug).

Not pulled.

		Linus
