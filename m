Return-Path: <linux-kernel-owner+w=401wt.eu-S932334AbZJ1DzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbZJ1DzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbZJ1DzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:55:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:34395 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757244AbZJ1DzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:55:23 -0400
Message-ID: <4AE7C057.7030605@kernel.org>
Date: Tue, 27 Oct 2009 20:53:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com> <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <4AE75B38.8070301@sgi.com> <alpine.DEB.2.00.0910271345400.9183@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0910271345400.9183@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Tue, 27 Oct 2009, Mike Travis wrote:
> 
>> I applied your previous patch with the change to use static and
>> here's the console output from a live system:
>>
>>
>> [    0.000000] SRAT: PXM 0 -> APIC {0-7,16-23} -> Node 0
>> [    0.000000] SRAT: PXM 1 -> APIC {32-39,48-55} -> Node 1
>> [    0.000000] SRAT: PXM 2 -> APIC {64-71,80-87} -> Node 2
>> [    0.000000] SRAT: PXM 3 -> APIC {96-103,112-119} -> Node 3
>> [    0.000000] SRAT: PXM 4 -> APIC {128-135,144-151} -> Node 4
>> [    0.000000] SRAT: PXM 5 -> APIC {160-167,176-183} -> Node 5
>> [    0.000000] SRAT: PXM 6 -> APIC {192-199,208-215} -> Node 6
>> [    0.000000] SRAT: PXM 7 -> APIC {224-231,240-247} -> Node 7
>> [    0.000000] SRAT: PXM 8 -> APIC {256-263,272-279} -> Node 8
>> [    0.000000] SRAT: PXM 9 -> APIC {288-295,304-311} -> Node 9
>> [    0.000000] SRAT: PXM 10 -> APIC {320-327,336-343} -> Node 10
>> [    0.000000] SRAT: PXM 11 -> APIC {352-359,368-375} -> Node 11
>> [    0.000000] SRAT: PXM 12 -> APIC {384-391,400-407} -> Node 12
>> [    0.000000] SRAT: PXM 13 -> APIC {416-423,432-439} -> Node 13
>> [    0.000000] SRAT: PXM 14 -> APIC {448-455,464-471} -> Node 14
>> [    0.000000] SRAT: PXM 15 -> APIC {480-487,496-503} -> Node 15
>> [    0.000000] SRAT: PXM 16 -> APIC {512-519,528-535} -> Node 16
>> [    0.000000] SRAT: PXM 17 -> APIC {544-551,560-567} -> Node 17
>> [    0.000000] SRAT: PXM 18 -> APIC {576-583,592-599} -> Node 18
>> [    0.000000] SRAT: PXM 19 -> APIC {608-615,624-631} -> Node 19
>> [    0.000000] SRAT: PXM 20 -> APIC {640-647,656-663} -> Node 20
>> [    0.000000] SRAT: PXM 21 -> APIC {672-679,688-695} -> Node 21
>> [    0.000000] SRAT: PXM 22 -> APIC {704-711,720-727} -> Node 22
>> [    0.000000] SRAT: PXM 23 -> APIC {736-743,752-759} -> Node 23   
>>
> 
> Quite the system you have there :)  What was once 760 lines has been 
> reduced to 24 without removing any information.
> 

can you change the apic to hex print?

YH
