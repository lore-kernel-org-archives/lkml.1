Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZIUOUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZIUOUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZIUOUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:20:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:35030 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbZIUOUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:20:12 -0400
Message-Id: <20090921140848.444528343@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 21 Sep 2009 16:08:48 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 0/2] perf vs d-cache aliasses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

based on your vmalloc code, an alternative implementation that lets x86 stay
with regular allocations.

While I'm sad to have to propose having two implementations around, I see no
other way to please both sides.

Alternative to placing the code in arch/sparc we could do something like

CONFIG_PERF_WANTS_VMALLOC and place both somewhere in kernel/



