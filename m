Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbZEBUOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbZEBUOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbZEBUOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:14:01 -0400
Received: from sandeen.net ([209.173.210.139]:20148 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbZEBUOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:14:00 -0400
Message-ID: <49FCA988.2050600@sandeen.net>
Date: Sat, 02 May 2009 15:14:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: linux-kernel@vger.kernel.org, Heinz Diehl <htd@fancy-poultry.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>	 <20090502101405.GA6145@fancy-poultry.org>	 <a4423d670905021135s4fdbea82t20cf75b61c59dc75@mail.gmail.com>	 <49FC9762.6010109@sandeen.net> <a4423d670905021159k51e91b12h96189005980b5e73@mail.gmail.com>
In-Reply-To: <a4423d670905021159k51e91b12h96189005980b5e73@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> 2009/5/2 Eric Sandeen <sandeen@sandeen.net>:
>> Alexander Beregalov wrote:
>>> 2009/5/2 Heinz Diehl <htd@fancy-poultry.org>:
>>>> On 01.05.2009, Alexander Beregalov wrote:
>>>>
>>>>> # xfs_db -r /dev/sdc1
>>>>> xfs_db> frag
>>>>> actual 23805, ideal 22890, fragmentation factor 3.84%
>>>>> # xfs_fsr -v /dev/sdc1
>>>>> /mnt/c start inode=0
>>>>> ino=158
>>>>> extents before:3 after:1 DONE ino=158
>>>>>
>>>>>  then it hangs
>>>> I can't confirm this here on my systems:
>>>>
>>>> liesel:~ # uname -a
>>>> Linux liesel 2.6.30-rc4 #1 SMP PREEMPT Sat May 2 11:49:13 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux
>>> I have this problem on two x86_32 hosts.
>>> It runs for about a minute and then hangs.
>> echo w > /proc/sysrq-trigger
>> dmesg
>>
>> would show all the sleeping processes...
> It is the same as I posted already:

hum, only 1 thread, interesting...

Thanks,
-Eric

