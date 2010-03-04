Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab0CDXVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:21:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:13137 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab0CDXVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:21:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,583,1262592000"; 
   d="scan'208";a="497889762"
Message-Id: <20100304231454.247805000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Mar 2010 15:14:54 -0800
From: venkatesh.pallipadi@intel.com
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
Subject: [patch 0/2] Support for IA32_ENERGY_PERF_BIAS MSR - v2
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

---
Modification from first version - Revised kernel parameter documentation.

-- 

