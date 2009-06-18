Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZFRSf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZFRSf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbZFRSfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:35:51 -0400
Received: from sous-sol.org ([216.99.217.87]:49125 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbZFRSfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:35:50 -0400
Date: Thu, 18 Jun 2009 11:34:05 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "'Chris Wright'" <chrisw@sous-sol.org>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       "'iommu'" <iommu@lists.linux-foundation.org>,
       "'lkml'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] IOMMU Identity Mapping Support:
	iommu_identity_mapping definition
Message-ID: <20090618183405.GC19771@sequoia.sous-sol.org>
References: <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <1240135508.3589.75.camel@macbook.infradead.org> <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com> <20090513231351.GA22386@linux-os.sc.intel.com> <1242314271.3393.11.camel@macbook.infradead.org> <20090514175944.GA5168@linux-os.sc.intel.com> <20090618180514.GA24082@linux-os.sc.intel.com> <20090618181335.GB19771@sequoia.sous-sol.org> <A6AD88C3F2289247BE726C37303E1EB8B0044F04@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B0044F04@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yu, Fenghua (fenghua.yu@intel.com) wrote:
> >>
> >> The first patch defines iommu_identity_mapping varialbe which controls
> >the
> >> identity mapping code and is 0 by default.
> >
> >The only real difference between "pt" and "identity" is hardware support.
> >We should have a single value we don't have to tell users to do different
> >things depending on their hardware (they won't even know what they have)
> >to achieve the same result.
> 
> Technically keeping two separate options in base kernel might be clear and easy to understand. A distro might merge them together or have other usage model.

This pushes burden to distros and users for no obvious gain.  Just like
queued invalidation vs. register based invalidation...it's a hardware
detail that users don't really care that much about, they just care
about user visible functionality.

thanks,
-chris
