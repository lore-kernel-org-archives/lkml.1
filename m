Return-Path: <linux-kernel-owner+w=401wt.eu-S1764035AbXJRKih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764035AbXJRKih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761907AbXJRKiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:38:23 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:28274 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758182AbXJRKiW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:38:22 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] PCI: disable MSI on more ATI NorthBridges
Date: Thu, 18 Oct 2007 18:37:59 +0800
Message-ID: <5CAB7B5D6F8AB84AA868A46B47A507055D8C67@sshaexmb1.amd.com>
In-Reply-To: <20071018.031957.104033396.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] PCI: disable MSI on more ATI NorthBridges
Thread-Index: AcgRcHotFPpVyrc3Tl6R26hf0ZqIQgAALaZw
From: "Shane Huang" <Shane.Huang@amd.com>
To: "David Miller" <davem@davemloft.net>
cc: gregkh@suse.de, htejun@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, "Su, Henry" <Henry.Su@amd.com>,
       "Yang, Libin" <Libin.Yang@amd.com>, "Shane Huang" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 18 Oct 2007 10:38:03.0362 (UTC)
 FILETIME=[F624F420:01C81172]
X-WSS-ID: 6B09E8070602261184-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miller:

Thank you for your response.

The reason why MSIs of these northbridges do not work is still under
further debug, we are NOT able to tell its hardware issue or software
issue at this  time. But enablement of them will lead to the OS
installation failure in many distributions like openSUSE, Ubuntu etc:
https://bugzilla.novell.com/show_bug.cgi?id=302016

So we have to disable them firstly before we find out the root cause,
maybe they are just workarounds.

If you guys know much more about this MSI problem, don't hesitate to
tell us, we can debug on some of the hardware platforms.

BTW, There already some disablements to some ATI NB MSIs in the kernel,
the reasons are similar.


Thanks
Shane


> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Thursday, October 18, 2007 6:20 PM
> To: Shane Huang
> Cc: gregkh@suse.de; htejun@gmail.com; linux-kernel@vger.kernel.org;
linux-pci@atrey.karlin.mff.cuni.cz; Su, Henry; Yang, Libin
> Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
> 
> From: "Shane Huang" <Shane.Huang@amd.com>
> Date: Thu, 18 Oct 2007 17:14:36 +0800
> 
> > More ATI North Bridges like RS780 can't do MSI like its predecessors
> > in linux. Disable MSIs on them.
> >
> > Signed-off-by: Shane Huang <shane.huang@amd.com>
> 
> Can we get some detail as to why these north bridges have to have MSI
> disabled completely?  I can't believe that all 6 of these ATI
> controllers which will now be listed in the quirk table cannot use MSI
> at all.
> 
> I've discovered several cases where it was a buggy device or a driver
> bug that caused someone to erroneously submit patches that disable MSI
> completely for the bridge they were behind.
> 
> I don't want that to happen any more.  One way to prevent that is to
> have a full detailed justification for the MSI disabling in the
> changelog or in the comments for the MSI quirk.
> 
> Thank you.
> 



