Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYGaLaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYGaLaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYGaL3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:29:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41924 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbYGaL3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:29:46 -0400
Date: Thu, 31 Jul 2008 13:29:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, greg@kroah.com
Subject: Re: [bug] PCI hotplug, ibmphp_access_ebda: WARNING: at
	arch/x86/mm/ioremap.c:182 __ioremap_caller+0x2d1/0x340()
Message-ID: <20080731112928.GC24030@elte.hu>
References: <20080726131512.GA29472@elte.hu> <200807281531.32640.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807281531.32640.jbarnes@virtuousgeek.org>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Saturday, July 26, 2008 6:15 am Ingo Molnar wrote:
> > FYI, -tip testing triggered the new warning below on a testbox. I
> > suspect it's related to recent commits in drivers/pci/hotplug/.
> > I'm wondering, why does a driver map the EBDA? That's a really lowlevel
> > thing.
> 
> AFAICT, this driver digs around in there for hotplug controller 
> configuration (cc'ing Greg since he appears to be one of the original 
> authors).  It's a custom platform driver too, that may be the only 
> method available there.  Is there a shadow copy of the EDBA somewhere 
> we should be using instead?

not that i know of, but it could be provided i guess. Enumerating and 
making all hw configuration data available reliably would be a plus i 
guess.

	Ingo
