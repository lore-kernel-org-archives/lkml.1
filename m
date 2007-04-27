Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbXD0SFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbXD0SFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756969AbXD0SFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:05:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:14866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965AbXD0SFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:05:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,462,1170662400"; 
   d="scan'208";a="237941100"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: ACPI interpreter errors
Date: Fri, 27 Apr 2007 11:05:17 -0700
Message-ID: <B28E9812BAF6E2498B7EC5C427F293A4025DC20B@orsmsx415.amr.corp.intel.com>
In-Reply-To: <20070427140757.56f5e218@laptop.hypervisor.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ACPI interpreter errors
Thread-Index: AceI1IGcbPyuxaUwSRqxdyyyHL6R8wAIefxg
From: "Moore, Robert" <robert.moore@intel.com>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: "Linux ACPI Mailing List" <linux-acpi@vger.kernel.org>
X-OriginalArrivalTime: 27 Apr 2007 18:05:17.0949 (UTC) FILETIME=[9CED7AD0:01C788F6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Status 5 from ACPICA is AE_NOT_FOUND.

_OSC is an optional control method, so whatever code is squawking about it probably handle it and shut up.


-----Original Message-----
From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Udo A. Steinberg
Sent: Friday, April 27, 2007 5:08 AM
To: Linux Kernel Mailing List
Cc: Linux ACPI Mailing List
Subject: ACPI interpreter errors

Hello,

With 2.6.21 I am getting the following errors from the ACPI interpreter on an
Intel S5000PSL board:

Allocate Port Service[0000:02:02.0:pcie20]
Allocate Port Service[0000:02:02.0:pcie21]
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:02.0:pcie01 failed with error 2
aer_init: AER service init fails - No ACPI _OSC support
aer: probe of 0000:00:03.0:pcie01 failed with error 1
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:04.0:pcie01 failed with error 2
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:05.0:pcie01 failed with error 2
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:06.0:pcie01 failed with error 2
aer_init: AER service init fails - No ACPI _OSC support
aer: probe of 0000:00:07.0:pcie01 failed with error 1

The complete dmesg output is attached. If you need more information, please let
me know.

Cheers,

        - Udo
