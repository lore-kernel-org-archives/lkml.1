Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbYGQM2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbYGQM2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYGQM2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:28:46 -0400
Received: from mga06.intel.com ([134.134.136.21]:39692 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753118AbYGQM2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:28:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,203,1215414000"; 
   d="scan'208";a="419017312"
Message-ID: <487F3AFA.7090908@linux.intel.com>
Date: Thu, 17 Jul 2008 14:28:42 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: robert.moore@intel.com, Andrew Paprocki <andrew@ishiboo.com>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ACPI WARNING: at	drivers/acpi/tables/tbfadt.c:348	acpi_tb_create_local_fadt+0x147/0x2f4()
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com> <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com> <487F2629.76E4.0078.0@novell.com> <487F0B85.4030202@linux.intel.com> <487F29B2.76E4.0078.0@novell.com>
In-Reply-To: <487F29B2.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> The question is just if the hardware is really 8 bits or if the table
>> is not just wrong. What does lspci say?
> 
> What would lspci have to do with this? 

When it's an chipset with available data sheets one could check that.

> /proc/acpi/fadt (from an older
> kernel if the new one fails to come up) would seem to help somewhat,
> as that would allow comparing the v1 (byte-width) and v2 (bit-width)
> values - if they're out of sync (and they likely are if the system worked
> flawlessly with previous kernels), I'd be certain the tables are wrong.

Ok, but we can just get that from a table dump.

-Andi

