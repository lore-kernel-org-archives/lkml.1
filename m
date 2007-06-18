Return-Path: <linux-kernel-owner+w=401wt.eu-S933162AbXFRXIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbXFRXIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764548AbXFRXIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:08:19 -0400
Received: from mga05.intel.com ([192.55.52.89]:25452 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763117AbXFRXIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,436,1175497200"; 
   d="scan'208";a="258390063"
Subject: Change in default vm_dirty_ratio
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Intel
Date: Mon, 18 Jun 2007 14:14:30 -0700
Message-Id: <1182201271.4883.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

The default vm_dirty_ratio changed from 40 to 10
for the 2.6.22-rc kernels in this patch:
 
http://git.kernel.org/?
p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=07db59bd6b0f279c31044cba6787344f63be87ea;hp=de46c33745f5e2ad594c72f2cf5f490861b16ce1

IOZone write drops by about 60% when test file size is 50 percent of
memory.  Rand-write drops by 90%. 

Is there a good reason for turning down the default dirty ratio?
How will it help for most cases?  Intuitively, it seems like 
a less aggressive writeback will have better performance.

Thanks.

Tim
