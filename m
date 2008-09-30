Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbYI3Pjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbYI3Pjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYI3Pjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:39:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43770 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbYI3Pj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:39:29 -0400
Date: Tue, 30 Sep 2008 17:38:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 6/9] x86/iommu: change Calgary to use dma_ops register
	interface
Message-ID: <20080930153815.GA22693@elte.hu>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <1222107681-8185-7-git-send-email-joerg.roedel@amd.com> <20080930111028.GC12529@elte.hu> <20080930133024.GA20341@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930133024.GA20341@il.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> > > +static int calgary_device_supported(struct device *dev)
> > > +{
> > > +	return translation_enabled(find_iommu_table(dev));
> > > +}
> 
> Sure, but I prefer the explicit form since it lends itself to easier
> debugging (oops line numbers, adding printks, etc.).

we never do that for simple stuff like this. The kernel would be twice 
as large if we did. An oops is easy enough to decode and an oops does 
not come with a line number.

	Ingo
