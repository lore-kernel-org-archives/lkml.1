Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0CCRzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:55:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:58104 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab0CCRzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:55:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,574,1262592000"; 
   d="scan'208";a="250432232"
Subject: Re: [patch 2/2] x86: Manage ENERGY_PERF_BIAS based on cpufreq
 governor
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20100303164007.GA31365@srcf.ucam.org>
References: <20100303000649.757684000@intel.com>
	 <20100303000849.278509000@intel.com> <20100303164007.GA31365@srcf.ucam.org>
Content-Type: text/plain
Date: Wed, 03 Mar 2010 09:55:38 -0800
Message-Id: <1267638938.16916.957.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 08:40 -0800, Matthew Garrett wrote:
> Have you done any measurements with this bit being set dynamically by 
> ondemand depending on the target frequency?
> 

The not so good part about this feature is that its setting is opaque.
Different CPUs can use this value for different optimizations. So, in
future we may have to change the value of this MSR based on frequency or
other metrics. But, for CPUs which support this MSR today, changing the
value with frequency do not make any difference.

Thanks,
Venki

