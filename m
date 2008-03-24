Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYCXV0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYCXV0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYCXV0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:26:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54172 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYCXV0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:26:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E81C0E.7050103@s5r6.in-berlin.de>
Date: Mon, 24 Mar 2008 22:24:30 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Meyer <thomas@m3y3r.de>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de> <alpine.LFD.1.00.0803241348510.2775@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803241348510.2775@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> [ Ahh, I was reading email in the wrong order, so I saw your other email 
>   first. ]
> 
> On Mon, 24 Mar 2008, Thomas Meyer wrote:
>> Yes. With this patch applied the error messages doesn't appear anymore.
> 
> Does the firewire port work too? 

Thomas, if you don't have anything to plug in, something like the 
following log messages after module loading should be enough 
confirmation that the issue is resolved:

(new driver)

ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 19 (level, low) -> IRQ 19
firewire_ohci: Added fw-ohci device 0000:03:03.0, OHCI version 1.0
firewire_core: created device fw0: GUID 0017f2fffe66fb80, S400

(or old driver)

ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 19 (level, low) -> IRQ 19
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19] 
MMIO=[90000000-900007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0017f2fffe66fb80]
-- 
Stefan Richter
-=====-==--- --== ==---
http://arcgraph.de/sr/
