Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbXGXHrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbXGXHrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXGXHqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:46:55 -0400
Received: from havoc.gtf.org ([69.61.125.42]:40852 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbXGXHqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:46:54 -0400
Date: Tue, 24 Jul 2007 03:46:53 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 0/3] More ISDN hotplug/probe conversions (kill
	pci_find_device)
Message-ID: <20070724074653.GA14987@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following three patches continue the development work found on the
'isdn-pci' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

which currently contains the following changes:

      [ISDN] HiSax: modularize card setup
      [ISDN] Ready HiSax driver for modularization
      [ISDN] HiSax bkm_a4t: convert to PCI hotplug API
      [ISDN] HiSax enternow: convert to PCI hotplug API
      [ISDN] HiSax hfc_pci, w6692: convert to PCI hotplug API
      [ISDN] HiSax nj_s, nj_u: convert to PCI hotplug API
      [ISDN] HiSax telespci: convert to PCI hotplug API
P     [ISDN] HiSax: additional export to make things proper
1 --> [ISDN] HiSax avm_pci: split setup into three smaller functions
2 --> [ISDN] HiSax avm_pci: convert to modern probing
2 --> [ISDN] HiSax acm_pci: fix module unload
3 --> [ISDN] HiSax gazel: convert to ISA/PCI new probing

The three patches' contents are the final four changesets listed.

These new patches begin to convert drivers that are not exclusively
PCI-only, complicating things a bit.

	Jeff



