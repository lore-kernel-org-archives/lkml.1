Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbYGQOca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbYGQOca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbYGQOcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:32:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:5037 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYGQOcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=r/mt+f5Yb/tGqMgj5MminXCRboYkFAgsY9wy12nTRNZQSv1cI5Q7IW0bn+XHD0yGya
         ZC3f1qOUpib04tYILe0zbz36M6uKe0uwoMD8wF4MJZLXP+ywXhPggt1erFNxFgH4UJs+
         MCNH+ftNDapT4aIu3xoRnJ+A9pHSVQGNU1XOU=
Message-ID: <76366b180807170732i112d54bcl49f630a3064f87f@mail.gmail.com>
Date: Thu, 17 Jul 2008 10:32:21 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: ACPI WARNING: at drivers/acpi/tables/tbfadt.c:348 acpi_tb_create_local_fadt+0x147/0x2f4()
Cc: "Andi Kleen" <ak@linux.intel.com>, robert.moore@intel.com,
       "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <487F6C32.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com>
	 <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com>
	 <487F2629.76E4.0078.0@novell.com> <487F0B85.4030202@linux.intel.com>
	 <487F29B2.76E4.0078.0@novell.com> <487F3AFA.7090908@linux.intel.com>
	 <76366b180807170603qaf669a5q625fc166a2045756@mail.gmail.com>
	 <487F6C32.76E4.0078.0@novell.com>
X-Google-Sender-Auth: e3b413a3c8b9b10f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 9:58 AM, Jan Beulich <jbeulich@novell.com> wrote:
>>>> "Andrew Paprocki" <andrew@ishiboo.com> 17.07.08 15:03 >>>
>>On Thu, Jul 17, 2008 at 8:28 AM, Andi Kleen <ak@linux.intel.com> wrote:
>>> Ok, but we can just get that from a table dump.
>>
>>Output from acpidump is attached.
>
> Just as I suspected - the v1 field says 4 bytes, but the v2 field says 8 bits.

So does the BIOS owner need to fix the table? If you could give me the
exact text to pass along to the mobo mfr, I will forward it and I can
get them to release a new BIOS rev.

Thanks,
-Andrew
