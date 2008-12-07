Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYLGIoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYLGIoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 03:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYLGIoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 03:44:15 -0500
Received: from ozlabs.org ([203.10.76.45]:38538 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbYLGIoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 03:44:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFC 5/8] param: arch_get_boot_command_line() (take II)
Date: Sun, 7 Dec 2008 19:14:06 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "Luck, Tony" <tony.luck@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
References: <200812012326.03151.rusty@rustcorp.com.au> <200812041128.34159.rusty@rustcorp.com.au> <20081206204217.GA10788@flint.arm.linux.org.uk>
In-Reply-To: <20081206204217.GA10788@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812071914.08285.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 December 2008 07:12:17 Russell King wrote:
> On Thu, Dec 04, 2008 at 11:28:32AM +1030, Rusty Russell wrote:
> > On Thursday 04 December 2008 05:07:25 Luck, Tony wrote:
> > > > I pulled your git tree.  All my test configs build cleanly
> > > > for ia64 ... but sadly the first kernel I tested (generic_defconfig)
> > > > doesn't boot (no console output at all).
> > > >
> > > > I'll see if I can figure out what is going on.
> > >
> > > Aha.
> > 
> > OK, both appended to git tree.  
> > git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-boot-params.git
> > 
> > If noone else complains, I'll fold the fix and ask Stephen to take the tree 
> > for linux-next.
> 
> One commit in there looks rather dirty:

Yeah, it's a fix commit.  Git fits with arch maintainers' workflow most
easily so I use it here, but it leads to expectations about "append only".

I'll fold into a sane series before shovelling through linux-next; this
week I expect, since noone actually said "this is a stupid waste of time".

> |     With the addition of this patch ia64 bits are
> | 
> |     Acked-by: Tony Luck <tony.luck@intel.com>
> 
> I'm wondering whether the ia64 bits are now green, yellow or maybe they're
> taking some terminal exercise by jumping off the cliff like lemmings.

I think they're green.  No doubt I've broken other archs, but they haven't
whined yet (and I cross-compiled for arm, at least).

Thanks,
Rusty.
