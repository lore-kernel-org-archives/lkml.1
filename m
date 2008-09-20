Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYITN7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYITN7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 09:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYITN7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 09:59:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37963 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbYITN7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 09:59:47 -0400
Date: Sat, 20 Sep 2008 09:59:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sitsofe Wheeler <sitsofe@yahoo.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       lenb@kernel.org, astarikovskiy@suse.de
Subject: Re: Reading EeePC900 battery info causes stalls (was Re: How how
 latent should non-preemptive scheduling be?)
In-Reply-To: <48D4CC1B.7030708@yahoo.com>
Message-ID: <alpine.DEB.1.10.0809200955360.12824@gandalf.stny.rr.com>
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no>
 <48D4CC1B.7030708@yahoo.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Sep 2008, Sitsofe Wheeler wrote:
> 
> > I thought we had a wakeup latency tracer exacty like we have preempt and
> > irq off latency tracers, Steve, where'd that go?
> 
> I rebuilt my kernel after a make clean and wakeup was still not there. It
> might be a good idea to modify the kernel documentation currently
> provided with 2.6.27 if it has gone away for now (or document the extra
> switches needed to turn it on if that's why it didn't show up for me)...

The wake up tracing is CONFIG_SCHED_TRACER. If you do not see 
"wakeup" as one of the available tracers in available_tracers, then check
your dmesg and see if you have CONFIG_FTRACE_STARTUP_TEST enabled. There 
was a known bug that would cause the wakeup tracing to fail the test. When 
a trace fails the startup test, it is disabled.

-- Steve

