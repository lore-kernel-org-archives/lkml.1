Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbYA2VcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbYA2VcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYA2VcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:32:08 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:33597 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbYA2VcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:32:05 -0500
X-IronPort-AV: E=Sophos;i="4.25,271,1199692800"; 
   d="scan'208";a="10487459"
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Integration of SCST in the mainstream Linux kernel
X-Message-Flag: Warning: May contain useful information
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	<1201639331.3069.58.camel@localhost.localdomain>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 29 Jan 2008 13:31:52 -0800
In-Reply-To: <1201639331.3069.58.camel@localhost.localdomain> (James Bottomley's message of "Tue, 29 Jan 2008 15:42:11 -0500")
Message-ID: <adazluoe2t3.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Jan 2008 21:31:52.0929 (UTC) FILETIME=[5D561510:01C862BE]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > .                           .   STGT read     SCST read    .    STGT read      SCST read    .
 > .                           .  performance   performance   . performance    performance   .
 > .                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB, MB/s)   (1 MB, MB/s)  .
 > . iSER     (8 Gb/s network) .     250            N/A       .       360           N/A       .
 > . SRP      (8 Gb/s network) .     N/A            421       .       N/A           683       .

 > On the comparable figures, which only seem to be IPoIB they're showing a
 > 13-18% variance, aren't they?  Which isn't an incredible difference.

Maybe I'm all wet, but I think iSER vs. SRP should be roughly
comparable.  The exact formatting of various messages etc. is
different but the data path using RDMA is pretty much identical.  So
the big difference between STGT iSER and SCST SRP hints at some big
difference in the efficiency of the two implementations.

 - R.
