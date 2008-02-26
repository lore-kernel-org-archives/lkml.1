Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbYBZATu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbYBZATu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbYBZATn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:19:43 -0500
Received: from gw.goop.org ([64.81.55.164]:42190 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbYBZATm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:19:42 -0500
Message-ID: <47C35A56.8080509@goop.org>
Date: Mon, 25 Feb 2008 16:16:22 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: compile problem in current x86.git
References: <47C315CC.5020001@goop.org> <19f34abd0802251237q2aa5db03s522c77340cdc96a@mail.gmail.com> <20080225204438.GA1213@elte.hu>
In-Reply-To: <20080225204438.GA1213@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
>   
>>>  asm-x86/kmemcheck.h does seem to be completely missing.  Looks like 
>>>  8db0acefb3025795abe3f37669354677a03de680 "x86: add hooks for 
>>>  kmemcheck" should have added the file.
>>>       
>> Hm. This is x86#testing, no? I don't think there's any kmemcheck code 
>> whatsoever in other branches.
>>
>> The file should be added with this commit:
>>
>> kmemcheck: add the kmemcheck core 
>> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commit;h=c83d05d69382945c92a2e7a2b168c1cc2aa77c29
>>     
>
> yes, x86.git looks fine here too:
>
>  ~/linux.trees.git> git-checkout -b tmp x86/testing
>  Branch tmp set up to track remote branch refs/remotes/x86/testing.
>  Switched to a new branch "tmp"
>  ~/linux.trees.git> cd include/asm-x86/
>  ~/linux.trees.git/include/asm-x86> ls -l kmemcheck.h
>  -rw-rw-r-- 1 mingo mingo 55 2008-02-25 21:41 kmemcheck.h
>  ~/linux.trees.git/include/asm-x86> cd ..
>  ~/linux.trees.git/include> cd ..
>  ~/linux.trees.git> ls -ldt include/asm-x86/kmemcheck.h
>  -rw-rw-r-- 1 mingo mingo 55 2008-02-25 21:41 include/asm-x86/kmemcheck.h
>  ~/linux.trees.git> git-log | head -1
>  commit c9d2f5489cec70f814bf64033290e5f05b4d7f33

I'm using #mm.  Should I be using #testing?

    J
