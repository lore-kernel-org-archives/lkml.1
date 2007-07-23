Return-Path: <linux-kernel-owner+w=401wt.eu-S1765442AbXGWSmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765442AbXGWSmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763259AbXGWSmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:42:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56366 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760969AbXGWSmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:42:22 -0400
Message-ID: <46A4F5EF.8010402@zytor.com>
Date: Mon, 23 Jul 2007 11:39:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/8] i386: bitops: Rectify bogus "Ir" constraints
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160538.22137.35213.sendpatchset@cselinux1.cse.iitk.ac.in> <alpine.LFD.0.999.0707231056260.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707231056260.3607@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 23 Jul 2007, Satyam Sharma wrote:
>> * The "I" constraint modifier is applicable only to immediate-value operands,
>>   and combining it with "r" is bogus.
> 
> This is wrong too.
> 
> The whole point of a "Ir" modifier is to say that the instruction takes 
> *either* an "I" or an "r".
> 
> Andrew - the ones I've looked at were all wrong. Please don't take this 
> series.
> 

Incidentally, I just noticed the x86-64 bitops have "dIr" as their
constraint set.  "d" would normally be redundant with "r", and as far as
I know, gcc doesn't prefer one over the other without having "?" or "!"
as part of the constraint, so is is "d" a stray or is there some meaning
behind it?

	-hpa
