Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbYDDVRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbYDDVRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYDDVQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:16:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:47542 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbYDDVQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:16:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,606,1199692800"; 
   d="scan'208";a="545916807"
Message-ID: <47F69965.7030303@intel.com>
Date: Fri, 04 Apr 2008 14:11:01 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [ANNOUNCE] e1000 to e1000e migration of PCI Express devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2008 21:12:04.0364 (UTC) FILETIME=[8828F4C0:01C89698]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


All,

>From kernel 2.6.26 onward all *PCI Express* device IDs previously
supported by e1000 will be moving to the e1000e driver.  This includes
ich8 and ich9 onboard LAN, server 5000 platform onboard LAN (es2) and
82571/2/3 chipset based adapters and variants.

If you have not already enabled CONFIG_E1000E make sure that you do so.
You can already do this with 2.6.25.  From 2.6.26 on this change will be
required if you have such a device.

It is also worthwhile to note you will have to update your modprobe.conf
or equivalent file to point existing interfaces to the new driver.

For clarity, please note that all 8254x devices are only supported by
e1000, even if they are hidden behind a PCI Express bridge.  They are
still regular PCI or PCI-X devices.

Intel will continue to support both e1000 and e1000e drivers in the
kernel.


Regards,

Auke
