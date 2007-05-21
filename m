Return-Path: <linux-kernel-owner+w=401wt.eu-S1764054AbXEUS2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764054AbXEUS2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762556AbXEUS17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:27:59 -0400
Received: from rutherford.zen.co.uk ([212.23.3.142]:51514 "EHLO
	rutherford.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbXEUS17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:27:59 -0400
Message-ID: <4651E4A8.7010009@gmail.com>
Date: Mon, 21 May 2007 19:27:52 +0100
From: Matt Keenan <tank.en.mate@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Ray Lee <ray@madrabbit.org>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
References: <464F57DD.2000309@tmr.com> <2c0942db0705191322p54e05e40p512146f21f68299a@mail.gmail.com> <464F99EC.3080006@tmr.com>
In-Reply-To: <464F99EC.3080006@tmr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-Rutherford-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Ray Lee wrote:
>> On 5/19/07, Bill Davidsen <davidsen@tmr.com> wrote:
>>> I generated a table of results from the latest glitch1 script, using an
>>> HTML postprocessor I not *quite* ready to foist on the word. In any 
>>> case
>>> it has some numbers for frames per second, fairness of the processor
>>> time allocated to the compute bound processes which generate a lot of
>>> other screen activity for X, and my subjective comments on how 
>>> smooth it
>>> looked and felt.
>>>
>>> The chart is at http://www.tmr.com/~davidsen/sched_smooth_01.html for
>>> your viewing pleasure.
>>
>> Is the S.D. columns (immediately after the average) standard
>> deviation? If so, you may want to rename those 'stdev', as it's a
>> little confusing to have S.D. stand for that and Staircase Deadline.
>> Further, which standard deviation is it? (The standard deviation of
>> the values (stdev), or the standard deviation of the mean (sdom)?)
>>
> What's intended is the stddev from the average, and perl bit me on 
> that one. If you spell a variable wrong the same way more than once it 
> doesn't flag it as a possible spelling error.
>
> Note on the math, even when coded as intended, the divide of the 
> squares of the errors is by N-1 not N. I found it both ways in online 
> doc, but I learned it decades ago as "N-1" so I used that.
N-1 is for estimating the standard deviation from a random sample of a 
population (s), N is for calculating the standard deviation of a whole 
population (σ).

xref http://en.wikipedia.org/wiki/Standard_deviation

Yes, I am aware of the potential for Wikipedia articles to be wrong, but 
this article seems correct at first blush :)

Matt


