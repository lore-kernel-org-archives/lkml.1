Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943Ab0AMPn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0AMPn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290Ab0AMPn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:43:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:19229 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab0AMPn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:43:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,268,1262592000"; 
   d="scan'208";a="763888992"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: David Milburn <dmilburn@redhat.com>, Jeff Garzik <jgarzik@pobox.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 13 Jan 2010 07:43:53 -0800
Subject: RE: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel
 Cougar Point DeviceIDs
Thread-Topic: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel
 Cougar Point DeviceIDs
Thread-Index: AcqUYQedS37ksec2R3+DpislomiZ8QABgw8A
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF12D391CB2A@orsmsx501.amr.corp.intel.com>
References: <201001121700.18234.seth.heasley@intel.com>
 <4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
 <4B4DDFD3.5050700@redhat.com>
In-Reply-To: <4B4DDFD3.5050700@redhat.com>
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

>> * some of lines of Intel chips do not separate AHCI into a separate PCI
>> ID rather legacy IDE interface.  When an AHCI interface exists and
>> AHCI/IDE share the same PCI ID, we default to using AHCI.  Thus, some of
>> those PCI ID matches in ahci.c's PCI table may not get caught by the
>> generic PCI class match at the end of the table.
>>
>> * the cost carrying redundant PCI IDs seems low, harmless, and
>> potentially helpful.
>
>It is helpful for the specific device IDs to show up in "modinfo ahci" and
>modules.pcimap.
>
>David

This is the reason I was asked to start adding the AHCI DeviceIDs here.

-Seth
