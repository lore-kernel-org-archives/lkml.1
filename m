Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXCFJaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXCFJaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030459AbXCFJaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:30:20 -0500
Received: from fest.stud.feec.vutbr.cz ([147.229.72.16]:61238 "EHLO
	fest.stud.feec.vutbr.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030401AbXCFJaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:30:17 -0500
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 04:30:17 EST
Message-ID: <45ED30E5.9040105@stud.feec.vutbr.cz>
Date: Tue, 06 Mar 2007 10:14:13 +0100
From: Schmidt Michal <xschmi00@stud.feec.vutbr.cz>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Mockern@yandex.ru
CC: linux-kernel@vger.kernel.org
Subject: Re: Question: schedule()
References: <45ED23E3.000004.17474@webmail18.yandex.ru>
In-Reply-To: <45ED23E3.000004.17474@webmail18.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.177 () FROM_ENDS_IN_NUMS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern wrote:
> Hi,
> 
> What does schedule() function do? I want to make my kthread preemptive.

It makes a scheduling decision, i.e. it assigns the CPU time to a
suitable runnable task. If called with the current task's state set to 
TASK_(UN)INTERRUPTIBLE, it puts the task to sleep.
Kernel threads are preemptible if the kernel is configured with 
CONFIG_PREEMPT.
What exactly are you trying to do?

If you're new to Linux kernel programming, I suggest you read Robert
Love's book "Linux Kernel Development".
"Linux Device Drivers" by J.Corbet, A.Rubini and G.Kroah-Hartman will be
very helpful too and it is available online: http://lwn.net/Kernel/LDD3/

Michal
