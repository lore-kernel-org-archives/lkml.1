Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbYL2RJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbYL2RJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 12:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYL2RJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 12:09:39 -0500
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:59520 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751251AbYL2RJj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 12:09:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=KD7pemzEehdhqi1qBHLc3chW+Zsfn5pN/B3QBsDJ3BKUerMKQFeBQ0vBZ0l3g8FpKR0ovdl+lyuBFPedww7I3Xexpm9N5x4lVfFVBP8F5ZGS4S1yoPZQ3f5xj86zPN5U;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: reboot.c declare port_cf9_safe before they get used
Date: Mon, 29 Dec 2008 09:09:36 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <1230049288.14358.4.camel@jaswinder.satnam> <1230540199.3715.11.camel@jaswinder.satnam> <20081229110855.GA5065@elte.hu>
In-Reply-To: <20081229110855.GA5065@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812290909.36751.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 29, 2008 3:08 am Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
> > Hello Ingo,
> >
> > On Sat, 2008-12-27 at 11:31 +0100, Ingo Molnar wrote:
> > > btw., this is ugly now:
> > > > --- a/arch/x86/kernel/reboot.c
> > > > +++ b/arch/x86/kernel/reboot.c
> > > > @@ -22,6 +22,7 @@
> > > >  #endif
> > > >
> > > >  #include <mach_ipi.h>
> > > > +#include "../pci/pci.h"
> > >
> > > could you send another patch that moves arch/x86/pci/pci.h to
> > > arch/x86/include/asm/pci_x86.h (and update all the pci.h include
> > > sites)?
> >
> > 1. I send ﻿[PATCH] move arch/x86/pci/pci.h to
> > arch/x86/include/asm/pci_x86.h but I forget to write x86: before this
> > patch.
>
> no, your patch is fine. I routinely fix up commit logs.
>
> Jesse, is it fine to you if we push this via the x86 tree? A couple of
> usage sites of arch/x86/pci/pci.h arose that use ../pci/pci.h kind of ugly
> #include prefixes, which justifies moving the file to
> arch/x86/include/asm. No change in behavior.

Yeah, that's fine.  Best to get it over with... I'll take care of any 
conflicts in my tree when I prepare my merge.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

