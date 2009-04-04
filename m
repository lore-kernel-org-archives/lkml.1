Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbZDDJHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbZDDJHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 05:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZDDJHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 05:07:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:60964 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbZDDJHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 05:07:42 -0400
Subject: RE: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
From: David Woodhouse <dwmw2@infradead.org>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'IOMMU'" <iommu@lists.linux-foundation.org>,
       "'LKML'" <linux-kernel@vger.kernel.org>
In-Reply-To: <715D42877B251141A38726ABF5CABF2C01A2F7C440@pdsmsx503.ccr.corp.intel.com>
References: <715D42877B251141A38726ABF5CABF2C01A2F7C3A7@pdsmsx503.ccr.corp.intel.com>
	 <1238781474.27006.7866.camel@localhost.localdomain>
	 <715D42877B251141A38726ABF5CABF2C01A2F7C435@pdsmsx503.ccr.corp.intel.com>
	 <1238833738.3560.14.camel@macbook.infradead.org>
	 <715D42877B251141A38726ABF5CABF2C01A2F7C440@pdsmsx503.ccr.corp.intel.com>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 10:07:20 +0100
Message-Id: <1238836040.3560.17.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-04 at 16:48 +0800, Han, Weidong wrote:
> On linux head, I cannot find EIM_32BIT_APIC_ID in apic.c. I suspect
> iommu-2.6.git doesn't sync up with linux head on apic.c. I also fixed
> a bug which causes system hang due to queue invalidation is disabled
> when enable interrupt remapping. I will resend the patches. Do you
> want patches based on linux head or your iommu-2.6.git? BTW, I pull
> iommu-2.6.git very slow due to office proxy. But I can do it if you
> want. 

The conflict is with Fenghua's suspend/resume patches: 
http://git.infradead.org/iommu-2.6.git?a=commitdiff;h=b24696bc5

A simpler build fix is just to move the definitions of  EIM_8BIT_APIC_ID
and  EIM_32BIT_APIC_ID  outside #ifdef CONFIG_X86_X2APIC. I'll try that
and see if it boots.

-- 
dwmw2

