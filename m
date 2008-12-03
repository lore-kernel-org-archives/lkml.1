Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYLCCiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYLCCiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 21:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYLCCiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 21:38:13 -0500
Received: from ozlabs.org ([203.10.76.45]:50753 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYLCCiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 21:38:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg Ungerer <gerg@snapgear.com>
Subject: Re: [RFC 5/8] param: arch_get_boot_command_line()
Date: Wed, 3 Dec 2008 13:08:05 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
References: <200812012326.03151.rusty@rustcorp.com.au> <4935D8BF.6040208@snapgear.com>
In-Reply-To: <4935D8BF.6040208@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031308.06817.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2008 11:24:23 Greg Ungerer wrote:
> Hi Rusty,
>
> Rusty Russell wrote:
> > This allows us to get the command line before setup_arch(): right at
> > the beginning of start_kernel().  It also cleans up chaotic
> > commandline handling.

> I don't see any problems with the m68knommu bits.
> Are you looking for an acked-by?

Thanks Greg,

   There are some minor mods, so I'll repost.  You can ack that :)

I'll also create a git tree for archs to actually boot test.  No doubt 
there'll be more arch-specific fixes needed.

Thanks!
Rusty.
