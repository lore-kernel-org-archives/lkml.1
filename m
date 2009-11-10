Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbZKJVuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbZKJVuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758306AbZKJVuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:50:07 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:8718 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758288AbZKJVuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:50:06 -0500
X-Trace: 287951003/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.44.180/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.44.180
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMHABNv+UpPRSy0/2dsb2JhbACBTo52Ac47hD4E
X-IronPort-AV: E=Sophos;i="4.44,718,1249254000"; 
   d="scan'208";a="287951003"
Date: Tue, 10 Nov 2009 21:50:06 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/6] mm: prepare for ksm swapping
Message-ID: <Pine.LNX.4.64.0911102142570.2272@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a series of six miscellaneous mm patches against 2.6.32-rc5-mm1,
intended to follow my earlier swap_info patches, or slot in just before
mmend in the mmotm series.

Apart from the sixth, they have some relevance to the KSM-page swapping
patches, following after a few days.  They clear away some mm cruft,
to let that series concentrate on ksm.c; but should stand on their own.

 include/linux/ksm.h        |    5 -
 include/linux/mm.h         |   17 +++
 include/linux/page-flags.h |    8 -
 include/linux/rmap.h       |    8 +
 mm/Kconfig                 |   14 --
 mm/internal.h              |   26 ++---
 mm/memory-failure.c        |    2 
 mm/memory.c                |    4 
 mm/migrate.c               |   11 --
 mm/mlock.c                 |    2 
 mm/page_alloc.c            |    4 
 mm/rmap.c                  |  174 +++++++++++------------------------
 mm/swapfile.c              |    2 
 13 files changed, 110 insertions(+), 167 deletions(-)

Hugh
