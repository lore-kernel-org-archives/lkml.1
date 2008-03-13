Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbYCMPE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbYCMPE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYCMPEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:04:48 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:45528 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYCMPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:04:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qRr0JI3k7CgPx3FeFfHpPfGPKqGBF9VVFXg2Y2rM0jUO8lJQ5UXF16hN3TnMjHefejnm0pNQXynA5aKETs9c1+0FcGrr9EkuODT9CHBqsrH4gP76GOaSlyQqiCNuA1pzKQO0k7smqHwTNb+ZSXn1jv+mpztdVbPzOztmaVS5ZKc=
Message-ID: <47D94289.9030608@gmail.com>
Date: Thu, 13 Mar 2008 18:04:41 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
References: <20080313120514.GH17940@kernel.dk> <20080313122344.GD27873@ics.muni.cz> <20080313124633.GS17940@kernel.dk> <20080313125503.GE27873@ics.muni.cz> <20080313125933.GT17940@kernel.dk> <20080313130934.GG27873@ics.muni.cz> <20080313131334.GV17940@kernel.dk> <47D93C2C.8040907@gmail.com> <20080313143930.GZ17940@kernel.dk> <47D93F95.50807@gmail.com> <20080313145932.GA17940@kernel.dk>
In-Reply-To: <20080313145932.GA17940@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Mar 13 2008, Alexey Starikovskiy wrote:
>   
>> Jens Axboe wrote:
>>     
>>> On Thu, Mar 13 2008, Alexey Starikovskiy wrote:
>>>  
>>>       
>>>> Jens Axboe wrote:
>>>>    
>>>>         
>>>>> On Thu, Mar 13 2008, Lukas Hejtmanek wrote:
>>>>>
>>>>>      
>>>>>           
>>>>>> On Thu, Mar 13, 2008 at 01:59:34PM +0100, Jens Axboe wrote:
>>>>>>   
>>>>>>        
>>>>>>             
>>>>>>> The BIOS isn't that old, probably updated it a couple of months ago.
>>>>>>>     
>>>>>>>          
>>>>>>>               
>>>>>> I use the latest BIOS for my T61 and it just works. At least the event 
>>>>>> is
>>>>>> generated either for acpid or for Xserver.
>>>>>>   
>>>>>>        
>>>>>>             
>>>>> This is an x60, so there may be other differences there.
>>>>>
>>>>>
>>>>>      
>>>>>           
>>>> There are was some playing with acpi_osi=Linux in this timeframe, known
>>>> to deal with sound buttons too.
>>>> Some of Thinkpads were inserted into the blacklist to need this OSI.
>>>> It might be that your Thinkpad needs it too...
>>>>    
>>>>         
>>> Please talk to me like I'm an ACPI ignorant - because I am. Where is
>>> this blacklist?
>>>
>>>  
>>>       
>> drivers/acpi/blacklist.c:485.
>> You probably could set acp_osi=Linux as kernel parameter to check if it 
>> helps.
>>     
>
> I booted with acpi_osi=Linux and it has made no difference.
>
>   
What is the last kernel there these buttons work?

