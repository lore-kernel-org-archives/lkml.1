Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbYJDGKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbYJDGKd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 02:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYJDGKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 02:10:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYJDGKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 02:10:23 -0400
Subject: RE: [PATCH 2/2]Add Variable Page Size and IA64 Support in Intel
	IOMMU: IA64 Specific Part
From: David Woodhouse <dwmw2@infradead.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8844A6398@orsmsx505.amr.corp.intel.com>
References: <20081001165750.GA21272@linux-os.sc.intel.com>
	 <200810020951.08408.bjorn.helgaas@hp.com>
	 <A6AD88C3F2289247BE726C37303E1EB88408AA3E@orsmsx505.amr.corp.intel.com>
	 <200810030941.42800.bjorn.helgaas@hp.com>
	 <A6AD88C3F2289247BE726C37303E1EB8844A6398@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain
Date: Sat, 04 Oct 2008 07:09:57 +0100
Message-Id: <1223100597.30832.37.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 17:53 -0700, Yu, Fenghua wrote:
> >Architecturally, I'm surprised that ia64 would need to actually do a
> >cache flush.  I would think the VT-d hardware would do coherent
> accesses which would make the cache flush unnecessary.
> 
> VT-d hardware supports both non cache coherency and cache coherency by
> bit Coherency in Extended Capabilities Register.

But is the version without the cache coherency actually going to be
_seen_ on IA64?

> Could you please point me to the doc that explicitly says that
> architecturally ia64 doesn't need cache flush?

For safety, we can always make the driver just refuse to initialise on
IA64 if the cache coherency bit isn't set.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

