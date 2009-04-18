Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbZDSCoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbZDSCoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 22:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbZDSCnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 22:43:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41816 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbZDSCnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 22:43:53 -0400
Date: Sat, 18 Apr 2009 19:09:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: kbuild - introduce support for subdir-ccflags-y
Message-ID: <20090418180953.GE7148@flint.arm.linux.org.uk>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Sam Ravnborg <sam@ravnborg.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	linux arch <linux-arch@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	"David S. Miller" <davem@davemloft.net>
References: <20090418125159.GA23008@uranus.ravnborg.org> <20090418125839.GA3668@flint.arm.linux.org.uk> <20090418150750.GA24059@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090418150750.GA24059@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 05:07:50PM +0200, Ingo Molnar wrote:
> 
> * Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > On Sat, Apr 18, 2009 at 02:51:59PM +0200, Sam Ravnborg wrote:
> > > The typical use cases are an architecture or a subsystem that
> > > decide to cover all files with -Werror.
> > > Today alpha, mips and sparc uses -Werror in almost all their
> > > Makefile - with subdir-ccflag-y it is now simpler to do so
> > > as only the top-level directories needs to be covered.
> > 
> > Hmm, this won't make sense for ARM.  We have things like #warning 
> > and deprecated functions in machine specific headers, and adding 
> > -Werror to the whole of arch/arm/ will result in these causing 
> > builds to fail.
> 
> This is optional - if you dont want it, you dont set it.

Please read _all_ of my mail, particularly the bit where it talks about
it being useful for a certain subset.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
