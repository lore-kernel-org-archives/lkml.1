Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbYGZNqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbYGZNqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYGZNoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:44:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53633 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956AbYGZNop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:44:45 -0400
Date: Sat, 26 Jul 2008 15:44:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com
Subject: Re: [PATCH 0/3] IOMMU: move page number calculation to generic code
Message-ID: <20080726134427.GD4401@elte.hu>
References: <1216990680-1227-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216990680-1227-1-git-send-email-joerg.roedel@amd.com>
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

> This small patch series introduces a generic iommu_num_pages function 
> into the IOMMU helper code. This function can be used to calculate the 
> number of pages an IOMMU has to map for a specific mapping request.
> 
> The patchset converts the x86 IOMMU implementations for AMD IOMMU and 
> the GART to use this function.

applied to tip/x86/iommu - thanks Joerg.

> Other IOMMU implementations are not changed because I can't test them.

if it's straightforward and expected to work with a high likelyhood then 
please do it nevertheless. As long as it's finegrained patches we ought 
to be able to filter out broken changes.

	Ingo
