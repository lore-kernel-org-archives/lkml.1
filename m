Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbXI1UCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbXI1UCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbXI1UCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:02:06 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:60173 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbXI1UCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:02:04 -0400
X-IronPort-AV: E=Sophos;i="4.21,210,1188802800"; 
   d="scan'208";a="529439665"
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i915: make vbl interrupts work properly on i965g/gm
X-Message-Flag: Warning: May contain useful information
References: <Pine.LNX.4.64.0709280248480.10526@skynet.skynet.ie>
	<200709271909.23040.jbarnes@virtuousgeek.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 28 Sep 2007 13:02:02 -0700
In-Reply-To: <200709271909.23040.jbarnes@virtuousgeek.org> (Jesse Barnes's message of "Thu, 27 Sep 2007 19:09:22 -0700")
Message-ID: <adave9umudh.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Sep 2007 20:02:02.0532 (UTC) FILETIME=[6F998640:01C8020A]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to hijack this thread, but I have a question about i915
interrupts (945GM specifically) that I haven't gotten an answer to
yet, and this thread reminded me of it so I thought I'd ask again:
I hacked the kernel drm stuff on my laptop with 945GM graphics to do
pci_enable_msi() on the graphics device, and I don't see any
interrupts occur.

So can someone with access to details of the 945GM tell me if MSI
interrupts should work, and if so if there's some internal registers
that need to be poked to enable it (beyond what pci_enable_msi()
does).

It's not super-urgent-- I just like using shiny things like MSI, and I
already have ahci, iwl3945 and e1000 working with MSI on my laptop, so
the graphics are the only thing left with an MSI capability that's not
working.

Thanks!
  Roland
