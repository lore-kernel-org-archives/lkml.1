Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbYI0QzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbYI0QzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYI0QzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:55:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53939 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYI0QzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:55:07 -0400
Date: Sat, 27 Sep 2008 18:54:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080927165458.GH4600@elte.hu>
References: <20080919123320.GF7222@lenovo> <20080923005737.GA25045@linux-os.sc.intel.com> <20080923011620.GB25045@linux-os.sc.intel.com> <20080923045637.GA7172@localhost> <20080923183411.GD25045@linux-os.sc.intel.com> <20080923190002.GE10567@localhost> <20080923191742.GA15609@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923191742.GA15609@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1506]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> > +       while (apic >= 0)
> > +               kfree(early_ioapic_entries[apic--]);
> >         memset(early_ioapic_entries, 0,
> >                 ARRAY_SIZE(early_ioapic_entries));
> > 
> 
> looks better. thanks.

applied to tip/irq/sparseirq - and added your Acked-by. Thanks guys!

	Ingo
