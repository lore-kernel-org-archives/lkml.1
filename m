Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbZBNPye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbZBNPye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 10:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZBNPyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 10:54:24 -0500
Received: from h155.mvista.com ([63.81.120.155]:21410 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750752AbZBNPyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 10:54:24 -0500
Message-ID: <4996E924.3060600@ru.mvista.com>
Date: Sat, 14 Feb 2009 18:54:12 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Mark Lord <liml@rtr.ca>, =?ISO-8859-1?Q?Hanno_B=F6ck?= <hanno@hboeck.de>,
       Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>
Subject: Re: Very old IDE hard drive (240 MB) detected as 1.1 TB
References: <200902131428.40212.hanno@hboeck.de> <499584FC.2050104@gmail.com> <200902141352.24277.hanno@hboeck.de> <4996C563.9090900@ru.mvista.com> <4996D443.4060103@rtr.ca> <alpine.LFD.1.10.0902141526310.651@ftp.linux-mips.org>
In-Reply-To: <alpine.LFD.1.10.0902141526310.651@ftp.linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Maciej W. Rozycki wrote:

>>>   It has the current capacity in words 57-58 swapped:
>>>
>>> /dev/sdb:
>>> 0c5a 037f 0000 000a 8723 0275 0037 0030
>>> 000a 0000 2020 2020 2020 2020 2020 424d
>>> 3948 4d31 5020 2020 0003 0040 0004 302e
>>> 3336 2020 2020 436f 6e6e 6572 2050 6572
>>> 6970 6865 7261 6c73 2032 3430 4d42 202d
>>> 2043 5033 3032 3534 2020 2020 2020 8010
>>> 0000 0001 0000 0200 0202 0001 037f 000a
>>> 0037 0007 82da 0000 0000 0000 0000 0000
>>>
>>>
>>>   It must be 82da 0007, not 0007 82da.
>>>   IIRC, the IDE core doesn't trust the value reported in these words 
>>>       
>> ..
>>
>> That's right.  I wrote the IDE code that way
>> *specifically* due to a (different) Conner drive
>> I had here at the time.
>>     
>
>  It happened for some Maxtor drives too.  The reason is the ATA-1 spec was 
>   

   And with Fujitsu ones too. IIRC, the one I encountered (10+ years 
ago) had something like 0000 c000 there -- which in no way was related 
to its real capacity.

> not explicit about how words 57 and 58 were meant to be ordered and some 
>   
> manufacturers interpreted it one and some the other way.

   However, the drive vendors should've really thought better before 
reporting capacity in *middle-endian* format. :-)

>   Maciej
>   

MBR, Sergei


