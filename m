Return-Path: <linux-kernel-owner+w=401wt.eu-S1763363AbYEFFtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763363AbYEFFtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757947AbYEFFtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:49:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:12399 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762879AbYEFFtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:49:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,441,1204531200"; 
   d="scan'208";a="324904430"
Subject: AIM7 40% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 06 May 2008 13:48:24 +0800
Message-Id: <1210052904.3453.30.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with kernel 2.6.25, ﻿AIM7 (use tmpfs) has ﻿more than 40% with 2.6.26-rc1
on my 8-core stoakley, 16-core tigerton, and Itanium Montecito. Bisect located
below patch.

64ac24e738823161693bf791f87adc802cf529ff is first bad commit
commit 64ac24e738823161693bf791f87adc802cf529ff
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Fri Mar 7 21:55:58 2008 -0500

    Generic semaphore implementation


After I manually reverted the patch against 2.6.26-rc1 while fixing lots of
conflictions/errors, aim7 regression became less than 2%.

-yanmin


