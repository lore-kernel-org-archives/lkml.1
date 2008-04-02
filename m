Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYDBORe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYDBORe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYDBOR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:17:27 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57117 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbYDBOR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:17:26 -0400
Subject: [PATCH 0/3] hugetlbfs: cleanup and new primitives for s390
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 16:17:23 +0200
Message-Id: <1207145843.4980.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 15:31 -0700, Andrew Morton wrote: 
> > As there were no objections so far, which would be the right tree for
> > this to get it upstream?
> 
> -mm, I suppose.
> 
> But all the patcehs had the same title and I'd prefer to not have to
> invent your patch titles for you.

This patchset cleans up hugetlbfs architecture headers and adds new
primitives as preparation for the s390 large page support. Most notably
we found that we need to add a new tlb flush for the copy-on-write of
a large page (patch #2). We think that this is a bug, but obviously one
that hasn't shown up so far on any of the other large page architectures.

--
Gerald Schaefer


