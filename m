Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbYE0SsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbYE0SsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbYE0SsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:48:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299AbYE0SsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:48:08 -0400
Date: Tue, 27 May 2008 14:48:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: distinguish kretprobe'd functions in trace logs
In-Reply-To: <483C53EE.2060602@gmail.com>
Message-ID: <Pine.LNX.4.58.0805271442090.396@gandalf.stny.rr.com>
References: <483C53EE.2060602@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 May 2008, Abhishek Sagar wrote:
>
> But if irq_enter() has a kretprobe installed on it, the return value stored on the stack at each invocation is modified to divert the return to a kprobe trampoline function called kretprobe_trampoline(). So with this the trace would (currently) look like:
>
> <idle>-0     [00] 4154504455.781616: irq_enter <- kretprobe_trampoline
>
> Now this is quite misleading to the end user, as it suggests something that didn't actually happen. So just to avoid such misinterpretations, the inlined patch aims to output such a log as:
>
> <idle>-0     [00] 4154504455.781616: irq_enter <- [unknown/kretprobe'd]
>
>
> Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>

Thanks Abhishek,

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

