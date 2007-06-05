Return-Path: <linux-kernel-owner+w=401wt.eu-S1763729AbXFENMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763729AbXFENMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758872AbXFENME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:12:04 -0400
Received: from spatial.ca ([66.11.172.77]:14116 "EHLO fawkes.spatial.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757061AbXFENMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:12:02 -0400
Message-ID: <46656120.9020103@spatial.ca>
Date: Tue, 05 Jun 2007 09:12:00 -0400
From: Tom Moore <tmoore@spatial.ca>
Reply-To: tmoore@spatial.ca
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 4Gb ram not showing up
References: <46642C60.209@spatial.ca> <20070604191052.GD10008@csclub.uwaterloo.ca> <46646BF2.9020705@spatial.ca> <20070604222840.GC10208@animx.eu.org>
In-Reply-To: <20070604222840.GC10208@animx.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Sanitizer: Advosys mail filter
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Wakko Warner wrote:
> Tom Moore wrote:
>   
>> Thank you for the reply back.  Your answer makes perfect sense to me, 
>> and it is what I had suspected but was not sure about.  The math seems 
>> to indicate that 4Gb of ram plus 1Gb of PCI address space equals 5Gb of 
>> memory space.  So it does sound like I should have a larger kernel model.
>>
>> What confused me the most (and still does), is the help message string 
>> that is presented for the CONFIG_HIGHMEM4G option:
>>  "Select this if you have a 32-bit processor and between 1 and 4 
>> gigabytes of physical RAM."
>>     
>
> 4 is not between 1 and 4.
>   
This idiomatic phrase suggests to me that it applies when ram is >= 1Gb 
and <= 4Gb.  The fact that we interpret it differently indicates that it 
could be more clearly stated.  If your interpretation is correct, then 
what would this mean when a machine had 3.5Gb of ram installed?
>   
>> Well that sounds like the amount of memory that I have, so that is what 
>> I selected.
>>     
>
> You should select CONFIG_HIGHMEM64G.
>
>   
>> Also, although I know what PAE stands for, I don't know how to select it 
>> when building a kernel.  Would I get this from the CONFIG_HIGHMEM64G 
>> option?  The help text for that says:
>>  "Select this if you have a 32-bit processor and more than 4 gigabytes 
>> of physical RAM."
>>     
>
> Personally, I feel the wording should say:
> Select this if you have a 32-bit processor and 4 or more gigabytes of
> physical RAM.
>
> It may not hurt to say 3 or more, but I'm not that familiar with x86
> hardware in regards to memory.
>
>   
Ok, so it appears that this one is wrong also.  If someone could explain 
the rules that apply, I would be happy to prepare a patch to the Kconfig 
script.  I don't consider myself to be completely stupid, and if the 
help text was a bit more clear I wouldn't be asking these questions.  
I'm sure that other pilgrims will follow along later with the same 
questions.
>> This does not sound like it applies to my hardware.  There is something 
>> wrong with my understanding, or with these message strings.  I am still 
>> confused.
>>     
>
> It does.
>
> Here's my system (4gb of memory):
>              total       used       free     shared    buffers     cached
> Mem:       3619996    3289352     330644          0     469764    2025416
> -/+ buffers/cache:     794172    2825824
> Swap:            0          0          0
>
> I know it says 3.6gb of memory, but 4gb is installed.  I had 5gb in this
> machine and I saw all 5gb.  This is a 32-bit dual xeon (12gb max memory)
>
> I would be interested to know where the last 400mb of memory went.
>
>   

