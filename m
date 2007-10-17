Return-Path: <linux-kernel-owner+w=401wt.eu-S1760445AbXJQWDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445AbXJQWDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXJQWDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:03:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47047 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755738AbXJQWDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:03:41 -0400
Date: Wed, 17 Oct 2007 15:02:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Cc: kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net, tytso@mit.edu
Subject: Re: [PATCH 0/4] Fix PCIe hotplug for non-ACPI ExpressCard slots
 (version 2)
Message-Id: <20071017150243.1c21fea4.akpm@linux-foundation.org>
In-Reply-To: <47156B14.2080608@rtr.ca>
References: <4714C0A6.1030204@rtr.ca>
	<4714D700.7060008@rtr.ca>
	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>
	<47150565.5090102@rtr.ca>
	<20071016114328.a96e8bcb.kristen.c.accardi@intel.com>
	<47150982.6050102@rtr.ca>
	<471509FE.7080505@rtr.ca>
	<47151191.40406@rtr.ca>
	<20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>
	<4715217D.2000803@rtr.ca>
	<20071016214143.GC21815@kroah.com>
	<471533AF.60100@rtr.ca>
	<47156B14.2080608@rtr.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 21:53:24 -0400
Mark Lord <lkml@rtr.ca> wrote:

> Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
> in conjunction with the modparam of pciehp_force=1.
> 
> The PCIe Hotplug driver has two shortcomings when used on Dell notebooks
> which lack ACPI BIOS support for PCIe hotplug:

You just sent four patches all of which are identified as "Fix PCIe hotplug
for non-ACPI ExpressCard slots (version 2)".  Please do not do this.

I went through the (tiresome) exercise of inventing unique names for them
and then discovered that the first patch gets just a couple of rejects against
the mainline tree....

Hunk #1 succeeded at 129 (offset -31 lines).
Hunk #2 FAILED at 258.
Hunk #3 succeeded at 262 (offset -37 lines).
Hunk #4 FAILED at 295.
Hunk #5 FAILED at 304.
Hunk #6 FAILED at 313.
Hunk #7 FAILED at 331.
Hunk #8 FAILED at 363.
Hunk #9 FAILED at 373.
Hunk #10 FAILED at 391.
Hunk #11 FAILED at 409.
Hunk #12 FAILED at 417.
Hunk #13 FAILED at 430.
Hunk #14 FAILED at 440.
Hunk #15 FAILED at 451.
Hunk #16 FAILED at 459.
Hunk #17 FAILED at 535.
Hunk #18 FAILED at 546.
Hunk #19 FAILED at 592.
Hunk #20 FAILED at 612.
Hunk #21 FAILED at 637.
Hunk #22 FAILED at 694.
Hunk #23 succeeded at 734 (offset -91 lines).
Hunk #24 succeeded at 744 (offset -91 lines).
Hunk #25 succeeded at 801 (offset -91 lines).
Hunk #26 succeeded at 813 (offset -91 lines).
Hunk #27 FAILED at 824.
Hunk #28 FAILED at 843.
Hunk #29 FAILED at 854.
Hunk #30 FAILED at 894.
Hunk #31 FAILED at 905.
Hunk #32 FAILED at 924.
Hunk #33 FAILED at 935.
Hunk #34 FAILED at 975.
Hunk #35 succeeded at 988 (offset -97 lines).
Hunk #36 FAILED at 1066.
Hunk #37 FAILED at 1078.
Hunk #38 FAILED at 1102.
Hunk #39 FAILED at 1145.
Hunk #40 FAILED at 1171.
Hunk #41 succeeded at 1235 (offset -96 lines).
Hunk #42 FAILED at 1250.
Hunk #43 succeeded at 1264 (offset -93 lines).
34 out of 43 hunks FAILED -- saving rejects to file drivers/pci/hotplug/pciehp_hpc.c.rej

