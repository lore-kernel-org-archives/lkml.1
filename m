Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXHBR6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXHBR6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXHBR57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:57:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47157 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbXHBR56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:57:58 -0400
Date: Thu, 2 Aug 2007 19:59:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch warnings
Message-ID: <20070802175914.GC2431@uranus.ravnborg.org>
References: <46AE2459.7080905@googlemail.com> <20070730185124.GA29116@uranus.ravnborg.org> <46AE3C80.7010307@googlemail.com> <46AF9152.2050707@googlemail.com> <20070731204846.GA9985@uranus.ravnborg.org> <46AFB06E.2020401@googlemail.com> <46B1E9D6.80006@googlemail.com> <20070802163108.GA2431@uranus.ravnborg.org> <46B21084.4050308@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B21084.4050308@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 07:12:36PM +0200, Gabriel C wrote:
> Sam Ravnborg wrote:
> > On Thu, Aug 02, 2007 at 04:27:34PM +0200, Gabriel C wrote:
> >>>>> WARNING: vmlinux.o(.init.text+0x29d40): Section mismatch: reference to .exit.text:wbsd_release_resources (between 'wbsd_init' and 'wbsd_probe')
> >>>>> WARNING: vmlinux.o(.init.text+0x29d49): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
> >>>>> WARNING: vmlinux.o(.init.text+0x29f28): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
> >>>> When a function is marked __exit and used from an init function then the safe choice
> >>>> is to just remove the __exit marking. Usually this is small functions used
> >>>> only in error situations.
> >>>> Should be trivial too.
> >>> I'll look at those too
> >>>
> >>>> Sorry - no patch this time. Could you try to look at it yorself then I will review.
> >>> Ok I'll try.
> >>>
> >> The warnings gone with this patch but I'm not really sure it is correct.
> > Looks correct to me.
> > You drop the __devexit marking for functions used outside __exit.
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Shall I send this one to akpm with your ACK or you take care of it ?
Please forward it to akpm.
I usually do not carry non-kbuild patches in my tree to keep 'noise' level down.

	Sam
