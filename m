Return-Path: <linux-kernel-owner+w=401wt.eu-S1423374AbXD3Pan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423374AbXD3Pan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423373AbXD3Pan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:30:43 -0400
Received: from gw.goop.org ([64.81.55.164]:40428 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423374AbXD3Pak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:30:40 -0400
Message-ID: <46360BAF.8040208@goop.org>
Date: Mon, 30 Apr 2007 08:30:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
CC: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [patches] [PATCH] [19/40] i386: fix paravirt-documentation
References: <200704301227.598020000@suse.de>	 <20070430102752.F2EFE151CA@wotan.suse.de> <1177931258.7652.262.camel@nigel.suspend2.net>
In-Reply-To: <1177931258.7652.262.camel@nigel.suspend2.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
> Hi.
>
> On Mon, 2007-04-30 at 12:27 +0200, Andi Kleen wrote:
>   
>> From: Jeremy Fitzhardinge <jeremy@goop.org>
>> Remove #defines, add enum for PARAVIRT_LAZY_FLUSH.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>> Signed-off-by: Andi Kleen <ak@suse.de>
>>
>> ---
>>  include/asm-i386/paravirt.h |    7 +------
>>  1 file changed, 1 insertion(+), 6 deletions(-)
>>
>> ===================================================================
>> Index: linux/include/asm-i386/paravirt.h
>> ===================================================================
>> --- linux.orig/include/asm-i386/paravirt.h
>> +++ linux/include/asm-i386/paravirt.h
>> @@ -30,6 +30,7 @@ enum paravirt_lazy_mode {
>>  	PARAVIRT_LAZY_NONE = 0,
>>  	PARAVIRT_LAZY_MMU = 1,
>>  	PARAVIRT_LAZY_CPU = 2,
>> +	PARAVIRT_LAZY_FLUSH = 3,
>>  };
>>  
>>  struct paravirt_ops
>> @@ -1036,12 +1037,6 @@ static inline pte_t raw_ptep_get_and_cle
>>  }
>>  #endif	/* CONFIG_X86_PAE */
>>  
>> -/* Lazy mode for batching updates / context switch */
>> -#define PARAVIRT_LAZY_NONE 0
>> -#define PARAVIRT_LAZY_MMU  1
>> -#define PARAVIRT_LAZY_CPU  2
>> -#define PARAVIRT_LAZY_FLUSH 3
>> -
>>  #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
>>  static inline void arch_enter_lazy_cpu_mode(void)
>>  {
>>     
>
> Is the subject for this right?

Yes.  As part of the documentation I converted the #defines to enums,
but at some point it clashed with the patch which added PARAVIRT_LAZY_FLUSH.

    J
