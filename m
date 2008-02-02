Return-Path: <linux-kernel-owner+w=401wt.eu-S933110AbYBBXNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110AbYBBXNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763945AbYBBXNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:13:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34341 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524AbYBBXNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:13:05 -0500
Message-ID: <47A4F8F1.2020708@zytor.com>
Date: Sat, 02 Feb 2008 15:12:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, git-commits-head@vger.kernel.org
Subject: Re: x86: fix arch/x86/kernel/test_nx.c modular build bug
References: <200801310159.m0V1xU2L015772@hera.kernel.org> <20080202223645.GA27546@uranus.ravnborg.org>
In-Reply-To: <20080202223645.GA27546@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> This should have used _ASM_PTR from asm.h:
> 
> #ifdef CONFIG_X86_32
> /* 32 bits */
> 
> # define _ASM_PTR       " .long "
> ...
> #else
> /* 64 bits */
> 
> # define _ASM_PTR       " .quad "
> 

There is an even better patch now in upstream.

	-hpa
