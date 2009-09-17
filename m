Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZIQPDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZIQPDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZIQPDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:03:24 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50059 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZIQPDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:03:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAITssUqrR7MV/2dsb2JhbADGYohOAZA4BYQY
X-IronPort-AV: E=Sophos;i="4.44,404,1249257600"; 
   d="scan'208";a="390685556"
From: Roland Dreier <rdreier@cisco.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	<adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com>
	<1253198976.14935.27.camel@laptop>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 17 Sep 2009 08:03:25 -0700
In-Reply-To: <1253198976.14935.27.camel@laptop> (Peter Zijlstra's message of
	"Thu, 17 Sep 2009 16:49:36 +0200")
Message-ID: <adazl8td35u.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Sep 2009 15:03:25.0695 (UTC) FILETIME=[01C128F0:01CA37A8]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Hmm, or are you saying you can only get 1 event per registered range and
 > allocate the thing on registration? That'd need some registration limit
 > to avoid DoS scenarios.

Yes, that's what I do.  You're right, I should add a limit... although
their are lots of ways for userspace to consume arbitrary amounts of
kernel resources already.

 - R.
