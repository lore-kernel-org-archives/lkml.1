Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZHDEWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZHDEWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 00:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbZHDEWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 00:22:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38485
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667AbZHDEWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 00:22:23 -0400
Date: Mon, 03 Aug 2009 21:22:32 -0700 (PDT)
Message-Id: <20090803.212232.259171216.davem@davemloft.net>
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
 pci-dma-compat.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090803055608.GB19428@elte.hu>
References: <20090721160538.GL25756@amd.com>
	<20090721.121519.239732131.davem@davemloft.net>
	<20090803055608.GB19428@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 3 Aug 2009 07:56:08 +0200

> I'm wondering how sparc32 handles core_kernel_text() & friends? 
> 
> Those functions already assume that the bits between _stext and 
> _etext are all core kernel text and not generic pages freed back to 
> the buddy.

They won't work for such pages obviously.  Shows how many sparc32
users who trigger this case of actually freeing those pages and
using such facilities there actually are :-)
