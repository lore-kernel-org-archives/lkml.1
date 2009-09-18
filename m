Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZIRJNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZIRJNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 05:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZIRJNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 05:13:49 -0400
Received: from www.tglx.de ([62.245.132.106]:52633 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZIRJNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 05:13:48 -0400
Date: Fri, 18 Sep 2009 11:13:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Vasilyev <pavel@pavlinux.ru>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: INGO Why you remove set_user_nice() from kernel/kthread.c
In-Reply-To: <200909141935.25681.pavel@pavlinux.ru>
Message-ID: <alpine.LFD.2.00.0909181111170.2889@localhost.localdomain>
References: <200909141742.45487.pavel@pavlinux.ru> <1252937140.6500.11.camel@marge.simson.net> <4AAE5D60.2080703@nortel.com> <200909141935.25681.pavel@pavlinux.ru>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Mon, 14 Sep 2009, Pavel Vasilyev wrote:
>  ----------
>  CYCLE TEST
>  ----------
> 
> -T: 0 ( 5263) P: 0 I:1000 C:  98345 Min:      8 Act:656014 Avg:287390 Max:  
> 656450
> -T: 1 ( 5264) P: 0 I:1500 C:  65680 Min:      7 Act:481583 Avg:236140 Max:  
> 482343
> -T: 2 ( 5265) P: 0 I:2000 C:  49358 Min:      7 Act:286071 Avg:111300 Max:  
> 287453
> -T: 3 ( 5266) P: 0 I:2500 C:  39453 Min:      7 Act:370028 Avg:116111 Max:  
> 372481
> +T: 0 ( 6634) P: 0 I:1000 C:  98888 Min:      7 Act:113011 Avg:28733 Max:  
> 113817
> +T: 1 ( 6635) P: 0 I:1500 C:  65953 Min:      8 Act:72013 Avg:25026 Max:   
> 73110
> +T: 2 ( 6636) P: 0 I:2000 C:  49468 Min:      6 Act:66076 Avg:17455 Max:   
> 67486
> +T: 3 ( 6637) P: 0 I:2500 C:  39580 Min:      7 Act:52514 Avg:12882 Max:   
> 53256
> 
>  ----------
>  SIGNAL TEST
>  ----------
> 
> -T: 0 ( 5285) P: 0 C: 100000 Min:     13 Act:   23 Avg:   30 Max:    9229
> -T: 1 ( 5286) P: 0 C: 100000 Min:     13 Act:   99 Avg:  662 Max:   17282
> -T: 2 ( 5287) P: 0 C: 100000 Min:     13 Act:  110 Avg:  662 Max:   17294
> -T: 3 ( 5288) P: 0 C: 100000 Min:     13 Act:  119 Avg:  662 Max:   18645
> +T: 0 ( 6698) P: 0 C: 100000 Min:     13 Act:   22 Avg:   24 Max:    7898
> +T: 1 ( 6699) P: 0 C: 100000 Min:     13 Act:  104 Avg:  654 Max:   15728
> +T: 2 ( 6700) P: 0 C: 100000 Min:     13 Act:  114 Avg:  654 Max:   15740
> +T: 3 ( 6701) P: 0 C: 100000 Min:     13 Act:  124 Avg:  654 Max:   16102

These comparisons are not telling anything without the used command
line options and a description of the load on the machine while
running the tests.

Thanks,

	tglx
