Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab0CAW0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 17:26:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49637 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0CAW0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 17:26:05 -0500
Message-ID: <4B8C3EBA.9050407@zytor.com>
Date: Mon, 01 Mar 2010 14:24:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpu changes for v2.6.34
References: <20100227150942.GA6394@elte.hu>	 <alpine.LFD.2.00.1002281205320.27475@localhost.localdomain>	 <alpine.LFD.2.00.1002281239550.3637@localhost.localdomain>	 <20100301080058.GA8049@elte.hu> <20100301131701.GA5562@nowhere>	 <alpine.LFD.2.00.1003010843050.3616@localhost.localdomain> <1267472522.10871.14.camel@gandalf.stny.rr.com>
In-Reply-To: <1267472522.10871.14.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 11:42 AM, Steven Rostedt wrote:
> 
> As Frederic has said you can use 'ftrace=function_graph' on the kernel
> command line. It will be initialized in early_initcall (which I believe
> is before CPUs are set up. Then add a tracing_off() after the trouble
> code. You can make the trace buffers bigger with the kernel command
> line:
> 
> 	trace_buf_size=10000000
> 
> The above will make the trace buffer 10Meg per CPU. Unlike the
> "buffer_size_kb" file, this number is in bytes, even though it will
> round to the nearest page. (I probably should make this into kb, and
> rename it to trace_buf_size_kb, and deprecate trace_buf_size).
> 

Memory sizes specified on the kernel command line should generally be in
units of bytes, but accepting suffixes.

	-hpa
