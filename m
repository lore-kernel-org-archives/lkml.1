Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZKLXM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZKLXM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbZKLXMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:12:22 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:39670 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382AbZKLXMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:12:22 -0500
X-Trace: 285946208/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUBAIcl/EpPRTgw/2dsb2JhbAAIkEUBxS6EPAQ
X-IronPort-AV: E=Sophos;i="4.44,731,1249254000"; 
   d="scan'208";a="285946208"
Date: Thu, 12 Nov 2009 23:12:17 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/6] ksm: not quite swapping yet
Message-ID: <Pine.LNX.4.64.0911122303450.3378@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a series of six KSM patches against 2.6.32-rc5-mm1, plus the six
earlier "mm: prepare for ksm swapping" patches (and the ksm cond_resched
patch in 2.6.32-rc6-git).

These are all internal housekeeping changes to ksm.c, to minimize the
actual, functional KSM-page swapping patches, coming in a few days.

 include/linux/ksm.h |   24 +
 mm/ksm.c            |  540 +++++++++++++++++++-----------------------
 2 files changed, 266 insertions(+), 298 deletions(-)

Hugh
