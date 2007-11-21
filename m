Return-Path: <linux-kernel-owner+w=401wt.eu-S1760393AbXKUMyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393AbXKUMyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 07:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbXKUMy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 07:54:29 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:60352 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbXKUMy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 07:54:29 -0500
Message-ID: <4744295C.1090804@keyaccess.nl>
Date: Wed, 21 Nov 2007 13:49:32 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	<20071121145838.c66a6393.kamezawa.hiroyu@jp.fujitsu.com> <20071120220841.218dac46.akpm@linux-foundation.org>
In-Reply-To: <20071120220841.218dac46.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-11-07 07:08, Andrew Morton wrote:

>> fix (for my config ?) is attached.
>>
>> =
>> This was necessary to build.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>>  arch/ia64/lib/Makefile |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: linux-2.6.24-rc3-mm1/arch/ia64/lib/Makefile
>> ===================================================================
>> --- linux-2.6.24-rc3-mm1.orig/arch/ia64/lib/Makefile
>> +++ linux-2.6.24-rc3-mm1/arch/ia64/lib/Makefile
>> @@ -2,7 +2,7 @@
>>  # Makefile for ia64-specific library routines..
>>  #
>>  
>> -obj-y := io.o copy_page-export.o
>> +obj-y := io.o
>>  
>>  lib-y := __divsi3.o __udivsi3.o __modsi3.o __umodsi3.o			\
>>  	__divdi3.o __udivdi3.o __moddi3.o __umoddi3.o			\
> 
> erp.  Actually, it should be this:
> 
> --- a/arch/ia64/lib/Makefile~ia64-export-copy_page-to-modules-fix-fix
> +++ a/arch/ia64/lib/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for ia64-specific library routines..
>  #
>  
> -obj-y := io.o copy_page-export.o
> +obj-y := io.o
>  
>  lib-y := __divsi3.o __udivsi3.o __modsi3.o __umodsi3.o			\
>  	__divdi3.o __udivdi3.o __moddi3.o __umoddi3.o			\

Devil's in the invisible details? :-?

Rene.

