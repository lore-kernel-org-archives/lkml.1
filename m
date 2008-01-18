Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbYARGmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbYARGmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 01:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbYARGlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 01:41:52 -0500
Received: from proxy3.bredband.net ([195.54.101.73]:46553 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbYARGlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 01:41:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnoUAJnYj0fVcsfHRmdsb2JhbAAIkAQBAQE3AZ0s
Message-ID: <47904A27.4070405@sundmangroup.com>
Date: Fri, 18 Jan 2008 07:41:43 +0100
From: Matias Sundman <linux@sundmangroup.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SCHED_FIFO & system()
References: <37593.147.11.3.128.1200565147.squirrel@www.sundmangroup.com>
In-Reply-To: <37593.147.11.3.128.1200565147.squirrel@www.sundmangroup.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I forgot to add one important detail - the Kernel is configured as - 
Preemptible Kernel (Low-Latency Desktop).

Cheers // Matias

linux@sundmangroup.com skrev:
> Hello,
> I have some strange behavior in one of my systems.
>
> I have a real-time kernel thread under SCHED_FIFO which is running every
> 10ms.
> It is blocking on a semaphore and released by a timer interrupt every 10ms.
> Generally this works really well.
>
> However, there is a module in the system that makes a / system() / call
> from c-code in user-space;
>
>   system("run_my_script");
>
> By calling and running a bash script. Independent of how the actual
> script looks like the real time kernel thread does not get scheduled under
> the time of 80ms -- the time it takes for the system() call to finish.
>
> I can see when running a LTT session that the wake_up event occurs for
> the real time thread 10ms into the system call but nevertheless the real
> time kernel thread does not get scheduled.
>
> The thread that calls system("run_my_script") is configured as SCHED_OTHER.
>
> The Kernel is 2.6.21.
>
>
> Anybody who recognize this or similar situations?
>
>
>
> Cheers // Matias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
