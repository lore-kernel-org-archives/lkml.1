Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbXFNLEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbXFNLEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 07:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXFNLEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 07:04:00 -0400
Received: from barikada.upol.cz ([158.194.242.200]:56233 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbXFNLD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 07:03:59 -0400
Date: Thu, 14 Jun 2007 13:16:21 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, kbuild-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Need opinions on asm-offsets cleanup (Re: [patch 01/03] kbuild, asm-values: infrastructure)
Message-ID: <20070614111621.GL7266@flower.upol.cz>
References: <20070612233650.486224000@flower.upol.cz> <20070612234558.648949000@flower.upol.cz> <20070614074143.GK7266@flower.upol.cz> <20070614091225.GA30817@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614091225.GA30817@uranus.ravnborg.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 11:12:25AM +0200, Sam Ravnborg wrote:
> On Thu, Jun 14, 2007 at 09:41:43AM +0200, Oleg Verych wrote:
> > Jun 13, 2007 at 01:36:51AM +0200, asm-values patch set:
> > > 	* header with widely used value definitions
> > > 	* handle all asm-related things in one file (Makefile.asm)
> > > 	* move some asm bits from Makefile.build there
> > > 	  (rule %.s:%.c)
> > > 	* add script to generate headers from assembles output
> > > 	  (hopefully better output, MIPS testing/joining to all arch
> > > 	   probably needed)
> > > 
> > > rfc-by: Oleg Verych
> > > ---
> > 
> > So, is it another not so juicy lets-break-it-all stuff from me, or it just
> > doesn't apply for you?
> 
> I have not yet looked at it. A few other items pending that I need to finish
> off before next merge window has priority.
 
That's my view about asm-offsets cleanup/generalizing. I just need ack or
nack from, for example arch maintainers if this is acceptable at all or
anybody, actually interested in this kind of things. Not cool stuff, but
still quite straight and easy to finish and merge.
____
