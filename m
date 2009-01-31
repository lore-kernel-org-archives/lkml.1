Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZAaOkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZAaOkv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZAaOkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:40:43 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:34627 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZAaOkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:40:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=m1FH9vA7nDr0QdsWsLyZWbBlj+OotK2j3jRYa1QmtS1/UNY/N3KAmx+OPhCVHO4Hc7
         PiIyDpKHgZtrJrpbcKhxX+dYejIRQtxKtk852K7yowuLgbrG6/d6drzM2Bei4RKjO/lS
         WgQKrJINO07HEPWPMEZ9os2eMjzEuSzs+7kRY=
Message-ID: <498462E8.8090309@gmail.com>
Date: Sat, 31 Jan 2009 06:40:40 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, xdg@lists.freedesktop.org
Subject: Re: 2.6.29-rc3+git macbook pro1,1 garbled display on resume
References: <1233348609.3707.6.camel@localhost>  <4983F365.40701@gmail.com>	 <1233400739.4140.3.camel@localhost>  <49845124.9080206@gmail.com> <1233410992.14295.3.camel@localhost>
In-Reply-To: <1233410992.14295.3.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
> On Sat, 2009-01-31 at 05:24 -0800, Justin P. Mattock wrote:
>   
>> Soeren Sonnenburg wrote:
>>     
>>> On Fri, 2009-01-30 at 22:44 -0800, Justin P. Mattock wrote:
>>>   
>>>       
>>>> Soeren Sonnenburg wrote:
>>>>     
>>>>         
>>>>> Hi,
>>>>>
>>>>> the macbook pro suspends just fine, but even though the machine returns
>>>>> to X I see on resume some random garbled output but can still move the
>>>>> mouse cursor (which is OK!) and using the keyboard successfully adjust
>>>>> the brightness of the display.
>>>>>       
>>>>>           
>>> [...]
>>> I recognized that everything seems to work just fine *on console only*.
>>> At least I could suspend and resume via s2ram >3 times in a row.
>>>
>>> What also worked was to just start plain X (no window manager or
>>> anything) and suspend/resume then. However with compiz running I am
>>> seeing the garbage/hang on resume.
>>>
>>> Are you by chance to having an ATI card + use a compositing window
>>> manager?
>>>
>>> Soeren
>>>
>>>   
>>>       
>> At the moment I don't have compiz manager
>> running, only fluxbox. But after thinking,
>> I did experience this(choppy screen)when using kexec,
>> i.g. starting a new kernel from a terminal inside the xserver
>> did create a messed up screen. Then(ctl+alt+del)disabling
>> the xserver, made things work the way they were supposed too.
>>
>> I am running radeon on a macbook pro. If I can remember
>> at the time I was using kexec I did have radeon.(I'll try and reproduce 
>> this though).
>> In any case I think this is an xserver issue not a kernel(but thats just 
>> a guess).
>> I added a cc (hopefully it's the right one);
>>     
>
> Could be... I've tried with a more recent radeon driver, i.e. 
> xserver-xorg-video-radeon    deb-version        1:6.10.0-2 - same thing.
>
> Is anyone aware of a known-to-work radeon version that I should try?
>
> Soeren
>
>   
I'm running everything from jaunty
(with an exception of a few packages from sid "s2ram");
As for the screen being garbled, I have not see this
with s2ram yet.(although I need to see if I can recreate
this with kexec);

regards;

Justin P. Mattock


