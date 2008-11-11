Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYKKAk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYKKAk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 19:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYKKAkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 19:40:13 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:36660 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKKAkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 19:40:12 -0500
Message-ID: <4918D468.6090908@ct.jp.nec.com>
Date: Mon, 10 Nov 2008 16:40:08 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add include list.h in binfmts.h
References: <490907DE.2030502@ct.jp.nec.com> <20081110161238.2f1ec110.akpm@linux-foundation.org>
In-Reply-To: <20081110161238.2f1ec110.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 29 Oct 2008 18:03:26 -0700
> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> linux_binfmt uses list_head, so list.h is needed.
>>
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> ---
>>  include/linux/binfmts.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
>> index 7394b5b..06c1123 100644
>> --- a/include/linux/binfmts.h
>> +++ b/include/linux/binfmts.h
>> @@ -1,6 +1,7 @@
>>  #ifndef _LINUX_BINFMTS_H
>>  #define _LINUX_BINFMTS_H
>>  
>> +#include <linux/list.h>
>>  #include <linux/capability.h>
>>  
>>  struct pt_regs;
> 
> Did this fix a build error which you were seeing?

I just noticed it modifying arch/x86/kernel/signal_32.c headers.
I don't know any case to fail build kernel.

The file signal_32.c includes <linux/list.h> first, and To remove
including list.h causes a build error.


thanks,
Hiroshi Shimamoto
