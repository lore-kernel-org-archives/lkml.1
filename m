Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbXGOJ53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbXGOJ53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbXGOJ5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:57:22 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57824 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812AbXGOJ5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:57:21 -0400
Date: Sun, 15 Jul 2007 05:57:16 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 0/5] Convert a HiSax driver to the PCI hotplug API
Message-ID: <20070715095716.GA20949@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series presents a series of five patches, the end result
being a HiSax driver modularized and converted to use the standard PCI
hotplug API (and not pci_find_device).

1) HiSax: move card setup into separate function
2) HiSax: move card state alloc/setup code into separate functions
3) HiSax: modularize card setup; introduce simple hotplug API
4) HiSax netjet_s: code movement, prep for hotplug
5) HiSax netjet_s: convert to PCI hotplug API

As discussed a month or two ago when I submitted my first ISDN PCI
cleanup patch...  kkeil suggested that I do a sample PCI API conversion,
from which others could model HiSax driver conversion work.

DO NOT APPLY.  It is 98% upstream ready, and ready for testing/debug,
but some changes in patch #5 need to be moved to patches 1-3.
And most importantly, I do not have access to ISDN hardware, so kkeil
or somebody will need to be able to test and debug this stuff :/

This work can be found on the 'isdn-pci' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

	Jeff



P.S. "DO NOT APPLY" is only for upstream.  It would be great for this to
appear in -mm.

