Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbZACO7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbZACO7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 09:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbZACO6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 09:58:54 -0500
Received: from relay3.sgi.com ([192.48.171.31]:50630 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753752AbZACO6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 09:58:54 -0500
Message-ID: <495F7D27.8020104@sgi.com>
Date: Sat, 03 Jan 2009 06:58:47 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <200901031751.00076.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu>
In-Reply-To: <20090103105208.GA19080@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
>> On Saturday 03 January 2009 07:08:40 Ingo Molnar wrote:
>>>  - architectures that have no __fls (8 out of 21) fail to build:
>>>
>>>      arch/cris
>>>      arch/frv
>>>      arch/h8300
>>>      arch/m32r
>>>      arch/m68k
>>>      arch/mn10300
>>>      arch/xtensa
>> Fixes pushed, m68k should be OK tho; is this actual compile test?  You have
>> to look in include/asm-m68k to see __fls.
> 
> yeah, i stopped the tests after the first two build failures - the rest is 
> a grep result from arch/*/, that's why include/asm-m68k/ was left out.
> 
>>> Rusty, would it be fine with you if we did all the remaining bits via 
>>> tip/cpus4096? It's your tree and your bits and we wanted to send our 
>>> remaining bits after your tree went to Linus but the conflict 
>>> resolutions from Mike are valuable so i think we should reconsider the 
>>> ordering.
>> Yeah, no reason for us to do the merge twice.  As long as it ends 
>> upstream, I'm a happy camper.
> 
> great - lets do it that way then. I have pulled your fixes into the 
> cpus4096 tree:
> 
>  5ece5c5: xtensa: define __fls
>  5c134da: mn10300: define __fls
>  16a2062: m32r: define __fls
>  9ddabc2: h8300: define __fls
>  ee38e51: frv: define __fls
>  0999769: cris: define __fls
> 
> Once we have figured out the CPU-hotplug lockdep splat (possibly due to 
> Mike's changes not yours) i'll send it to Linus. Thanks,
> 
> 	Ingo

Thanks!  Am working on that now.

Mike
