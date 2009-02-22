Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZBVW7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZBVW7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZBVW7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:59:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39502 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbZBVW7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:59:03 -0500
Date: Sun, 22 Feb 2009 23:58:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Kevin O'Connor" <kevin@koconnor.net>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org, Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: Re: MPTable can not be high-memory on Linux
Message-ID: <20090222225847.GB1649@elte.hu>
References: <499DB40C.1060205@coresystems.de> <499DCE79.8020809@coresystems.de> <20090222152530.GA30576@morn.localdomain> <200902221806.55429.rjw@sisk.pl> <49A1C4AF.9000009@kernel.org> <20090222223226.GA3346@morn.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222223226.GA3346@morn.localdomain>
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


* Kevin O'Connor <kevin@koconnor.net> wrote:

> On Sun, Feb 22, 2009 at 01:33:35PM -0800, Yinghai Lu wrote:
> [...]
> > >>>  BIOS-e820: 0000000000090000 - 0000000000100000 (reserved)
> > >>>  BIOS-e820: 0000000000100000 - 000000003f7f0000 (usable)
> > >>>  BIOS-e820: 000000003f7f0000 - 0000000040000000 (reserved)
> [...]
> > >>> found SMP MP-table at [c00f9fc0] 000f9fc0
> [...]
> > 
> > that should work for a long time.
> > 
> > 0xf9fc0 < 1M is quite < max_low_pfn, so wonder why bootmem could panic.
> 
> On this machine the mptable "floating" structure is at 
> 0xf9fc0.  It points to the rest of the table which is in the 
> 0x3f7f0000 area.
> 
> Note, that this is on a Coreboot+SeaBIOS machine - so we can 
> change the bios.  However, the mptable spec does allow for 
> part of the table to be high memory.

yes, and i'd prefer if it worked fine even if it's that high.

	Ingo
