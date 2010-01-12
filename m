Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159Ab0ALVJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0ALVJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 16:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326Ab0ALVJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 16:09:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:32983 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0ALVJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 16:09:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,264,1262592000"; 
   d="scan'208";a="530677441"
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <4B4CE35D.4040801@zytor.com>
References: <20100109101038.GA17555@in.ibm.com>
	 <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
	 <20100110023015.GA2253@in.ibm.com>
	 <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>
	 <20100110102638.GA7838@elte.hu>
	 <86802c441001111343p2afaafb7o702884e632260bf7@mail.gmail.com>
	 <1263246829.2859.537.camel@sbs-t61.sc.intel.com>
	 <86802c441001121110u2f3dcfbpafb0d9c4bb6a4e4d@mail.gmail.com>
	 <1263327630.2854.448.camel@sbs-t61.sc.intel.com>
	 <4B4CE35D.4040801@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 12 Jan 2010 13:07:54 -0800
Message-Id: <1263330474.2854.548.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 13:02 -0800, H. Peter Anvin wrote:
> On 01/12/2010 12:20 PM, Suresh Siddha wrote:
> > On Tue, 2010-01-12 at 11:10 -0800, Yinghai Lu wrote:
> >> if the system can not use logical flat.
> >>
> >> should have some bit set in FADT...
> > 
> > Yinghai, Sorry. I am not sure what you are referring to here. I have
> > mentioned about FADT in another thread, so not sure what you mean by
> > this here.
> > 
> > Are you referring that bios for the IBM system can use this to fix their
> > problem? Once we understand what the problem is with IBM platform, then
> > we can propose a solution (using FADT perhaps) that is acceptable to
> > everyone.
> > 
> 
> Does the IBM platform set this bit in FADT?

No. If they had set it, kernel would have used physical mode and
wouldn't have seen this issue.

