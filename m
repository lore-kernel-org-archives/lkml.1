Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab0BYSg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:36:56 -0500
Received: from mailb.microsoft.com ([131.107.115.215]:37548 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab0BYSgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:36:54 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Hank Janssen <hjanssen@microsoft.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Problem with auto-detecting a HV environment from within Linux
Thread-Topic: Problem with auto-detecting a HV environment from within Linux
Thread-Index: AQHKtjnpPG+DB1+VDUmGCDmANJRAY5HXEhsAgACJl4D//4hyAA==
Date: Thu, 25 Feb 2010 18:37:05 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF725B6A5633@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <20100225164436.GA3310@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225173611.GA14124@kroah.com>
In-Reply-To: <20100225173611.GA14124@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, February 25, 2010 12:36 PM
> What does the following command output in a HV virtual system:
> 	grep . /sys/bus/acpi/devices/*/modalias

/sys/bus/acpi/devices/VMBus:00/modalias:acpi:VMBus:

> How about DMI data?  Does the Host export any info there?  Is there
> anything in the /sys/class/dmi/id/ directory?  If so, can you send the
> output of:
> 	cat /sys/class/dmi/id/modalias

dmi:bvnAmericanMegatrendsInc.:bvr090004:bd03/19/2009:svnMicrosoftCorporation:pnVirtualMachine:pvr7.0:rvnMicrosoftCorporation:rnVirtualMachine:rvr7.0:cvnMicrosoftCorporation:ct3:cvr7.0:

> And you are sure no PCI devices are present to key off of that are
> never going to show up in a "physical" machine?

There is also a pci device as you said:
00:08.0 VGA compatible controller: Microsoft Corporation Device 5353 (prog-if 00 [VGA controller])
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f8000000 (32-bit, non-prefetchable) [size=64M]

> 
> What do you recommend doing here?

I think any of the above can be used.

Thanks,

- Haiyang

