Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYKGM22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYKGM22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 07:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYKGM2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 07:28:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38639 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYKGM2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 07:28:19 -0500
Message-ID: <49143449.2010704@redhat.com>
Date: Fri, 07 Nov 2008 07:27:53 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kasper Sandberg <lkml@metanurb.dk>
CC: "Phillip O'Donnell" <phillip.odonnell@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Oskar Liljeblad <oskar@osk.mine.nu>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: sata errors with Seagate 1.5TB on AMD 780G/SB700 motherboard
References: <fa.01zEaARwrup2dCOTuHTYxzuS9BI@ifi.uio.no>	 <49079E09.20703@shaw.ca> <20081029185856.GA8152@osk.mine.nu>	 <20081029201724.0a7d736e@lxorguk.ukuu.org.uk> <4908C62E.5070307@redhat.com>	 <7a9b5c320810291352k5db86a4eg4e03fb09317de459@mail.gmail.com>	 <4908E5B6.1080703@redhat.com> <1226057597.17253.98.camel@localhost>
In-Reply-To: <1226057597.17253.98.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasper Sandberg wrote:
> On Wed, 2008-10-29 at 18:37 -0400, Ric Wheeler wrote:
>   
>> Phillip O'Donnell wrote:
>>     
> <snip>
>   
>> I am just going based on what I read at the Seagate customer site - it 
>> looks like the hang was during the processing of the ATA_CACHE_FLUSH_EXT 
>> command.
>>
>> New drives are routinely buggy to some degree, especially ones that jump 
>> up in capacity :-)  Seagate has a well earned reputation for quality and 
>> I will be surprised if they don't fix this issue soon,
>>     
>
> Is there any new information on this? so far the only thing i can find
> seems to be people reporting the issue, but no word from seagate..
>   

I don't actually have one of these drives, so I don't have any updates, 
sorry.

There was a recent patch to correctly calculate sector numbers for these 
disks, but I am not sure that this was the same issue you saw...

ric

>   
>> Ric
>>
>>     
>>>   
>>>       
>>>> I suspect that the drive is simply choking on the barrier related cache
>>>> flushing that we do - that seemed to be the MacOS error as well. The windows
>>>> comment suggested that windows had an hba/driver bug (most likely unrelated
>>>> to this).
>>>>
>>>> If you want to avoid the issue until they fix the drive, you could run fast
>>>> and dangerous (mount without barriers on) or slow and safe (disable the
>>>> write cache).
>>>>     
>>>>         
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>     
>
>   

