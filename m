Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbXFDDu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbXFDDu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 23:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXFDDuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 23:50:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:41630 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbXFDDuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 23:50:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,378,1175497200"; 
   d="scan'208";a="93142614"
Subject: Re: [PATCH] reduce AER init error information
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       us15@os.inf.tu-dresden.de, davej@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070601120429.GC7345@suse.de>
References: <1177832284.14017.270.camel@ymzhang>
	 <465C3446.5020603@googlemail.com> <20070529155732.GA7068@suse.de>
	 <alpine.LFD.0.98.0705291406000.26602@woody.linux-foundation.org>
	 <20070601120429.GC7345@suse.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 04 Jun 2007 11:49:40 +0800
Message-Id: <1180928980.3068.5.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 05:04 -0700, Greg KH wrote:
> On Tue, May 29, 2007 at 02:06:52PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 29 May 2007, Greg KH wrote:
> > > 
> > > Care to forward the above patch to the stable@kernel.org address after
> > > it goes into Linus's tree?
> > 
> > .. talking about going to my tree, where _is_ it? It's not in my mailbox, 
> > at least..
> 
> I tried to get this to work for the last round of PCI patches that I
> sent you yesterday, but it had build problems, which I need to spend
> some time fixing up :(
> 
I fixed by patch at http://marc.info/?l=linux-kernel&m=117783233918191&w=2.
Later on, someone found if CONFIG_ACPI=n, there is a compilation error. Then,
I sent out a new patch to fix the compilation error, but another guy wants
AER driver support although CONFIG_ACPI=n. He sent out the 3rd patch to fix the
compilation error and enables AER driver when CONFIG_ACPI=n.

So pls. apply 2 patches.

1) http://marc.info/?l=linux-kernel&m=117783233918191&w=2;
2) http://marc.info/?l=linux-mm-commits&m=118046936720790&w=2

When patch 2 is applied to stable kernel 2.6.21.3, there is a fuzz warning.
It doesn't matter.

Sorry for replying so late.

Yanmin

