Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbXJJON2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbXJJON2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 10:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbXJJONU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 10:13:20 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:35506 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbXJJONU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 10:13:20 -0400
Message-ID: <470CDDFC.8010307@davidnewall.com>
Date: Wed, 10 Oct 2007 23:43:16 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Gustavo Chain <g@0xff.cl>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reserve N process to root
References: <20071009194820.6c8d6e8d@0xff.cl>	<470C2FA7.5030207@davidnewall.com>	<20071010011523.7d6cca12@0xff.cl>	<470C66A6.2060801@davidnewall.com> <20071010094622.7b8121cf@0xff.cl>
In-Reply-To: <20071010094622.7b8121cf@0xff.cl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gustavo Chain wrote:
> El Wed, 10 Oct 2007 15:14:06 +0930
> David Newall <david@davidnewall.com> escribió:
>   
>> Gustavo Chain wrote:
>>     
>>> El Wed, 10 Oct 2007 11:19:27 +0930
>>> David Newall <david@davidnewall.com> escribió:
>>>   
>>>       
>>>> Gustavo Chain wrote:
>>>>     
>>>>         
>>>>> I think it's necessary to reserve some pids to the super user.
>>>>> 5 must be sufficient.
>>>>>       
>>>>>           
>>>> Why?  (Sorry if I missed something.)
>>>>     
>>>>         
>>> ¿ To prevent a posible DoS ?
>>>   
>>>       
>> That was what I thought you had in mind; it protects from some kind
>> of fork bomb, right?  But it doesn't seem useful unless you guarantee 
>> having a process already running (with CAP_SYS_ADMIN) *before* the
>> bomb goes off.
>>     
>
> Not really, because fork bomb will never reach maximum pid possible.
> And root will always have a "slot" to kill desired processes.
>   

This is like pulling teeth: painful.

I don't think you have satisfactorily explained why it's necessary.  "To 
prevent a possible DoS" isn't sufficient by itself.  I think you should 
explain the scenarios you have in mind.

