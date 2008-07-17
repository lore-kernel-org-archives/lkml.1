Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbYGQRlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbYGQRlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845AbYGQRlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:41:06 -0400
Received: from mga06.intel.com ([134.134.136.21]:48272 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756874AbYGQRlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:41:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,204,1215414000"; 
   d="scan'208";a="316190901"
Message-ID: <487F8426.4080607@linux.intel.com>
Date: Thu, 17 Jul 2008 19:40:54 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Moore, Robert" <robert.moore@intel.com>
CC: Jan Beulich <jbeulich@novell.com>, Andrew Paprocki <andrew@ishiboo.com>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ACPI WARNING: at drivers/acpi/tables/tbfadt.c:348acpi_tb_create_local_fadt+0x147/0x2f4()
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com> <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com> <487F2629.76E4.0078.0@novell.com> <487F0B85.4030202@linux.intel.com> <487F29B2.76E4.0078.0@novell.com> <487F3AFA.7090908@linux.intel.com> <76366b180807170603qaf669a5q625fc166a2045756@mail.gmail.com> <487F6C32.76E4.0078.0@novell.com> <76366b180807170732i112d54bcl49f630a3064f87f@mail.gmail.com> <487F81A6.76E4.0078.0@novell.com> <9D39833986E69849A2A8E74C1078B6B3ADFA66@orsmsx415.amr.corp.intel.com>
In-Reply-To: <9D39833986E69849A2A8E74C1078B6B3ADFA66@orsmsx415.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moore, Robert wrote:
> So far, in the number of the cases like this that I've seen, it's the v2
> fields that have problems. Perhaps the heuristic should be something
> like "if there is an inconsistency between the v1 and v2 fields, fall
> back to v1". 

Yes that makes sense. Jan could you revise the patch to do that please?

Thanks,

-Andi
