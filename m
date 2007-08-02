Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbXHBRka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbXHBRka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbXHBRkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:40:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:22176 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbXHBRkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:40:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,214,1183359600"; 
   d="scan'208";a="273757004"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: scripts/mod/file2alias.c cross compile problem
Date: Thu, 2 Aug 2007 10:40:14 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A02156CC1@scsmsx411.amr.corp.intel.com>
In-Reply-To: <jewswdvqpt.fsf@sykes.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: scripts/mod/file2alias.c cross compile problem
Thread-Index: AcfVI0Nnai62keSmSVSgd7IchnqiEAACE2aQ
From: "Luck, Tony" <tony.luck@intel.com>
To: "Andreas Schwab" <schwab@suse.de>
Cc: <trenn@suse.de>, "Adrian Bunk" <bunk@stusta.de>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Jan Dittmer" <jdi@l4x.org>,
       "Len Brown" <lenb@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 02 Aug 2007 17:40:16.0058 (UTC) FILETIME=[2FCCD9A0:01C7D52C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>  struct acpi_device_id {
>>>  	__u8 id[ACPI_ID_LEN];
>>> +	__u8 dummy[FILLUP_LEN];
>>>  	kernel_ulong_t driver_data;
>>>  };
>>
>> What's so special about this structure that we get an error?
>
> It's special because it's a device_id structure, and those structures
> must come out identical using either the host or the target compiler.

That didn't help me understand.  Are device_id structures visible
in some user-level API?  If so, then I can see why they'd need to
be the same (but then I'd be confused why this structure uses a
"kernel_ulong_t" type).

-Tony
