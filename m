Return-Path: <linux-kernel-owner+w=401wt.eu-S1161004AbXAZJb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161004AbXAZJb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 04:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161002AbXAZJb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 04:31:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4034 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965623AbXAZJbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 04:31:41 -0500
Date: Wed, 24 Jan 2007 17:50:51 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Andrew Morton <akpm@osdl.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: [PATCH 2/3] ARM: Convert to use shared APM emulation.
Message-ID: <20070124175050.GB3953@ucw.cz>
References: <20070115205935.GA5010@martell.zuzino.mipt.ru> <20070123164541.42faf54e.akpm@osdl.org> <20070124071337.GA21110@linux-sh.org> <20070124124422.GA14757@linux-mips.org> <20070124124538.GA14917@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124124538.GA14917@linux-mips.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
>  arch/arm/Kconfig               |   29 ++----------------
>  arch/arm/common/sharpsl_pm.c   |    2 -
>  arch/arm/kernel/Makefile       |    1 
>  arch/arm/mach-pxa/corgi_pm.c   |    2 -
>  arch/arm/mach-pxa/sharpsl_pm.c |    2 -
>  arch/arm/mach-pxa/spitz_pm.c   |    2 -
>  include/asm-arm/apm.h          |   64 -----------------------------------------
>  7 files changed, 8 insertions(+), 94 deletions(-)

Maybe you should delete apm.c, too?
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
