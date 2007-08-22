Return-Path: <linux-kernel-owner+w=401wt.eu-S933551AbXHVUtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbXHVUtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933431AbXHVUsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:48:54 -0400
Received: from cpsmtp-voip03.KPNplanet.nl ([213.75.38.87]:52387 "EHLO
	cpsmtp-voip03.kpnplanet.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933424AbXHVUsw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:48:52 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 16:48:52 EDT
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Subject: Re: Forcedeth: Nvidia NIC goes up and down
Date: Wed, 22 Aug 2007 22:43:45 +0200
Message-ID: <181B3AA5E931BA4AB8ED25976193DDC30137416B@CPEXBE-VOIP03.bbp.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: Forcedeth: Nvidia NIC goes up and down
Thread-Index: Acfk/SIZqWWmL8blTJOPJe/vI9F6Fg==
From: <jos.huisken@kpnplanet.nl>
To: <linux-kernel@vger.kernel.org>
Cc: <anders@gnulinux.dk>
X-OriginalArrivalTime: 22 Aug 2007 20:43:45.0811 (UTC) FILETIME=[2262D630:01C7E4FD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I have a similar issue. The network drops away randomly for short periods (several to ten(s) seconds).
Strange enough nothing is reported is syslog, and indeed from the machine itself pinging works perfectly to another machine.
>From that other machine however the connections looks dead in those periods...

I'm running kernel 2.6.18.8-0.5-default on a SUSE 10.2 machine with a ASUS M2NPV-VM board.
Have tried both the default "0.59" and "0.62-Driver Package V1.23" version of forcedeth
Tried 2 BIOSes: 0901 and 1001.

Also have tried several kernel options independently: noapic, pci=routeirq, acpi=off, pci=nomsi
All did not help.


Any suggestions?
BTW I'm not subscribed, please CC me personally.


Thanks in advance,
-- Jos


00:14.0 Ethernet controller: nVidia Corporation MCP51 Ethernet Controller (rev a1)
        Subsystem: ASUSTeK Computer Inc. Unknown device 816a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (250ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 169
        Region 0: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at c800 [size=8]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable+ DSel=0 DScale=0 PME-


Settings for eth0:
        Supported ports: [ MII ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised auto-negotiation: Yes
        Speed: 100Mb/s
        Duplex: Full
        Port: MII
        PHYAD: 1
        Transceiver: external
        Auto-negotiation: on
        Supports Wake-on: g
        Wake-on: d
        Link detected: yes

