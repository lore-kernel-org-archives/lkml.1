Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbXCTMz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbXCTMz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933328AbXCTMz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:55:57 -0400
Received: from ipmail02.adl2.internode.on.net ([203.16.214.141]:60830 "EHLO
	ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933318AbXCTMz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:55:57 -0400
X-IronPort-AV: i="4.14,304,1170595800"; 
   d="scan'208"; a="99878459:sNHT21752584"
Message-ID: <45FFD9DC.8050103@iinet.net.au>
Date: Tue, 20 Mar 2007 23:55:56 +1100
From: Ben Nizette <ben.nizette@iinet.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org
Subject: Re: 2.6.21-rc4-mm1 [PATCH] init/missing_syscalls.h fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Jourdois wrote:
> On Mon, Mar 19, 2007 at 08:56:23PM -0800, Andrew Morton wrote:
>> Temporarily at
>>
>>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 
> [..]
> 
>> +complain-about-missing-system-calls.patch
>> +complain-about-missing-system-calls-update.patch
> 
> 
> Hi,
> 
> I needed the following patch to fix this compile error (which does not
> happend at first compile):
> [..]
> # (note all three \1 missing, replaced by char '^A', not visible here.
> # note also that my /bin/sh is symlinked to dash (not bash) 0.5.3
> [..] 
> Can someone confirm that this is the right way to patch this ?
> 

Can't confirm the correctness but I can confirm that this problem
appears for me using both bash and dash and that the attached patch
allows compile to progress.  Cheers :)

--Ben.

> 
> Thanks,
> - Stéphane.
