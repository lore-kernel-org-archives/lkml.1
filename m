Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYA0BMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYA0BMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 20:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYA0BMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 20:12:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33797 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYA0BMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 20:12:05 -0500
Message-ID: <479BDA39.1060907@zytor.com>
Date: Sat, 26 Jan 2008 17:11:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 5/9] x86: Unify strings in arch/x86/boot/compressed/misc_??.c
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>	 <25c98f11d5811cdee328b2e6c400a36c875bc9b8.1201348185.git.ijc@hellion.org.uk> <86802c440801261703k22b6a51ft6254690f3b211efb@mail.gmail.com>
In-Reply-To: <86802c440801261703k22b6a51ft6254690f3b211efb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>
>> diff --git a/arch/x86/boot/compressed/misc_64.c b/arch/x86/boot/compressed/misc_64.c
>> index 8c1573b..bd822b7 100644
>> --- a/arch/x86/boot/compressed/misc_64.c
>> +++ b/arch/x86/boot/compressed/misc_64.c
>> @@ -372,8 +372,8 @@ asmlinkage void decompress_kernel(void *rmode, unsigned long heap,
>>                 error("Destination address too large");
>>
>>         makecrc();
>> -       putstr(".\nDecompressing Linux...");
>> +       putstr("Uncompressing Linux... ");
>>         gunzip();
>> -       putstr("done.\nBooting the kernel.\n");
>> +       putstr("Ok, booting the kernel.\n");
>>         return;
>>  }
> 
> 64 bit old print out seem more clear. again can you change that in misc_32.c
> 

Yes, except for the odd stray dot.

	-hpa
