Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbXFQVmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbXFQVmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXFQVmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:42:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37836 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618AbXFQVmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:42:17 -0400
Date: Sun, 17 Jun 2007 23:42:31 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
Message-ID: <20070617214231.GA3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please revert commit 21564fd2a3deb48200b595332f9ed4c9f311f2a7

It's not acceptable since illegal modules should definitely not get 
write access to paravirt_ops.

Andi forwarded it although the following people had already NAK'ed it:
- Christoph Hellwig [1]
- Peter Zijlstra [2]
- Alan Cox [3]

Considering that Andi forwarded it 2 days after he himself said a 
different solution was pending [4] I assume he mistakenly sent it for 
inclusion in your tree.

Reverting is safe since it simply re-establishes the 2.6.21 status quo.

cu
Adrian

[1] http://lkml.org/lkml/2007/4/30/132
[2] http://lkml.org/lkml/2007/4/30/197
[3] http://lkml.org/lkml/2007/4/30/237
[4] http://lkml.org/lkml/2007/4/30/335

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

