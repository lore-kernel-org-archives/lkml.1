Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbXHBKXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbXHBKXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXHBKXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:23:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50038 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbXHBKW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:22:59 -0400
Date: Thu, 2 Aug 2007 16:05:24 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: John Sigler <linux.kernel@free.fr>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Section mismatch: reference to .init.text: (between 'kthreadd'
 and 'init_waitqueue_head')
In-Reply-To: <46B1A9DE.4090907@free.fr>
Message-ID: <alpine.LFD.0.999.0708021603380.8258@enigma.security.iitk.ac.in>
References: <46B1A9DE.4090907@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Aug 2007, John Sigler wrote:

> Hello,
> 
> I'm trying to build a 2.6.22.1-rt9 kernel for a P3.
> 
> I used 'make xconfig' to create .config
> http://linux.kernel.free.fr/latency/config-2.6.22.1-rt9-adlink
> 
> I get the following warning:
> 
>   LD      vmlinux
>   SYSMAP  System.map
>   SYSMAP  .tmp_System.map
>   MODPOST vmlinux
> WARNING: kernel/built-in.o(.text+0x19152): Section mismatch: reference to
> .init.text: (between 'kthreadd' and 'init_waitqueue_head')

This is a bogus warning, already taken care of in 2.6.23-rc1-latestgit.

> Finally, I note that X86_CMPXCHG64 is no longer defined since its
> specification was changed between 2.6.20 and 2.6.22.
> 
>  config X86_CMPXCHG64
>     bool
> -   depends on !M386 && !M486
> +   depends on X86_PAE
>     default y
> 
> Will this have an impact on spinlocks? RCU? something else?

No idea about this one.
