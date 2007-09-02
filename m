Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbXIBCdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbXIBCdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 22:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXIBCdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 22:33:43 -0400
Received: from mail.tmr.com ([64.65.253.246]:38815 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbXIBCdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 22:33:42 -0400
Message-ID: <46DA2133.5000809@tmr.com>
Date: Sat, 01 Sep 2007 22:34:27 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
In-Reply-To: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> is there any sort of standard for testing and integration into
> mainline ?  in the Blackfin world, we've been developing little
> external kernel modules and adding them to our own testsuite, but
> often times these things are not Blackfin specific.  case in point,
> we're integrating a string testsuite to make sure all of the fun str*
> and mem* functions are sane and operate as they expected, but rather
> than having just Blackfin benefit here, i'd like to see this pushed
> upstream ...
> 
> i'm fully aware of LTP (as i work on it), but i feel that serves a
> great purpose for exercising the API/ABI exposed to userspace either
> directly through the kernel or indirectly through the system libc ...
> it isnt a very good tool for testing kernel internals, especially as
> the kernel changes and evolves.
> 
> is there a framework already in place i'm not aware of ?  should there
> be ?  should this all live in LTP ?  i wouldnt mind an option under
> kernel hacking "Enable testsuites" ... as far as i can tell, the
> testing process is really based extensively on feedback from people,
> nothing really automated.
>
If you want to test that stuff and run it on the current code in the 
kernel, how about a kernel module? You could "modprobe sanitytest" or 
something and report to syslog at module load time. And maybe have a 
parameter which does something drastic if something core is so hosed 
that filesystem damage is likely. Or just optional init code run by a 
kernel option, perhaps sanity testing after boot is not a great idea.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
