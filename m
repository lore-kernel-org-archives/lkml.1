Return-Path: <linux-kernel-owner+w=401wt.eu-S1757761AbYC1Cxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbYC1Cxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYC1Cxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:53:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:48715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbYC1Cxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:53:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,567,1199692800"; 
   d="scan'208";a="224191971"
Subject: [PATCH 0/4] x86_64 boot -v2: Add linked listof struct setup_data
	to boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Mar 2008 10:49:38 +0800
Message-Id: <1206672578.13404.21.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 28 Mar 2008 02:46:36.0754 (UTC) FILETIME=[F0EE9B20:01C8907D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the linked list of struct setup_data to boot
protocol. This is needed by EDD information and some SGI machine with
E820 entry number > 128.

Now, only the x86_64 is supported. The i386 can be supported after early
reservation mechanism for x86 is available.

This patchset is based x86.git latest branch and has been tested on
Intel x86_64 machine.

v2:

- Rebased on x86.git latest branch


Best Regards,
Huang Ying

