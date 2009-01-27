Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZA0LM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZA0LM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZA0LMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:12:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZA0LMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:12:48 -0500
Date: Tue, 27 Jan 2009 12:12:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New build regressions: 2.6.27-rc2-git2
Message-ID: <20090127111238.GA17848@elte.hu>
References: <20090127093516.GA27545@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127093516.GA27545@flint.arm.linux.org.uk>
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


* Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> >From this morning's ARM kautobuild:
> 
> magician defconfig:
> 
> drivers/built-in.o: In function `debugfs_create_size_t':
> led-core.c:(.text+0x0): multiple definition of `debugfs_create_size_t'
> kernel/built-in.o:dma-coherent.c:(.text+0x0): first defined here

should be fixed in latest -git by:

  5ee8100: Fix "multiple definition of `debugfs_create_size_t'"

	Ingo
