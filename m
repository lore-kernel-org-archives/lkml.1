Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbYL3Hia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbYL3Hia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYL3HiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:38:21 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:9787 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYL3HiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:38:20 -0500
X-IronPort-AV: E=Sophos;i="4.36,300,1228089600"; 
   d="scan'208";a="221334581"
From: Roland Dreier <rdreier@cisco.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: general@lists.openfabrics.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Aleksey Senin <alekseys@voltaire.com>
Subject: Re: linux-next: origin tree build failure
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 29 Dec 2008 23:38:18 -0800
In-Reply-To: <20081229114321.4b6baea5.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Mon, 29 Dec 2008 11:43:21 +1100")
Message-ID: <adavdt2ru39.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Dec 2008 07:38:18.0628 (UTC) FILETIME=[95496440:01C96A51]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > ERROR: ".ipv6_chk_addr" [drivers/infiniband/core/ib_addr.ko] undefined!
 > ERROR: ".ip6_route_output" [drivers/infiniband/core/ib_addr.ko] undefined!

OK, I pushed out a change that should fix this, so you can drop the
revert.  Let me know if you see further issues.

 - R.
