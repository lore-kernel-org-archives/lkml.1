Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYC0HGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYC0HGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 03:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYC0HGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 03:06:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:58259 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbYC0HGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 03:06:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,562,1199692800"; 
   d="scan'208";a="265272517"
Subject: [PATCH -mm 0/4] x86_64 boot: Add linked listof struct setup_data
	to boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Mar 2008 15:09:03 +0800
Message-Id: <1206601743.3067.20.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 27 Mar 2008 07:06:02.0626 (UTC) FILETIME=[04806E20:01C88FD9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the linked list of struct setup_data to boot
protocol. This is needed by EDD information and some SGI machine with
E820 entry number > 128.

Now, only the x86_64 is supported. The i386 can be supported after early
reservation mechanism for x86 is available.

This patchset is based on 2.6.25-rc5-mm1 and has been tested on Intel
x86_64 machine.

Best Regards,
Huang Ying

