Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0CCASm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:18:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:20201 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab0CCASj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:18:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,570,1262592000"; 
   d="scan'208";a="497172113"
Message-Id: <20100303000649.757684000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 02 Mar 2010 16:06:49 -0800
From: venkatesh.pallipadi@intel.com
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 0/2] Support for IA32_ENERGY_PERF_BIAS MSR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new hardware feature, which lets system software to set
Energy Performance Preference. This is a opaque knob in the form of
IA32_ENERGY_PERF_BIAS MSR, which has a 4 bit Energy Performance
Preference Hint.

The support for this feature is indicated by CPUID.06H.ECX.bit3. Refer to
Intel Architectures Software Developer's Manual for more info.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

-- 

