Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbYFQVu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbYFQVu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYFQVur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:50:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756809AbYFQVuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:50:46 -0400
Date: Tue, 17 Jun 2008 14:49:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <48582FAB.1020402@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0806171447330.2907@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <485829A1.4020705@firstfloor.org>
 <alpine.LFD.1.10.0806171421100.2907@woody.linux-foundation.org> <20080617213618.GL28946@ZenIV.linux.org.uk> <48582FAB.1020402@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Andi Kleen wrote:
> 
> Linus seems to think that copy_to_user() should have
> copy_in_user semantics().

No. 

I *know* that copy_to/from_user() is supposed to return the number of 
bytes not copied.

And if you loaded a value but didn't store it to the destination, then BY 
DEFINITION you didn't copy it.

Comprende?

Obviously you don't.

Gaah. Why do I keep bothering to even _try_ to educate you? Can't you 
accept that I just fixed a bug, which had a test-case an everything?

Andi, really. Take it from me. If I tell you something, I'm usually right. 
Think about that for a moment, instead of living in your own little 
dream-world where you think you understand everything.

		Linus
