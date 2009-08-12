Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZHLXeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZHLXeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZHLXeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:34:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48670
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934AbZHLXeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:34:17 -0400
Date: Wed, 12 Aug 2009 16:34:27 -0700 (PDT)
Message-Id: <20090812.163427.161326946.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: mingo@elte.hu, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, fenghua.yu@intel.com
Subject: Re: [PATCH resend 0/8] sparc: use asm-generic/dma-mapping-common.h
 and pci-dma-compat.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1249872797-1314-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1249872797-1314-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 10 Aug 2009 11:53:09 +0900

> This is the repost of the patchset (as Ingo asked me offline) :
> 
> http://lkml.org/lkml/2009/7/13/20
> 
> There is no functional change. I just added David's ack to #3-8
> patches and Robert's Tested-by to #8 patch.
> 
> I confirmed that it can be applied cleanly to mainline, -next, and
> -tip trees.
> 
> The git tree is also available:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git sparc

I just made a quick build test on sparc32 and sparc64, as well as
a non-debug execution test on sparc64 and it all looks fine.

Thanks for doing this work!

I assume Ingo or someone else is going to merge this stuff?
