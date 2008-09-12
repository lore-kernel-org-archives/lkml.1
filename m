Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYILVpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYILVpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYILVpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:45:01 -0400
Received: from www.tglx.de ([62.245.132.106]:56173 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbYILVpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:45:00 -0400
Date: Fri, 12 Sep 2008 23:44:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
In-Reply-To: <87y71xqd1x.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0809122323050.13819@apollo.tec.linutronix.de>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com> <20080912122031.eca8723e.akpm@linux-foundation.org> <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com> <48CACD68.4050006@zytor.com> <87y71xqd1x.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008, Andi Kleen wrote:
> On the other hand there's quite some other information dumped
> at boot that could be cut out. e.g. It doesn't really make 
> much sense to dump the cache information of each CPU at boot
> when that information can easily be gotten from user space
> later.

You're assuming that you ever reach user space, which is a pretty dumb
assumption.

I prefer to have a detailed view of the machine when I have to look at
a bug report where the machine does _NOT_ reach user space.
 
> I personally was also always sceptical of some of the
> more detailed new memory map dumping, like those "nosave
> memory" or the early reservation/early node/add_active_range output.
> It's pretty much a direct function of the e820 map dumped earlier.
> Also node information has now the dubious distinction to be 
> the most redundantly dumped kernel information of all.

Bla, bla, bla. 

This code was reworked significantly and every information which is
given about the various decisions made are useful to debug problems. I
prefer a more noisy startup over some silent fuckup when a problem
hits.

We had enough trouble to decode silent "fixups" which failed
miserably.

Thanks,

	tglx
