Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab0BROeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 09:34:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:17170 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab0BROeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 09:34:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y2R1NDfqY7dAijCQIL/xA7hvXAQudQ5TDjmwfeh3S0hMpCNesN/tu9qasIupVT8iL6
         Rc3yGXSOZjiiJQJRmfKHoR2tCG3hWKhRuiM3c6hMsF7UA3oks83dCWk14D9J8of8fMgm
         5z0zLArQeW/RvTB3LDVlPdTLJCLfgNOsuLnLw=
Date: Thu, 18 Feb 2010 15:33:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
Message-ID: <20100218143355.GA855@nowhere>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com> <1266491616-6270-3-git-send-regression-fweisbec@gmail.com> <8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com> <20100218120944.GA2406@osiris.boeblingen.de.ibm.com> <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com> <20100218123453.GA5136@nowhere> <20100218132521.GB2406@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218132521.GB2406@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 02:25:21PM +0100, Heiko Carstens wrote:
> Subject: [PATCH] tracing/kprobes: add short documentation for HAVE_REGS_AND_STACK_ACCESS_API
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>



Thanks, I'm adding it in the set.



> ---
>  arch/Kconfig |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -123,6 +123,10 @@ config USE_GENERIC_SMP_HELPERS
>  
>  config HAVE_REGS_AND_STACK_ACCESS_API
>  	bool
> +	help
> +	  This symbol should be selected by an architecure if it supports
> +	  the API needed to access registers and stack entries from pt_regs.
> +	  For example the kprobes-based event tracer needs this API.
>  
>  config HAVE_CLK
>  	bool

