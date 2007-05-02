Return-Path: <linux-kernel-owner+w=401wt.eu-S2993334AbXEBPQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993334AbXEBPQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993335AbXEBPQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:16:36 -0400
Received: from mail.tmr.com ([64.65.253.246]:51675 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993334AbXEBPQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:16:35 -0400
Message-ID: <4638ABD4.3040703@tmr.com>
Date: Wed, 02 May 2007 11:18:44 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: ck@vds.kolivas.org, Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [REPORT] 2.6.21 vs. 2.6.21-sd046 vs. 2.6.21-CFSv7
References: <463643A9.5040009@tmr.com> <200705010851.41375.kernel@kolivas.org>
In-Reply-To: <200705010851.41375.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Tuesday 01 May 2007 05:29, Bill Davidsen wrote:
>   
>> System: Intel 6600 Core2duo, 2GB RAM, X nice 0 for all tests, display
>> using i945G framebuffer
>>     
>
> Bill thanks for testing.
>   
>> Test: playing a 'toon with mplayer while kernel build -j20 running.
>>     
>
> Umm I don't think make -j20 is a realistic load on 2 cores. Not only does it 
> raise your load to 20 but your I/O bandwidth will even be struggling. If 
> video playback was to be smooth at that size a load it would suggest some 
> serious unfairness. I'm not just pushing the fairness barrow here; I mean it 
> would need to be really really unfair unless your combined X and video 
> playback cpu combined added up to less than 1/20th of your total cpu power 
> (which is possible but I kinda doubt it). Do you really use make -j20 to 
> build regularly?
>
>   
Yes, this is a compile and file server, I frequently build a raft of 
kernels when a security patch comes out. There doesn't seem to be an i/o 
issue, with 2GB RAM and RAID5 over a SATA array I have enough, but 
honestly the disk activity is minimal, even with a single drive.
>> Tuning: not yet, all scheduler parameters were default
>>
>> Result: base 2.6.21 showed some pauses and after the pause the sound got
>> louder for a short time (<500ms). With sd-0.46 the playback had many
>> glitches and finally just stopped with the display looping on a small
>> number of frames and no sound. The skips were repeatable, the hang was
>> only two of five runs, I didn't let them go until the make finished
>> (todo list) but killed the mplayer after 10-15 sec. No glitches observed
>> with cfsv7, I thought I saw one but repeating with granularity set to
>> 500000 and then with no make running convinced me that it's just a
>> crappy piece of animation at that point.
>>     
>
> I did notice on your followup email that nice +10 of the 20 makes fixed the 
> playback which sounds pretty good.
>
>   
Yes, I can get around the load doing that.
>> I ran glxgears, again sd-0.46 had frequent pauses and uneven fps
>> reported. Stock 2.6.21 had a visible pause when the frame rate was
>> output, otherwise minimal pauses. CFSv7 appeared smooth at about 250 fps.
>>     
>
> I assume you mean glxgears when you're running make -j20 again here.
>   
Of course. ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

