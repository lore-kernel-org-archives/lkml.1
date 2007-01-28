Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbXA1MKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbXA1MKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 07:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbXA1MKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 07:10:44 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:13526 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751927AbXA1MKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 07:10:43 -0500
Message-Id: <20070128115118.837777000@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Sun, 28 Jan 2007 12:51:18 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/7] breaking the global file_list_lock
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set breaks up the global file_list_lock which was found to be a
severe contention point under basically any filesystem intensive workload.

It has been part of the -rt kernel for some time now and is deemed solid and
useful enough to post in its own right. This contention should also occur on
the large SMP machines.

Feedback would be appreciated, especially with regard to the extra workqueue
that was added to flush per cpu lists. Is there an alternative aproach?



