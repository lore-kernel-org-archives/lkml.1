Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZBNOZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZBNOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 09:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZBNOZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 09:25:10 -0500
Received: from rtr.ca ([76.10.145.34]:52176 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZBNOZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 09:25:09 -0500
Message-ID: <4996D443.4060103@rtr.ca>
Date: Sat, 14 Feb 2009 09:25:07 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: =?UTF-8?B?SGFubm8gQsO2Y2s=?= <hanno@hboeck.de>,
       Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>
Subject: Re: Very old IDE hard drive (240 MB) detected as 1.1 TB
References: <200902131428.40212.hanno@hboeck.de> <499584FC.2050104@gmail.com> <200902141352.24277.hanno@hboeck.de> <4996C563.9090900@ru.mvista.com>
In-Reply-To: <4996C563.9090900@ru.mvista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
> 
> Hanno Böck wrote:
> 
>>> That would be worth investigating, yes.. If you can provide the dmesg
>>> output from bootup, as well as the output of hdparm --Istdout on the
>>> disk device, that would be useful..
>>>     
>>
>> That (and a bit more, normal hdparm output, smartctl output) here:
>> http://files.hboeck.de/conner/
>>   
> 
>   It has the current capacity in words 57-58 swapped:
> 
> /dev/sdb:
> 0c5a 037f 0000 000a 8723 0275 0037 0030
> 000a 0000 2020 2020 2020 2020 2020 424d
> 3948 4d31 5020 2020 0003 0040 0004 302e
> 3336 2020 2020 436f 6e6e 6572 2050 6572
> 6970 6865 7261 6c73 2032 3430 4d42 202d
> 2043 5033 3032 3534 2020 2020 2020 8010
> 0000 0001 0000 0200 0202 0001 037f 000a
> 0037 0007 82da 0000 0000 0000 0000 0000
> 
> 
>   It must be 82da 0007, not 0007 82da.
>   IIRC, the IDE core doesn't trust the value reported in these words 
..

That's right.  I wrote the IDE code that way
*specifically* due to a (different) Conner drive
I had here at the time.

Cheers
