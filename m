Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684Ab0ALSZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0ALSZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273Ab0ALSZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:25:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:50617 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab0ALSZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:25:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,263,1262592000"; 
   d="scan'208";a="763591576"
Subject: Re: [RFC PATCH 2/4] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c441001121013o4b8775edl1bc36f120e072b75@mail.gmail.com>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
	 <1263264483-3959-4-git-send-email-yinghai@kernel.org>
	 <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
	 <86802c441001120059s46a2e93aydc76067960aa07e6@mail.gmail.com>
	 <alpine.LFD.2.00.1001120719260.17145@localhost.localdomain>
	 <86802c441001121013o4b8775edl1bc36f120e072b75@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 12 Jan 2010 10:24:07 -0800
Message-Id: <1263320647.2854.295.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 10:13 -0800, Yinghai Lu wrote:
> ok let stay with option 1.
>
> and would like to use DMI to blacklist those systems that do need treat disabled
> cpus MADT as hotplug cpus.

Yinghai, I don't think we have to worry about disabled cpu's etc using
DMI etc. If we really come across such a system, they can use ACPI FADT
flags (ACPI_FADT_APIC_PHYSICAL) to specify that they need to use
physical mode.

thanks,
suresh

