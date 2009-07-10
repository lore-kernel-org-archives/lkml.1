Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZGJNEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZGJNEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbZGJNES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:04:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:35431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZGJNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:04:16 -0400
Message-Id: <20090710125755.559739294@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 10 Jul 2009 14:57:55 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
       mingo@elte.hu
Subject: [PATCH 0/2] cond_resched() optimization
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt suggested, whereupon Linus sayeth:

 "This looks like a good patch. Please make it so"

Compile and boot tested on x86_64 only.

