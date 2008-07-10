Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYGJXod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYGJXod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYGJXoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:44:24 -0400
Received: from mga10.intel.com ([192.55.52.92]:43762 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751052AbYGJXoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:44:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,341,1212390000"; 
   d="scan'208";a="589692007"
Date: Thu, 10 Jul 2008 19:37:33 -0400
From: Yong Wang <yong.y.wang@linux.intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
       andi@firstfloor.org, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 26/26] x64, x2apic/intr-remap: introduce
	CONFIG_INTR_REMAP
Message-ID: <20080710233733.GA21085@ywang-dev>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710182239.635284000@linux-os.sc.intel.com> <m1r6a1fhc8.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6a1fhc8.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is it possible to run in x2apic mode without running in interrupt remapping mode?
> Just send the irqs directly to the cpu?  It feels like it should be if an iommu
> doesn't get in the way.
> 

Yes, it is possible to run in x2apic mode without intr-remap. However, the extended
cpu addressability will not be fully utilized that way.
