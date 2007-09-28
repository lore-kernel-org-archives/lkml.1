Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbXI1T3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbXI1T3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXI1T3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:29:14 -0400
Received: from mail.tmr.com ([64.65.253.246]:33565 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbXI1T3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:29:13 -0400
Message-ID: <46FD5707.9040807@tmr.com>
Date: Fri, 28 Sep 2007 15:33:27 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Peter Fordham <peter.fordham@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: fpu IO port reservation (arch/i386)
References: <a71b7b480709210622l23481221pd09302a827b55eb@mail.gmail.com>	<Pine.LNX.4.64N.0709211440380.2724@blysk.ds.pg.gda.pl> <p73y7f07zuz.fsf@bingen.suse.de>
In-Reply-To: <p73y7f07zuz.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "Maciej W. Rozycki" <macro@linux-mips.org> writes:
> 
>> Hi Peter,
>>
>>> Does anybody know why we reserve this range of IO ports for 'fpu'?
>>> AFAIK from all the IO maps I can find on the internet for various x86
>>> chipsets only 0x00f0 is actaully ever used.
>>  There are two ports used: 0xf0 is the busy latch reset and 0xf1 is the 
>> coprocessor reset.  They are legacy ports resulting from the interesting 
>> way the FPU has been wired by IBM in their PC design. 
> 
> Was it really needed on 386s? I didn't think there was a IBM 386 PC.

There were 386 PC clones for sure, and they almost certainly needed it 
and still do. IBM was doing the MCA thing at that time and it was a 
wonderful time for the clone makers.
> 
>> None of them is 
>> used by Linux for i486 and newer systems, which can support the FPU in its 
>> native configuration.
> 
> I can remove it from x86-64 at least. 
> 
AFAIK you are just right, I'm pretty sure there will be systems needing 
it for 386 and 486, and maybe the old Pentium systems as well. A lot of 
system vendors wanted it so software for the old systems would still work.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
