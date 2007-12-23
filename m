Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbXLWXLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbXLWXLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 18:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXLWXLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 18:11:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbXLWXLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 18:11:45 -0500
Message-ID: <476EEAAA.2050804@zytor.com>
Date: Sun, 23 Dec 2007 15:09:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc6-mm1
References: <20071222233056.d652743e.akpm@linux-foundation.org> <200712231335.58939.rjw@sisk.pl>
In-Reply-To: <200712231335.58939.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 23 of December 2007, Andrew Morton wrote:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
>>
>> - This kernel doesn't work on i386!
>>
>>   It oopses late in boot due to an unrevertable change (e3c1b141) in git-x86
>>   which I stared at for a while then I ran out of time and gave up.
>>
>>   I would have just abandoned this release until it was fixed but I'll be
>>   largely offline for ten days starting tomorrow.
>>
>>   The culprits have been notified and hopefully we'll have a patch for
>>   hot-fixes/ tomorrow.
>>
>>   x86_64 and powerpc work OK though.
> 
> Well it doesn't build on x86-64 for me:
> 
>   CHK     include/linux/compile.h
>   CC      arch/x86/ia32/../../../fs/compat_binfmt_elf.o
> Assembler messages:
> Fatal error: can't create arch/x86/ia32/../../../fs/.tmp_compat_binfmt_elf.o: No such file or directory
> make[2]: *** [arch/x86/ia32/../../../fs/compat_binfmt_elf.o] Error 2
> 
> I will post the .config if anyone is interested.
> 

It's a Kbuild race -- if you keep re-building it will eventually build 
the right file.

Not excusable, but that's what's going on.

	-hpa
