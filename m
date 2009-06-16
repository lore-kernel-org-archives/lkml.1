Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbZFPRRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbZFPRRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760828AbZFPRRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:17:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:6124 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760818AbZFPRRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:17:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,230,1243839600"; 
   d="scan'208";a="155225350"
Date: Tue, 16 Jun 2009 10:17:42 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 3/4] PCI: PCIE AER: PCIE AER software error injection
Message-ID: <20090616101742.64f3a0f7@jbarnes-g45>
In-Reply-To: <1245033777.5320.328.camel@yhuang-dev.sh.intel.com>
References: <1240541127.6842.681.camel@yhuang-dev.sh.intel.com>
	<20090611115954.294581bb@jbarnes-g45>
	<1244771641.5320.146.camel@yhuang-dev.sh.intel.com>
	<20090612085336.08a89d68@jbarnes-g45>
	<1245033777.5320.328.camel@yhuang-dev.sh.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 10:42:57 +0800
Huang Ying <ying.huang@intel.com> wrote:

> On Fri, 2009-06-12 at 23:53 +0800, Barnes, Jesse wrote:
> > On Thu, 11 Jun 2009 18:54:01 -0700
> > "Huang, Ying" <ying.huang@intel.com> wrote:
> > 
> > > On Fri, 2009-06-12 at 02:59 +0800, Barnes, Jesse wrote:
> > > > On Fri, 24 Apr 2009 10:45:27 +0800
> > > > Huang Ying <ying.huang@intel.com> wrote:
> > > >
> > > > > Debugging PCIE AER code can be very difficult because it is
> > > > > hard to trigger various real hardware errors. This patch
> > > > > provide a software based error injection tool, which can fake
> > > > > various PCIE errors with a user space helper tool named
> > > > > "aer-inject". Which can be gotten from:
> > > > >
> > > > >   http://www.kernel.org/pub/linux/kernel/people/yhuang/
> > > > >
> > > > > The patch fakes AER error by faking some PCIE AER related
> > > > > registers and an AER interrupt for specified the PCIE device.
> > > > >
> > > > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > > >
> > > >
> > > > This patch got mangled, care to resend?
> > > 
> > > Sorry. Resend patch follows.
> > > 
> > 
> > This one didn't apply either; can you pull down my linux-next branch
> > and diff against that?  Also, cc my personal address,
> > jbarnes@virtuousgeek.org, so Exchange doesn't mess up the patch.
> 
> Re-base on
> git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
> branch linux-next.
> 
> Sent as attachment, I think that works even for Exchange.
> 
> Another patch to fix the user space tool URL is attached with the mail
> too. Please fold it into inject document patch if possible.

Ok, that one applied, thanks.  It's queued up in linux-next now...

-- 
Jesse Barnes, Intel Open Source Technology Center
