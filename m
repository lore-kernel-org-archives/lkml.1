Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYJMEqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYJMEqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 00:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYJMEqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 00:46:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYJMEqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 00:46:35 -0400
Date: Mon, 13 Oct 2008 00:46:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Luis Henriques <henrix@sapo.pt>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26.6-rt10
In-Reply-To: <48F29310.1030206@sapo.pt>
Message-ID: <alpine.DEB.1.10.0810130044390.26132@gandalf.stny.rr.com>
References: <1223839814.19319.5.camel@localhost.localdomain> <48F29310.1030206@sapo.pt>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Oct 2008, Luis Henriques wrote:

> >   - ftrace quick stop (Steven Rostedt)
> > 

> I found a compilation error while compiling this new version of the rt
> pach.  I guess the following line is enough for you to trace the problem:
> 
> kernel/trace/trace_events.c:49: error: ?function_trace_stop? undeclared
> (first use in this function)
> 
> It seems that an 'extern int function_trace_stop' is missing somewhere...
> 

Hi Luis,

What arch did you compile this on?  I did a make allmodconfig on x86_64 
and it compiled to completion. I also ran this on x86_64 and i386 boxes 
(a more natural config).

Could you send me your config and tell me what arch you compiled this for.

Thanks,

-- Steve

