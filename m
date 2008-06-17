Return-Path: <linux-kernel-owner+w=401wt.eu-S1759798AbYFQVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbYFQVih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYFQVi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:38:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756086AbYFQVi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:38:28 -0400
Date: Tue, 17 Jun 2008 14:37:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <48582D04.1000107@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0806171434200.2907@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <485829A1.4020705@firstfloor.org>
 <alpine.LFD.1.10.0806171421100.2907@woody.linux-foundation.org> <48582D04.1000107@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Andi Kleen wrote:
> 
> Ok if I'm really wrong on this (but frankly I don't see the mistake, sorry)
> for my person edification: what's a legitimate case for copy_to_user()
> where the source can fault?

Andi, read the patch already. And then shut up. I'm so tired of you always 
trying to argue against fixes, just because you wrote the code.

The fact is, that code was buggy. I've explained _why_ it was buggy. I've 
sent a patch. I've even talked about how I _tested_ the patch. You've read 
none of that, you just fixated on the fact that I said "to" instead of 
"from" by mistake, even though it's the exact same code.

At no point did you at all bother to read the patch, nor did you try to 
understand the problem, nor did you follow the original report or try it 
out, or think about it.

So tell me why I shouldn't just put you in my "idiots" filter? The 
aggravation just isn't worth it for me.

When you grow up and can admit that your code was buggy, or at least 
*look* at the patches, feel free to start sending me email again.

Until then, just don't bother.

		Linus
