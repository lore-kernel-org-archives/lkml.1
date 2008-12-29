Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYL2Ip1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYL2Ip1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 03:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYL2IpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 03:45:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:39484 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYL2IpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 03:45:17 -0500
Subject: Re: [PATCH] x86: reboot.c declare port_cf9_safe before they get
	used
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081227103141.GF14639@elte.hu>
References: <1230049288.14358.4.camel@jaswinder.satnam>
	 <20081227103141.GF14639@elte.hu>
Content-Type: text/plain; charset=utf8
Date: Mon, 29 Dec 2008 14:13:18 +0530
Message-Id: <1230540199.3715.11.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Sat, 2008-12-27 at 11:31 +0100, Ingo Molnar wrote:

> btw., this is ugly now:
> 
> > --- a/arch/x86/kernel/reboot.c
> > +++ b/arch/x86/kernel/reboot.c
> > @@ -22,6 +22,7 @@
> >  #endif
> >  
> >  #include <mach_ipi.h>
> > +#include "../pci/pci.h"
> 
> could you send another patch that moves arch/x86/pci/pci.h to 
> arch/x86/include/asm/pci_x86.h (and update all the pci.h include sites)?
> 

1. I send ﻿[PATCH] move arch/x86/pci/pci.h to
arch/x86/include/asm/pci_x86.h but I forget to write x86: before this
patch.

Please let me know which one is better option :
﻿[PATCH]x86: move arch/x86/pci/pci.h to arch/x86/include/asm/pci_x86.h
OR
﻿﻿[PATCH -tip]x86: move arch/x86/pci/pci.h to
arch/x86/include/asm/pci_x86.h
OR some other name.

2. I also did not write any reason of patch this may lead confusion to
other developers, can you please provide some good reasons for this
patch.

3. I also did some cleanups in ﻿arch/x86/include/asm/pci_x86.h raised
by  ./scripts/checkpatch.pl, is this OK.

4. Can I resend above patch by solving above issues.

Thank you,

	JSR


