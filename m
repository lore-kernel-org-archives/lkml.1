Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbZGRQJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbZGRQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 12:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZGRQJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 12:09:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:52863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbZGRQJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 12:09:27 -0400
Subject: Re: [PATCH][RFC] Adding transition of CPU frequency counting
 support to perfcounters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mitake@dcl.info.waseda.ac.jp
Cc: mingo@elte.hu, fweisbec@gmail.com, linux@brodo.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090718.231137.187581409.mitake@dcl.info.waseda.ac.jp>
References: <20090716.110834.886429911292889318.mitake@dcl.info.waseda.ac.jp>
	 <20090718093115.GB9142@elte.hu>
	 <20090718.231137.187581409.mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 18:09:15 +0200
Message-Id: <1247933355.6597.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 23:11 +0900, mitake@dcl.info.waseda.ac.jp wrote:
> 
> Oh, my perf could count cpufreq events!
> Thanks for your nice advice!
> 
> % perf stat -a sleep 60
> 
>  Performance counter stats for 'sleep 60':
> 
>   479088.075595  task-clock-msecs         #      7.984 CPUs
>          199080  context-switches         #      0.000 M/sec
>           19584  CPU-migrations           #      0.000 M/sec
>          322978  page-faults              #      0.001 M/sec
>              29  cpufreq-up               #      0.000 M/sec
>              42  cpufreq-down             #      0.000 M/sec
>     73703367828  cycles                   #    153.841 M/sec
>     52005203450  instructions             #      0.706 IPC
>       209762467  cache-references         #      0.438 M/sec
>        84916856  cache-misses             #      0.177 M/sec
> 
>    60.009508200  seconds time elapsed
> 
> And I'm using ondemand governor now,
> so kernel thread [kondemand] context causes freq transition.
> I didn't notice that...
> 
> Could you merge this patch?
> Can I send this patch with descriptions and Signed-off-by?

Why, what is the usecase?

