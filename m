Return-Path: <linux-kernel-owner+w=401wt.eu-S965929AbXCPU7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965929AbXCPU7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965930AbXCPU7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:59:54 -0400
Received: from dvhart.com ([64.146.134.43]:50412 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965926AbXCPU7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:59:53 -0400
Message-ID: <45FB0548.5070909@mbligh.org>
Date: Fri, 16 Mar 2007 13:59:52 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org> <20070315160648.GA11812@one.firstfloor.org> <1173977264.7922.24.camel@localhost.localdomain> <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com> <20070316114415.GA26403@one.firstfloor.org> <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com> <45FAFD57.90601@mbligh.org> <Pine.LNX.4.64.0703161346060.6204@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0703161346060.6204@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 16 Mar 2007, Martin Bligh wrote:
> 
>> You have to do some sort of lookup anyway, and Andy seemed to have them
>> all folded into one.
> 
> What lookup would you need to do? On x86_64 even the TLB use is 
> hidden by the existing 2M entries for 1-1 mappings.
> 
>> Or are you trying to avoid this by going to back to the crud we had
>> in 2.4 where we pretend mem_map is one big array, indexed by pfn with
>> huge sparsely mapped holes in it?
> 
> Yes that the advanced way of doing it rather than adding useless custom 
> lookups.

For starters, you can't do that sparse a mapping on a 32 bit system.
I'll let Andy explain the rest of it.

>> Would be nice to work out (and document somewhere) what the pros and
>> cons of virtual memmap vs sparsemem were - ISTR one of the arguments
>> was extremely sparsely layed out machines, and you needed sparsemem
>> for that. But right now we have 3 solutions, which is not a good
>> situation.
> 
> Please read my posts to linux-mm on that subject. We discussed it last 
> year in detail and the agreement was that the sparsemem crud needs to be 
> taken out. Kame-san posted patches to do that.

"the agreement"? So Andy agreed to taking it out? Or you and Kame did?

M.


