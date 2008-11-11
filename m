Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYKKKjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYKKKjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbYKKKjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:39:17 -0500
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:53491 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYKKKjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:39:16 -0500
Message-ID: <491962FE.1020805@numericable.fr>
Date: Tue, 11 Nov 2008 11:48:30 +0100
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008101911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rakib Mullick <rakib.mullick@gmail.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: Fixing improper annotation.
References: <49193D1A.9040000@numericable.fr> <20081111103649.GA10554@elte.hu>
In-Reply-To: <20081111103649.GA10554@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rufus&  Azrael<rufus-azrael@numericable.fr>  wrote:
>
>    
>> Hi Rakib,
>>
>>
>> Your two patches set for x86 init_thread_xsate function section
>> mismatch is correct to fix the compilation warning, but generates
>> this other one :
>>
>>      
>>> WARNING: vmlinux.o(.cpuinit.text+0x7de): Section mismatch in reference
>>> from the function xsave_cntxt_init() to the function
>>> .init.text:__alloc_bootmem()
>>> The function __cpuinit xsave_cntxt_init() references
>>> a function __init __alloc_bootmem().
>>> If __alloc_bootmem is only used by xsave_cntxt_init then
>>> annotate __alloc_bootmem with a matching annotation.
>>>        
>
> that's with both 1/2 and 2/2 applied?
>
> 	Ingo
>
>    
Yes Ingo with the two patches applied.

Regards.
