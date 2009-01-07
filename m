Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZAGIiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZAGIiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 03:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZAGIhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 03:37:54 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:48489 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZAGIhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 03:37:54 -0500
Date: Wed, 7 Jan 2009 09:37:50 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: powerpc: introduce asm/swab.h
In-Reply-To: <1231303340.14860.61.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0901070937200.26808@anakin>
References: <200901070400.n0740Ore002063@hera.kernel.org>
 <1231303340.14860.61.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009, Benjamin Herrenschmidt wrote:
> On Wed, 2009-01-07 at 04:00 +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=156ca2bbf6503a02d7d6829886ce381d572de66e
> > Commit:     156ca2bbf6503a02d7d6829886ce381d572de66e
> > Parent:     8cdd3a9261e8efe36aeb6c708edb76d7e2b5d13f
> > Author:     Harvey Harrison <harvey.harrison@gmail.com>
> > AuthorDate: Tue Jan 6 14:56:23 2009 -0800
> > Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> > CommitDate: Tue Jan 6 18:10:27 2009 -0800
> > 
> >     powerpc: introduce asm/swab.h
> >     
> >     Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Was this tested ? I see no arch maintainer signed-off here, it appears
> to at least break ppc32, and contains hunks that paulus says were
> explicitely nacked (removing of our ld_* macros) etc...

And m68k (sun3, why not the others/):
http://kisskb.ellerman.id.au/kisskb/buildresult/66040/

Why hasn't this been in linux-next?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
