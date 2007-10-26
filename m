Return-Path: <linux-kernel-owner+w=401wt.eu-S1763035AbXJZJpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763035AbXJZJpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762731AbXJZJoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:44:22 -0400
Received: from mga05.intel.com ([192.55.52.89]:45757 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756562AbXJZJoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:44:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,332,1188802800"; 
   d="scan'208";a="358992178"
Subject: aim7 -30% regression in 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: mingo@elte.hu
Content-Type: text/plain; charset=utf-8
Date: Fri, 26 Oct 2007 17:43:07 +0800
Message-Id: <1193391787.3019.174.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I tested 2.6.24-rc1 on my x86_64 machine which has 2 quad-core processors.

Comparing with 2.6.23, aim7 has about -30% regression. I did a bisect and found
patch http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b5869ce7f68b233ceb81465a7644be0d9a5f3dbb
caused the issue.

kbuild/SPECjbb2000/SPECjbb2005 also has big regressions. On my another
tigerton machine (4 quad-core processors), SPECjbb2005 has more than -40%
regression. I didn't do a bisect on such benchmark testing, but I suspect
the root cause is like aim7's.

-yanmin

