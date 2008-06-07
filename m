Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbYFGLDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbYFGLDE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 07:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbYFGLCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 07:02:55 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54899 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbYFGLCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 07:02:54 -0400
Date: Sat, 7 Jun 2008 13:03:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: Greg Ungerer <gerg@snapgear.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: missing sections for linker script
Message-ID: <20080607110335.GA25562@uranus.ravnborg.org>
References: <200805070052.m470qdod017612@goober> <20080511004107.GA2675@uranus.ravnborg.org> <20080511230321.GA20157@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511230321.GA20157@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 01:03:21AM +0200, Sebastian Siewior wrote:
> * Sam Ravnborg | 2008-05-11 02:41:07 [+0200]:
> 
> >Any specific reasons why m68knommu does
> >not use include/asm-generic/vmlinux-lds.h?
> Yes, binutils syntax. I made a patch that changes vmlinux-lds a little
> to make it work with the generic one. I posted it to uclinux ml and wait
> for Greg's feedback (whether here is fine with this approach). I can
> recall that he wanted to use the generic if possible. Here is the patch
> so you drop an eye on it.
> 
> >
> >	Sam
> Sebastian
> ---
> 
> From: Sebastian Siewior <bigeasy@linutronix.de>
> Subject: [PATCH] generic: add OUTPUT_DATA_SECTION to vmlinux.lds.h

Looks good Sebastian.
I have this one applied and I assume you or Greg will folloup
with the m68knommu simplification.

	Sam
