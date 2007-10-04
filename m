Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbXJDP0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbXJDP0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 11:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbXJDP0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:26:16 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:54309 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbXJDP0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:26:15 -0400
X-IronPort-AV: E=Sophos;i="4.21,230,1188802800"; 
   d="scan'208";a="404036992"
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: "yogeshwar sonawane" <yogyas@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Accessing 64-bit BARs
X-Message-Flag: Warning: May contain useful information
References: <b681c62b0710040153w5b4779fat1ccc7fa3e5775c2c@mail.gmail.com>
	<200710041440.15464.eike-kernel@sf-tec.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 04 Oct 2007 08:26:12 -0700
In-Reply-To: <200710041440.15464.eike-kernel@sf-tec.de> (Rolf Eike Beer's message of "Thu, 4 Oct 2007 14:40:10 +0200")
Message-ID: <adasl4qdhpn.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Oct 2007 15:26:12.0870 (UTC) FILETIME=[E5B60260:01C8069A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > You should use pci_iomap() to get an access pointer to the BAR. After this you 
 > can access the memory with ioread*() and iowrite*(). See "man pci_iomap(9)" 
 > if you build kernel manpages.

That works fine, but ioremap() and readl()/writel() is also perfectly
fine for regions that you know are always MMIO.

 - R.
