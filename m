Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbZC3W5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbZC3W5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZC3W4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:56:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:53188 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbZC3W4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:56:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,448,1233561600"; 
   d="scan'208";a="398853019"
Date: Mon, 30 Mar 2009 15:56:44 -0700
From: Chris Leech <christopher.leech@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: mask irq before move it
Message-ID: <20090330225644.GA28098@cleech-lnx.jf.intel.com>
References: <20090326220411.GA16286@cleech-lnx.jf.intel.com> <86802c440903261929s775fe85cv86b900e2610acf1d@mail.gmail.com> <20090327163438.GA10185@cleech-lnx.jf.intel.com> <49CDAAD5.9010202@kernel.org> <20090330221034.GC27774@cleech-lnx.jf.intel.com> <86802c440903301525h41481c98lfff9b40b98b2d7f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440903301525h41481c98lfff9b40b98b2d7f3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 03:25:07PM -0700, Yinghai Lu wrote:
> On Mon, Mar 30, 2009 at 3:10 PM, Chris Leech
> <christopher.leech@intel.com> wrote:
> > On Fri, Mar 27, 2009 at 09:43:01PM -0700, Yinghai Lu wrote:
> >>
> >> Imapct: fix panic
> >>
> >> try to mask the irq, before move the irq desc
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >
> > This change did not fix the issue I'm seeing.  The following output was
> > generated with 2.6.29 + this patch.
> >
> > I will send system information and kernel config separately.
> 
> in your /proc/interrupts
> 
>  57:          0          0          0          0          0          0
>          0          0   PCI-MSI-edge      aerdrv, pciehp
> 
> how can that be shared?

I don't know, I'm not really up on how drivers that deal with
PCI-Express switch ports work.  I'd be happy to test again with both
advances error reporting and hotplug removed from my configuration.

- Chris
