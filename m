Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZERUgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZERUgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZERUgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:36:11 -0400
Received: from waste.org ([66.93.16.53]:45429 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbZERUgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:36:10 -0400
Date: Mon, 18 May 2009 15:34:20 -0500
From: Matt Mackall <mpm@selenic.com>
To: Martin Knoblauch <spamtrap@knobisoft.de>,
       Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from
	drivers/char/random.c
Message-ID: <20090518203420.GF2658@calx>
References: <688406.16641.qm@web32603.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <688406.16641.qm@web32603.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 06:29:13AM -0700, Martin Knoblauch wrote:
> 
> CC Maintainer.

Bizarre. I bet Linus has an opinion about your compiler.
 
> ----- Original Message ----
> > From: Martin Knoblauch <spamtrap@knobisoft.de>
> > To: linux-kernel@vger.kernel.org
> > Sent: Monday, May 18, 2009 2:58:35 PM
> > Subject: Rgeression: 2.6.30-rc6-git3 build error - ICE from drivers/char/random.c
> > 
> > Hi,
> > 
> > trying to build 2.6.30-rc6-git3 with RHEL4.3 userspace (gcc (GCC) 3.4.5 20051201 
> > (Red Hat 3.4.5-2)):
> > 
> > 
> >   CC      drivers/char/mem.o
> >   CC      drivers/char/random.o
> > drivers/char/random.c: In function `get_random_int':
> > drivers/char/random.c:1672: error: unrecognizable insn:
> > (insn 202 148 150 0 
> > /scratch/build/linux-2.6.30-rc6-git3/arch/x86/include/asm/tsc.h:23 (set (reg:SI 
> > 0 ax [91])
> >         (subreg:SI (plus:DI (plus:DI (reg:DI 0 ax [88])
> >                     (subreg:DI (reg:SI 6 bp) 0))
> >                 (const_int -4 [0xfffffffffffffffc])) 0)) -1 (nil)
> >     (nil))
> > drivers/char/random.c:1672: internal compiler error: in extract_insn, at 
> > recog.c:2083
> > Please submit a full bug report,
> > with preprocessed source if appropriate.
> > See for instructions.
> > Preprocessed source stored into /tmp/ccvLBDQc.out file, please attach this to 
> > your bugreport.
> > make[2]: *** [drivers/char/random.o] Error 1
> > make[1]: *** [drivers/char] Error 2
> > make: *** [drivers] Error 2
> > 
> > did not happen with -rc3. Config attached.
> > 
> > Cheers
> > Martin

-- 
Mathematics is the supreme nostalgia of our time.
