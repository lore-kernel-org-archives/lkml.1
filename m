Return-Path: <linux-kernel-owner+w=401wt.eu-S934217AbZLOXMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934217AbZLOXMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761599AbZLOXMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:12:35 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:35166 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934206AbZLOXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:12:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aJ4nD2Ui8VB4qXxnUH04NHOh68uizmgFdUcBmH3KeiefiUH0tpXQ9n2eI/PS9HKZn0
         GNfcdoZcdg+/wEQ5MwtzNDtWTz9b0ngGqFvVwAKVUzxTgv5Wq3HpUMNn2jdmt4FBrToo
         RKHYiWSb9Vq3hj37Y5gPUc2MCwMJb+R64OnAM=
Message-ID: <4B2817DD.4000005@gmail.com>
Date: Tue, 15 Dec 2009 15:12:29 -0800
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Younes Manton <younes.m@gmail.com>
CC: xorg@freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [drm] nouveau iMac crashes and burns
References: <dd18b0c30912151454l1aa7fb97g951483993ab42502@mail.gmail.com> 	<586c2acd0912151502o303f6b14g7277289ff5dc69b3@mail.gmail.com> <586c2acd0912151508q5361d6a5o12016648935b4eec@mail.gmail.com>
In-Reply-To: <586c2acd0912151508q5361d6a5o12016648935b4eec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/09 15:08, Younes Manton wrote:
> On Tue, Dec 15, 2009 at 6:02 PM, Younes Manton<younes.m@gmail.com>  wrote:
>    
>> On Tue, Dec 15, 2009 at 5:54 PM, Justin Mattock<justinmattock@gmail.com>  wrote:
>>      
>>> I had figured this would happen,
>>> but was curious to see if this
>>> new bad boy would work.
>>> (probably why fedora 12 doesnt boot as well).
>>>
>>> basically the system freezes during boot once
>>> drn nouveau is loaded. here's dmesg captured
>>> with firescope:(a bit long)
>>>        
>>   <..snip..>
>>      
>>> <3>[    6.891531] [drm] nouveau 0000:02:00.0: No ctxprog for NV94
>>>        
>>   <..snip..>
>>
>>      
>>> machine is an iMac with the gt130 card
>>> I loaded mesa,dri, but didn't find any
>>> firmware(if any) for /lib/firmware
>>>        
>> You need the firmware, it's not carried in the upstream tree.[1]
>> There's also a PPC-specific patch currently in the Nouveau tree and on
>> various lists that you need to apply.[2]
>>
>> [1] http://people.freedesktop.org/~pq/
>> [2] http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=a51b847bebf85e8539db6afe1627a3a17a05dfcc
>>
>>      
> (You only need to apply [2] if yours is a PPC Mac in case it wasn't
> obvious, I just assumed PPC for some reason...)
>
>    
this is an intel iMac, with the 130 card

Justin P. Mattock
