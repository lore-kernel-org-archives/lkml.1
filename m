Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXINHBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXINHBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 03:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbXINHAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 03:00:41 -0400
Received: from smtpoutm.mac.com ([17.148.16.75]:61574 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbXINHAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 03:00:39 -0400
In-Reply-To: <6b8cef970709131847r770ad338tcfbbad90377a4115@mail.gmail.com>
References: <20070911200459.GA6974@elte.hu> <6b8cef970709111816l2e421bf3s55e63274e87fd5e1@mail.gmail.com> <6b8cef970709130142h7be591f7ja5ffd8976faef09c@mail.gmail.com> <20070913090655.GA28505@elte.hu> <6b8cef970709130224t2f8d28d4mdfbf22ba10b42497@mail.gmail.com> <20070913093137.GA31923@elte.hu> <6b8cef970709130236o48e4d923ofe4ad862c749f2da@mail.gmail.com> <20070913114828.GA28339@elte.hu> <6b8cef970709131847r770ad338tcfbbad90377a4115@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6B4EDD11-4EE4-48DA-8544-39DDB43E222A@mac.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [announce] CFS-devel, performance improvements
Date: Fri, 14 Sep 2007 02:59:58 -0400
To: Rob Hussey <robjhussey@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 13, 2007, at 21:47:25, Rob Hussey wrote:
> On 9/13/07, Ingo Molnar <mingo@elte.hu> wrote:
>> are you sure this is happening with the latest iteration of the  
>> patch too? (with the combo-3.patch?) You can pick it up from here:
>>
>>    http://people.redhat.com/mingo/cfs-scheduler/devel/sched-cfs- 
>> v2.6.23-rc6-v21-combo-3.patch
>
> I managed to work it all out (it was my fault after all), and I've now
> made the changes you suggested to my .configs for 2.6.23-rc1 and
> 2.6.23-rc6. I've done the benchmarks all over, including tests with
> the task bound to a single core. Without further ado, the numbers I
> promised:
>
> [...]
>
> I've made graphs like last time:
> http://www.healthcarelinen.com/misc/lat_ctx_benchmark.png
> http://www.healthcarelinen.com/misc/hackbench_benchmark.png
> http://www.healthcarelinen.com/misc/pipe-test_benchmark.png
> http://www.healthcarelinen.com/misc/BOUND_lat_ctx_benchmark.png
> http://www.healthcarelinen.com/misc/BOUND_hackbench_benchmark.png
> http://www.healthcarelinen.com/misc/BOUND_pipe-test_benchmark.png

Well looking at these graphs (and the fixed one from your second  
email), it sure looks a lot like CFS is doing at *least* as well as  
the old scheduler in every single test, and doing much better in most  
of them (in addition it's much more consistent between runs).  This  
seems to jive with all the other benchmarks and overall empirical  
testing that everyone has been doing.  Overall I have to say a job  
well done for Ingo, Peter, Con, and all the other major contributors  
to this impressive endeavor.

Cheers,
Kyle Moffett

