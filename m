Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbYIIGvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbYIIGvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYIIGvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:51:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:11384 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbYIIGvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:51:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,363,1217833200"; 
   d="scan'208";a="614276151"
From: Sheng Yang <sheng.yang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       Andi Kleen <ak@linux.intel.com>, "\"H. Peter Anvin\"" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2] Extend "flags" to contain HW virtualization info
Date: Tue,  9 Sep 2008 14:54:52 +0800
Message-Id: <12209432941440-git-send-email-sheng.yang@intel.com>
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

Here is the update version of "virt flags" according to comments. Now I
extend the "flags" instead of new "virt flags" line, this also result in
NCAPINTS was extended to 9.

Still just implement Intel side. And I don't mean to tell apart from VMX and
SVM features in cpufeatures.h.

Thanks!

--
regards
Yang, Sheng
