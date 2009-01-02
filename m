Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbZABTCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbZABTCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758419AbZABTBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:01:54 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:53783 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698AbZABTBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ix4Uv8j3Zb3pooi0Ca4F70ledeOTgify5/objj5NbWo7DXw2B1Tz28wLMVh3T+fDxu
         xXnvVpqAlTWmqaBf9qUEF4v6iVJ2WL+nFXIvMhVM5lYfXwfzL673B1GB26cE/WejgASA
         XzLfMGq9wM1cA4bTn7JGixD1YTEVWWodvAHEg=
Message-ID: <495E649B.7030006@gmail.com>
Date: Fri, 02 Jan 2009 11:01:47 -0800
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
After thinking back with what I did,
I was using 2.6.28-rc9 then(if I recall);
did a git-pull monday morning.
In the git log I remember seeing this:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cb10ea549fdc0ab2dd8988adab5bf40b4fa642f3
then after compiling and rebooting
I noticed the mixer had changed.(thus seeing the no button for "front").
then after a few hours I reverted back to 2.6.28-rc9.
waited a few days and did a git-pull Wednesday morning,changed my .config
(after sending the original post);
then noticed that the "front" had changed to "speaker" on the mixer itself.
(telling myself "man I must be seeing things");

As for the .config options you're right, it doesn't make difference.
As for seeing any commits after sunday that might have fixed this
(not sure) I see loads of commits,
I can't keep up with this.

I think the best thing for me to do, is to not say anything,
until after all of this merging is done,(man santa is here!)
 then asses the situation.

Don't mean to cause any heat.

regards;

Justin P. Mattock




