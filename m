Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbYGQN6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbYGQN6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbYGQN6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:58:22 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:40015 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbYGQN6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:58:21 -0400
Message-Id: <487F6C32.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 17 Jul 2008 14:58:42 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Paprocki" <andrew@ishiboo.com>, "Andi Kleen" <ak@linux.intel.com>
Cc: <robert.moore@intel.com>, "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: ACPI WARNING: at drivers/acpi/tables/tbfadt.c:348
	acpi_tb_create_local_fadt+0x147/0x2f4()
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com>
 <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com>
 <487F2629.76E4.0078.0@novell.com> <487F0B85.4030202@linux.intel.com>
 <487F29B2.76E4.0078.0@novell.com> <487F3AFA.7090908@linux.intel.com>
 <76366b180807170603qaf669a5q625fc166a2045756@mail.gmail.com>
In-Reply-To: <76366b180807170603qaf669a5q625fc166a2045756@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Andrew Paprocki" <andrew@ishiboo.com> 17.07.08 15:03 >>>
>On Thu, Jul 17, 2008 at 8:28 AM, Andi Kleen <ak@linux.intel.com> wrote:
>> Ok, but we can just get that from a table dump.
>
>Output from acpidump is attached.

Just as I suspected - the v1 field says 4 bytes, but the v2 field says 8 bits.

Jan

