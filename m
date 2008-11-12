Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbYKLRwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbYKLRwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYKLRvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:51:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:53700 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYKLRvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:51:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=otLxvzS3m2LHCfZeUonqu6gG/Zvi0Jy7g6MjJWUPqwDTAZqCa6oC6FO7GPr3t9m5XM
         UV9hQxxMPf4ZB5DlGyHZuDd7HZNlcYP1NayLTnNMQ5gvX5UD1yyZefOfcwM15/4rJyOT
         Ebkz4ZbYQo9Tp0H/Oq4RT4C1bKEatPUqIx40g=
Message-ID: <491B17B3.204@gmail.com>
Date: Wed, 12 Nov 2008 19:51:47 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Bob Copeland <me@bobcopeland.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
References: <491506DB.1070000@gmail.com>	 <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>	 <4918A8C5.3050607@gmail.com> <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
In-Reply-To: <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Kossifidis wrote:
> 2008/11/10 Maxim Levitsky <maximlevitsky@gmail.com>:
>> Bob Copeland wrote:
>>> On Fri, Nov 7, 2008 at 10:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>>>> ** 2 - wireless: not to mention the fact that ath5k wasn't installed by
>>>> default in ubuntu...
>>>> wireless more or less works, but kernel log is full of backtraces.
>>> As you've seen, these should at least be gone now...
>>>
>>>> Was able to connect to my WPA2 access point.
>>>> Sometimes wireless fails completely, especially after suspend to ram.
>>> Did you get noise calibration failures in dmesg at this point?  Felix posted
>>> a patch recently that handles them better.
>> Yep, but they seems to be gone in latest -git too.
>> Wireless work fine now, it seems like my iwl3945.
>>
>>>> Advanced features like monitor/injection work, but when I changed the card's
>>>> mac address it stopped working.
>>>> I also noticed that if I then start airodump, then wireless works with new
>>>> mac.
>> Why it doesn't accept new mac?, can this be fixed?

Any update on mac changer status?

>>
>>
>>>> ** 4 - wireless led doesn't work.
>>>> ath5k devs, can you fix this?
>>> Currently all the LED code we have in there is for setting a particular gpio
>>> for particular laptops (and they differ between models).  We only have quirks
>>> for IBM and HP, none for Acer.  Also, the legacy-hal seems to have a different
>>> strategy for 2425 chips.  I can try to hack up some code for you to test.
>>>
>> I have seen on the web that madwifi did support the led with some gpio settings
>>
>> sysctl -w dev.wifi0.ledpin=3
>> sysctl -w dev.wifi0.softled=1
>>
>> from https://help.ubuntu.com/community/AspireOne
>>
>> Best regards,
>>        Maxim Levitsky
> 
> i think that some led settings are stored on EEPROM, let me check it out...
>

Thanks a lot.

 
> 

Best regards,
	Maxim Levitsky
