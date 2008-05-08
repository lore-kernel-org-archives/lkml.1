Return-Path: <linux-kernel-owner+w=401wt.eu-S1764943AbYEHVb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764943AbYEHVb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYEHVbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:31:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45362 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752317AbYEHVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:31:12 -0400
Message-ID: <4823711D.70401@sgi.com>
Date: Thu, 08 May 2008 14:31:09 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sh migor_defconfig build breakage
References: <20080508203949.GC22887@cs181133002.pp.htv.fi> <48236E59.8070400@sgi.com>
In-Reply-To: <48236E59.8070400@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Adrian Bunk wrote:
>> Commit aa6b54461cc5c0019b9d792adf3176b444c10763
>> (asm-generic: add node_to_cpumask_ptr macro)
>> causes the following build error with migor_defconfig:
>>
>> <--  snip  -->
>>
>> ...
>>   CC      arch/sh/kernel/asm-offsets.s
>> In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:8,
>>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/asm-offsets.c:13:
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h: In function 'alloc_pages_node':
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h:190: 
>> error: implicit declaration of function 'cpu_to_node'
>> make[2]: *** [arch/sh/kernel/asm-offsets.s] Error 1
>>
>> <--  snip  -->
>>
>> cu
>> Adrian
>>
> 
> Hi Adrian,
> 
> Thanks for the feedback, I'll cross-compile test this config.
> 
> Mike


Ouch.  I just discovered I don't have a cross-compiler for 'sh'.  Can you point me
towards one?

Thanks,
Mike
