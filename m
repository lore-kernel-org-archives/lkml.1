Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYDUKIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYDUKIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbYDUKIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:08:09 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:39656 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbYDUKIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:08:06 -0400
Message-ID: <480C677D.1010508@linux.vnet.ibm.com>
Date: Mon, 21 Apr 2008 15:37:57 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: subrata@linux.vnet.ibm.com
CC: Peter 1 Oberparleiter <Peter.Oberparleiter@de.ibm.com>,
       linux-kernel@vger.kernel.org, ltp-list <ltp-list@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>,
       Peter Oberparleiter <peter.oberparleiter@gmx.de>
Subject: Re: [LTP] [ANNOUNCE] gcov-kernel patches for Linux 2.6.25.
References: <bb33bcf20804210152t676d9be3x6d5f403acdb7180@mail.gmail.com> <1208770501.5051.24.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1208770501.5051.24.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subrata Modak wrote:
> Peter,
> 
> There has been a recent concern that these Patches does not compile on
> the x86_64 architecture. We recently had this problem with the 2.6.24
> GCOV Patches. Do you have any fixes for this ?
> 
> CC-ing Kamalesh, who reported this Problem. Kamalesh, can you please
> exemplify your problem to Peter.

When the gcov patches are applied to the kernels over the x86_64 machines, 
the kernel seg-faults during the bootup, 

Linux version 2.6.24-gcov-autokern1 (root@bl6-13.ltc.austin.ibm.com) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Fri Apr 4 13:15:01 CDT 2008
Command line: ro root=/dev/VolGroup00/LogVol00 console=tty0 console=ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 ABAT:1207333349
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
 BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
.
.
<snip>
.
.
powernow-k8: Found 1 Dual Core AMD Opteron(tm) Processor 270 processors (4 cpu cores) (version 2.20.00)
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
Freeing unused kernel memory: 456k freed
Red Hat nash verinit[1]: segfault at ffffffff80ceccd8 rip ffffffffff60040c rsp 7fff05e68290 error 7
sion 5.0.32 starKernel panic - not syncing: Attempted to kill init!
ting

Please let me know, If any other information is reaquired.
> 
> Regards--
> Subrata
> 
> On Mon, 2008-04-21 at 14:22 +0530, Subrata Modak wrote:
>> Hi,
>>
>> GCOV-kernel patches for Linux 2.6.25 are now available for downloads
>> at:
>>
>> http://ltp.cvs.sourceforge.net/ltp/utils/analysis/gcov-kernel/,
>>
>> You can use them for generating code coverage on 2.6,25.
>>
>> -- 
>> Regards & Thanks--
>> Subrata
>> -------------------------------------------------------------------------
>> This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
>> Don't miss this year's exciting event. There's still time to save $100. 
>> Use priority code J8TL2D2. 
>> http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
>> _______________________________________________ Ltp-list mailing list Ltp-list@lists.sourceforge.net https://lists.sourceforge.net/lists/listinfo/ltp-list


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
