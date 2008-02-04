Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYBDNIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYBDNIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbYBDNIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:08:40 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:61547 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755832AbYBDNIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:08:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABKdpkdMQWYq/2dsb2JhbACBWKlB
Date: Mon, 4 Feb 2008 08:08:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kbuild: Fix instrumentation removal breakage on avr32
Message-ID: <20080204130835.GA16379@Krystal>
References: <20080203211042.GF2648@uranus.ravnborg.org> <20080204124448.3633e937@dhcp-252-066.norway.atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080204124448.3633e937@dhcp-252-066.norway.atmel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:07:50 up 92 days, 18:13,  3 users,  load average: 1.58, 1.01,
	1.10
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Haavard Skinnemoen (hskinnemoen@atmel.com) wrote:
> On Sun, 3 Feb 2008 22:10:42 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > Mathieu Desnoyers (5):
> >       Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig
> 
> AVR32 still includes Kconfig.instrumentation, so it won't build after
> this...
> 
> I did point this out when the patch was submitted, I sent the avr32
> pull request early as promised (more than a week ago), but it still
> broke. Please apply the fix below. This fixes 2.6.24-mm1 too.
> 

This one slipped through.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  arch/avr32/Kconfig |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: linux-2.6.24-mm1/arch/avr32/Kconfig
> ===================================================================
> --- linux-2.6.24-mm1.orig/arch/avr32/Kconfig	2008-02-04 12:28:31.000000000 +0100
> +++ linux-2.6.24-mm1/arch/avr32/Kconfig	2008-02-04 12:28:36.000000000 +0100
> @@ -236,8 +236,6 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/avr32/Kconfig.debug"
>  
>  source "security/Kconfig"

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
