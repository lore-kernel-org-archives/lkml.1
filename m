Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZCZRkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZCZRkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZCZRj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:39:59 -0400
Received: from www.tglx.de ([62.245.132.106]:58192 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbZCZRj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:39:58 -0400
Date: Thu, 26 Mar 2009 18:38:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -tip] x86: unification of module.c
In-Reply-To: <1238072913.2507.3.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0903261835020.3397@localhost.localdomain>
References: <1238072913.2507.3.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009, Jaswinder Singh Rajput wrote:
> This patch is based on -tip:x86/core:
> 
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Thu, 26 Mar 2009 18:33:45 +0530
> Subject: [PATCH] x86: unification of module.c
> 
> Impact: Unification, cleanup
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/Makefile    |    2 +-
>  arch/x86/kernel/module.c    |  261 +++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/module_32.c |  152 -------------------------
>  arch/x86/kernel/module_64.c |  194 --------------------------------
>  4 files changed, 262 insertions(+), 347 deletions(-)
>  create mode 100644 arch/x86/kernel/module.c
>  delete mode 100644 arch/x86/kernel/module_32.c
>  delete mode 100644 arch/x86/kernel/module_64.c

Sigh. We went through this before. 

First make module_32 and module_64 the same if necessary in several
steps. The last step is to rename one of the files to module.c and
remove the other one.

This cobble all together approach is hard to review and error prone.

Thanks,

	tglx
