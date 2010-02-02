Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab0BBXFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 18:05:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55627 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab0BBXFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 18:05:41 -0500
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v8] RO/NX protection for loadable kernel modules
From: Andi Kleen <andi@firstfloor.org>
References: <817ecb6f1001311522q52bf4eebmb748c486dcd5ad35@mail.gmail.com>
Date: Wed, 03 Feb 2010 00:05:39 +0100
In-Reply-To: <817ecb6f1001311522q52bf4eebmb748c486dcd5ad35@mail.gmail.com> (Siarhei Liakh's message of "Sun, 31 Jan 2010 18:22:35 -0500")
Message-ID: <873a1jdyrg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siarhei Liakh <sliakh.lkml@gmail.com> writes:

> This patch is a logical extension of the protection provided by
> CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
> module_core and module_init into three logical parts each and setting
> appropriate page access permissions for each individual section:

My current kernel has 52 modules loaded, most of them very small. 
Assuming the additional alignment of the data section cost two more
pages on average (I think that's a good assumption), that's roughly
424KB of additional memory, plus associated runtime costs in increased
TLB usage. 

What would I get for that if I applied the patch and enabled the option? 

That information seems to be missing in this patch submission.

Did you find any bugs with this option?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
