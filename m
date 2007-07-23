Return-Path: <linux-kernel-owner+w=401wt.eu-S933547AbXGWLbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbXGWLbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbXGWLbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:31:39 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38611 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbXGWLbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:31:38 -0400
Message-ID: <46A49172.2060200@s5r6.in-berlin.de>
Date: Mon, 23 Jul 2007 13:30:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>
CC: linux1394-devel@lists.sourceforge.net,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] firewire: mass-storage i/o-problems
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de> <46A3E973.6090701@s5r6.in-berlin.de> <200707231007.50565.andreas.messer@stud-mail.uni-wuerzburg.de>
In-Reply-To: <200707231007.50565.andreas.messer@stud-mail.uni-wuerzburg.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Messer wrote:
> On Monday, 23. Juli 2007 01:34 Stefan Richter wrote:
>> Are you sure the FireWire controller is from VIA?  Check with lscpi.
>> The NVidia nForce2 chipset has an own FireWire controller, and that one
>> is only "supported" by a gross hack in ohci1394 and at the moment
>> unsupported in firewire-ohci.
...
> The first System, where harddisc don't work at all with the new stack: 
> Nvidia NForce2 Ultra Chipset; 1GB RAM; XP-M 2600; FW-Controller is
> PCI addon card; lspci says Via

OK, if it's an add-on card, then you surely got the right information
from lspci.  I tested 3 different VIA controllers, they all worked for me.

> Vanilla Kernel 2.6.22, apic, Preempt, Dynamic Tics. hmm something else 
> interesting?

I haven't tested dyntics yet, should do so eventually.
-- 
Stefan Richter
-=====-=-=== -=== =-===
http://arcgraph.de/sr/
