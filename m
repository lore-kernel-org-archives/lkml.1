Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbXEJEcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbXEJEcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 00:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbXEJEcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 00:32:09 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:43585 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbXEJEcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 00:32:08 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Thu, 10 May 2007 02:50:20 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Corey Minyard <minyard@acm.org>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de
Subject: Re: [PATCH (trivial)] Fix wrong identifier name in Documentation/kref.txt
In-Reply-To: <463B8037.70701@acm.org>
Message-ID: <Pine.LNX.4.64.0705100242080.10484@cselinux1.cse.iitk.ac.in>
References: <Pine.LNX.4.64.0705041949130.14683@cselinux1.cse.iitk.ac.in>
 <463B8037.70701@acm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

Nobody seems to have picked this up -- I didn't see it in the other 
trivial stuff you pushed to Linus earlier today (my mistake, I hadn't 
copied you in the original post), and it's not in the latest git either. 
If somebody can please pick this up for upstream ...

Thanks,
Satyam


On Fri, 4 May 2007, Corey Minyard wrote:
> Yes, please add this.  Thanks.
>
> -corey
>
> Satyam Sharma wrote:
>> Here's another trivial one I've been meaning to send since ... a long time 
>> back.
>> 
>> Cheers,
>> Satyam
>> 
>> ---
>> 
>> There's a typo / wrong identifier name in Documentation/kref.txt. Fix it.
>>
>>     Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
>> 
>> ---
>> 
>> diff -ruNp linux-2.6.21.1/Documentation/kref.txt 
>> linux-2.6.21.1~patch/Documentation/kref.txt
>> --- linux-2.6.21.1/Documentation/kref.txt    2007-05-04 19:40:01.000000000 
>> +0530
>> +++ linux-2.6.21.1~patch/Documentation/kref.txt    2007-05-04 
>> 19:41:04.000000000 +0530
>> @@ -67,7 +67,7 @@ void more_data_handling(void *cb_data)
>>      .
>>      . do stuff with data here
>>      .
>> -    kref_put(data, data_release);
>> +    kref_put(&data->refcount, data_release);
>>  }
>>
>>  int my_data_handler(void)
>
>
