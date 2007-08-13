Return-Path: <linux-kernel-owner+w=401wt.eu-S1033622AbXHMS6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033622AbXHMS6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1033115AbXHMSyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:54:24 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:50585 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S974345AbXHMSyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:54:20 -0400
Date: Mon, 13 Aug 2007 11:53:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: joe@perches.com
Cc: zach@vmware.com, virtualization@lists.osdl.org,
       torvalds@linux-foundation.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, jeremy@xensource.com, chrisw@sous-sol.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [365/2many] MAINTAINERS - PARAVIRT_OPS INTERFACE
Message-ID: <20070813185323.GG3672@sequoia.sous-sol.org>
References: <46bffb3b.jTNczaQ2ECqVDjzn%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffb3b.jTNczaQ2ECqVDjzn%joe@perches.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* joe@perches.com (joe@perches.com) wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2166416..44768ce 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3519,6 +3519,9 @@ M:	rusty@rustcorp.com.au
>  L:	virtualization@lists.osdl.org
>  L:	linux-kernel@vger.kernel.org
>  S:	Supported
> +F:	arch/i386/kernel/paravirt.c
> +F:	include/asm-i386/paravirt.h
> +F:	include/asm-um/paravirt.h

Not asm-um.  And it's much more spread out than that, touching many
non-paravirt specific files (as in include/asm-i386/ and search for
CONFIG_PARAVIRT).  I'm failing to see the value of this churn.

thanks,
-chris
