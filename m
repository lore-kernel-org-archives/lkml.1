Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYGRImv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYGRImv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYGRImn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:42:43 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:20338 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYGRImm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:42:42 -0400
Message-Id: <488073B8.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 09:43:04 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Robert Moore" <robert.moore@intel.com>, "Andi Kleen" <ak@linux.intel.com>
Cc: "Andrew Paprocki" <andrew@ishiboo.com>, "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: RE: ACPI WARNING: at
	drivers/acpi/tables/tbfadt.c:348acpi_tb_create_local_fadt+0x147/0x2f4()
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com>
 <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com>
 <487F2629.76E4.0078.0@novell.com> <487F0B85.4030202@linux.intel.com>
 <487F29B2.76E4.0078.0@novell.com> <487F3AFA.7090908@linux.intel.com>
 <76366b180807170603qaf669a5q625fc166a2045756@mail.gmail.com>
 <487F6C32.76E4.0078.0@novell.com>
 <76366b180807170732i112d54bcl49f630a3064f87f@mail.gmail.com>
 <487F81A6.76E4.0078.0@novell.com>
 <9D39833986E69849A2A8E74C1078B6B3ADFA66@orsmsx415.amr.corp.intel.com>
In-Reply-To: <9D39833986E69849A2A8E74C1078B6B3ADFA66@orsmsx415.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Moore, Robert" <robert.moore@intel.com> 17.07.08 19:20 >>>
>So far, in the number of the cases like this that I've seen, it's the v2
>fields that have problems. Perhaps the heuristic should be something
>like "if there is an inconsistency between the v1 and v2 fields, fall
>back to v1". 

While extending the patch to do so, I realize that other v2 fields are
used as-is, no matter whether their bit_width (or other fields) are
wrong. Is that perhaps why hardware/hwregs.c uses hard-coded
constants rather than the specified widths? If so (and if the v1 fields
are considered reliable), shouldn't the v2 ones be sanity-checked
against the v1 ones and then the specified widths be used as intended
by the spec?

Jan

