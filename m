Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZKUBab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZKUBab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 20:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbZKUBaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 20:30:30 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:43208 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZKUBa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 20:30:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=bDk7txmmvYopNjgxZvum4elgGEIRRyjHDBuDOGGqNk1pQ7XQZ1kbURQ2PcW1XPJ5wB
         efToEoSfuY+cgOTtjxIXGxsqFubZi5oLvK+uDa1TFmlxEYhf2Ju3xDmCVu2ijzn0yP9R
         veVz5RiI/dGVT/iOweCDMJTDfGTRpqdt3hCuI=
MIME-Version: 1.0
Date: Fri, 20 Nov 2009 20:30:34 -0500
X-Google-Sender-Auth: 31d5f2ecdd0c325b
Message-ID: <30353c3d0911201730n4682ff7dy8225d475599eb9bb@mail.gmail.com>
Subject: ieee80211_tx_status: headroom too small
From: David Ellingsworth <david@identd.dyndns.org>
To: Johannes Berg <johannes@sipsolutions.net>, users@host1.serialmonkey.com,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wasn't sure where to send this, but with the latest 2.6.32-rc8-wl
kernel built from the wireless-testing repository I'm getting a number
of "ieee80211_tx_status: headroom too small" errors in my syslog. I'm
using the rt61pci driver in conjunction with hostap as a wpa2 secured
access point. The relevant information about my card from lspci is:

01:08.0 0280: 1814:0301
        Subsystem: 1458:e934
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 128 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fe6f0000 (32-bit, non-prefetchable) [size=32K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: rt61pci

If you need any other information, I'll be happy to provide it.

Regards,

David Ellingsworth
