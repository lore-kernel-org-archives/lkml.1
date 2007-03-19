Return-Path: <linux-kernel-owner+w=401wt.eu-S965425AbXCSDtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425AbXCSDtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 23:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965360AbXCSDtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 23:49:09 -0400
Received: from dxa01.wellsfargo.com ([151.151.65.117]:49632 "EHLO
	dxa01.wellsfargo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965425AbXCSDtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 23:49:07 -0400
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Subject: RE: 1000xf bus problem
Date: Sun, 18 Mar 2007 22:48:55 -0500
Message-ID: <E8C008223DD5F64485DFBDF6D4B7F71D0289EDC2@msgswbmnmsp25.wellsfargo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 1000xf bus problem
Thread-Index: Acdp2D+K3jAG5M4zTZy/oS2xz4neLwAADkJg
References: <fa.wDPF1lWlqGQpxbyWee64Z3t4BVM@ifi.uio.no> <45FD95CD.2030403@shaw.ca> <45FDA668.1090202@intel.com> <E8C008223DD5F64485DFBDF6D4B7F71D0289EDC1@msgswbmnmsp25.wellsfargo.com> <45FE05FE.80009@intel.com>
From: <Greg.Chandler@wellsfargo.com>
To: <auke-jan.h.kok@intel.com>
Cc: <hancockr@shaw.ca>, <linux-kernel@vger.kernel.org>,
       <e1000-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 19 Mar 2007 03:48:55.0991 (UTC) FILETIME=[84C8A470:01C769D9]
X-WFMX: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


That would completely and uttly suck if it were the case.
So in theory, the card should be talking at full speed, but since the
bridge is 66 then it would be the bottleneck right?

There are 3 pci busses in the server I am working on, so I know there is
at least _a_ bridge there.....
 

-----Original Message-----
From: Kok, Auke [mailto:auke-jan.h.kok@intel.com] 
Sent: Sunday, March 18, 2007 10:40 PM
To: Chandler, Greg
Cc: auke-jan.h.kok@intel.com; hancockr@shaw.ca;
linux-kernel@vger.kernel.org; e1000-devel@lists.sourceforge.net
Subject: Re: 1000xf bus problem

Greg.Chandler@wellsfargo.com wrote:
> If you mean dmesg it says this:
> e1000: 0000:0d:02.0: e1000_probe: (PCI-X:100MHz:64-bit)  {macaddress}
> 
> That's weird... dmesg shows one thing, lspci shows another, and my 
> data transfers seem to point to the lspci info...
> 
> Any idea which I should trust?


Both, the e1000 driver asks the card what it sees from it's side of the
connection, and lspci tells you what the cpu side of it is connected to.

Since stuff like pci bridges exist, both could very well be correct!

I highly suspect that that is exactly the case.


Auke


