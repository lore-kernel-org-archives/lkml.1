Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbZDHHM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbZDHHM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762361AbZDHHMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:12:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:37134 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761778AbZDHHMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:12:03 -0400
Message-ID: <49DC4E3A.6040809@gawab.com>
Date: Wed, 08 Apr 2009 00:11:54 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc1: invalid opcode with call trace
References: <49DC367A.90603@gawab.com> <20090408063240.GQ5178@kernel.dk> <20090408064733.GA16984@elte.hu> <20090408065201.GA6490@elte.hu> <20090408065352.GR5178@kernel.dk>
In-Reply-To: <20090408065352.GR5178@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Apr 08 2009, Ingo Molnar wrote:
>   
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>     
>>> I too have an async hang/crash, on an old-style SCSI (aic7xxx) box 
>>> - hang log attached below.
>>> [...]
>>>
>>> ( Full bootlog attached below as well - i'm sending the config as a 
>>>   reply as this mail is close to lkml size limits already. )
>>>       
>> Config attached.
>>
>>  known bad  : v2.6.29-9854-gd508afb
>>  known good : v2.6.29
>>
>> Suspected commit introducing the regression:
>>
>>  9710794: async: remove the temporary (2.6.29) "async is off by default" code
>>
>> (i'll now try a revert of this.)
>>     
>
> That's what I figured was the culprit as well, but that does not really
> tell us anything about what part of async.c is buggy :-)
>
>   
In my case, the system doesn't hang or anything, it continues to boot 
into a working system (except for no wireless and usb).
The only thing is that shutting down doesn't work. I have to hold the 
power button because it hangs on shutdown.

Justin Madru
