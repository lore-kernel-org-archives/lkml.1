Return-Path: <linux-kernel-owner+w=401wt.eu-S1767157AbXDERns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767157AbXDERns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 13:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767158AbXDERns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 13:43:48 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:12075 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767157AbXDERns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 13:43:48 -0400
Message-Id: <20070405174209.498059336@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Thu, 05 Apr 2007 19:42:09 +0200
From: root@programming.kicks-ass.net
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com
Subject: [PATCH 00/12] per device dirty throttling -v3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Against 2.6.21-rc5-mm4 without:
  per-backing_dev-dirty-and-writeback-page-accounting.patch

This series implements BDI independent dirty limits and congestion control.

This should solve several problems we currently have in this area:

 - mutual interference starvation (for any number of BDIs), and
 - deadlocks with stacked BDIs (loop and FUSE).

All the fancy new congestion code has been compile and boot tested, but
not much more. I'm posting to get feedback on the ideas.


