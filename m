Return-Path: <linux-kernel-owner+w=401wt.eu-S934804AbXEVRU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804AbXEVRU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934594AbXEVRUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:20:15 -0400
Received: from mail.tmr.com ([64.65.253.246]:43756 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747AbXEVRUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:20:13 -0400
Message-ID: <465326C1.6070904@tmr.com>
Date: Tue, 22 May 2007 13:22:09 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Miguel Figueiredo <elmig@debianpt.org>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
References: <464F57DD.2000309@tmr.com> <4650774F.9040208@debianpt.org>
In-Reply-To: <4650774F.9040208@debianpt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Figueiredo wrote:
> Bill Davidsen wrote:
>> I generated a table of results from the latest glitch1 script, using 
>> an HTML postprocessor I not *quite* ready to foist on the word. In 
>> any case it has some numbers for frames per second, fairness of the 
>> processor time allocated to the compute bound processes which 
>> generate a lot of other screen activity for X, and my subjective 
>> comments on how smooth it looked and felt.
>>
>> The chart is at http://www.tmr.com/~davidsen/sched_smooth_01.html for 
>> your viewing pleasure. The only "tuned" result was with sd, since 
>> what I observed was so bad using the default settings. If any 
>> scheduler developers would like me to try other tunings or new 
>> versions let me know.
>>
>
> As I tryied myself kernels 2.6.21, 2.6.21-cfs-v13, and 2.6.21-ck2 on 
> the same machine i found *very* odd those numbers you posted, so i 
> tested myself those kernels to see the numbers I get instead of 
> talking about the usage of kernel xpto feels like.
>
> I did run glxgears with kernels 2.6.21, 2.6.21-cfs-v13 and 2.6.21-ck2 
> inside Debian's GNOME environment. The hardware is an AMD Sempron64 
> 3.0 GHz, 1 GB RAM, Nvidia 6800XT.
> Average and standard deviation from the gathered data:
>
> * 2.6.21:         average = 11251.1; stdev = 0.172
> * 2.6.21-cfs-v13:    average = 11242.8; stdev = 0.033
> * 2.6.21-ck2:        average = 11257.8; stdev = 0.067
>
> Keep in mind those numbers don't mean anything we all know glxgears is 
> not a benchmark, their purpose is only to be used as comparison under 
> the same conditions.
>
> One odd thing i noticed, with 2.6.21-cfs-v13 the gnome's time applet 
> in the bar skipped some minutes (e.g. 16:23 -> 16:25) several times.
>
> The data is available on: 
> http://www.debianPT.org/~elmig/pool/kernel/20070520/
>
>
> How did you get your data? I am affraid your data it's wrong, there's 
> no  such big difference between the schedulers...
>
The glitch1 script starts multiple scrolling xterms at the same time as 
the glxgears, and allows observation of smoothness of the gears. It's 
not a benchmark, although the fps is reported since fast or slow and 
scheduler with "fair" aspirations should have similar results in 5 sec 
time slices, and between multiple CPU-bound xterms scrolling  with the 
same code. The comments column can be used to report the user 
impressions, since that's the important thing if you want to listen to 
music or watch video.

Perhaps my data appear "wrong" because you have failed to measure the 
same thing?

You can get the most recent info at http://www.tmr.com/~public/source/ 
if you want to duplicate the test on your hardware, or view the most 
recent tests at http://www.tmr.com/~davidsen/sched_smooth_03.html to see 
what the data look like when you run the same test.

Note: there have been some minor changes in the test and analysis 
resulting from suggestions, only the recent results are worth investigating.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

