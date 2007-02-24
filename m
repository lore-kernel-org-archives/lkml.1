Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbXBXNOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbXBXNOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 08:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932682AbXBXNOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 08:14:33 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2437 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbXBXNOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 08:14:32 -0500
Date: Sat, 24 Feb 2007 13:14:22 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: typo in include/linux/irqflags.h ?
Message-ID: <20070224131422.GA5047@flint.arm.linux.org.uk>
Mail-Followup-To: Nicholas Mc Guire <der.herr@hofr.at>,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.60.0702241243270.1583@rtl14.hofr.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0702241243270.1583@rtl14.hofr.at>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 12:45:16PM +0100, Nicholas Mc Guire wrote:
> 
> Hi !
> 
> Seems like there was a cut&past error in include/linux/riqflags.h.
> 
> 
> --- linux-2.6.20/include/linux/irqflags.h	2007-02-04 09:44:54.000000000 -0900
> +++ linux-2.6.20xm/include/linux/irqflags.h	2008-01-27 20:29:26.000000000 -0900
> @@ -91,6 +91,6 @@
>   })
> 
>   #define irqs_disabled_flags(flags)	raw_irqs_disabled_flags(flags)
> -#endif		/* CONFIG_X86 */
> +#endif		/* CONFIG_TRACE_IRQFLAGS_SUPPORT */

Just yet rid of the comment - you can see the corresponding #ifdef on
the screen without paging up or down so it seems pointless to have such
a comment - it just adds additional unnecessary clutter to the screen.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
