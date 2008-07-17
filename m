Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYGQJOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYGQJOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYGQJOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:14:39 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:27200 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbYGQJOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:14:38 -0400
Message-Id: <487F29B2.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 17 Jul 2008 10:14:58 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@linux.intel.com>
Cc: <robert.moore@intel.com>, "Andrew Paprocki" <andrew@ishiboo.com>,
       "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: ACPI WARNING: at
	drivers/acpi/tables/tbfadt.c:348	acpi_tb_create_local_fadt+0x147/0x2f4()
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com>
 <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com>
 <487F2629.76E4.0078.0@novell.com> <487F0B85.4030202@linux.intel.com>
In-Reply-To: <487F0B85.4030202@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The question is just if the hardware is really 8 bits or if the table
>is not just wrong. What does lspci say?

What would lspci have to do with this? /proc/acpi/fadt (from an older
kernel if the new one fails to come up) would seem to help somewhat,
as that would allow comparing the v1 (byte-width) and v2 (bit-width)
values - if they're out of sync (and they likely are if the system worked
flawlessly with previous kernels), I'd be certain the tables are wrong.

Jan

