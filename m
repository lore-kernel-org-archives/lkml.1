Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZBFPgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZBFPgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZBFPfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:35:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43717 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZBFPft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:35:49 -0500
Date: Fri, 6 Feb 2009 15:33:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       cooloney@kernel.org, tony.luck@intel.com, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [linux-next][PATCH] revert headers_check fix: ia64, fpu.h
Message-ID: <20090206153315.GD13758@n2100.arm.linux.org.uk>
References: <20090206164546.6291.KOSAKI.MOTOHIRO@jp.fujitsu.com> <3f9a31f40902060053x18dacf58u40c739ab89f13860@mail.gmail.com> <20090206180957.6294.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090206145556.GH18368@elte.hu> <1233934141.3209.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233934141.3209.20.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 08:59:01PM +0530, Jaswinder Singh Rajput wrote:
> On Fri, 2009-02-06 at 15:55 +0100, Ingo Molnar wrote:
> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > > > Index: b/arch/ia64/include/asm/fpu.h
> > > > > ===================================================================
> > > > > --- a/arch/ia64/include/asm/fpu.h
> > > > > +++ b/arch/ia64/include/asm/fpu.h
> > > > > @@ -6,7 +6,7 @@
> > > > >  *     David Mosberger-Tang <davidm@hpl.hp.com>
> > > > >  */
> > > > >
> > > > > -#include <linux/types.h>
> > > > > +#include <asm/types.h>
> > > > >
> > > > 
> > > > No , we do not even need asm/types.h
> > > > 
> > > > Subject: [PATCH] Neither asm/types.h nor linux/types.h is not required
> > > > for arch/ia64/include/asm/fpu.h
> > > > 
> > > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > 
> > > ok. I confirmed.
> > > 	Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > Thanks.
> > 
> > Jaswinder, mind adding these tags to the commit and sending a pull request 
> > with all fixes?
> 
> The following changes since commit 0b86a4e34d885e734a4c4e46293376f3f1c639eb:
>   Ingo Molnar (1):
>         Merge branch 'core/header-fixes' of git://git.kernel.org/.../jaswinder/linux-2.6-tip into core/header-fixes
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git core/header-fixes
> 
> Jaswinder Singh Rajput (2):
>       Neither asm/types.h nor linux/types.h is required for arch/ia64/include/asm/fpu.h
>       make linux/types.h as assembly safe

I continue to disagree with the need for the second patch.
