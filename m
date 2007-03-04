Return-Path: <linux-kernel-owner+w=401wt.eu-S1751156AbXCDKOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbXCDKOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 05:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXCDKOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 05:14:36 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:45915 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbXCDKOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 05:14:35 -0500
Message-ID: <45EA9BFA.70401@cosmosbay.com>
Date: Sun, 04 Mar 2007 11:14:18 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: David Lang <david.lang@digitalinsight.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: dynamic linking files slow fork down significantly
References: <Pine.LNX.4.63.0703021647070.24792@qynat.qvtvafvgr.pbz> <45E92837.3030807@cosmosbay.com> <Pine.LNX.4.63.0703040012070.26326@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0703040012070.26326@qynat.qvtvafvgr.pbz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sun, 04 Mar 2007 11:14:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang a écrit :
> On Sat, 3 Mar 2007, Eric Dumazet wrote:
>>
>> # time ldd -r ./groff
>>        libstdc++.so.5 => /usr/lib/libstdc++.so.5 (0xf7e8f000)
>>        libm.so.6 => /lib/tls/libm.so.6 (0xf7e6d000)
>>        libgcc_s.so.1 => /lib/libgcc_s.so.1 (0xf7e62000)
>>        libc.so.6 => /lib/tls/libc.so.6 (0x42000000)
>>        /lib/ld-linux.so.2 => /lib/ld-linux.so.2 (0xf7f4c000)
>> 0.00user 0.00system 0:00.00elapsed 50%CPU (0avgtext+0avgdata 
>> 0maxresident)k
>> 0inputs+0outputs (0major+777minor)pagefaults 0swaps
>>
>> You can see 777 pagefaults instead of 696 on this example.
> 
> the version of time on my system (debian 3.1) doesn't give me the cpu or 
> pagefault info, just the times. where should I get the version that 
> gives more info? (although I don't think I can apply it directly to my 
> troubleshooting as the work is all being done in child processes).

time is a shell builtin.
But there is normally an /usr/bin/time standalone program.

# type time
time is a shell keyword
# time date
Sun Mar  4 12:15:54 CET 2007

real    0m0.003s
user    0m0.000s
sys     0m0.000s

# /usr/bin/time date
Sun Mar  4 12:15:56 CET 2007
0.00user 0.00system 0:00.00elapsed ?%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+192minor)pagefaults 0swaps
