Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZDJWq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZDJWq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZDJWqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:46:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZDJWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:46:47 -0400
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
 enabled
From: David Woodhouse <dwmw2@infradead.org>
To: Kyle McMartin <kyle@redhat.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'Andrew Lutomirski'" <amluto@gmail.com>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'Yinghai Lu'" <yinghai@kernel.org>,
       "'Mark Gross'" <mgross@linux.intel.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090324204028.GE11771@kibblesnbits.boston.devel.redhat.com>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com>
	 <20090324203259.GC26930@elte.hu>
	 <A6AD88C3F2289247BE726C37303E1EB8A04DB530@orsmsx505.amr.corp.intel.com>
	 <20090324204028.GE11771@kibblesnbits.boston.devel.redhat.com>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 15:46:11 -0700
Message-Id: <1239403571.712.1228.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 16:40 -0400, Kyle McMartin wrote:
> > Current kernel doesn't have iommu suspend/resume support yet. I'll
> > send out suspend/resume patches today or tomorrow. Hope that will
> > help. 
> 
> Heh, awesome, someone could have brought this, uhm, subtle, weakness
> when things were getting defaulted on...

git://git.infradead.org/~dwmw2/iommu-suspend-2.6.29.git

That's just for IOMMU, not interrupt remapping (yet).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

