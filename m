Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0BAPrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:47:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:59682 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab0BAPrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:47:00 -0500
Message-ID: <4B66F752.1070001@windriver.com>
Date: Mon, 01 Feb 2010 09:46:26 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree with the kgdb tree
References: <20100201172952.95fe2150.sfr@canb.auug.org.au>
In-Reply-To: <20100201172952.95fe2150.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2010 15:46:26.0381 (UTC) FILETIME=[B68E57D0:01CAA355]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the tip tree got a conflict in
> arch/x86/kernel/kgdb.c between commit
> 53a2aa296b5108e9bfdcda7f41221e721d9c7474 ("x86,hw_breakpoint,kgdb: kgdb
> to use hw_breakpoint API") from the kgdb tree and commit
> cc0967490c1c3824bc5b75718b6ca8a51d9f2617 ("x86, hw_breakpoints, kgdb: Fix
> kgdb to use hw_breakpoint API") from the tip tree.
>
> These two commits are similar but sufficiently different to make a mess.
> I effectively reverted the kgdb tree version and used the tip tree
> version.  This also involved reverting the kgdb tree changes to
> arch/x86/kernel/hw_breakpoint.c.  I hope I got it right (since I had to
> reapply a few other kgdb changes by hand) (an x86_64 allmodconfig build
> produces no new warnings or errors, so I have some hope).
>
> Someone should give me some guidance as to a way forward here, please.
>
>   

What is in tip is the correct version. 

It is the age old time dependency of who updates whose tree first, vs
when the linux-next merge runs.  At any rate this is already resolved.

Thanks,
Jason.
