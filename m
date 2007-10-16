Return-Path: <linux-kernel-owner+w=401wt.eu-S935070AbXJPSv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935070AbXJPSv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760949AbXJPSvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:51:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:46473 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130AbXJPSvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:51:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,284,1188802800"; 
   d="scan'208";a="299734230"
Date: Tue, 16 Oct 2007 11:43:28 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
Message-Id: <20071016114328.a96e8bcb.kristen.c.accardi@intel.com>
In-Reply-To: <47150565.5090102@rtr.ca>
References: <4714C0A6.1030204@rtr.ca>
	<4714D700.7060008@rtr.ca>
	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>
	<47150565.5090102@rtr.ca>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 14:39:33 -0400
Mark Lord <lkml@rtr.ca> wrote:

> I also checked my modprobe.d/ options, and I am using pciehp_force=1.
> Without that flag, none of this ever works.

OK - I suspected something like this.  Most Dell computers don't support
ExpressCard hotplug using Native PCIe -- in fact, I've not seen a single
one, they explicitly disable it because they have not validated it or
they have and something didn't work right.  I'll take a look at what you've
got, but be aware that you are forcing pciehp to load and operate on a system
where they've certainly either not tested it, or tested it and something
bad happened.
