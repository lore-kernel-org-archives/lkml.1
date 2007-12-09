Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbXLIIpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbXLIIpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 03:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbXLIIpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 03:45:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35436
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750732AbXLIIpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 03:45:18 -0500
Date: Sun, 09 Dec 2007 00:45:17 -0800 (PST)
Message-Id: <20071209.004517.201813773.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: 2.6.24-rc4-mm1: some issues on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071208102239.2457eeaa.akpm@linux-foundation.org>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<200712081920.28748.m.kozlowski@tuxland.pl>
	<20071208102239.2457eeaa.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 8 Dec 2007 10:22:39 -0800

> That's
> 
>         J_ASSERT_BH(bh, !buffer_jbddirty(bh));
> 
> at the end of journal_unmap_buffer().
> 
> I don't recall seeing that before and I can't think of anything we've
> done recently which could cause it, sorry.

If the per-cpu data patches are in the -mm tree that is the first
place I would start looking at for possible cause.
