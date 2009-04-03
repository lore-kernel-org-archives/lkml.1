Return-Path: <linux-kernel-owner+w=401wt.eu-S936465AbZDCSLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936465AbZDCSLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935328AbZDCSLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:11:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:28079 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935184AbZDCSLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:11:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,320,1235980800"; 
   d="scan'208";a="400158947"
Subject: Re: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Han, Weidong" <weidong.han@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       IOMMU <iommu@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1238782131.3494.66.camel@macbook.infradead.org>
References: <715D42877B251141A38726ABF5CABF2C01A2F7C3A7@pdsmsx503.ccr.corp.intel.com>
	 <1238781474.27006.7866.camel@localhost.localdomain>
	 <1238782131.3494.66.camel@macbook.infradead.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 03 Apr 2009 10:10:35 -0800
Message-Id: <1238782235.27006.7868.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 11:08 -0700, David Woodhouse wrote:
> On Fri, 2009-04-03 at 09:57 -0800, Suresh Siddha wrote:
> > On Fri, 2009-04-03 at 02:15 -0700, Han, Weidong wrote:
> > >  
> > > -#ifdef CONFIG_INTR_REMAP
> > > +#ifdef CONFIG_X86_X2APIC
> > 
> > Weidong, Can we also fix these config options?
> > 
> > Today, selecting CONFIG_INTR_REMAP automatically selects
> > CONFIG_X86_X2APIC. It should be the other way round.
> > 
> > i.e., turning on CONFIG_X86_X2APIC should automatically enable
> > CONFIG_INTR_REMAP and just enabling CONFIG_INTR_REMAP shouldn't enable
> > CONFIG_X86_X2APIC.
> > 
> > Also please make sure that the code compiles (and works :)) in different
> > combinations of these config settings.
> 
> Which should SGI Ultraviolet be selecting?

Both X2APIC and INTR_REMAP. They already select X2APIC today. With above
change, they automatically get INTR_REMAP too.

