Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYI0STU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYI0STU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYI0STM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:19:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbYI0STK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:19:10 -0400
Date: Sat, 27 Sep 2008 20:18:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 3/3] x86/iommu: use __GFP_ZERO instead of memset for
	GART
Message-ID: <20080927181855.GA11147@elte.hu>
References: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com> <1222337635-28285-4-git-send-email-joerg.roedel@amd.com> <20080925102012.GA13631@elte.hu> <20080925104212.GA27928@amd.com> <20080927181438.GF1108@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080927181438.GF1108@elte.hu>
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


another thing:

How hard would it be to add an CONFIG_IOMMU_DEBUG option that forces as 
many DMA requests to go via the IOMMU as possible?

This slows things down of course so it's only for debugging - but it 
also makes sure that we utilize the IOMMU code to the maximum - which is 
not normally the case.

Would be nice to have it .config driven (default-disabled), so that 
-tip's randconfig testing can stumble upon it every now and then. I've 
got GART test-systems - this way we could find certain types of IOMMU 
breakages sooner.

	Ingo
