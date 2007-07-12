Return-Path: <linux-kernel-owner+w=401wt.eu-S934924AbXGLRPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934924AbXGLRPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 13:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbXGLRPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 13:15:31 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:56340 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbXGLRPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 13:15:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALD+lUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,533,1175497200"; 
   d="scan'208"; a="166550307:sNHT26726427"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 00/10] IB/ehca: Multiple Event Queues, MR/MW rework, large page MRs, fixes
X-Message-Flag: Warning: May contain useful information
References: <200707121745.27592.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 12 Jul 2007 10:15:24 -0700
In-Reply-To: <200707121745.27592.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 12 Jul 2007 17:45:26 +0200")
Message-ID: <adawsx55ys3.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jul 2007 17:15:25.0598 (UTC) FILETIME=[3CBDF3E0:01C7C4A8]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Note that patch 7 will introduce a few lines over 80 chars that will be
 > unindented in patch 8 - I hope that's okay with you.

That's fine -- the 80 column rule is one thing I don't worry about too
much; absurdly long lines are bad, but if a line is, say, 84 chars and
breaking it makes the code uglier, then I just leave the 84 char line.

 > [09/10] fixes a lot of checkpatch.pl warnings

Are these warnings from earlier patches in the series, or problems
that already existed in the code?  If they are coming from other
patches in the series, please just fix the earlier patches before I
merge them.

Thanks,
  Roland
