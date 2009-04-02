Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbZDBJNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbZDBJNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760294AbZDBJMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:12:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59145 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbZDBJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:12:51 -0400
Message-Id: <20090402091158.291810516@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 11:11:58 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/6] more perf_counter stuff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set implements some features requested by Paul/Corey.
The main one being the singleshot thing, which is still RFC due to
being incomplete.

It really needs a mechanism to run bits in a regular context ASAP
after the event context. My faviourite is a self-IPI, because one can
issue it from NMI context, or IRQ-disabled rq->lock context and have
it work as expected.

I'll look at doing a x86 self-IPI.


