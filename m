Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYBQUMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYBQUMt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYBQUMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:12:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333AbYBQUMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:12:13 -0500
Message-ID: <47B89501.5090108@zytor.com>
Date: Sun, 17 Feb 2008 12:11:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>, ak@suse.de, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86: lds - Use THREAD_SIZE instead of numeric	constant
References: <20080217151716.274134094@gmail.com> <20080217151925.402628615@gmail.com> <20080217185936.GB14588@uranus.ravnborg.org> <20080217190801.GC31968@cvg> <47B88FAA.9080603@zytor.com> <20080217200654.GF31968@cvg>
In-Reply-To: <20080217200654.GF31968@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Thanks Peter for comments. Peter could you clarify for me a bit
> more on the string:
> 
> x86/kernel/head_32.S:339
> 
> 	/* Set up the stack pointer */
> 	lss stack_start,%esp
> 
> but stack_start is defined as head_32.S:647
> 
> .data
> ENTRY(stack_start)
> 	.long init_thread_union+THREAD_SIZE
> 
> so stack_start *must* be aligned with THREAD_SIZE in vmlinux.lds
> at compiling time. There is no PDA at this booting time. Am I wrong?
> If you're too busy - just reply me like "Read the code" ;)
> 

That doesn't follow.

You're saying that it *must* be aligned, I don't think that's true 
anymore; I think nowadays it's more accurate to say that it *is* 
aligned, but I don't think that's fundamental.

	-hpa
