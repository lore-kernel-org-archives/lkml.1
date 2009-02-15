Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZBOCRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZBOCRQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 21:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZBOCRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 21:17:00 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:41611 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZBOCQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 21:16:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=s3p8gDg7+vUxzHHPUcZDqJLw593RrJCmNcK/Kv7RlLKZGItsmdszCKin8XccLA6irV
         vZ/Bug3dJsZoR3hG6CR1yfINkE63hqvxErnqhFsCkEOzhC4hpsqVt0Ti2MU1V8G6Rfks
         piZ25PA2W+VLsLkqhjgxnf0URUkyTV1+Sq4kA=
Message-ID: <49977B18.1030303@gmail.com>
Date: Sat, 14 Feb 2009 20:16:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Richard Jonsson <richard_jonsson@hotmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Unable to write dvd+r on 3 systems
References: <BAY108-W34B897781EDB26A588B4B29DB90@phx.gbl> <49973D4B.30802@gmail.com> <BAY108-W52F43AD46BC7BE27057F0B9DB90@phx.gbl>
In-Reply-To: <BAY108-W52F43AD46BC7BE27057F0B9DB90@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Jonsson wrote:
> 
> 
> ----------------------------------------
>> Date: Sat, 14 Feb 2009 15:53:15 -0600
>> From: hancockrwd@gmail.com
>> To: richard_jonsson@hotmail.com
>> CC: linux-kernel@vger.kernel.org
>> Subject: Re: Unable to write dvd+r on 3 systems
>>
>> Richard Jonsson wrote:
>>> It seems I am the last person on earth burning dvd's. I have tried on three different systems, using a mix of growisofs, xfburn, brasero and k3b. They all give the same result for their respective system.
>>>
>>> On system 1 it takes forever to complete the process. The system is completely useless while burning. IO wait is 50% and hardIRQ is 10-20%. If audio is playing at the same time it stutters in a way that it sounds as it's playing slow. Mouse cursor jerks and it takes eons to even open a new terminal.
>>>
>>> On system 2 growisofs will try for half a minute and then fail with a message in dmesg. The disc isn't even touched. Tried homebuilt kernel.org kernels from 2.6.25 to current git with no difference. See attachment "growisofs_system2.txt". I have been able to burn exactly 1 disc in total, which magically started recording immediately.
>>>
>>> System 3 burns at decent speed and always reports success, but about half the time only part of the disc is actually burned. It is visible to the eye, and it will not work. Tried at 4x too.
>> It sounds like you may have multiple problems. System 1 sounds like
>> maybe DMA is not being used for some reason, the dmesg output would be
>> useful. On System 2 it looks like a write timed out, and system 3 is
>> having burn quality problems. System 1 may have a kernel issue that
>> should be looked into, but as for the other two, I would tend to suspect
>> the quality of the discs you are using. There is a lot of crap media out
>> there, and also some burners don't like discs with media codes that they
>> don't have preprogrammed burn strategies for.
> 
> Thanks for your reply.
> 
> System 1 is affected by
> http://bugzilla.kernel.org/show_bug.cgi?id=12309

Not sure if that is related, that's referring to heavy disk write IO 
where yours is CD burning, which is a rather different workload.

> Also, just noticed that it doesn't appear to have udma capability?!
> (see attachment).

Not too unusual for a lot of burners..

> 
> Regarding system 3, should there not be an error raised or some such?
> It appears to complete the process, but halfway through the laser is
> cut?

That's up to the drive. If it chooses not to provide an error to the 
burning software when something goes wrong, there's not much that can be 
done about it. (It's possible the burning software is failing to report 
the error, but that isn't usually the case as far as I've seen.)

> 
> As for the media, I currently use branded discs (tdk), any
> recommendations what to shop for?

Verbatim (MCC or MKM media code) are the ones I usually use. Anything 
made by Taiyo Yuden is fairly well regarded as well. It depends a lot on 
what is available in your area..
