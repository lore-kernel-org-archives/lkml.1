Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbXJWJsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbXJWJsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXJWJsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:48:13 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:39316 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbXJWJsL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:48:11 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] PCI: disable MSI on more ATI NorthBridges
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Tue, 23 Oct 2007 17:39:22 +0800
Message-ID: <5CAB7B5D6F8AB84AA868A46B47A507055D91AE@sshaexmb1.amd.com>
In-Reply-To: <20071022.171318.104036671.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] PCI: disable MSI on more ATI NorthBridges
Thread-Index: AcgVCYYm7q3318ZwQB67TBv4Vt8VBwATgPUw
References: <Pine.LNX.4.64.0710221555190.32497@iabervon.org>
 <471D0ADC.7000005@garzik.org>
 <Pine.LNX.4.64.0710221700120.32497@iabervon.org>
 <20071022.171318.104036671.davem@davemloft.net>
From: "Shane Huang" <Shane.Huang@amd.com>
To: "David Miller" <davem@davemloft.net>, barkalow@iabervon.org
cc: jeff@garzik.org, linas@austin.ibm.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-ide@vger.kernel.org, brice@myri.com,
       "Shane Huang" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 23 Oct 2007 09:39:23.0497 (UTC)
 FILETIME=[9834ED90:01C81558]
X-WSS-ID: 6B031E0207S36132-03-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David:

> I think this pretty much sums up the situation accurately.
> 
> My suggestion is:
> 
> 1) Leave the pci_intx() twiddling code in drivers/pci/msi.c
> 
> 2) Add quirks for "INTX_DISABLE turns off MSI too", this sets
>    a flag in the pci_dev.
> 
> 3) The pci_intx() calls in drivers/pci/msi.c are skipped if this
>    flag from #2 is set.
> 
> 4) Add quirk entries for drivers/net/tg3.c chips and these SATA
>    devices we are learning about here, as well as any others we
>    are aware of right now.
> 
> 5) Remove the pci_intx() workaround code from drivers/net/tg3.c
>    and elsewhere.

This quirk seems good to me. Waiting for your final decision....

This SB700 SATA controller MSI/INTx problem has been reported to our
hardware team. I will forward the update information or response to
you when I get any from HW team.


Thanks
Shane



