Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbXGIVfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbXGIVfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXGIVfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:35:40 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:21317 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbXGIVfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:35:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAB5HkkarR7MV/2dsb2JhbACQYw
X-IronPort-AV: i="4.16,518,1175497200"; 
   d="scan'208"; a="501398947:sNHT27104972"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 06/13] IB/ehca: Set SEND_GRH flag for all non-LL UD QPs on eHCA2
X-Message-Flag: Warning: May contain useful information
References: <200707091502.22407.fenkes@de.ibm.com>
	<200707091527.14272.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 09 Jul 2007 14:35:31 -0700
In-Reply-To: <200707091527.14272.fenkes@de.ibm.com> (Joachim Fenkes's message of "Mon, 9 Jul 2007 15:27:13 +0200")
Message-ID: <adazm25w998.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jul 2007 21:35:32.0068 (UTC) FILETIME=[13AF0A40:01C7C271]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Out of curiousity, does this mean that a GRH will be sent on all UD
messages (for non-LL QPs)?

What decides if a QP is LL or not?

 - R.
