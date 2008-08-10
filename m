Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYHJG1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYHJG1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 02:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYHJG1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 02:27:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:65385 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYHJG1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 02:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nJLyWR0CZEXOf/KnO3i9VT2bdxTDNPhbJeZ1kx3PyaukigjPcTIK/qY9AySmDMit4y
         SXzbiuMFdjl6K19B0phsOL77Nn0cwqBBQ1huEg8wJFEQW+QwHpXaxksLiDsOMBKLrWSm
         hWDGH92x8IaVxKRJDOEyK3N7xuxnQm6e7TlUo=
Message-ID: <3f9a31f40808092327h272ba73emcfc1ead6b6d1099@mail.gmail.com>
Date: Sun, 10 Aug 2008 11:57:42 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11271] BUG: fealnx in 2.6.27-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <cX_-nNkxKaF.A.T-.DDjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
	 <cX_-nNkxKaF.A.T-.DDjnIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Sun, Aug 10, 2008 at 4:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11271
> Subject         : BUG: fealnx in 2.6.27-rc1
> Submitter       : Jaswinder Singh <jaswinderlinux@gmail.com>
> Date            : 2008-08-05 14:58 (5 days old)
> References      : http://marc.info/?l=linux-netdev&m=121794762016830&w=4
>
>

This still exists on 2.6.27-rc2 when I transfer some data on RealTek 8139C NIC.

01:00.0 Ethernet controller: MYSON Technology Inc SURECOM EP-320X-S
100/10M Ethernet PCI Adapter
	Subsystem: MYSON Technology Inc SURECOM EP-320X-S 100/10M Ethernet PCI Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (8000ns min, 16000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at d800 [size=256]
	Region 1: Memory at ff8ffc00 (32-bit, non-prefetchable) [size=1K]
	Expansion ROM at e6a00000 [disabled] [size=64K]
	Capabilities: [88] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0-,D1+,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: fealnx

If you need more info or need help in debugging please let me know.

Thank you,

Jaswinder Singh.
