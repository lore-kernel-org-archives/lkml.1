Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbXLZX5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbXLZX5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 18:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbXLZX4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 18:56:55 -0500
Received: from mail.tmr.com ([64.65.253.246]:33760 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXLZX4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 18:56:54 -0500
Message-ID: <4772EEFE.1080503@tmr.com>
Date: Wed, 26 Dec 2007 19:17:02 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: James Courtier-Dutton <James@superbug.co.uk>
CC: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com>	<20071219202323.GH2310@csclub.uwaterloo.ca>	<Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com>	<20071220150255.GE2308@csclub.uwaterloo.ca>	<Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com>	<20071220182815.GA5438@uranus.ravnborg.org>	<Pine.LNX.4.61.0712201623500.9531@chaos.analogic.com>	<20071220220547.GA5641@uranus.ravnborg.org>	<Pine.LNX.4.61.0712201757410.9907@chaos.analogic.com> <20071221005303.771032f3@werewolf> <476BACD6.5060900@superbug.co.uk>
In-Reply-To: <476BACD6.5060900@superbug.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Courtier-Dutton wrote:
> J.A. Magallón wrote:
>>>>>
>>>>> I need to get rid of -mregparm=3 on gcc's command line. It
>>>>> is completely incompatible with the standard calling conventions
>>>>> used in all our assembly-language files in our drivers. We make
>>>>> very high-speed number-crunching drivers that munge high-speed
>>>>> data into images. We need to do that in assembly as we have
>>>>> always done.
>>>>>         
>>
>> Just for curiosity... yep, I understand now you have everything written
>> in assembler, but why not consider start writing it in C and stop
>> doing the compiler work (such as pipelining, out of order reordering,
>> loop unrolling for specific processor, and so on...)
>>
>> That's what everyone taught me, nowadays you won't be better than the
>> compiler in anything longer than three lines...
>>
>>   
> 
> Not true for image processing. compilers are not too good with 
> optimizing mmx and sse algorithms. This is why user space libraries like 
> ffmpeg still use assembly code.

If half of what I read about the Intel compiler is true, that may no 
longer be true.

> That being said, I don't think sse and mmx are available in kernel 
> space, so I would have suggested doing all the grunt work in userspace 
> would be better for this persons application so that he could use sse 
> and mmx etc.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

