Return-Path: <linux-kernel-owner+w=401wt.eu-S1765694AbXGKRhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765694AbXGKRhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbXGKRgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:36:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:25133 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019AbXGKRgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:36:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,527,1175497200"; 
   d="scan'208";a="249180258"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Date: Wed, 11 Jul 2007 10:33:19 -0700
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de>
In-Reply-To: <p734pkbyuu4.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111033.20465.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > i386-trim-memory-not-covered-by-wb-mtrrs.patch
>
> Might need more testing?

For the mtrr trim patch at least, I think the coverage we've received 
in -mm is probably sufficient (the failure mode would be fairly 
obvious).  The only thing I'm nervous about is adding AMD support for 
the quirk, since I don't have any way of testing it.  We can easily add 
that later though, if a tester steps forward or we see demand for it 
(should just be an extra conditional in the trim code).

Thanks,
Jesse
