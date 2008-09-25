Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYIYO7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYIYO7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYIYO7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:59:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34817 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYIYO7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:59:42 -0400
Subject: Re: [PATCH] x86/pci: fix dmar_tbl early_ioremap leak v2
From: David Woodhouse <dwmw2@infradead.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, mark gross <mgross@linux.intel.com>
In-Reply-To: <200809250743.35271.jbarnes@virtuousgeek.org>
References: <1222327705-22048-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080925081158.GA30349@elte.hu>
	 <200809250743.35271.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 07:59:17 -0700
Message-Id: <1222354757.19709.5.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 07:43 -0700, Jesse Barnes wrote:
> On Thursday, September 25, 2008 1:11 am Ingo Molnar wrote:
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > > use early_acpi_os_unmap_memory
> > >
> > > v2: move unmap_memory early...
> > >
> > > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > >
> > > ---
> > >  drivers/pci/dmar.c |    9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > since this depends on other x2apic/sparseirq changes in -tip i've
> > applied it to tip/irq/sparseirq.
> >
> > Jesse, any objections?
> 
> Nope, but it would be good to get Dave or Mark's ack (Dave owns this code 
> now).

I own the code in theory, but am not yet sufficiently competent.

My VT-d hardware arrived just before I left the country for KS+LPC, so
is gathering dust in my absence. I get home this weekend.

_Next_ week, if you see me thinking about _anything_ other than the
IOMMU, please slap me.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

