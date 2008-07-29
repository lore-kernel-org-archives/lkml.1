Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYG2KKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYG2KKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbYG2KKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:10:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47928
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754653AbYG2KKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:10:08 -0400
Date: Tue, 29 Jul 2008 03:10:05 -0700 (PDT)
Message-Id: <20080729.031005.203132019.davem@davemloft.net>
To: joerg.roedel@amd.com
Cc: sfr@canb.auug.org.au, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080729095027.GA4851@amd.com>
References: <20080728.222439.176200666.davem@davemloft.net>
	<20080729164523.bfd2d539.sfr@canb.auug.org.au>
	<20080729095027.GA4851@amd.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>
Date: Tue, 29 Jul 2008 11:50:27 +0200

> I think moving that function to x86-only code is the best solution for
> now. Before moving it back to generic code we need an architecture
> independent way to find out the IOMMU page size.

My suggestion (again) is to pass it in as a "const unsigned long
io_page_size" argument and update the callers.
