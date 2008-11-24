Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYKXXzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYKXXzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYKXXz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:55:28 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:3919 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYKXXz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:55:28 -0500
Message-ID: <492B3EEF.8070404@ct.jp.nec.com>
Date: Mon, 24 Nov 2008 15:55:27 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: signal: cosmetic unification of	sys_rt_sigreturn()
References: <49276229.9060000@ct.jp.nec.com> <492762B1.4020107@ct.jp.nec.com> <4927655B.5070906@zytor.com> <4927698C.90104@ct.jp.nec.com> <20081123095146.GR30453@elte.hu>
In-Reply-To: <20081123095146.GR30453@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> H. Peter Anvin wrote:
>>> Hiroshi Shimamoto wrote:
>>>>  
>>>> +#ifdef CONFIG_X86_32
>>>>  asmlinkage int sys_rt_sigreturn(unsigned long __unused)
>>>>  {
>>>>  	struct pt_regs *regs = (struct pt_regs *)&__unused;
>>>>  
>>>>  	return do_rt_sigreturn(regs);
>>>>  }
>>> Why not:
>>>
>>> asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
>>> {
>>> 	return do_rt_sigreturn(&regs);
>>> }
>>>
>>> ...?
>> Good question. I didn't realize about that.
>> Will take a look.
> 
> I've applied your 3 patches to tip/x86/signal - please send a patch on 
> top of your current lineup, for the detail Peter pointed out.

OK, will do.
I think it's better to send a patch after unifying signal_{32|64}.c.

thanks,
Hiroshi Shimamoto
