Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZFFJJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZFFJJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZFFJJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:09:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:52714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZFFJJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:09:35 -0400
Subject: Re: [PATCH 0/6] headers_check fix patches 20090604
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090606084341.GB14555@uranus.ravnborg.org>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244275812.2475.2.camel@ht.satnam>
	 <20090606084341.GB14555@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 14:39:37 +0530
Message-Id: <1244279377.2475.37.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

On Sat, 2009-06-06 at 10:43 +0200, Sam Ravnborg wrote:
> On Sat, Jun 06, 2009 at 01:40:12PM +0530, Jaswinder Singh Rajput wrote:
> > On Thu, 2009-06-04 at 17:53 +0530, Jaswinder Singh Rajput wrote:
> > > Please Review :
> > > 
> > > Jaswinder Singh Rajput (6):
> > >       headers_check fix: arm, hwcap.h
> > >       headers_check fix: ia64, fpswa.h
> > >       headers_check fix: m68k, swab.h
> > >       headers_check fix: mips, ioctl.h
> > >       headers_check fix: mn10300, ptrace.h
> > >       headers_check fix: mn10300, setup.h
> > 
> > Thanks for you review, I applied all these patches to headers-check tree
> > for linus :
> > 
> > http://git.kernel.org/?p=linux/kernel/git/jaswinder/headers-check-2.6.git;a=summary
> 
> We agreed to do mips different - right?
> 

As I already said earlier that I mentioned compatible issue in commit
log :

"Make ioctl.h compatible with asm-generic/ioctl.h and userspace"

and it also fixes headers_check for userspace. So I kept it to maintain
harmony :

http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git&a=search&h=HEAD&st=commit&s=headers_check

Thanks,
--
JSR



