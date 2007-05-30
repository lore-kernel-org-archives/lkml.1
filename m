Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbXE3W7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbXE3W7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbXE3W7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:59:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60213 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXE3W7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:59:44 -0400
Message-ID: <465E01CA.4080703@oracle.com>
Date: Wed, 30 May 2007 15:59:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hugh@veritas.com
Subject: Re: [PATCH 1/3] hexdump: more output formatting
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>	 <20070524145517.1f32cd94.randy.dunlap@oracle.com>	 <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>	 <20070530143428.2f20446a.randy.dunlap@oracle.com>	 <a781481a0705301456n246e7185ife2a144eae3179b3@mail.gmail.com>	 <465DF49B.7040100@oracle.com>	 <a781481a0705301511p69387b2ep754c8c754ba09f36@mail.gmail.com>	 <Pine.LNX.4.64.0705301515290.14642@schroedinger.engr.sgi.com>	 <a781481a0705301541h242d679fhebf314c2f6721901@mail.gmail.com>	 <465DFE4C.6090503@oracle.com> <a781481a0705301548t6ceaf3f6p8f15959ed69b0432@mail.gmail.com>
In-Reply-To: <a781481a0705301548t6ceaf3f6p8f15959ed69b0432@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 5/31/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> Satyam Sharma wrote:
>> > On 5/31/07, Christoph Lameter <clameter@sgi.com> wrote:
>> >> On Thu, 31 May 2007, Satyam Sharma wrote:
>> >>
>> >> > Yes, you're right, but I was just wondering whether any users really
>> >> > cared enough about the rowsize and groupsize, also seeing that
>> >> > accommodating these two args leads to a lot of increase in code.
>> >>
>> >> Have two functions
>> >>
>> >> 1. A function that prints full lines with address and ascii
>> >>         This defaults to 16 bytes by default + ascii.
>> >>
>> >> hex_dump?
>> >>
>> >> 2. A function to convert a few bytes for use in other output.
>> >>
>> >> sprint_hex?
>> >
>> > Yes, or we could go the whole hog and have a total of 4 functions:
>> >
>> > (1) For users that want to use a short version, and are fine with
>> > the default values for the grouping / other parameters -- also have
>> > both the print_to_buffer/sprint_hex and print_to_console/hex_dump
>> > variants.
>> >
>> > (2) For users that care about these parameters, both the variants
>> > with the expanded arglist (the ones listed above in (1) would then
>> > just be inlines wrapping over these ones)
>> >
>> > Just that it would be nice if there is some simple (with short arglist)
>> > function that works well-enough for most people that everyone would
>> > be able to adopt/use quickly.
>>
>> Satyam, you sound like you need something to do, so please grep the
>> kernel tree for /hexdump/, /hex_dump/, /dump_hex/, /dumphex/, and
>> other such variants and help me add some callers for lib/hexdump.c.
>> That way we can see what parameters it really needs.
> 
> Sure, I'll get started on this, then! :-)

Great!  oh, there's also dumpmem, dump_mem, memdump, mem_dump, etc.  :)

Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
