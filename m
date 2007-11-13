Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbXKMTGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbXKMTGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760623AbXKMTGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:06:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46965 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759447AbXKMTGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:06:18 -0500
Message-ID: <4739F564.5080006@zytor.com>
Date: Tue, 13 Nov 2007 11:05:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 4/8] Add asm-compat.h to x86
References: <20071113185800.436425570@polymtl.ca> <20071113190040.426268972@polymtl.ca>
In-Reply-To: <20071113190040.426268972@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> In assembly code and in gcc inline assembly, we need .long to express a "c long"
> type on i386 and a .quad to express the same on x86_64. Use macros similar to
> powerpc "PPC_LONG" to express those. Name chosen: ASM_LONG. (didn't feel like
> X86_LONG was required)

In the x86 queue I already have a patch which adds <asm/asm.h> for this; 
I used the namespace _ASM_* and the name _ASM_PTR since in Linux it is 
what holds a pointer.

	-hpa

