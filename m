Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbYLIXCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbYLIXCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbYLIXCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:02:30 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:38599 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026AbYLIXC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:02:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Y1tPSb8GR/77VaZr06HjRfyiYdiV0ZvAOCocrp5uPEdy3X8hrxH5bwjjn/O0mrcCj8
         c9hAX4WJAq9DINhKyLMm0xZ8jQRihJE/mvGUm2c8FI4IcYexwhUiee+60QPzJow6zgQn
         UJJfxaMitctFxu/O8u4aLrrsYvNaE3IcYc3Xc=
Message-ID: <493EF797.7090603@gmail.com>
Date: Tue, 09 Dec 2008 23:56:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] tracing/function-graph-tracer: signal interrupt triggering
 on output
References: <493EF64D.50804@gmail.com>
In-Reply-To: <493EF64D.50804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> This patchset adds all the features to draw hardirq triggering on output
> for the function graph tracer.
> An example is given on the third patch.
> 
> Just one question, on recordmcount.pl:
> 
> my %text_sections = (
>       ".text" => 1,
>       ".sched.text" => 1,
>       ".spinlock.text" => 1,
> 
> The .sched.text section is included inside .text, it's a subsection, I'm not sure
> it's necessary to add it in text_sections. In doubt I added the new .irqentry.text
> 
> The stat of the patchset:
> 
>  arch/x86/kernel/apic.c               |    3 +-
>  arch/x86/kernel/irq_64.c             |    3 +-
>  arch/x86/kernel/vmlinux_64.lds.S     |    1 +
>  include/asm-generic/vmlinux.lds.h    |   10 +++++
>  include/linux/ftrace.h               |   11 ++++++
>  kernel/trace/trace_functions_graph.c |   66 +++++++++++++++++++++++++++++++--
>  scripts/recordmcount.pl              |    1 +
>  7 files changed, 89 insertions(+), 6 deletions(-)
> 
> 

Sorry, forgot to cc LKML on this one.
