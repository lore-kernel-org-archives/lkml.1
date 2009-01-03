Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbZACKiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbZACKiu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZACKil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:38:41 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:49352 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZACKik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:38:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=x/X7eVCqYpMcxBh48pBVzupUagm/Vq/ZZFV0ewX+miqFfT6lvGq6MJlwZNFMTvzQQX
         iJ5ESSb6vlXOPjlEkI2pkBUhFM7ht/YFGVQzSZvNdcpa7AYDnNKCr1eHvylXkroZCn32
         gWaPFtB1vkQxE7iGNmzkMNC/QdaZmDzvG6W68=
References: <495B31E2.6000801@gmail.com> <s5hvdszpd87.wl%tiwai@suse.de> <495CF3BA.8080403@gmail.com> <s5heizmhti7.wl%tiwai@suse.de> <495E649B.7030006@gmail.com> <s5hr63kem6j.wl%tiwai@suse.de>
Message-Id: <8FBC32EE-F81C-4DED-9FE7-05BDD5B00B33@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
In-Reply-To: <s5hr63kem6j.wl%tiwai@suse.de>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5G77)
Mime-Version: 1.0 (iPhone Mail 5G77)
Subject: Re: snd-hda-intel no front mute switch
Date: Sat, 3 Jan 2009 02:38:24 -0800
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think so, look at CRED
Man that's nice..
Anyways I must have hit git at the wrong time. Thanks for the Info
I'll post if I see any wiered anomalys.

regards,

justin P. Mattock



On Jan 3, 2009, at 2:08 AM, Takashi Iwai <tiwai@suse.de> wrote:

> At Fri, 02 Jan 2009 11:01:47 -0800,
> Justin P. Mattock wrote:
>>
>> Takashi Iwai wrote:
>>> At Thu, 01 Jan 2009 08:47:54 -0800,
>>> Justin P. Mattock wrote:
>>>
>>>> Takashi Iwai wrote:
>>>>
>>>>> At Wed, 31 Dec 2008 00:48:34 -0800,
>>>>> Justin P. Mattock wrote:
>>>>>
>>>>>
>>>>>> Not sure if I have my configurations correct, but after
>>>>>> pulling the latest git, I notice that my mixer has no switch to  
>>>>>> mute
>>>>>> the "front", or external speaker on a macbook pro(ati chipset);
>>>>>> other than that the sound sounds really good.
>>>>>> (solution I guess: plug-in headphones, and mute headphone  
>>>>>> option);
>>>>>>
>>>>>>
>>>>> Could you run alsa-info.sh with --no-upload option on both old and
>>>>> new kernels, and attach the generated files to compare?
>>>>> The script is found in
>>>>>    http://www.alsa-project.org/alsa-info.sh
>>>>>
>>>>> You can find some other information regarding HD-audio in
>>>>> Documentation/sound/alsa/HD-Audio.txt.
>>>>>
>>>>>
>>>>> thanks,
>>>>>
>>>>> Takashi
>>>>>
>>>>>
>>>>>
>>>> After adjusting my .config,
>>>> I am getting a speaker option to mute
>>>> the external speakers, as well as the headphones.
>>>> the options that I added were:
>>>>
>>>> SND_HRTIMER [=y]
>>>> SND_HDA_RECONFIG [=y]
>>>> SND_HDA_INPUT_BEEP [=y]
>>>>
>>>> before adding these, like what I mentioned
>>>> there was no "speaker" option(or "front");
>>>> As for the sound itself, I'll have to
>>>> blast myself with some good tunes,
>>>> and see If I hear or experience any anomalies.
>>>> (then wakeup the next day unable to hear);
>>>> : )
>>>>
>>>
>>> Good to hear that it works now.
>>> Could you check which config was broken exactly?
>>> The config items above should be irrelevant with the (first) codec
>>> parsing, at least.
>>>
>>>
>>> Takashi
>>>
>>>
>> After thinking back with what I did,
>> I was using 2.6.28-rc9 then(if I recall);
>> did a git-pull monday morning.
>> In the git log I remember seeing this:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cb10ea549fdc0ab2dd8988adab5bf40b4fa642f3
>> then after compiling and rebooting
>> I noticed the mixer had changed.(thus seeing the no button for  
>> "front").
>> then after a few hours I reverted back to 2.6.28-rc9.
>> waited a few days and did a git-pull Wednesday morning,changed  
>> my .config
>> (after sending the original post);
>> then noticed that the "front" had changed to "speaker" on the mixer  
>> itself.
>> (telling myself "man I must be seeing things");
>>
>> As for the .config options you're right, it doesn't make difference.
>> As for seeing any commits after sunday that might have fixed this
>> (not sure) I see loads of commits,
>> I can't keep up with this.
>>
>> I think the best thing for me to do, is to not say anything,
>> until after all of this merging is done,(man santa is here!)
>> then asses the situation.
>>
>> Don't mean to cause any heat.
>
> OK, let's see whether Santa really exists and fixed the things
> magically :)
>
>
> thanks,
>
> Takashi
