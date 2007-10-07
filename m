Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbXJGVAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbXJGVAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXJGU7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 16:59:55 -0400
Received: from ns2.suse.de ([195.135.220.15]:34165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbXJGU7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 16:59:54 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <200710071059.126674000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] [0/6] Some scheduler changes for sched-devel
Date: Sun,  7 Oct 2007 22:59:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Various source code cleanups (no functional changes) 
- Shrink binary size by refactoring some code
- One K8 optimization that is unfortunately not measurable.
But it sounded good in theory! @)
(if you have a better scheduling latency benchmark than
lmbench3 it would be cool to try) 
- One real bug fix for a obscure problem

All against the sched-devel git tree with 
d024f67c652f7f0519d2a1906b646286abbb2e48 head.

Future wishlist: someone document all the magic numbers
in the load balancer code.

-Andi
