Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbXL3H2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbXL3H2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbXL3HLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbXL3HLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:11:16 -0500
Message-ID: <47774314.9080406@zytor.com>
Date: Sat, 29 Dec 2007 23:04:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Introduce REX prefix helper for kprobes
References: <1198466795.6323.12.camel@brick> <47773C2D.8070600@redhat.com>
In-Reply-To: <47773C2D.8070600@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Hi Harvey,
> 
> Harvey Harrison wrote:
>> Fold some small ifdefs into a helper function.
>>
>> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>> ---
>> Masami, Ingo, I had this left in some unsent kprobes unification
>> work.  Depends on your tastes, but does reduce ifdefs and is a bit
>> better about self-documenting the REX prefix on X86_64.
> 
> Basically, I think it is good idea.
> Could you use a macro same as the stack_addr() macro, like as below?
> 
> #defile is_REX_prefix(insn) ((insn & 0xf0) == 0x40))
> 
> This is just a bit checker, so I think a macro is better to do that.
> 

Why is a macro better than an inline, and why the odd mIXed case?

	-hpa
