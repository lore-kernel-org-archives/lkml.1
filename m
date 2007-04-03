Return-Path: <linux-kernel-owner+w=401wt.eu-S1030285AbXDCOqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030285AbXDCOqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030293AbXDCOqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:46:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030285AbXDCOqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:46:36 -0400
Message-Id: <20070403144047.073283598@taijtu.programming.kicks-ass.net>
User-Agent: quilt/0.46-1
Date: Tue, 03 Apr 2007 16:40:47 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl
Subject: [PATCH 0/6] per device dirty throttling -V2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

A new version of the per BDI dirty page throttle patches.

This is against 2.6.21-rc5-mm4 with:

 per-backing_dev-dirty-and-writeback-page-accounting.patch

reverted.

These patches should solve several problem we current have in this area,
namely:

 - mutual interference starvation (for any number of BDIs), and
 - deadlocks with stacked BDIs (loop and FUSE).

Dave, would you mind testing if the XFS umount problem is still present?
I could not reproduce it with this code.

