Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbXJXKJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbXJXKJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbXJXKJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:09:27 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60743 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbXJXKJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:09:26 -0400
Date: Wed, 24 Oct 2007 12:10:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/git patch] move samples/ to Documentation/markers/
Message-ID: <20071024101058.GA450@uranus.ravnborg.org>
References: <20071024095226.GA30326@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024095226.GA30326@havoc.gtf.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff.

Why do you think it is not worthwhile to build the samples so we can check that they
are to some extend valid code?

I noticed you deleted the following - but you did not explain why.

	Sam

Makefile b/Makefile
> index 2a47290..83894ae 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -774,9 +774,6 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) $(kallsyms.o) vmlinux.o
>  ifdef CONFIG_HEADERS_CHECK
>  	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
>  endif
> -ifdef CONFIG_SAMPLES
> -	$(Q)$(MAKE) $(build)=samples
> -endif
>  	$(call vmlinux-modpost)
>  	$(call if_changed_rule,vmlinux__)
>  	$(Q)rm -f .old_version
