Return-Path: <linux-kernel-owner+w=401wt.eu-S1763495AbYF3Shp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763495AbYF3Shp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYF3ShH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:37:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60853 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbYF3ShF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:37:05 -0400
Date: Mon, 30 Jun 2008 20:35:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] AMD IOMMU: disable suspend/resume with IOMMU enabled
	(for now)
Message-ID: <20080630183550.GE32211@elte.hu>
References: <1214849882-18550-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214849882-18550-1-git-send-email-joerg.roedel@amd.com>
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

> This patch disables suspend/resume on machines with AMD IOMMU enabled. 
> Real suspend/resume support for AMD IOMMU is currently being worked 
> on. Until this is ready it will be disabled to avoid data corruption 
> when the IOMMU is not properly re-enabled at resume. The patch is 
> based on a similar patch for the GART driver written by Pavel Machek. 
> The overall driver merged into tip/master is tested with parallel disk 
> and network loads and showed no problems in a test running for 3 days.

applied to tip/x86/amd-iommu, thanks Joerg.

	Ingo
