Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZG0Rf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZG0Rf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZG0Rf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:35:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59366 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZG0Rf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:35:28 -0400
Date: Mon, 27 Jul 2009 13:35:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [regression] sched_getaffinity fails with EINVAL in 2.6.31-rc4
In-Reply-To: <4A6DE0DC.2070207@gmail.com>
Message-ID: <alpine.DEB.2.00.0907271334420.30108@gandalf.stny.rr.com>
References: <4A6DE0DC.2070207@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Jul 2009, Gregory Haskins wrote:

> I am not sure when this started, but noticed that sched_getaffinity is
> not working in -rc4.
> 
> [pid  6254] sched_getaffinity(0, 128, 0x7f80586b1fe0) = -1 EINVAL
> (Invalid argument)
> 
> Here is a simple program for reproduction:

Thanks,

I have a box available in which I can look at this further.

-- Steve

> 
> #include <sched.h>
> 
> int main(void)
> {
> 	cpu_set_t mask;
> 	int ret;
> 
> 	ret = sched_getaffinity(0, sizeof(mask), &mask);
> 	if (ret < 0)
> 		perror("getaffinity");
> 
> 	return ret;
> }
> 
> If I get time, I will bisect this later today.
> 
> Regards,
> -Greg
> 
> 
