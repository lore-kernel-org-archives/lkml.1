Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYLSWgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYLSWgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYLSWgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:36:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:33347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbYLSWgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:36:03 -0500
Message-ID: <494C2179.1060600@kernel.org>
Date: Fri, 19 Dec 2008 14:34:33 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix lguest used_vectors breakage
References: <494B8790.4060801@kernel.org> <20081219222349.GA10954@elte.hu>
In-Reply-To: <20081219222349.GA10954@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Impact: fix and clean up
> 
> i tidied the changelog up - see it attached further below. Also Cc:-ed 
> Rusty as the motivation is to fix and standardize lguest's irq vector 
> allocation method.
> 
> One small detail, we'll need a -v2:
> 
>  In file included from 
>  /home/mingo/linux/linux/arch/x86/include/asm/elf.h:90,
>                  from include/linux/elf.h:8,
>                  from include/linux/module.h:15,
>                  from include/linux/crypto.h:22,
>                  from arch/x86/kernel/asm-offsets_32.c:8,
>                  from arch/x86/kernel/asm-offsets.c:3:
>  /home/mingo/linux/linux/arch/x86/include/asm/desc.h:324: error: 'NR_VECTORS' undeclared here (not in a function)
> 
> config attached. Please pick up the changelog (and subject line) below 
> when you iterate the patch. Thanks,

where is config?

YH
