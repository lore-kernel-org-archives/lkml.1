Return-Path: <linux-kernel-owner+w=401wt.eu-S932632AbYBMJdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbYBMJdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYBMJdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:33:24 -0500
Received: from mga05.intel.com ([192.55.52.89]:20101 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752119AbYBMJdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:33:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,345,1199692800"; 
   d="scan'208";a="517740193"
Subject: 2.6.25-rc1: volanoMark 45% regression
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: vatsa@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=utf-8
Date: Wed, 13 Feb 2008 17:30:28 +0800
Message-Id: <1202895028.3027.27.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

volanoMark has 45% regression with kernel 2.6.25-rc1 on my both 8-core
stoakley and 16-core Tigerton.

I used bisect to locate below patch.

commit 58e2d4ca581167c2a079f4ee02be2f0bc52e8729
Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Date:   Fri Jan 25 21:08:00 2008 +0100

    sched: group scheduling, change how cpu load is calculated



hackbench has about 30% regression on 16-core tigerton, but has about 10% improvement
on 8-core stoakley.

In addition, tbench has about 6% regression on my 8-core stoakley and
25% regression on 16-core stoakley. Some other benchmarks, like netperf/aim7
also have some regression. I will verify if they are all related to the
patch.

-yanmin


