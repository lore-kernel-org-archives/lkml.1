Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYLIXeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYLIXeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYLIXd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:33:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbYLIXd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:33:56 -0500
Date: Tue, 9 Dec 2008 18:33:47 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, Richard Henderson <rth@twiddle.net>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-parisc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: setup_arch/arch_get_boot_command_line changes
Message-ID: <20081209233347.GD7015@bombadil.infradead.org>
References: <200812100850.26728.rusty@rustcorp.com.au> <20081209225931.GA7015@bombadil.infradead.org> <20081209230214.GB7015@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081209230214.GB7015@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 06:02:14PM -0500, Kyle McMartin wrote:
> On Tue, Dec 09, 2008 at 05:59:31PM -0500, Kyle McMartin wrote:
> > Will this not run afoul of lockdep since it will be attempting to take
> > locks before lockdep has initialized?
> > 
> 
> Ah, printk calls lockdep_off now. Handy.
> 

Nevermind, this doesn't do what I think it does... Rusty, does this work
with lockdep enabled?
