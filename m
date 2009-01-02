Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZABPmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZABPmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 10:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbZABPma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 10:42:30 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:16964 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbZABPma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 10:42:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QOWgtGNsmla/LxrYD270z8URxrucsz5MuZPg5M9qx3noKQXGCtGe/GKWDZh7Lz/HXS
         CIrgQzRGxhaLefkVqaEzigCxtbcBE2a/O2d61+MbWTKO57wDQjrIZwjo+AYY/ePMk/GZ
         uAcFK34mENzYcazf1ujoTm+Jq6B4gFVATd4mw=
Message-ID: <495E35DF.8050204@gmail.com>
Date: Fri, 02 Jan 2009 07:42:23 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: snd-hda-intel no front mute switch
References: <495B31E2.6000801@gmail.com>	<s5hvdszpd87.wl%tiwai@suse.de>	<495CF3BA.8080403@gmail.com> <s5heizmhti7.wl%tiwai@suse.de>
In-Reply-To: <s5heizmhti7.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Thu, 01 Jan 2009 08:47:54 -0800,
> Justin P. Mattock wrote:
>   
>> Takashi Iwai wrote:
>>     
>>> At Wed, 31 Dec 2008 00:48:34 -0800,
>>> Justin P. Mattock wrote:
>>>   
>>>       
>>>> Not sure if I have my configurations correct, but after
>>>> pulling the latest git, I notice that my mixer has no switch to mute
>>>> the "front", or external speaker on a macbook pro(ati chipset);
>>>> other than that the sound sounds really good.
>>>> (solution I guess: plug-in headphones, and mute headphone option);
>>>>     
>>>>         
>>> Could you run alsa-info.sh with --no-upload option on both old and
>>> new kernels, and attach the generated files to compare?
>>> The script is found in
>>>     http://www.alsa-project.org/alsa-info.sh
>>>
>>> You can find some other information regarding HD-audio in
>>> Documentation/sound/alsa/HD-Audio.txt.
>>>
>>>
>>> thanks,
>>>
>>> Takashi
>>>
>>>   
>>>       
>> After adjusting my .config,
>> I am getting a speaker option to mute
>> the external speakers, as well as the headphones.
>> the options that I added were:
>>
>> SND_HRTIMER [=y]
>> SND_HDA_RECONFIG [=y]
>> SND_HDA_INPUT_BEEP [=y]
>>
>> before adding these, like what I mentioned
>> there was no "speaker" option(or "front");
>> As for the sound itself, I'll have to
>> blast myself with some good tunes,
>> and see If I hear or experience any anomalies.
>> (then wakeup the next day unable to hear);
>> : )
>>     
>
> Good to hear that it works now.
> Could you check which config was broken exactly?
> The config items above should be irrelevant with the (first) codec
> parsing, at least.
>
>
> Takashi
>
>   
I can try and have a look, but if you're telling
me that the above are irrelevant, then it must have been
something else;
luckily I saved 2.6.28-rc9
So I can go ahead and load that kernel, and see,
without adding any config options, what it looks like.
(the problem is there might have been some more commits,
that might have affected that since 4 days ago.);
hence the change from "front" to "Speaker"
on the mixer itself. making this a lost cause.
regards;

Justin P. Mattock
