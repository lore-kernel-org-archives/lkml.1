Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYHEI0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYHEI0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 04:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbYHEI0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 04:26:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:59262 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbYHEI0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 04:26:23 -0400
Subject: Re: [PATCH 10/10] sparc64: use iommu_num_pages function in IOMMU
	code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net,
       paulus@samba.org, fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080805074935.GA32012@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
	 <1217865890-3593-11-git-send-email-joerg.roedel@amd.com>
	 <20080804.142834.171476315.davem@davemloft.net>
	 <20080805074935.GA32012@amd.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 18:23:29 +1000
Message-Id: <1217924609.24157.170.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I didn't want to change multiple architectures with a single patch so I
> splitted it up. The whole renaming in the beginning is to make the patch
> series bisectable. But if its no problem to change multiple
> architectures with one patch I will those changes in a single patch next
> time.

I wouldn't say there's a strict rule. It's a balance to find between
the complexity of the patch, the risk of breaking archs, etc...

In your case, the added churn of going through a temporary renamed
helper represents more, imho, than the risk of breakage of what is
a fairly trivial patch in the first place. Also, it only affects a few
archs. So it's simpler or everybody to deal with a single patch even if
that means it -might- need a rev or two in case it does indeed break
something...

Ben.


