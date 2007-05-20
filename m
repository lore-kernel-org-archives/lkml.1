Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbXETQ7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbXETQ7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757987AbXETQ6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:58:54 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:2095 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbXETQ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:58:53 -0400
Message-ID: <46507E1D.6030002@debianpt.org>
Date: Sun, 20 May 2007 17:58:05 +0100
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
References: <464F57DD.2000309@tmr.com> <4650774F.9040208@debianpt.org> <2c0942db0705200944r19a37bd8pd7c220903084e4d3@mail.gmail.com>
In-Reply-To: <2c0942db0705200944r19a37bd8pd7c220903084e4d3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On 5/20/07, Miguel Figueiredo <elmig@debianpt.org> wrote:
>> As I tryied myself kernels 2.6.21, 2.6.21-cfs-v13, and 2.6.21-ck2 on the
>> same machine i found *very* odd those numbers you posted, so i tested
>> myself those kernels to see the numbers I get instead of talking about
>> the usage of kernel xpto feels like.
>>
>> I did run glxgears with kernels 2.6.21, 2.6.21-cfs-v13 and 2.6.21-ck2
>> inside Debian's GNOME environment. The hardware is an AMD Sempron64 3.0
>> GHz, 1 GB RAM, Nvidia 6800XT.
>> Average and standard deviation from the gathered data:
>>
>> * 2.6.21:               average = 11251.1; stdev = 0.172
>> * 2.6.21-cfs-v13:       average = 11242.8; stdev = 0.033
>> * 2.6.21-ck2:           average = 11257.8; stdev = 0.067
>>
>> Keep in mind those numbers don't mean anything we all know glxgears is
>> not a benchmark, their purpose is only to be used as comparison under
>> the same conditions.
> 
> Uhm, then why are you trying to use them to compare against Bill's
> numbers? You two have completely different hardware setups, and this
> is a test that is dependent upon hardware. Stated differently, this is
> a worthless comparison between your results and his as you are
> changing multiple variables at the same time. (At minimum: the
> scheduler, cpu, and video card.)

The only thing i want to see it's the difference between the behaviour 
of the different schedulers on the same test setup. In my test -ck2 was 
a bit better, not 200% worse as in Bill's measurements. I don't compare 
absolute values on different test setups.

> 
>> One odd thing i noticed, with 2.6.21-cfs-v13 the gnome's time applet in
>> the bar skipped some minutes (e.g. 16:23 -> 16:25) several times.
>>
>> The data is available on:
>> http://www.debianPT.org/~elmig/pool/kernel/20070520/
>>
>>
>> How did you get your data? I am affraid your data it's wrong, there's no
>>   such big difference between the schedulers...
> 
> It doesn't look like you were running his glitch1 script which starts
> several in glxgears parallel. Were you, or were you just running one?

No i'm not, i'm running only one instance of glxgears inside the GNOME's 
environment.


-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org
