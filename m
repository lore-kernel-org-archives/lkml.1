Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbXGIViS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbXGIViS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbXGIViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:38:10 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:54630 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbXGIViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:38:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAB5HkkarR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,518,1175497200"; 
   d="scan'208"; a="501399880:sNHT402957376"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 08/13] IB/ehca: Lock renaming, static initializers
X-Message-Flag: Warning: May contain useful information
References: <200707091502.22407.fenkes@de.ibm.com>
	<200707091529.04073.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 09 Jul 2007 14:38:03 -0700
In-Reply-To: <200707091529.04073.fenkes@de.ibm.com> (Joachim Fenkes's message of "Mon, 9 Jul 2007 15:29:03 +0200")
Message-ID: <adavectw950.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jul 2007 21:38:04.0112 (UTC) FILETIME=[6E4F1D00:01C7C271]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > +DEFINE_SPINLOCK(hcall_lock);

This can be static.  (I fixed it up when I applied the patch)
