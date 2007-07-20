Return-Path: <linux-kernel-owner+w=401wt.eu-S1765532AbXGTVVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765532AbXGTVVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbXGTVVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:21:18 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:56714 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579AbXGTVVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:21:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAN7DoEarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,564,1175497200"; 
   d="scan'208"; a="167654582:sNHT22893822"
To: "Leech, Christopher" <christopher.leech@intel.com>
Cc: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>, <jeff@garzik.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
X-Message-Flag: Warning: May contain useful information
References: <BD524EA7912ED5469DFD0BAEF6BC752F023E842F@orsmsx411.amr.corp.intel.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 14:21:13 -0700
In-Reply-To: <BD524EA7912ED5469DFD0BAEF6BC752F023E842F@orsmsx411.amr.corp.intel.com> (Christopher Leech's message of "Fri, 20 Jul 2007 14:10:35 -0700")
Message-ID: <adazm1qai0m.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Jul 2007 21:21:13.0521 (UTC) FILETIME=[E67E6A10:01C7CB13]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > This driver supports some chipsets that do MSI, and some that do MSI-X,
 > but none that can do both.

Thanks, that's the simple answer I was hoping for.  Obviously if some
chipsets only do MSI then you need the MSI code in addition to the
MSI-X code.
