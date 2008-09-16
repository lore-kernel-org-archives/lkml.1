Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYIPTHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYIPTHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbYIPTHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:07:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60943 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbYIPTHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:07:22 -0400
Message-ID: <48D00353.3080203@redhat.com>
Date: Tue, 16 Sep 2008 15:04:51 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Xu Yang <risingsunxy@googlemail.com>
CC: Bernd Petrovitsch <bernd@firmix.at>, linux-kernel@vger.kernel.org
Subject: Re: looking for a function
References: <ab40e9c0809160550q411507aeledae30a9f835d09d@mail.gmail.com>	 <1221573632.6103.83.camel@spike.firmix.at> <ab40e9c0809160711p4182d9e7n9b3ce965b3ce9f1f@mail.gmail.com>
In-Reply-To: <ab40e9c0809160711p4182d9e7n9b3ce965b3ce9f1f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xu Yang wrote:
> Hi Bernd,
> 
> thanks for you reply.
> 
> yes, I know the thread migrates all the time, this is exactly what I
> would like to observe. I would like to learn about the thread
> migration of some specific scheduling algorithm. so ....
> 
> any idea about the function?
> 
> Best regards,
> 
> Yang

getcpu() should do what you want.

-- Chris

> 2008/9/16, Bernd Petrovitsch <bernd@firmix.at>:
>> Hi!
>>
>> On Tue, 2008-09-16 at 14:50 +0200, Xu Yang wrote:
>>> Hi guys,
>>>
>>> I am looking for a function that can show me the current thread is
>>> running on which cpu.
>>> e.g I am using pthread to write a multithreaded program, in each
>>> thread I would like to insert such kind of function so that I can know
>>> on which cpu this thread is running on.
>> That doesn't make much sense as the same thread can run on a different
>> CPU after each scheduling decision. And - as it is in userspace -
>> scheduling can happen before any assembler op.
>>
>>        Bernd
>> --
>> Firmix Software GmbH                   http://www.firmix.at/
>> mobil: +43 664 4416156                 fax: +43 1 7890849-55
>>          Embedded Linux Development and Services
>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

