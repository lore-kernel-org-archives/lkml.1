Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbXICNgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbXICNgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 09:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbXICNgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 09:36:33 -0400
Received: from mail.tmr.com ([64.65.253.246]:39662 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbXICNgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 09:36:32 -0400
Message-ID: <46DC0E2A.3060902@tmr.com>
Date: Mon, 03 Sep 2007 09:37:46 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>	 <46DA2133.5000809@tmr.com> <8bd0f97a0709012044p4e7826e2s46368e519bd349e@mail.gmail.com>
In-Reply-To: <8bd0f97a0709012044p4e7826e2s46368e519bd349e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On 9/1/07, Bill Davidsen <davidsen@tmr.com> wrote:
>   
>> If you want to test that stuff and run it on the current code in the
>> kernel, how about a kernel module? You could "modprobe sanitytest" or
>> something and report to syslog at module load time. And maybe have a
>> parameter which does something drastic if something core is so hosed
>> that filesystem damage is likely. Or just optional init code run by a
>> kernel option, perhaps sanity testing after boot is not a great idea.
>>     
>
> i'm fully capable of doing my own testing right now; that isnt the
> point of this thread ... the point is for everyone to benefit, not
> just the Blackfin architecture
>   

That's exactly the point I was making, if your tests and any others 
people feel are useful were in a module and/or could be run as init code 
only when wanted, everyone could benefit from the tests. Anything 
related to build sanity could be in one place, to guard against 
surprises like new versions of gcc, typos in patches, etc.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

