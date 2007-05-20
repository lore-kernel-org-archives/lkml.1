Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbXETQaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbXETQaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbXETQ3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:29:55 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:4635 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbXETQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:29:54 -0400
Message-ID: <4650774F.9040208@debianpt.org>
Date: Sun, 20 May 2007 17:29:03 +0100
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
References: <464F57DD.2000309@tmr.com>
In-Reply-To: <464F57DD.2000309@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> I generated a table of results from the latest glitch1 script, using an 
> HTML postprocessor I not *quite* ready to foist on the word. In any case 
> it has some numbers for frames per second, fairness of the processor 
> time allocated to the compute bound processes which generate a lot of 
> other screen activity for X, and my subjective comments on how smooth it 
> looked and felt.
> 
> The chart is at http://www.tmr.com/~davidsen/sched_smooth_01.html for 
> your viewing pleasure. The only "tuned" result was with sd, since what I 
> observed was so bad using the default settings. If any scheduler 
> developers would like me to try other tunings or new versions let me know.
> 

As I tryied myself kernels 2.6.21, 2.6.21-cfs-v13, and 2.6.21-ck2 on the 
same machine i found *very* odd those numbers you posted, so i tested 
myself those kernels to see the numbers I get instead of talking about 
the usage of kernel xpto feels like.

I did run glxgears with kernels 2.6.21, 2.6.21-cfs-v13 and 2.6.21-ck2 
inside Debian's GNOME environment. The hardware is an AMD Sempron64 3.0 
GHz, 1 GB RAM, Nvidia 6800XT.
Average and standard deviation from the gathered data:

* 2.6.21: 		average = 11251.1; stdev = 0.172
* 2.6.21-cfs-v13:	average = 11242.8; stdev = 0.033
* 2.6.21-ck2:		average = 11257.8; stdev = 0.067

Keep in mind those numbers don't mean anything we all know glxgears is 
not a benchmark, their purpose is only to be used as comparison under 
the same conditions.

One odd thing i noticed, with 2.6.21-cfs-v13 the gnome's time applet in 
the bar skipped some minutes (e.g. 16:23 -> 16:25) several times.

The data is available on: 
http://www.debianPT.org/~elmig/pool/kernel/20070520/


How did you get your data? I am affraid your data it's wrong, there's no 
  such big difference between the schedulers...

-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org
