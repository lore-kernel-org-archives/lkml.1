Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbXLBVed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbXLBVed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 16:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbXLBVeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 16:34:23 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:60387 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbXLBVeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 16:34:22 -0500
To: bunk@kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add EXPORT_SYMBOL(ksize);
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp>
	<20071202134841.GI15974@stusta.de>
In-Reply-To: <20071202134841.GI15974@stusta.de>
Message-Id: <200712030634.CBJ18798.OVFQJSFFOHMtLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 3 Dec 2007 06:34:20 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Adrian Bunk wrote:
> > mm/slub.c exports ksize(), but mm/slob.c and mm/slab.c don't. I don't know why.
> That's due to the fact that my patch to remove this unused export from 
> slub was not yet applied...
So, removing exports is intended thing?

> Where is the modular in-kernel user?
I don't know.
But I think ksize() should be available to kernel modules as well as kmalloc() etc.

Thanks.
