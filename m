Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbYDARBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbYDARBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 13:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbYDARBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 13:01:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690AbYDARBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 13:01:10 -0400
Date: Tue, 1 Apr 2008 10:00:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: davem@davemloft.net, greg@kroah.com, m.kozlowski@tuxland.pl,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: +
 revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch added to
 -mm tree
Message-Id: <20080401100050.009cec7b.akpm@linux-foundation.org>
In-Reply-To: <200804010957.16459.bjorn.helgaas@hp.com>
References: <200803282348.m2SNmleP016847@imap1.linux-foundation.org>
	<200804010957.16459.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008 09:57:15 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Friday 28 March 2008 05:48:47 pm akpm@linux-foundation.org wrote:
> > 
> > The patch titled
> >      revert gregkh-pci-pci-x86-use-generic-pci_enable_resources
> > has been added to the -mm tree.  Its filename is
> >      revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch
> 
> OK, I'm not sure where we are with this.  Ben listed arches where
> the generic pci_enable_resources() should be safe: x86, alpha, and
> powerpc.  I think we should also include ia64, since I work on that.
> 
> If there's no objection to those arches, how should we move forward?
> Since Andrew put in "revert gregkh-pci" patches rather than just
> dropping things, I assume the original patches are in Greg KH's tree.
> 
> Can we just drop the "revert gregkh" patches for x86, alpha, powerpc,
> and ia64?

So powerpc is OK but ppc might not be?

