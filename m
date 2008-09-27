Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYI0StF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYI0StF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYI0Ssy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:48:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbYI0Ssx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:48:53 -0400
Date: Sat, 27 Sep 2008 20:48:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mgross@linux.intel.com, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] x86/pci: fix dmar_tbl early_ioremap leak v2
Message-ID: <20080927184825.GA17867@elte.hu>
References: <1222327705-22048-1-git-send-email-yhlu.kernel@gmail.com> <20080925081158.GA30349@elte.hu> <200809250743.35271.jbarnes@virtuousgeek.org> <20080925162434.GA30374@linux.intel.com> <86802c440809251001vc9aa170vb6656ca6f61b1971@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809251001vc9aa170vb6656ca6f61b1971@mail.gmail.com>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Thu, Sep 25, 2008 at 9:24 AM, mark gross <mgross@linux.intel.com> wrote:
> > On Thu, Sep 25, 2008 at 07:43:34AM -0700, Jesse Barnes wrote:
> >> On Thursday, September 25, 2008 1:11 am Ingo Molnar wrote:
> >> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >> > > use early_acpi_os_unmap_memory
> >> > >
> >> > > v2: move unmap_memory early...
> >> > >
> >> > > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >> > >
> >> > > ---
> >> > >  drivers/pci/dmar.c |    9 +++++++--
> >> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> >> >
> >> > since this depends on other x2apic/sparseirq changes in -tip i've
> >> > applied it to tip/irq/sparseirq.
> >> >
> >> > Jesse, any objections?
> >>
> >> Nope, but it would be good to get Dave or Mark's ack (Dave owns this code
> >> now).
> >>
> > Sorry for the dumb question but where is acpi_get_table_with_size
> > defined?  Its not in linus's git. /me goes and gets linux-next...
> >
> 
> in tip/master

access coordinates:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
