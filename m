Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYL2KIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYL2KIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYL2KIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:08:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbYL2KIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:08:12 -0500
Date: Mon, 29 Dec 2008 11:07:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, mj@ucw.cz
Subject: Re: [PATCH] move arch/x86/pci/pci.h to
	arch/x86/include/asm/pci_x86.h
Message-ID: <20081229100746.GA12159@elte.hu>
References: <1230382948.3373.1.camel@jaswinder.satnam> <20081229065713.GA10960@x200.localdomain> <1230537538.3090.4.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1230537538.3090.4.camel@jaswinder.satnam>
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


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> On Mon, 2008-12-29 at 09:57 +0300, Alexey Dobriyan wrote:
> > On Sat, Dec 27, 2008 at 06:32:28PM +0530, Jaswinder Singh Rajput wrote:
> > > Impact: cleanup, arch/x86/pci/pci.h -> arch/x86/include/asm/pci_x86.h
> > 
> > And this is done for what?
> 
> Don't you think ﻿arch/x86/pci/pci.h looks ugly it should be in
> arch/x86/incluse/asm directory ?
> 
> It was suggested by Ingo :
> http://marc.info/?l=linux-kernel&m=123037395221921&w=2
> 
> I think Ingo will have more valid reasons to satisfy your curiousity ;-)

yes - the reason why i asked for that is that asm/pci.h already exists, 
and it is included in generic code (via linux/include/pci.h) and provides 
public PCI interfaces.

pci_x86.h (a'ka arch/x86/pci/pci.h) includes lowlevel x86-only internals, 
included from a handful PCI arch/x86/ platform .c files.

	Ingo
