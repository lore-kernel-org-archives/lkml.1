Return-Path: <linux-kernel-owner+w=401wt.eu-S933261AbYGQUbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbYGQUbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760330AbYGQUb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:31:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:15486 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204AbYGQUb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:31:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,205,1215414000"; 
   d="scan'208";a="598731393"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Check for BIOS bugs - Original Subject: Re: [PATCH 23/70] ACPICA: Workaround for reversed _PRT entries from BIOS
Date: Thu, 17 Jul 2008 13:31:25 -0700
Message-ID: <960B77DF2E6D974DBE24FD066EAEE8DAEA9BA8@azsmsx422.amr.corp.intel.com>
In-Reply-To: <200807091051.57322.trenn@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Check for BIOS bugs - Original Subject: Re: [PATCH 23/70] ACPICA: Workaround for reversed _PRT entries from BIOS
Thread-Index: AcjhoQ9J+A+2e0t+SR+vEzWc5LPdUgGqgL4A
References: <1213947852-10924-1-git-send-email-lenb@kernel.org> <48738A65.9060905@linux.intel.com> <960B77DF2E6D974DBE24FD066EAEE8DAD90886@azsmsx422.amr.corp.intel.com> <200807091051.57322.trenn@suse.de>
From: "Brown, Len" <len.brown@intel.com>
To: "Thomas Renninger" <trenn@suse.de>
Cc: "Arjan van de Ven" <arjan@linux.intel.com>, "Pavel Machek" <pavel@suse.cz>,
       "Len Brown" <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Huang Cheng" <cheng.huang@intel.com>,
       <firmwarekit-discuss@bughost.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Jul 2008 20:31:26.0429 (UTC) FILETIME=[15FF98D0:01C8E84C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I'm not excited about maintaining
>> maintaining linux-as-a-firmware-diagnostic --
>> particularly when...

>Above is not for ACPI only. But ACPI is probably a candidate 
>which should make use of it.

Sure, there may be justification for doing something like this
in the kernel, but the issue that started this thread isn't it.

The issue that started this thread can be diagnosed by user-space
in linuxfirmwarekit.  Multiple machines have this bug, which means
that it is "common industry practice" and the kernel has to work
around it (silently) if we like it or not.
ie. the issue, now that it is debugged and worked around,
is effectly just firmware lint.

thanks,
-Len
