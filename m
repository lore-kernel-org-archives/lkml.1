Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYBECgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYBECgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 21:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYBECgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 21:36:38 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:61381 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYBECgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 21:36:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZzobpeuZl2/zxlKJbgy5mXr1ZF+YqQQc0/YjwI1w+ymvqZro1HmFBWkTkOkX/AC3aLstdGAyp4UCU8t7yG4o/2U4UhzWx/Loqi+CqhjnKqmxmSgM1vJJHP7E1GAmlyMPaopF8Wv6iDSqkOlE9WnRFZOk3KwtFDqE0FJfFmHQ3HA=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Date: Tue, 5 Feb 2008 04:36:30 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20080130011550.GA31853@elte.hu>
In-Reply-To: <20080130011550.GA31853@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802050436.31070.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 January 2008 03:15:50 Ingo Molnar wrote:
> 
> Linus, please pull the latest x86 git tree from:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> 
> Find the shortlog attached below.
> 
> Most of the changes we have described here:
> 
>     http://lkml.org/lkml/2008/1/21/230
> 
> It's not a small merge, it consists of 908 commits from 96 individual 
> arch/x86 developers (!):
> 
>     671 files changed, 42791 insertions(+), 38967 deletions(-)
> 
> so here are a few highlevel comments as well, in addition to the 
> shortlog:
> 
> - a number of core files are changed as well: most notably percpu,
>   debugging details, timers, the firewire remote debugging patch and ...
>   the KGDB remote debugging stub in kernel/kgdb.c.
> 
> - we tested KGDB to be merge-worthy within the x86 architecture (the 
>   only supported architecture for now) and it's better to have 
>   kernel/kgdb.c than arch/x86/kernel/kgdb.c. The code is reasonably 
>   clean and the user-space exposure is small - the only real exposure is 
>   the decades-old remote GDB protocol. We are happy to fix up any 
>   further cleanliness comments that people might have - but we really 
>   wanted to start somewhere and get this thing moving. As an added 
>   bonus: finally a kernel debugger that can be read without puking too
>   much ;-) [anyone remember KDB?]
> 

The x86 tree was merged several times, but I don't see kgdb included in 
latest mainline -git.

So just one question, will it be included or no?

Best regards,
	Maxim Levitsky
