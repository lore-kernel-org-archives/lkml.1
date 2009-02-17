Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZBQSsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZBQSsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZBQSsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:48:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:15060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbZBQSsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:48:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,224,1233561600"; 
   d="scan'208";a="387527938"
From: "Moore, Robert" <robert.moore@intel.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 17 Feb 2009 10:48:20 -0800
Subject: RE: [2.6.29-rc5 ACPI] truncated dsobject list...
Thread-Topic: [2.6.29-rc5 ACPI] truncated dsobject list...
Thread-Index: AcmRHT4ffSALy/61T7a682BNUgsp1QAEtM9w
Message-ID: <4911F71203A09E4D9981D27F9D830858149BBB4F@orsmsx503.amr.corp.intel.com>
References: <6278d2220902170831n3801a935x578b5dff64d00c62@mail.gmail.com>
In-Reply-To: <6278d2220902170831n3801a935x578b5dff64d00c62@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>ACPI Warning (dsobject-0502): Package List length (6) larger than
>NumElements count (4), truncated

This simply means that in one of the ACPI tables, a Package object was found that was declared to have 6 items. However, when parsing the package, the interpreter only found 4 items.

It's a BIOS issue, but probably not serious unless there really is supposed to be 6 items.


>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>owner@vger.kernel.org] On Behalf Of Daniel J Blueman
>Sent: Tuesday, February 17, 2009 8:32 AM
>To: linux-acpi@vger.kernel.org; Linux Kernel
>Subject: [2.6.29-rc5 ACPI] truncated dsobject list...
>
>With 2.6.29-rc5 on an Intel S5000PAL server (BIOS
>S5000.86B.10.60.0091.100920081631), we see ACPI object list truncation
>[1]. Does it make sense to increase the default element allocation?
>
>Many thanks,
>  Daniel
>
>--- [1]
>
>ACPI: EC: Look up EC in DSDT
>ACPI Warning (dsobject-0502): Package List length (6) larger than
>NumElements count (4), truncated
>[20081204]
>--
>Daniel J Blueman
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
