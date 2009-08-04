Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZHDEVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZHDEVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 00:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZHDEVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 00:21:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38473
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbZHDEVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 00:21:02 -0400
Date: Mon, 03 Aug 2009 21:21:10 -0700 (PDT)
Message-Id: <20090803.212110.104970698.davem@davemloft.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, joerg.roedel@amd.com,
       fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
 pci-dma-compat.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090803055441.GA19428@elte.hu>
References: <20090718110620.GC27287@elte.hu>
	<20090802.202135.63875488.davem@davemloft.net>
	<20090803055441.GA19428@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 3 Aug 2009 07:54:41 +0200

> So that it can be freed. It's also placed next to the regular init 
> section to not create too many holes. It also keeps the 'kernel text 
> area' continuous and things like core_kernel_text() & co still work 
> fine.

Ok, I'll look into doing similar on sparc.
