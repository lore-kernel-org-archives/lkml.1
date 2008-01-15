Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYAOGFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYAOGFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 01:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYAOGFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 01:05:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:12184 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYAOGFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:05:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,285,1196668800"; 
   d="scan'208";a="289737881"
Subject: [PATCH -mm 0/2 -v2] kexec/i386: kexec page table code clean up
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Horman <horms@verge.net.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Jan 2008 14:05:42 +0800
Message-Id: <1200377142.3505.49.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 15 Jan 2008 06:05:29.0059 (UTC) FILETIME=[A0FC1B30:01C8573C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up page table setup code of kexec on i386.

This patchset is based on 2.6.24-rc5-mm1 and has been tested on i386
with/without PAE enabled.


v2:

- Rename some function names, such as alloc_page_tables ->
  machine_kexec_alloc_page_tables, etc.

- Cleanup error processing for machine_alloc_page_tables.


Best Regards,
Huang Ying

