Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbXGaNBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbXGaNBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759244AbXGaNB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:01:27 -0400
Received: from tristate.vision.ee ([194.204.30.144]:41719 "HELO mail.city.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757987AbXGaNBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:01:25 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:01:25 EDT
Message-ID: <46AF3111.7090206@city.ee>
Date: Tue, 31 Jul 2007 15:54:41 +0300
From: =?UTF-8?B?TGVuYXIgTMO1aG11cw==?= <lenar@city.ee>
User-Agent: Thunderbird 2.0.0.5 (X11/20070723)
MIME-Version: 1.0
To: Klaus Schulz <Klaus.Schulz@web.de>
CC: ck@vds.kolivas.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: ck vs. cfs : realtime audio performance
References: <1185870355.7933.55.camel@klaus-laptop> <1185886161.7397.11.camel@klaus-laptop>
In-Reply-To: <1185886161.7397.11.camel@klaus-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'd to LKML & Ingo.

L.

Klaus Schulz wrote:
> Hi there.
>
>
>
>
> Am Dienstag, den 31.07.2007, 10:26 +0200 schrieb Klaus Schulz:
>   
>> Hi folks.
>>
>> I am currently testing the 2.6.22.1 cfs-rt9 vs. ck1 on my rather pure
>> realtime high-end-audio setup. (NO X, just a terminal, streaming .wav. 
>> I am using my own written player and brutefir as the audio engine.)
>> Comment: This is not a standard (amarok or xmms setup), all buffers in
>> the chain are very small. Any problem will immidetialy end up in xruns.
>> The sounddriver, HW (pci-bus etc.) are tweaked accordingly 
>>
>> Until now ck1 on 2.6.22 is giving me better results (less audible
>> distortions) and runs extremely stable compared to cfs. 
>> Under ck I ran my player with schedtool -R -p 98, which was better than
>> running it e.g. with nice -20 
>> Both setups under cfs were giving me worse results than ck.
>> With CFS I also experienced XRUNS from time to time, what never happened
>> with ck.
>>
>> However:
>>
>> When looking at the latest performance statistics cfs vs. ck which are
>> spread around here, I am wondering, what might cause the differences.
>>
>> With ck I tweaked the rr_interval to 6 and was running at 10000Hz,
>> which caused obvious improvements.
>>
>> These options I do not have with CFS.
>>
>> I am wondering if sched_granularity_ns should be touched when using cfs.
>> I googled somewhere that bringing it down to e.g. 250000 instead of
>> 4000000 would smoothen the audio playback. I havn't tried it yet. I am
>> wondering if this tweak is still applicable.
>>     
>
>
>
> I did test now decreasing the sched_granularity_ns to 250000.
> There is still a clearly audible difference comparing ck and cfs. 
> ck Ídelivers cristal clear sound. With cfs I still get quite some
> distortions. 
>
> Any hints how to improve the situtation are welcome. 
>
>
>
>   
>> I'd be happy to get a hint on how to tweak the system parameters best to
>> give cfs a fair chance. I am also wondering how the timer freqency could
>> by increased under a cfs-patched kernel.
>>
>> Info: dynamic ticks and IRQ balancing are off for the time being.
>>      /proc/sys/dev/rtc is set to 4096 (gave me best results)
>>      ( I don't have a clue how all the (rtc)-timers in the OS interact,
>>        To me it is just a trial and error exercise to figure out which
>>        setup sounds best)
>>
>> THX for your advise. 
>>
>> Cheers
>> \Klaus
>>     
>
>
> Cheers
> \Klaus
>
>
> _______________________________________________
> http://ck.kolivas.org/faqs/replying-to-mailing-list.txt
> ck mailing list - mailto: ck@vds.kolivas.org
> http://vds.kolivas.org/mailman/listinfo/ck
>   

