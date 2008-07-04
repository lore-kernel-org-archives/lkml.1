Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbYGDJwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYGDJwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 05:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYGDJwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 05:52:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55474 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYGDJwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 05:52:45 -0400
Date: Fri, 4 Jul 2008 11:52:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0/6] AMD IOMMU updates
Message-ID: <20080704095213.GB22658@elte.hu>
References: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi,
> 
> this series of patches contain some updates to the AMD IOMMU code 
> currently in tip/master. The updates address some objections discussed 
> on the initial patches and also contain optimization and small code 
> cleanup. The code with these updates is tested on real hardware under 
> load and showed no problems.

applied to tip/x86/amd-iommu and pushed that topic out, thanks Joerg.

also, i've integrated it into tip/master as well (will push that out
after some testing).

The IOMMU driver code seems to be getting into good shape, so i've also 
added the topic to auto-x86-next, which means it will go into linux-next 
on the next iteration (in 1-2 days). Does anyone see any remaining 
problems?

	Ingo
