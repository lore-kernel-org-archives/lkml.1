Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZAAQsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZAAQsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 11:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbZAAQsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 11:48:03 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:9020 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbZAAQsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 11:48:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YZ/nt8HYwu1Sv6dSElsMNZbEnCYnTAOSU0ziHvzUJKYe1SGiJRv8wa7QHV0PeoyAVu
         hOig7GqlzEM2Sp8h7TsAv8n5+6q23YdrXAVVBDH+Wm+u9voxeDMRMoOLzYWjj/fCWKAo
         mwlpwaAqd8KLxHTAVmdz/qfTQ8+mA/8PWoVcg=
Message-ID: <495CF3BA.8080403@gmail.com>
Date: Thu, 01 Jan 2009 08:47:54 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: snd-hda-intel no front mute switch
References: <495B31E2.6000801@gmail.com> <s5hvdszpd87.wl%tiwai@suse.de>
In-Reply-To: <s5hvdszpd87.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Wed, 31 Dec 2008 00:48:34 -0800,
> Justin P. Mattock wrote:
>   
>> Not sure if I have my configurations correct, but after
>> pulling the latest git, I notice that my mixer has no switch to mute
>> the "front", or external speaker on a macbook pro(ati chipset);
>> other than that the sound sounds really good.
>> (solution I guess: plug-in headphones, and mute headphone option);
>>     
>
> Could you run alsa-info.sh with --no-upload option on both old and
> new kernels, and attach the generated files to compare?
> The script is found in
>     http://www.alsa-project.org/alsa-info.sh
>
> You can find some other information regarding HD-audio in
> Documentation/sound/alsa/HD-Audio.txt.
>
>
> thanks,
>
> Takashi
>
>   
After adjusting my .config,
I am getting a speaker option to mute
the external speakers, as well as the headphones.
the options that I added were:

SND_HRTIMER [=y]
SND_HDA_RECONFIG [=y]
SND_HDA_INPUT_BEEP [=y]

before adding these, like what I mentioned
there was no "speaker" option(or "front");
As for the sound itself, I'll have to
blast myself with some good tunes,
and see If I hear or experience any anomalies.
(then wakeup the next day unable to hear);
: )

regards;

Justin P. Mattock




