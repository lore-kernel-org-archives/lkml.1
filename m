Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbZHCMIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbZHCMIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbZHCMIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:08:34 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:9565 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693AbZHCMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:08:33 -0400
X-Trace: 237200519/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.63.67/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.63.67
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8GAMJvdkpPRT9D/2dsb2JhbACBUo4EAcAOhBgFgjE
X-IronPort-AV: E=Sophos;i="4.43,314,1246834800"; 
   d="scan'208";a="237200519"
Date: Mon, 3 Aug 2009 13:08:23 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 0/12] ksm: stats, oom, doc, misc
Message-ID: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Izik,

Here's a set of twelve patches, which I think complete what I want
to do with KSM for current mmotm and 2.6.32: it's as I sent you in
a rollup last week, but with 1/12 and 10/12 added.  Patches apply
to 2.6.31-rc5 plus our previous ten KSM patches, or to mmotm which
already includes those.

[PATCH  1/12] ksm: rename kernel_pages_allocated
[PATCH  2/12] ksm: move pages_sharing updates
[PATCH  3/12] ksm: pages_unshared and pages_volatile
[PATCH  4/12] ksm: break cow once unshared
[PATCH  5/12] ksm: keep quiet while list empty
[PATCH  6/12] ksm: five little cleanups
[PATCH  7/12] ksm: fix endless loop on oom
[PATCH  8/12] ksm: distribute remove_mm_from_lists
[PATCH  9/12] ksm: fix oom deadlock
[PATCH 10/12] ksm: sysfs and defaults
[PATCH 11/12] ksm: add some documentation
[PATCH 12/12] ksm: remove VM_MERGEABLE_FLAGS

 Documentation/vm/00-INDEX |    2 
 Documentation/vm/ksm.txt  |   89 +++++
 include/linux/ksm.h       |   31 +
 kernel/fork.c             |    1 
 mm/Kconfig                |    1 
 mm/ksm.c                  |  574 ++++++++++++++++++++++--------------
 mm/memory.c               |    5 
 mm/mmap.c                 |   15 
 8 files changed, 498 insertions(+), 220 deletions(-)

If you and others are happy with these, please send them on to Andrew
(or else just point him to them); if not, then let's fix them first.

Thanks,
Hugh
