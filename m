Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYHCKwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYHCKwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 06:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYHCKwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 06:52:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53970 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYHCKwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 06:52:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48958DC2.7070506@s5r6.in-berlin.de>
Date: Sun, 03 Aug 2008 12:51:46 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
Subject: Re: [PATCH 2/5] x86: Coding style fixes to arch/x86/kernel/bios_uv.c
References: <20080802212406.047e8ae6@paolo-desktop> <48952DB3.20101@zytor.com>
In-Reply-To: <48952DB3.20101@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Paolo Ciarrocchi wrote:
>>
>> diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
>> index c639bd5..100e759 100644
>> --- a/arch/x86/kernel/bios_uv.c
>> +++ b/arch/x86/kernel/bios_uv.c
>> @@ -25,11 +25,21 @@ x86_bios_strerror(long status)
>>  {
>>      const char *str;
>>      switch (status) {
>> -    case  0: str = "Call completed without error"; break;
>> -    case -1: str = "Not implemented"; break;
>> -    case -2: str = "Invalid argument"; break;
>> -    case -3: str = "Call completed with error"; break;
>> -    default: str = "Unknown BIOS status code"; break;
>> +    case  0:
>> +        str = "Call completed without error";
>> +        break;
>> +    case -1:
>> +        str = "Not implemented";
>> +        break;
>> +    case -2:
>> +        str = "Invalid argument";
>> +        break;
>> +    case -3:
>> +        str = "Call completed with error";
>> +        break;
>> +    default:
>> +        str = "Unknown BIOS status code";
>> +        break;
>>      }
>>      return str;
>>  }
> 
> This should be an array in the first place...

Besides, by following CodingStyle to the letter, it arguably breaks 
rather than fixes coding style.  The former code was easy enough to read.
-- 
Stefan Richter
-=====-==--- =--- ---==
http://arcgraph.de/sr/
