Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXGTViS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXGTViS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbXGTViH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:38:07 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:27388 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbXGTViF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:38:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAFPIoEarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,564,1175497200"; 
   d="scan'208"; a="9750512:sNHT12354198"
To: "Manu Abraham" <abraham.manu@gmail.com>
Cc: "Leech, Christopher" <christopher.leech@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net, jeff@garzik.org,
       "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
X-Message-Flag: Warning: May contain useful information
References: <BD524EA7912ED5469DFD0BAEF6BC752F023E842F@orsmsx411.amr.corp.intel.com>
	<adazm1qai0m.fsf@cisco.com>
	<1a297b360707201432q3dc976b3x214c2916ca235b6f@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 14:38:02 -0700
In-Reply-To: <1a297b360707201432q3dc976b3x214c2916ca235b6f@mail.gmail.com> (Manu Abraham's message of "Sat, 21 Jul 2007 01:32:36 +0400")
Message-ID: <adaveceah8l.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Jul 2007 21:38:02.0818 (UTC) FILETIME=[4014EA20:01C7CB16]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > In a case where you have a device that which supports MSI-X (multiple
 > interrupts) but the device in default is in MSI mode, ie some
 > configuration change is needed on the device. In such a case, how
 > would one handle between MSI-X and MSI ?
 > 
 > ie the device initially doesn't support MSI-X

I don't understand the question really.  Does the PCI spec even allow
a device to be in MSI mode by default?  Surely the OS must initialize
the address/message before the device can generate an MSI?

What device do you have in mind?  I guess the interesting case is a
PCIe device that supports MSI and MSI-X but not legacy interrupts.
However I would assume such a device would come up with both MSI and
MSI-X disabled.

 - R.
