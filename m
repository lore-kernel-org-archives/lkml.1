Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYJMVPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYJMVPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbYJMVP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:15:28 -0400
Received: from relay6.ptmail.sapo.pt ([212.55.154.26]:35396 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759420AbYJMVP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:15:27 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Message-ID: <48F3BA5F.2000107@sapo.pt>
Date: Mon, 13 Oct 2008 22:15:11 +0100
From: Luis Henriques <henrix@sapo.pt>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26.6-rt10
References: <1223839814.19319.5.camel@localhost.localdomain> <48F29310.1030206@sapo.pt> <alpine.DEB.1.10.0810131550540.522@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0810131550540.522@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 13 Oct 2008, Luis Henriques wrote:
>> I found a compilation error while compiling this new version of the rt
>> pach.  I guess the following line is enough for you to trace the problem:
>>
>> kernel/trace/trace_events.c:49: error: ?function_trace_stop? undeclared
>> (first use in this function)
>>
>> It seems that an 'extern int function_trace_stop' is missing somewhere...
>>
> 
> Luis, I just released a -rt11 that should fix this for you. Can you 
> download it and give it a try.


Hi Steve,

just recompiled it and, although I did not really tested it (just booted
the new kernel), it seems to works like a charm ;)

Regards,
--
Luis Henriques
