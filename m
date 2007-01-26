Return-Path: <linux-kernel-owner+w=401wt.eu-S965642AbXAZNE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965642AbXAZNE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 08:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965649AbXAZNE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 08:04:59 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:44200 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965642AbXAZNE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 08:04:58 -0500
Date: Fri, 26 Jan 2007 13:04:55 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: [PATCH 2/3] ARM: Convert to use shared APM emulation.
Message-ID: <20070126130454.GA21675@linux-mips.org>
References: <20070115205935.GA5010@martell.zuzino.mipt.ru> <20070123164541.42faf54e.akpm@osdl.org> <20070124071337.GA21110@linux-sh.org> <20070124124422.GA14757@linux-mips.org> <20070124124538.GA14917@linux-mips.org> <20070124175050.GB3953@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124175050.GB3953@ucw.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 05:50:51PM +0000, Pavel Machek wrote:

> >  arch/arm/Kconfig               |   29 ++----------------
> >  arch/arm/common/sharpsl_pm.c   |    2 -
> >  arch/arm/kernel/Makefile       |    1 
> >  arch/arm/mach-pxa/corgi_pm.c   |    2 -
> >  arch/arm/mach-pxa/sharpsl_pm.c |    2 -
> >  arch/arm/mach-pxa/spitz_pm.c   |    2 -
> >  include/asm-arm/apm.h          |   64 -----------------------------------------
> >  7 files changed, 8 insertions(+), 94 deletions(-)
> 
> Maybe you should delete apm.c, too?

Indeed ...  New patch in reply to this email.

Thanks,

  Ralf
