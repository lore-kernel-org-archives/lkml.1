Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYGHPka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYGHPka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 11:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYGHPkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 11:40:21 -0400
Received: from mga05.intel.com ([192.55.52.89]:55267 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753489AbYGHPkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 11:40:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,323,1212390000"; 
   d="scan'208";a="350210422"
Message-ID: <48738A65.9060905@linux.intel.com>
Date: Tue, 08 Jul 2008 08:40:21 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Thomas Renninger <trenn@suse.de>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
       Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Huang Cheng <cheng.huang@intel.com>, firmwarekit-discuss@bughost.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Check for BIOS bugs - Original Subject: Re: [PATCH 23/70] ACPICA:
 Workaround for reversed _PRT entries from BIOS
References: <1213947852-10924-1-git-send-email-lenb@kernel.org> <deade3c973eb9c98d2a6cfed658bbb49e693894a.1213947350.git.len.brown@intel.com> <200807011033.27887.trenn@suse.de> <20080707111207.GH5643@ucw.cz>
In-Reply-To: <20080707111207.GH5643@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> Some BIOSs erroneously reverse the _PRT SourceName and the
>>> SourceIndex.  Detect and repair this problem. MS ACPI also allows
>>> and repairs this problem, thus ACPICA must also.
>> It would be great to have an interface to report this as a BIOS defect.
>>
>> Something like:
>>
>> FIRMWARE_BUG_ON(FIRM_WARN, "erroneously reversed the _PRT source_name", ACPI_ 
>> Bug);
>>
>> FIRMWARE_BUG_ON(severity, description, component);
> 
> Yes, please.
> 
> I'd also like HARDWARE_BUG_ON(), with similar usage.
> 
> With all the preload-linux-on-foo project, we have some chance to make
> BIOS vendors fix their stuff if we can easily diagnose errors in
> there.

also we can tie this to kerneloops.org to make a list of top known firmware/hardware bugs, seperate from the kernel code bugs
> 

