Return-Path: <linux-kernel-owner+w=401wt.eu-S1765671AbYA2SFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765671AbYA2SFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYA2SEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:04:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:24604 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYA2SEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:04:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,270,1199692800"; 
   d="scan'208";a="294090001"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.24] ata_piix:  IDE mode SATA patch for Intel ICH10 DeviceID's
Date: Tue, 29 Jan 2008 10:03:04 -0800
Message-ID: <39B20DF628532344BC7A2692CB6AEE0702403EBE@orsmsx420.amr.corp.intel.com>
In-Reply-To: <479F5EDF.9010601@pobox.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.24] ata_piix:  IDE mode SATA patch for Intel ICH10 DeviceID's
Thread-Index: Achimp906J66UpkZQC+3BCrGzvPtFwABodYg
References: <200801281736.45574.jason.d.gaston@intel.com> <479F5EDF.9010601@pobox.com>
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <htejun@gmail.com>
X-OriginalArrivalTime: 29 Jan 2008 18:03:48.0534 (UTC) FILETIME=[4C0E9560:01C862A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Jeff Garzik [mailto:jgarzik@pobox.com]
>Sent: Tuesday, January 29, 2008 9:14 AM
>To: Gaston, Jason D
>Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org;
>htejun@gmail.com
>Subject: Re: [PATCH 2.6.24] ata_piix: IDE mode SATA patch for Intel
ICH10
>DeviceID's
>
>Jason Gaston wrote:
>> This patch adds the Intel ICH10 IDE mode SATA Controller DeviceID's.
>>
>> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
>>
>> --- linux-2.6.24/drivers/ata/ata_piix.c.orig	2008-01-24
>14:58:37.000000000 -0800
>> +++ linux-2.6.24/drivers/ata/ata_piix.c	2008-01-28
14:58:22.000000000 -
>0800
>> @@ -263,6 +263,14 @@
>>  	{ 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci
},
>>  	/* SATA Controller IDE (Tolapai) */
>>  	{ 0x8086, 0x5028, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
tolapai_sata_ahci },
>> +	/* SATA Controller IDE (ICH10) */
>> +	{ 0x8086, 0x3a00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci
},
>> +	/* SATA Controller IDE (ICH10) */
>> +	{ 0x8086, 0x3a06, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata
},
>> +	/* SATA Controller IDE (ICH10) */
>> +	{ 0x8086, 0x3a20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci
},
>> +	/* SATA Controller IDE (ICH10) */
>> +	{ 0x8086, 0x3a26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata
},
>
>can these do AHCI mode without losing any PATA ports?
>
>if so, I would prefer to always drive the hardware in AHCI mode, if it
>is capable of doing so.

They do not have PATA.

Jason


