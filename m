Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbXIFR2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbXIFR2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 13:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbXIFR16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 13:27:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:34167 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbXIFR15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 13:27:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,216,1186383600"; 
   d="scan'208";a="273359359"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch for Intel Tolapai
Date: Thu, 6 Sep 2007 10:27:55 -0700
Message-ID: <39B20DF628532344BC7A2692CB6AEE0701B9A4CA@orsmsx420.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch for Intel Tolapai
thread-index: AcfroyjKgfQ2QoQvS56po7XeVOgmmgATkLwgAS5jbgA=
References: <200708302127.19535.jason.d.gaston@intel.com> <46D7C783.8050803@pobox.com> 
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Gaston, Jason D" <jason.d.gaston@intel.com>
X-OriginalArrivalTime: 06 Sep 2007 17:27:56.0386 (UTC) FILETIME=[43611C20:01C7F0AB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Gaston, Jason D
>Sent: Friday, August 31, 2007 10:10 AM
>To: 'Jeff Garzik'
>Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: RE: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch
for
>Intel Tolapai
>
>This device has both AHCI and RAID modes that use the ahci driver.
Only
>the RAID mode DID's are being added as the PCI class code support will
>cover the AHCI mode.  Looking at the Generic, PCI class code support
>section, it uses "board_ahci".  I assumed that they should be the same
as
>the generic class code support is working on this platform.
>
>Thanks,
>
>Jason
>
>
>>-----Original Message-----
>>From: Jeff Garzik [mailto:jgarzik@pobox.com]
>>Sent: Friday, August 31, 2007 12:47 AM
>>To: Gaston, Jason D
>>Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
>>Subject: Re: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch
for
>>Intel Tolapai
>>
>>Jason Gaston wrote:
>>> Resend trying to remove 8-bit characters in the email.
>>>
>>> This patch adds the Intel Tolapai RAID controller DID's for SATA
>support.
>>>
>>> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
>>>
>>> --- linux-2.6.23-rc4/drivers/ata/ahci.c.orig	2007-08-27
>>18:32:35.000000000 -0700
>>> +++ linux-2.6.23-rc4/drivers/ata/ahci.c	2007-08-28
>16:58:11.000000000 -
>>0700
>>> @@ -411,6 +411,8 @@
>>>  	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci_pi }, /* ICH9M */
>>>  	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
>>>  	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */
>>> +	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
>>> +	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
>>
>>Why did you not use board_ahci_pi?  Is the AHCI ports-implemented
>>register unreliable on this platform?

Jeff,

Do I need to change this to board_ahci_pi or is it ok to leave it at
board_ahci, which will be used by the AHCI class code devices?

Thanks,

Jason
