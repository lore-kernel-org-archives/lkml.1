Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0BBORR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:17:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49391 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab0BBORQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:17:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cGbCzHLxe2VWQXf7XXchrcBLkqe36ip/P0mfPZPnuxPD2AMk8mfrbHQzwJ3x5dROst
         OBAgRKDYgQplFPBtToXJb8/bfYVHQggmxX9dZkLaO0a0cdJLm7sYEEkIcBF0GLHd3Qr6
         JlWcofmiGJGDelbl4u8/e1c7S1tXS9B9GnxmE=
Message-ID: <4B6833DD.1020001@gmail.com>
Date: Tue, 02 Feb 2010 09:17:01 -0500
From: Chandra Shekhar Sah <edu4madh@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: port multiplier problem
References: <4B5885F7.2020007@gmail.com> <4B679EA9.6030203@kernel.org>
In-Reply-To: <4B679EA9.6030203@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Thanks a lot for reply.

The disk array was connected to suse 10.3 before accident and was 
working fine. After accident, I saw problems, so I switched to Fedora 12 
because it has up-to-date sil24 driver for sata host controller sil3124.

Now, I am using Fedora 12 (kernel 2.6.31.12). The backplane card 
(NORCO-LIB1220) on the disk array has 12 sata conectors, 5-5-1-1. i.e. 
there are two port multiplier (sil3726, 5 sata ports in each PMP) and 
two are without port multiplier, I mentioned it as "direct sata" (may be 
not appropriate word).

I thought PMP is damaged so I purchased a new NORCO-LIB1220 backplane 
card but same problem. The disks connected to PMP are not being 
recognized. However, disk connected to "direct sata" (no disks on PMP) 
is fine.

I greatly appreciate your help.
CN



On 2/1/10 10:40 PM, Tejun Heo wrote:
> Hello,
>
> On 01/22/2010 01:51 AM, Chandra Nepali wrote:
>    
>> I have a disk array of 12 disks. The interface card has two sil3726 port
>> multiplier for 10 disks (5 disks in each port multiplier) and 2 direct
>> sata connectors. The host controller is sil3124. It was connected to
>> suse 10.4 and working fine.
>>      
> Wasn't 10.3 the last of 10 series?  After that it was 11.0.  What's
> the version of the kernel?
>
>    
>> There was a high voltage accident (high voltage to disk array only, not
>> computer) and because of that we replaced the power supply of this disk
>> array. Now, we are getting some problem, disks are not being
>> recognized,.
>>      
> Ouch...
>
>    
>> So, I connected it to Fedora 12 (To correct if it is
>> because of some bugs) with driver sil24. Here are few things that I have
>> tested.
>>
>> 1) If I connect only one disk to direct sata connector, it works fine.
>> 2) If I connect two disks to both direct sata connectors, it won't work.
>> 3) If I connect  one disk to one direct sata and one disk directly to
>> host controller, it works.
>>      
> What do you mean by 'direct sata'?  How is it different from 'directly
> to host controller'?
>
>    
>> 3) If I connect one or more disk to PM, it won't work.
>> 4) If I connect one disk to direct sata and one to PM, it won't work.
>>      
> Maybe the PMP is fried?
>
> Thanks.
>
>    

