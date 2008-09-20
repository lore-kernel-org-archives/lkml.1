Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYITOLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYITOLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 10:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYITOLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 10:11:44 -0400
Received: from pih-relay04.plus.net ([212.159.14.17]:36707 "EHLO
	pih-relay04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYITOLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 10:11:43 -0400
Message-ID: <48D50498.5050608@yahoo.com>
Date: Sat, 20 Sep 2008 15:11:36 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       lenb@kernel.org, astarikovskiy@suse.de
Subject: Re: Reading EeePC900 battery info causes stalls (was Re: How how
   latent should non-preemptive scheduling be?)
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no> <48D4CC1B.7030708@yahoo.com> <alpine.DEB.1.10.0809200955360.12824@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0809200955360.12824@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: fa56d807dbbbada94c8c6811ceb8b074
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> The wake up tracing is CONFIG_SCHED_TRACER. If you do not see 
> "wakeup" as one of the available tracers in available_tracers, then check
> your dmesg and see if you have CONFIG_FTRACE_STARTUP_TEST enabled. There 
> was a known bug that would cause the wakeup tracing to fail the test. When 
> a trace fails the startup test, it is disabled.

This is exactly the case (dmesg reports the ftrace wakeup startup test 
failed). That's what I get for not reading my dmesg more carefully...

-- 
Sitsofe | http://sucs.org/~sits/
