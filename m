Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbXLGVhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbXLGVhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXLGVhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:37:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:36477 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbXLGVhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:37:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,269,1194249600"; 
   d="scan'208";a="424269352"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Date: Fri, 7 Dec 2007 13:38:00 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE38C313@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20071205111720.GC3864@ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Thread-Index: Acg5FyDRwJ/JAF/0SMC+uI8KNhkfcgAAjLAQ
References: <20071130142058.816d1693.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com> <20071205111720.GC3864@ucw.cz>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, <lkml@rtr.ca>,
       <abelay@novell.com>, <lenb@kernel.org>, <mlord@pobox.com>,
       <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
       <linux-acpi@vger.kernel.org>
X-OriginalArrivalTime: 07 Dec 2007 21:37:38.0801 (UTC) FILETIME=[63993610:01C83919]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Pavel Machek [mailto:pavel@ucw.cz] 
>Sent: Wednesday, December 05, 2007 3:17 AM
>To: Pallipadi, Venkatesh
>Cc: Andrew Morton; lkml@rtr.ca; abelay@novell.com; 
>lenb@kernel.org; mlord@pobox.com; rjw@sisk.pl; 
>linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org
>Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch 
>added to -mm tree
>
>Hi!
>
>> >It is not known whether Mark is actually writing to this 
>> >thing.  Perhaps
>> >read-only permissions would be a suitable fix?
>> >
>> 
>> Exporting it as read only should be OK. We also need to know if there
>> are hard user space dependency on writing to this from userspace.
>
>Some people are manipulating it from their suspend scripts..
>

That is done by default in kernel now. Deep C-states are disabled
between suspend and resume.

Thanks,
Venki
