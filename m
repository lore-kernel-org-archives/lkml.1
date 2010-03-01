Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878Ab0CAIt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:49:29 -0500
Received: from ozlabs.org ([203.10.76.45]:38188 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab0CAIt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:49:28 -0500
Date: Mon, 1 Mar 2010 19:49:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Luca Barbieri <luca@luca-barbieri.com>, Ingo Molnar <mingo@elte.hu>,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86-32: improve atomic64_t functions (v2)
Message-ID: <20100301084923.GG26848@brick.ozlabs.ibm.com>
References: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
 <4B845AEE.5080604@zytor.com>
 <ff13bc9a1002240156x27e28764mb6ba24da0b125d81@mail.gmail.com>
 <20100226101423.GA25641@elte.hu>
 <ff13bc9a1002260308k319d34b5y4757fcfb36106278@mail.gmail.com>
 <ff13bc9a1002260323k6b3f38ah4f0505e401dcf77d@mail.gmail.com>
 <4B8B6E43.9030305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8B6E43.9030305@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 11:35:31PM -0800, H. Peter Anvin wrote:

> On 02/26/2010 03:23 AM, Luca Barbieri wrote:
> > Sent patches, both to conditionally perform the test and implement the
> > functions for x86 and x86-64.
> 
> Yes, and with the test turned on, the kernel crashes immediately on boot
> on x86-64.
> 
> Some minor investigation reveals the following:
> 
> lib/atomic64.c has the wrong return value for atomic64_add_unless().
> With "wrong" I mean it is the opposite sense compared to
> atomic_add_unless(), not just on x86 but on all architectures.
> 
> Accordingly, I have to conclude that lib/atomic64.c is buggy, and that
> since your test matches that bug, I will have to conclude that your
> x86-32 implementation is also buggy.  Thus, please send patches to fix
> your test and your 32-bit implementations (and preferrably
> lib/atomic64.c too, but I can do that just fine.)
> 
> Cc: Paul Mackerras who did the generic atomic64_t implementation for
> verification that this is indeed a bug.

Yes, it sure looks like it.  *blush*

Paul.
