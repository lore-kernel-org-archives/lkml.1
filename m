Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZCVRhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZCVRhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 13:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZCVRhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 13:37:05 -0400
Received: from www.tglx.de ([62.245.132.106]:48384 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZCVRhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 13:37:04 -0400
Date: Sun, 22 Mar 2009 18:35:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/cpu.h cleanup
In-Reply-To: <1237709776.909.14.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903221825570.29264@localhost.localdomain>
References: <1237709776.909.14.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Mar 2009, Jaswinder Singh Rajput wrote:
> Is it worth to move arch/x86/kernel/cpu/cpu.h data to asm/cpu.h and if
> required we can also make it private like:
> #ifdef __KERNEL__
> #ifndef MODULE
> private data for kernel only
> #endif
> #endif
> 
> By this way we move header files to include directory. Or you have some
> better option.

There is no option at all. The header files which are in source
directories stay just where they are.

They are there for a reason. Have you even looked which files include
arch/x86/kernel/cpu/cpu.h ?

Thanks,

	tglx
