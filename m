Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbXDMID5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbXDMID5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXDMID5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:03:57 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:44807 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752654AbXDMIDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:03:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=hhjZH9voNM040bd/95HQWuAEFVB6Gq7rsCqBf6UMHh9vG/7t0l9uKoxmXZ3wksTyT/oUgBdYBuRN+EZT+rilXNv46E61bOAiZHqly8AX9OZLSZsOWM4CyQ2Li5//8dizA74b0rV3ZwLplX/KxRnqlsGT/cqBd1xA1NReqgUJeo4=  ;
X-YMail-OSG: ahe4u3kVM1nb0mPyYCpNj8ndSqX2ib8i1CbtWdqOlp4KmkVaXWKhDLGfTK2U4VVTrElr.g71Mg--
Message-ID: <461F3961.6030300@yahoo.com.au>
Date: Fri, 13 Apr 2007 18:03:45 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au> <20070413065357.GP2986@holomorphy.com> <461F2BCB.2020200@yahoo.com.au> <20070413075142.GA23822@infradead.org>
In-Reply-To: <20070413075142.GA23822@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Apr 13, 2007 at 05:05:47PM +1000, Nick Piggin wrote:
> 
>>Ah, OK. Anyway, with kprobes/systemtap they can do whatever they like
>>and none of us need to care in the slightest ;)
> 
> 
> Umm, folks.  systemtap basically means people compile kernel modules
> from an odd scripting language with embedded C snipplets into kernel
> modules.  The kernel modules don't use normal exported APIs but use
> kallsysms and dwarf info to poke into every possible private bit.
> 
> Saying you don't care the slightest whether oracle will load huge
> amounts of code into the kernel that depends on intimate implementation
> details, and that you don't even have source to to debug it is not what
> I'd call "none of us need to care in the slightest", at least for those
> of you working for distributions that may actually have to debug this
> shit in the end.

Yeah good point ;) I just meant the wider "we".

With all the problems kprobes has, something like poking deep into
kernel internals seems like a good thing to use it for instead of
hardcoding that stuff into the kernel. If not, then why did we even
merge it in the first place?

We could distribute some systemtap scripts, and even distribute some
basic useful ones like this sort of page info in the kernel source
tree.


> While we're at it, what happened to the idea of tainting the kernel
> as soon as krpobes are placed in the kernel to at least make people
> aware of it?

Seems like a very good idea.


-- 
SUSE Labs, Novell Inc.
