Return-Path: <linux-kernel-owner+w=401wt.eu-S966185AbXJPWSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966185AbXJPWSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966138AbXJPWR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:17:59 -0400
Received: from rtr.ca ([76.10.145.34]:1157 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966136AbXJPWR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:17:57 -0400
Message-ID: <47153894.8070901@rtr.ca>
Date: Tue, 16 Oct 2007 18:17:56 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix PCIe hotplug for Dell notebook ExpressCard slots
References: <4714C0A6.1030204@rtr.ca>	<4714D700.7060008@rtr.ca>	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>	<47150565.5090102@rtr.ca>	<20071016114328.a96e8bcb.kristen.c.accardi@intel.com>	<47150982.6050102@rtr.ca>	<471509FE.7080505@rtr.ca>	<47151191.40406@rtr.ca>	<20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>	<4715217D.2000803@rtr.ca>	<20071016214143.GC21815@kroah.com>	<471533AF.60100@rtr.ca> <20071016150454.c3c2ff75.kristen.c.accardi@intel.com>
In-Reply-To: <20071016150454.c3c2ff75.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Tue, 16 Oct 2007 17:57:03 -0400
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
>> in conjunction with modparam of pciehp_force=1.
> 
> Please resubmit, breaking this patch into 3 separate patches
> 1 for your first issue you wish to address, 2 for the second, and 3 for
> cosmetic changes.

It'll have to be the other way around, then.

The first patch will be one to fix the broken whitespace
and lines > 80 characters that already exist in the code
being touched.  Otherwise *none* of the patches pass checkpatch.pl paranoia.

Subsequent patches will then follow for the two issues.

Cheers
