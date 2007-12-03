Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbXLCLly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbXLCLly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 06:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbXLCLlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 06:41:47 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54688 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbXLCLlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 06:41:47 -0500
To: acme@redhat.com
Cc: bunk@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add EXPORT_SYMBOL(ksize);
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp>
	<20071202134841.GI15974@stusta.de>
	<200712030634.CBJ18798.OVFQJSFFOHMtLO@I-love.SAKURA.ne.jp>
	<20071202214629.GA15034@ghostprotocols.net>
In-Reply-To: <20071202214629.GA15034@ghostprotocols.net>
Message-Id: <200712032041.ABB90643.SOFVQFtMHFLOOJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 3 Dec 2007 20:41:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Arnaldo Carvalho de Melo wrote:
> > But I think ksize() should be available to kernel modules as well as kmalloc() etc.
> Why do you think so? You have to justify that with some valid use.
Is there an alternative function?
If not, it sounds to me that this is a regression.
We couldn't know how much memory was allocated by kmalloc() in 2.4 era, and we can know it 2.6 era.
But are we going back to 2.4 era for out-of-tree kernel modules?

Thanks.
