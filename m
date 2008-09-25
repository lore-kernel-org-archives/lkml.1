Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYIYQXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYIYQXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYIYQXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:23:24 -0400
Received: from mga07.intel.com ([143.182.124.22]:34632 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752699AbYIYQXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:23:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,309,1220252400"; 
   d="scan'208";a="51363259"
Date: Thu, 25 Sep 2008 09:24:34 -0700
From: mark gross <mgross@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] x86/pci: fix dmar_tbl early_ioremap leak v2
Message-ID: <20080925162434.GA30374@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <1222327705-22048-1-git-send-email-yhlu.kernel@gmail.com> <20080925081158.GA30349@elte.hu> <200809250743.35271.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809250743.35271.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 07:43:34AM -0700, Jesse Barnes wrote:
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
>
Sorry for the dumb question but where is acpi_get_table_with_size
defined?  Its not in linus's git. /me goes and gets linux-next...

--mgross
 
