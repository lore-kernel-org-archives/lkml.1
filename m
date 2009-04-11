Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZDKAtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZDKAtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 20:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZDKAtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 20:49:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:54721 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZDKAtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 20:49:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,170,1239001200"; 
   d="scan'208";a="680645877"
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
 enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: David Woodhouse <dwmw2@infradead.org>
Cc: Kyle McMartin <kyle@redhat.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Andrew Lutomirski'" <amluto@gmail.com>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "'Yinghai Lu'" <yinghai@kernel.org>,
       "'Mark Gross'" <mgross@linux.intel.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>
In-Reply-To: <1239403571.712.1228.camel@macbook.infradead.org>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com>
	 <20090324203259.GC26930@elte.hu>
	 <A6AD88C3F2289247BE726C37303E1EB8A04DB530@orsmsx505.amr.corp.intel.com>
	 <20090324204028.GE11771@kibblesnbits.boston.devel.redhat.com>
	 <1239403571.712.1228.camel@macbook.infradead.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 10 Apr 2009 17:48:33 -0700
Message-Id: <1239410913.27006.8062.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 15:46 -0700, David Woodhouse wrote:
> On Tue, 2009-03-24 at 16:40 -0400, Kyle McMartin wrote:
> > > Current kernel doesn't have iommu suspend/resume support yet. I'll
> > > send out suspend/resume patches today or tomorrow. Hope that will
> > > help. 
> > 
> > Heh, awesome, someone could have brought this, uhm, subtle, weakness
> > when things were getting defaulted on...
> 
> git://git.infradead.org/~dwmw2/iommu-suspend-2.6.29.git
> 
> That's just for IOMMU, not interrupt remapping (yet).

Is this for 2.6.29-stable series? Is this really critical to have it for
-stable?

