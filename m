Return-Path: <linux-kernel-owner+w=401wt.eu-S936401AbZDCSJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936401AbZDCSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936358AbZDCSI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:08:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:46063 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936354AbZDCSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:08:59 -0400
Subject: Re: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
From: David Woodhouse <dwmw2@infradead.org>
To: suresh.b.siddha@intel.com
Cc: "Han, Weidong" <weidong.han@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       IOMMU <iommu@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1238781474.27006.7866.camel@localhost.localdomain>
References: <715D42877B251141A38726ABF5CABF2C01A2F7C3A7@pdsmsx503.ccr.corp.intel.com>
	 <1238781474.27006.7866.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 19:08:51 +0100
Message-Id: <1238782131.3494.66.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 09:57 -0800, Suresh Siddha wrote:
> On Fri, 2009-04-03 at 02:15 -0700, Han, Weidong wrote:
> >  
> > -#ifdef CONFIG_INTR_REMAP
> > +#ifdef CONFIG_X86_X2APIC
> 
> Weidong, Can we also fix these config options?
> 
> Today, selecting CONFIG_INTR_REMAP automatically selects
> CONFIG_X86_X2APIC. It should be the other way round.
> 
> i.e., turning on CONFIG_X86_X2APIC should automatically enable
> CONFIG_INTR_REMAP and just enabling CONFIG_INTR_REMAP shouldn't enable
> CONFIG_X86_X2APIC.
> 
> Also please make sure that the code compiles (and works :)) in different
> combinations of these config settings.

Which should SGI Ultraviolet be selecting?

-- 
dwmw2

