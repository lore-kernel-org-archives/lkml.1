Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXITQ33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXITQ33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbXITQ3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:29:21 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:23851 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbXITQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:29:20 -0400
X-IronPort-AV: E=Sophos;i="4.20,279,1186383600"; 
   d="scan'208";a="526220346"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 3/3] IB/ehca: Make sure user pages are from hugetlb before using MR large pages
X-Message-Flag: Warning: May contain useful information
References: <200709131814.13937.fenkes@de.ibm.com>
	<200709131816.21162.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 20 Sep 2007 09:29:12 -0700
In-Reply-To: <200709131816.21162.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 13 Sep 2007 18:16:20 +0200")
Message-ID: <ada6425gv1j.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Sep 2007 16:29:13.0074 (UTC) FILETIME=[611ADD20:01C7FBA3]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied this and the umem patch...
