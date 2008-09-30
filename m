Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbYI3LLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbYI3LLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYI3LLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:11:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47146 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYI3LLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:11:31 -0400
Date: Tue, 30 Sep 2008 13:10:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Amit Shah <amit.shah@qumranet.com>,
       Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 6/9] x86/iommu: change Calgary to use dma_ops register
	interface
Message-ID: <20080930111028.GC12529@elte.hu>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <1222107681-8185-7-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222107681-8185-7-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2277]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> +static int calgary_device_supported(struct device *dev)
> +{
> +	struct iommu_table *tbl;
> +
> +	tbl = find_iommu_table(dev);
> +
> +	return translation_enabled(tbl);
> +}

i guess this could be written as a simple:

> +static int calgary_device_supported(struct device *dev)
> +{
> +	return translation_enabled(find_iommu_table(dev));
> +}

?

	Ingo
