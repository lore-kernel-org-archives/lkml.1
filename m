Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbYKGOES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbYKGOES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYKGOEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:04:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51389 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYKGOEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:04:05 -0500
Date: Fri, 7 Nov 2008 09:04:03 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Matt Fleming <mjf@netbsd.org>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       mingo@elte.hu
Subject: Re: [PATCH] ftrace: Allow section alignment
In-Reply-To: <5ff4a1e50811070559s1cbc4420ie600e0004b5e7309@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811070901240.23073@gandalf.stny.rr.com>
References: <5ff4a1e50811070512v410e623ax60e8a65b169f800@mail.gmail.com>  <1226063896.2697.28.camel@twins>  <alpine.DEB.1.10.0811070825580.27455@gandalf.stny.rr.com> <5ff4a1e50811070559s1cbc4420ie600e0004b5e7309@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Nov 2008, Matt Fleming wrote:
> 
> I've tried to explain the bug better in the attached patch. The issue
> is not that there were gaps in __mcount_loc, rather that the addresses
> in __mcount_loc were not aligned on a 4-byte boundary by the
> assembler. Unaligned accesses are not supported by our architecture
> and an alignment of 1-byte will likely lead to performance loss on
> architectures that do support them.

This is what I was looking for ;-)

Yes, I was just telling Peter on IRC, that this might just be an 
architecture request. Which I find as a legitimate reason. But because 
there was no mention of that in the change log, I would have to NACK it.


Ingo,

I'll pull this in my tree and test it first. Then I'll pass it off to you.

-- Steve

