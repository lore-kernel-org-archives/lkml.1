Return-Path: <linux-kernel-owner+w=401wt.eu-S935273AbZDCR7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935273AbZDCR7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbZDCR6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:58:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:28795 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbZDCR6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:58:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,320,1235980800"; 
   d="scan'208";a="400154125"
Subject: Re: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: "Han, Weidong" <weidong.han@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       IOMMU <iommu@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <715D42877B251141A38726ABF5CABF2C01A2F7C3A7@pdsmsx503.ccr.corp.intel.com>
References: <715D42877B251141A38726ABF5CABF2C01A2F7C3A7@pdsmsx503.ccr.corp.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 03 Apr 2009 09:57:54 -0800
Message-Id: <1238781474.27006.7866.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 02:15 -0700, Han, Weidong wrote:
>  
> -#ifdef CONFIG_INTR_REMAP
> +#ifdef CONFIG_X86_X2APIC

Weidong, Can we also fix these config options?

Today, selecting CONFIG_INTR_REMAP automatically selects
CONFIG_X86_X2APIC. It should be the other way round.

i.e., turning on CONFIG_X86_X2APIC should automatically enable
CONFIG_INTR_REMAP and just enabling CONFIG_INTR_REMAP shouldn't enable
CONFIG_X86_X2APIC.

Also please make sure that the code compiles (and works :)) in different
combinations of these config settings.

thanks,
suresh

