Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYBQSAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYBQSAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbYBQSAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:00:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbYBQSAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:00:19 -0500
Date: Sun, 17 Feb 2008 18:59:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, thomas.petazzoni@free-electrons.com,
       tglx@linutronix.de, hpa@zytor.com, Linux-tiny@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Configure out DMI scanning code v2 (Linux Tiny)
Message-ID: <20080217175954.GS6006@elte.hu>
References: <20080212100418.5de764da@crazy> <1202842605.12383.100.camel@cinder.waste.org> <20080212120817.5d27d09d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212120817.5d27d09d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 12 Feb 2008 12:56:45 -0600
> Matt Mackall <mpm@selenic.com> wrote:
> 
> > 
> > On Tue, 2008-02-12 at 10:04 +0100, Thomas Petazzoni wrote:
> > 
> > > Turn CONFIG_DMI into a selectable option if EMBEDDED is defined, in
> > > order to be able to remove the DMI table scanning code if it's not
> > > needed, and then reduce the kernel code size.
> > > 
> > > With CONFIG_DMI (i.e before) :
> > > 
> > >    text    data     bss     dec     hex filename
> > > 1076076  128656   98304 1303036  13e1fc vmlinux
> > > 
> > > Without CONFIG_DMI (i.e after) :
> > > 
> > >    text    data     bss     dec     hex filename
> > > 1068092  126308   98304 1292704  13b9a0 vmlinux
> > > 
> > > Result:
> > > 
> > >    text    data     bss     dec     hex filename
> > >   -7984   -2348       0  -10332   -285c vmlinux
> > > 
> > > The new option appears in "Processor type and features", only when
> > > CONFIG_EMBEDDED is defined.
> 
> Given this:
> 
> > > This patch is part of the Linux Tiny project, and is based on previous
> > > work done by Matt Mackall <mpm@selenic.com>.
> 
> 
> > Acked-by: Matt Mackall <mpm@selenic.com>
> 
> That should have been "Signed-off-by:".  I'll speculatively make that 
> change.

for the x86 bits:

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
