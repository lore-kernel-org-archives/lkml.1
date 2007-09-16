Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbXIPUL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbXIPUL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXIPULU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:11:20 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40975 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbXIPULU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:11:20 -0400
Date: Sun, 16 Sep 2007 22:12:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, kbuild-devel@lists.sourceforge.net
Subject: Re: Rename asm-offsets tool or not? (Re: [patch 01/03] kbuild, asm-values: infrastructure)
Message-ID: <20070916201245.GA10000@uranus.ravnborg.org>
References: <20070612233650.486224000@flower.upol.cz> <20070612234558.648949000@flower.upol.cz> <20070916182912.GA9630@uranus.ravnborg.org> <20070916193258.GD13543@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070916193258.GD13543@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 09:32:58PM +0200, Oleg Verych wrote:
> On Sun, Sep 16, 2007 at 08:29:12PM +0200, Sam Ravnborg wrote:
> > Hi Oleg.
> 
> Hallo. Nice, you are bringing it back. I'll try to have LKML-like
> output this time, not a makefile mess and stuff:
> 
> []
> > I see no value in renaming from asm_offset to asm_value - please drop it.
> > Introducing the generic asm-values.h should wait and when you do
> > you should be preapred to update all architectures (ecasue otherwise it
> > will not happen).
> 
> All archs, are using same syntax. But.
> 
> Interesting exception is MIPS, where tokens are organized and implemented
> more nicely, that is where *asm-values* name coming from, actually. One
> can see all that text, size, constant tokens in addition to just offsets.
> 
> So, if name change isn't worth, then OK; filename compatibility check, as
> one in `linux/Kbuild', is easy to hack as well to remove.
> 
> But nice feature/tool with meaningful name and functionality is just
> another thing.
> 
> Opinions?
Everyone and their cousin these days knows that asm-offset is constants
generated from C and used in assembler.
If we benefit from more values in the asm-offset file - let's do it.
But there is no reason to change a name that has been used for this purpose
for as long as I can remember.

	Sam
