Return-Path: <linux-kernel-owner+w=401wt.eu-S1759423AbZC1Twt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423AbZC1Twt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbZC1TuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:50:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:42682 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbZC1TuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:50:09 -0400
Message-Id: <20090328194359.426029037@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 28 Mar 2009 20:43:59 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/9] perf_counter patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set fixes 2 problems I found while going over the perf_counter code.
 - the delayed wakeups were incomplete (and broken on x86)
 - update_userpage() wasn't used properly

It also adds tracking of the mmap() data so that we can profile userspace.

I also folded in Paulus' pending patches (I had to fix up a few conflict,
please double check).

Finally, the writable control page patch... still not convinced we need that.
-- 

