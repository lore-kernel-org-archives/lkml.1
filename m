Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbYL2DiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbYL2DiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 22:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYL2Dhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 22:37:53 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:51636 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYL2Dhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 22:37:52 -0500
X-IronPort-AV: E=Sophos;i="4.36,293,1228089600"; 
   d="scan'208";a="126025127"
From: Roland Dreier <rdreier@cisco.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: general@lists.openfabrics.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Aleksey Senin <alekseys@voltaire.com>
Subject: Re: linux-next: origin tree build failure
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 28 Dec 2008 19:36:12 -0800
In-Reply-To: <20081229114321.4b6baea5.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Mon, 29 Dec 2008 11:43:21 +1100")
Message-ID: <ada8wpzvej7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Dec 2008 03:36:12.0943 (UTC) FILETIME=[98E401F0:01C96966]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
 > 
 > ERROR: ".ipv6_chk_addr" [drivers/infiniband/core/ib_addr.ko] undefined!
 > ERROR: ".ip6_route_output" [drivers/infiniband/core/ib_addr.ko] undefined!
 > 
 > Caused by commit 38617c64bf9a10bf20e41d95b69bb81e8560fe9d ("RDMA/addr:
 > Add support for translating IPv6 addresses").  This requires a dependency
 > on IPV6.

Thanks, I'll get a fix queued up.  Sorry about that.

 - R.
