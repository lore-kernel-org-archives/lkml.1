Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYL1Muj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYL1Muj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 07:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYL1Mua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 07:50:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59087 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbYL1Mua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 07:50:30 -0500
Date: Sun, 28 Dec 2008 13:49:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org, joerg.roedel@amd.com
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
Message-ID: <20081228124957.GA6872@elte.hu>
References: <20081228103419.GA7128@elte.hu> <20081228195952F.fujita.tomonori@lab.ntt.co.jp> <20081228115621.GA11954@elte.hu> <20081228213414O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228213414O.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Ok, I'll try to fix the root cause. We need lots of changes to IA64 
> especially. Hopefully, I can get Tony's ACK on these changes.

great - let me know if you need testing help on the x86 side as well. I.e. 
we can test some preliminary patch series from you as well, without 
committing it to anything stable (i.e. keeping open the ability to 
rebase/redo it) - while waiting for Tony's ACK.

	Ingo
