Return-Path: <linux-kernel-owner+w=401wt.eu-S1765958AbXHONEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765958AbXHONEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764694AbXHONBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:01:54 -0400
Received: from ns2.suse.de ([195.135.220.15]:47640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765154AbXHONBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:01:53 -0400
Date: Wed, 15 Aug 2007 15:55:54 +0200
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       glommer@gmail.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
Message-ID: <20070815135554.GE3406@bingen.suse.de>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11871822163867-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_X86_VSMP
> +static inline int raw_irqs_disabled_flags(unsigned long flags)
> +{
> +	return !(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC);
> +}
> +
> +#else
>  static inline int raw_irqs_disabled_flags(unsigned long flags)
>  {
>  	return !(flags & X86_EFLAGS_IF);
>  }
>  
> -#endif
> +#endif /* CONFIG_X86_VSMP */

Didn't we agree this should be a pvops client? 

-Andi
