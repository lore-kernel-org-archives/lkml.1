Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYK2Jeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYK2Jeo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 04:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYK2Jef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 04:34:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbYK2Jee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 04:34:34 -0500
Date: Sat, 29 Nov 2008 10:34:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <len.brown@intel.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org
Subject: Re: drivers/x86 (Was: Re: linux-next: Tree for November 28
	(misc/tc1100))
Message-ID: <20081129093414.GB26691@elte.hu>
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au> <4930307C.30106@oracle.com> <20081129083550.3c23af37.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129083550.3c23af37.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Len,
> 
> On Fri, 28 Nov 2008 09:55:08 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > make[2]: *** No rule to make target `drivers/misc/tc1100-wmi.o', needed by `drivers/misc/built-in.o'.
> > 
> > on allmodconfig & allyesconfig for i386.
> > 
> > On, moved to drivers/x86/.  Someone needs to clean up drivers/misc/Makefile.
> 
> Just wondering where the move to drivers/x86 was discussed, (reviewed 
> and tested) and why the change is in the acpi tree and not the x86 
> tree?

it will all conflict with pending bits in the x86 tree, so i'd prefer if 
Len did this atomically after 2.6.29-rc1, without it having this 
long-term breakage effect.

Historically drivers/misc/ has been more active via the ACPI tree. (Len 
being the (in-)voluntary maintainer for those platform details)

So drivers/x86/ makes sense i guess. Eventually the really lowlevel bits 
might move to arch/x86/drivers/ or so - but i've got no strong opinion on 
it. There seems to be enough precedent of existing drivers/$ARCH 
hierarchies.

	Ingo
