Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbZABOlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbZABOlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbZABOky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:40:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:26613 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbZABOkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:40:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=bpvv8Qedw9eQffPF+dcnG9n1eQETv05/TyALu6Hj6/5oqxWqZVQ390ffStYs9gRHX9
         ujWIY+vIafiy91jWcaJbb4ghBKVJaQHqSlbDBT3EWpQ2Jrse0huaeAoD4oBsNeu4AAs/
         nTVx8V5dMZflxpNuVacfIymflmsRbuk794MXU=
Message-ID: <3f9a31f40901020640m4a9a63caq9c96ba84ccd64d88@mail.gmail.com>
Date: Fri, 2 Jan 2009 20:10:50 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: wtarreau@hera.kernel.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org, jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: BUG - 2.4.37 fealnx.c NETDEV WATCHDOG: eth0: transmit timed out
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Now I tested fealnx driver from 2.4.37 (2.4 git). I am still getting
"NETDEV WATCHDOG: eth0: transmit timed out". Please let me know how
can I fix this problem.

fealnx.c:v2.51 Nov-17-2001
eth0: 100/10M Ethernet PCI Adapter at 0x6200, 00:40:95:78:05:73, IRQ 11.

NETDEV WATCHDOG: eth0: transmit timed out
eth0: Transmit timed out, status 00000000, resetting...
  Rx ring c11bf000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring c11be000:  80000000 80000000 80000000 80000000 0000 80000000
NETDEV WATCHDOG: eth0: transmit timed out
eth0: Transmit timed out, status 00000000, resetting...
  Rx ring c11bf000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring c11be000:  80000000 0000 80000000 80000000 80000000 80000000
NETDEV WATCHDOG: eth0: transmit timed out
eth0: Transmit timed out, status 00000000, resetting...
  Rx ring c11bf000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring c11be000:  80000000 80000000 80000000 80000000 80000000 0000


00:0a.0 Ethernet controller: MYSON Technology Inc: Unknown device 0803
	Subsystem: MYSON Technology Inc: Unknown device 0803
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (8000ns min, 16000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 6200 [size=256]
	Region 1: Memory at e1000000 (32-bit, non-prefetchable) [size=1K]
	Expansion ROM at <unassigned> [disabled] [size=64K]
	Capabilities: [88] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0-,D1+,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Thank you,
JSR
