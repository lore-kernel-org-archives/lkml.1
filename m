Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab0BLRde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:33:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757246Ab0BLRdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:33:33 -0500
Date: Fri, 12 Feb 2010 18:31:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       peter.lachner@intel.com
Subject: Re: [patch v3 1/2] x86, ptrace: regset extensions to support xstate
Message-ID: <20100212173143.GA20816@redhat.com>
References: <20100211195058.071883111@sbs-t61.sc.intel.com> <20100211195614.802495327@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211195614.802495327@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Suresh Siddha wrote:
>
> --- tip.orig/arch/x86/include/asm/user.h
> +++ tip/arch/x86/include/asm/user.h
> ...
> +struct user_xstateregs {
> +	struct {
> +		__u64 fpx_space[58];
> +		__u64 xstate_fx_sw[USER_XSTATE_FX_SW_WORDS];
> +	} i387;

Perhaps a small comment can explain that user_xstateregs.i387 is
"equal" to struct i387_fxsave_struct. Otherwise it is not immediately
clear what xstateregs_get() actually copies into *ubuf


I don't think my ACK should be counted here, but the patch looks
good to me.

Oleg.

