Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZHNTII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZHNTII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 15:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZHNTIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 15:08:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:54710 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbZHNTIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 15:08:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,381,1246863600"; 
   d="scan'208";a="175946001"
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Alex Chiang <achiang@hp.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090814163618.GQ7185@ldl.fc.hp.com>
References: <20090814163618.GQ7185@ldl.fc.hp.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 14 Aug 2009 12:07:11 -0700
Message-Id: <1250276831.3077.17.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 09:36 -0700, Alex Chiang wrote:
> As systems become larger and more complex, it is not always possible
> to assume that an APIC ID maps directly to a given physical slot.
> 
> From a UI point-of-view, it's nice if the 'physical id' field in
> /proc/cpuinfo matches the silk-screening or labelling on the system
> chassis.
> 
> Add a quirk that allows oddball platforms to ensure that what the kernel
> displays in /proc/cpuinfo matches the physical reality.

Alex, Does it makes sense to add a new entry in /proc/cpuinfo rather
than overloading the 'physical id' by modifying phys_proc_id.

That way, even if there is a mis-match between the bios and the OS fixup
tables, we won't screw up other topology setup etc in the kernel that
are dependent on the phys_proc_id.

thanks,
suresh



