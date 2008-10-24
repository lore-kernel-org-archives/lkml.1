Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYJXUoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYJXUoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbYJXUor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:44:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:18414 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbYJXUoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:44:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,480,1220252400"; 
   d="scan'208";a="455242213"
From: "Moore, Robert" <robert.moore@intel.com>
To: Len Brown <lenb@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 24 Oct 2008 13:43:59 -0700
Subject: RE: [PATCH] Subject: Prevent acpi_run_osc from using NULL objects
 (was: Re: Oops in ACPI with git latest)
Thread-Topic: [PATCH] Subject: Prevent acpi_run_osc from using NULL objects
 (was: Re: Oops in ACPI with git latest)
Thread-Index: Ack2Fukr2NCc4eSKSrCdApcINY87FgAAhuOw
Message-ID: <4911F71203A09E4D9981D27F9D8308580AA7FF3D@orsmsx503.amr.corp.intel.com>
References: <1224791103.3330.37.camel@localhost.localdomain>
 <1224811642.3330.57.camel@localhost.localdomain>
 <200810240857.18190.rjw@sisk.pl> <200810241349.43166.rjw@sisk.pl>
 <4911F71203A09E4D9981D27F9D8308580AA7FA4F@orsmsx503.amr.corp.intel.com>
 <alpine.LFD.1.10.0810241625170.3056@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0810241625170.3056@localhost.localdomain>
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

Yes, we will see.

Certainly, in this case it was helpful to have the warning up front that there was no return value.


>-----Original Message-----
>From: Len Brown [mailto:lenb@kernel.org]
>Sent: Friday, October 24, 2008 1:27 PM
>To: Moore, Robert
>Cc: Rafael J. Wysocki; James Bottomley; Jesse Barnes; linux-
>acpi@vger.kernel.org; linux-kernel
>Subject: RE: [PATCH] Subject: Prevent acpi_run_osc from using NULL objects
>(was: Re: Oops in ACPI with git latest)
>
>
>
>> We've just recently deployed a new module that validates the inputs and
>outputs
>> for the predefined ACPI methods (Those that start with underscore).
>>
>> That is the source of these messages:
>>
>> > > ACPI Warning (nspredef-0252): \_SB_.PCI0._OSC: Parameter count
>mismatch - ASL declared 5, expected 4 [20080926]
>> > > ACPI Error (nspredef-0163): \_SB_.PCI0._OSC: Missing expected return
>value [20080926]
>>
>> For the initial version of this module, we only output messages when the
>inputs and/or
>> outputs don't match the requirements of the ACPI specification.
>>
>> We can change this to returning exceptions in the future.
>
>I expect we're going to have a bunch of false positives with this one,
>and indeed may need to even pare the warnings back to only
>when CONFIG_ACPI_DEBUG, or acpi=strict or something.
>
>-Len
