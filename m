Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYKVCIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYKVCIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 21:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYKVCIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 21:08:14 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64897 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYKVCIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 21:08:14 -0500
Message-ID: <4927698C.90104@ct.jp.nec.com>
Date: Fri, 21 Nov 2008 18:08:12 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: signal: cosmetic unification of sys_rt_sigreturn()
References: <49276229.9060000@ct.jp.nec.com> <492762B1.4020107@ct.jp.nec.com> <4927655B.5070906@zytor.com>
In-Reply-To: <4927655B.5070906@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hiroshi Shimamoto wrote:
>>  
>> +#ifdef CONFIG_X86_32
>>  asmlinkage int sys_rt_sigreturn(unsigned long __unused)
>>  {
>>  	struct pt_regs *regs = (struct pt_regs *)&__unused;
>>  
>>  	return do_rt_sigreturn(regs);
>>  }
> 
> Why not:
> 
> asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
> {
> 	return do_rt_sigreturn(&regs);
> }
> 
> ...?

Good question. I didn't realize about that.
Will take a look.

thanks,
Hiroshi Shimamoto
