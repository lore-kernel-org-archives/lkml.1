Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbXFYR2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbXFYR2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 13:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbXFYR1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 13:27:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:31745 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbXFYR1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 13:27:49 -0400
Message-ID: <467FFAAA.8010103@rossove.com>
Date: Mon, 25 Jun 2007 12:26:02 -0500
From: David Jones <djones@rossove.com>
Reply-To: djones@rossove.com
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Robert Iakobashvili <coroberti@gmail.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Scaling Max IP address limitation
References: <467EA7C1.4080006@rossove.com>	 <20070624110236.fa36b2f9.akpm@linux-foundation.org>	 <7e63f56c0706241259u6e123ed6yc02b76f0260adaa5@mail.gmail.com>	 <467F063A.2030805@rossove.com>	 <7e63f56c0706250147w508d3aeay5f7aaca8215953c8@mail.gmail.com>	 <Pine.LNX.4.64.0706251130320.11964@fbirervta.pbzchgretzou.qr>	 <7e63f56c0706250241q19c6cb49yb846a38eb10a53e6@mail.gmail.com>	 <Pine.LNX.4.64.0706251437130.3137@fbirervta.pbzchgretzou.qr> <7e63f56c0706250544u78353454y44f4aab12a9e3fa8@mail.gmail.com>
In-Reply-To: <7e63f56c0706250544u78353454y44f4aab12a9e3fa8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok I have tried it on a Pentium-M ( 32 Bit ,) with 512 MB RAM and  Core 
2 Duo with 1Gig RAM  ( running SMP kernel , 2 CPUS) with same results. 
Cant go more than ~4K addresses. I have tried them with vanilla and 
custom kernels all 2.6.19+ versions.  Results are same on both systems , 
so thats the reason I am thinking that there is some limit in kernel 
source tree which I cant seem to find . Really appreciate your help in 
this regard.
Thanks,
-d

Robert Iakobashvili wrote:
> On 6/25/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>>
>> On Jun 25 2007 12:41, Robert Iakobashvili wrote:
>> >> > I am getting after initial successes some errors:
>> >> > "rtnl_talk(): RTNETLINK answers: Cannot allocate memory"
>> >> > and
>> >> > #ip addr | wc-l is 8194.
>> >>
>> >> I'd be surprised if it was 4096 on x86 and 8192 on x86_64...
>> >
>> > Missed to mention: the CPU is Pentium-4.
>>
>> That's like saying you've got a SPARC. Or a MIPS. Or a PPC.
>> (I can't infer from your answer whether that is running 32 or 64-bit
>> kernel, because there are P4s with and without 64-bit extensions.)
>
> 32/32
>
>>         Jan
>> -- 
>>
>
>

